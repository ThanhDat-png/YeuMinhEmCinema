import { mkdir, writeFile } from 'node:fs/promises';

// Chỉ dùng tài khoản/fixture _Test do chương trình C# truyền qua môi trường, không ghi mật khẩu ra tệp.
const base = 'http://localhost:5192';
const targets = await (await fetch('http://localhost:9226/json')).json();
const socket = new WebSocket(targets.find(t => t.type === 'page').webSocketDebuggerUrl);
await new Promise(resolve => socket.addEventListener('open', resolve, { once: true }));
let id = 0;
const pending = new Map();
socket.addEventListener('message', event => {
    const message = JSON.parse(event.data);
    if (pending.has(message.id)) {
        pending.get(message.id)(message.result);
        pending.delete(message.id);
    }
});
function send(method, params = {}) {
    return new Promise(resolve => {
        pending.set(++id, resolve);
        socket.send(JSON.stringify({ id, method, params }));
    });
}
async function evaluate(expression) {
    const result = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
    if (result.exceptionDetails) {
        throw new Error('JavaScript kiểm thử thất bại');
    }
    return result.result.value;
}
function check(value, name) {
    if (!value) {
        throw new Error('FAIL: ' + name);
    }
    console.log('PASS: ' + name);
}
async function wait(expression) {
    for (let i = 0; i < 100; i++) {
        if (await evaluate(expression)) {
            return;
        }
        await new Promise(resolve => setTimeout(resolve, 100));
    }
    throw new Error('Hết thời gian chờ trang kiểm thử');
}
async function visit(path) {
    await send('Page.navigate', { url: base + path });
    await wait('document.readyState === "complete"');
}
async function capture(name) {
    for (const width of [1366, 390, 320]) {
        await send('Emulation.setDeviceMetricsOverride', { width, height: 900, deviceScaleFactor: 1, mobile: width < 600 });
        await evaluate('window.scrollTo(0, 0)');
        check(await evaluate('document.documentElement.scrollWidth <= innerWidth'), name + ' không tràn ngang ' + width);
        const screenshot = await send('Page.captureScreenshot', { format: 'png' });
        await writeFile(`Tests/WebCustomerIntegration/bin/${name}-${width}.png`, Buffer.from(screenshot.data, 'base64'));
    }
}
await mkdir('Tests/WebCustomerIntegration/bin', { recursive: true });
await send('Page.enable');
await visit('/TaiKhoan/DangNhap');
await capture('login');
await evaluate(`document.getElementById('TenDangNhap').value = ${JSON.stringify(process.env.YMC_BROWSER_USER)};
    document.getElementById('MatKhau').value = ${JSON.stringify(process.env.YMC_BROWSER_PASSWORD)};
    document.querySelector('form.account-form button').click();`);
await wait('location.pathname === "/" && document.readyState === "complete"');
check(await evaluate('document.querySelector(".account-nav").textContent.includes("Đơn của tôi")'), 'Menu sau đăng nhập');
await visit('/Phim/ChiTiet/' + process.env.YMC_BROWSER_MOVIE);
await capture('movie');
await visit('/DatVe/Ghe/' + process.env.YMC_BROWSER_SHOW);
await capture('seats');
await evaluate(`document.querySelector('input[name=Ghe][value="${Number(process.env.YMC_BROWSER_SEAT)}"]').checked = true;
    document.querySelector('form[action*=BapNuoc] button').click();`);
await wait('location.pathname.includes("BapNuoc") && document.readyState === "complete"');
check(await evaluate('!!document.querySelector("[data-fnb]")'), 'Bước bắp nước sau chọn ghế');
await capture('fnb');
await evaluate(`(() => {
    const product = Array.from(document.querySelectorAll('input[type=hidden]')).find(i => i.name.endsWith('.MaSanPham') && i.value === '${Number(process.env.YMC_BROWSER_COMBO)}');
    product.closest('article').querySelector('input[type=number]').value = '1';
    product.closest('article').querySelector('input[type=number]').dispatchEvent(new Event('input', { bubbles: true }));
    document.querySelector('form[action*=GiuGhe] button').click();
})()`);
await wait('location.pathname.includes("/Don/ChiTiet") && document.readyState === "complete"');
check(await evaluate('document.body.textContent.includes("110.000")'), 'Tổng SQL 80.000 + combo 30.000');
check(await evaluate('!document.querySelector(".qr") && !!document.querySelector("[data-deadline]")'), 'Đơn chờ có hạn giữ và chưa có QR');
await capture('checkout');
await evaluate('document.querySelector("button[value=thanh-cong]").click()');
await wait('document.readyState === "complete" && !!document.querySelector(".qr")');
await wait('document.querySelector(".qr").complete && document.querySelector(".qr").naturalWidth > 0');
check(await evaluate('document.body.textContent.includes("Mô phỏng thành công")'), 'Mô phỏng qua giao diện thành công');
await capture('ticket');
await evaluate('window.print = function () { window.printCalled = true; }; document.querySelector("[data-print]").click()');
check(await evaluate('window.printCalled === true'), 'Nút in gọi chức năng in của trình duyệt');
// Nếu trình duyệt hỗ trợ bộ giải mã QR thì đối chiếu cả payload từ ảnh thật.
if (await evaluate('typeof BarcodeDetector !== "undefined"')) {
    const decoded = await evaluate(`(async () => {
        const detector = new BarcodeDetector({ formats: ['qr_code'] });
        const values = await detector.detect(document.querySelector('.qr'));
        return values[0]?.rawValue;
    })()`);
    check(/^[0-9a-f-]{36}$/i.test(decoded || ''), 'Giải mã QR từ ảnh trả GUID tương thích WinForms');
} else {
    console.log('CHƯA KIỂM TRA: Chrome không cung cấp BarcodeDetector để giải mã ảnh QR.');
}
await visit('/Don');
await capture('history');
check(await evaluate('document.body.textContent.includes("Đã thanh toán")'), 'Lịch sử hiển thị đơn đã thanh toán');
await send('Browser.close');
socket.close();
