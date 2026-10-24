import { readFile, writeFile, mkdir } from 'node:fs/promises';

// Dùng Chrome DevTools Protocol có sẵn; không cài framework hay sửa dữ liệu SQL.
const base = process.env.YMC_WEB_URL || 'http://localhost:5186';
function check(value, name) {
    if (!value) {
        throw new Error('FAIL: ' + name);
    }
    console.log('PASS: ' + name);
}

// HTTP chạy qua model binding thật, khác với gọi trực tiếp Controller.
for (const query of ['trang=abc', 'trang=0', 'trang=-1', 'trang=1000001', 'trang=2147483648', 'trang=999999999999999999999', 'trangThai=Sai', 'tuKhoa=' + 'a'.repeat(201)]) {
    const response = await fetch(base + '/?' + query);
    check(response.status === 400, 'HTTP 400: ' + query.slice(0, 45));
}
for (const status of ['', 'Đang chiếu', 'Sắp chiếu']) {
    const response = await fetch(base + '/?trangThai=' + encodeURIComponent(status));
    check(response.status === 200, 'Lọc trạng thái: ' + (status || 'Tất cả'));
}
const home = await fetch(base + '/');
check(home.status === 200, 'Trang chủ HTTP 200');
const title = (await home.text()).match(/<h4>\s*([^<]+)\s*<\/h4>/)?.[1].trim()
    .replace(/&#x([0-9a-f]+);/gi, (_, hex) => String.fromCodePoint(parseInt(hex, 16)))
    .replace(/&#([0-9]+);/g, (_, number) => String.fromCodePoint(Number(number)))
    .replace(/&amp;/g, '&');
check(title, 'Có phim thật để kiểm tra tìm kiếm');
const search = await fetch(base + '/?tuKhoa=' + encodeURIComponent(title));
check(search.status === 200 && (await search.text()).includes('movie-card'), 'Tìm tên phim có kết quả');
const empty = await fetch(base + '/?tuKhoa=zzzznotfound_web_smoke');
check((await empty.text()).includes('Chưa có phim phù hợp'), 'Tìm kiếm rỗng');
const beyond = await fetch(base + '/?trang=99&trangThai=&tuKhoa=' + encodeURIComponent(title), { redirect: 'manual' });
check(beyond.status === 302 && beyond.headers.get('location').includes('trang=1'), 'HTTP vượt trang chuyển về trang cuối');
const destination = await fetch(new URL(beyond.headers.get('location'), base));
check(destination.status === 200 && (await destination.text()).includes('movie-card'), 'Sau chuyển trang vẫn có phim đúng bộ lọc');

const targets = await (await fetch('http://localhost:9226/json')).json();
const target = targets.find(item => item.type === 'page');
const socket = new WebSocket(target.webSocketDebuggerUrl);
await new Promise(resolve => socket.addEventListener('open', resolve, { once: true }));
let nextId = 0;
const pending = new Map();
socket.addEventListener('message', function (event) {
    const message = JSON.parse(event.data);
    const callback = pending.get(message.id);
    if (callback) {
        pending.delete(message.id);
        if (message.error) {
            callback.reject(new Error(JSON.stringify(message.error)));
        } else {
            callback.resolve(message.result);
        }
    }
});
function send(method, params = {}) {
    const id = ++nextId;
    return new Promise((resolve, reject) => {
        pending.set(id, { resolve, reject });
        socket.send(JSON.stringify({ id, method, params }));
    });
}
async function evaluate(expression) {
    const result = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
    if (result.exceptionDetails) {
        throw new Error(JSON.stringify(result.exceptionDetails));
    }
    return result.result.value;
}
async function navigate(url) {
    await send('Page.navigate', { url });
    for (let i = 0; i < 100; i++) {
        if (await evaluate('document.readyState === "complete" && location.href !== "about:blank"')) {
            return;
        }
        await new Promise(resolve => setTimeout(resolve, 100));
    }
    throw new Error('Trang không tải xong');
}
await send('Page.enable');
await send('Emulation.setEmulatedMedia', { features: [{ name: 'prefers-reduced-motion', value: 'reduce' }] });
await navigate(base);
check(await evaluate('document.body.textContent.includes("Sau màn đêm") && document.querySelectorAll(".cinema-card").length > 0'), 'Phim Sau màn đêm và rạp thật đã hiển thị');
check(await evaluate('getComputedStyle(document.body).backgroundColor === "rgb(15, 15, 20)"'), 'Nền chính đúng #0F0F14');
check(await evaluate('getComputedStyle(document.querySelector(".movie-card")).backgroundColor === "rgb(24, 24, 27)"'), 'Nền thẻ đúng #18181B');
check(await evaluate('getComputedStyle(document.querySelector(".button")).backgroundColor === "rgb(211, 47, 47)"'), 'Nút dùng màu nhấn #D32F2F');
check(await evaluate('document.body.textContent.includes("Phim đang chiếu") && document.body.textContent.includes("Phim sắp chiếu")'), 'Có cả hai nhóm phim, nhóm rỗng được thông báo rõ');
await mkdir('Tests/WebSmoke/bin/screenshots', { recursive: true });
for (const width of [1366, 390, 320]) {
    await send('Emulation.setDeviceMetricsOverride', { width, height: 900, deviceScaleFactor: 1, mobile: width < 600 });
    await evaluate('window.scrollTo(0, 0)');
    check(await evaluate('document.documentElement.scrollWidth <= innerWidth'), 'Không cuộn ngang: ' + width);
    check(await evaluate('document.querySelector(".hero").offsetTop < document.querySelector(".featured").offsetTop'), 'Giới thiệu trước slide: ' + width);
    await evaluate('document.querySelector("#phim").scrollIntoView()');
    check(await evaluate('document.querySelector("#phim").getBoundingClientRect().top >= document.querySelector(".site-header").getBoundingClientRect().bottom'), 'Điểm neo không bị menu che: ' + width);
    const image = await send('Page.captureScreenshot', { format: 'png' });
    await writeFile('Tests/WebSmoke/bin/screenshots/home-' + width + '.png', Buffer.from(image.data, 'base64'));
    await evaluate('window.scrollTo(0, 0)');
    const full = await send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: true,
        clip: { x: 0, y: 0, width, height: await evaluate('document.documentElement.scrollHeight'), scale: 1 } });
    await writeFile('Tests/WebSmoke/bin/screenshots/full-' + width + '.png', Buffer.from(full.data, 'base64'));
}
check(await evaluate('document.getElementById("toggle-slide") === null'), 'Đã bỏ nút tự chuyển');
await evaluate('document.getElementById("next").click()');
check(await evaluate('Array.from(document.querySelectorAll(".slide")).findIndex(s => !s.hidden) === Array.from(document.querySelectorAll("[data-slide]")).findIndex(s => s.getAttribute("aria-pressed") === "true")'), 'Slide và chỉ báo khớp sau nút tiếp theo');
await evaluate('document.getElementById("previous").click(); document.querySelectorAll("[data-slide]")[1].click()');
check(await evaluate('!document.querySelectorAll(".slide")[1].hidden'), 'Nút trước và chọn chỉ báo hoạt động');
await evaluate('document.getElementById("next").focus()');
await send('Input.dispatchKeyEvent', { type: 'keyDown', key: 'Enter', code: 'Enter', text: '\r', windowsVirtualKeyCode: 13 });
await send('Input.dispatchKeyEvent', { type: 'keyUp', key: 'Enter', code: 'Enter', windowsVirtualKeyCode: 13 });
check(await evaluate('!document.querySelectorAll(".slide")[0].hidden'), 'Bàn phím Enter kích hoạt nút slide');
await evaluate('document.getElementById("previous").click()');
await evaluate('new Promise(resolve => setTimeout(resolve, 6300))');
check(await evaluate('!document.querySelectorAll(".slide")[1].hidden'), 'Slide giữ nguyên sau 6 giây, không còn tự chuyển');
await evaluate(`(() => {
    const element = document.querySelector('.featured');
    for (const [name, x] of [['touchstart', 200], ['touchend', 100]]) {
        const event = new Event(name);
        Object.defineProperty(event, 'changedTouches', { value: [{ clientX: x }] });
        element.dispatchEvent(event);
    }
})()`);
check(await evaluate('!document.querySelectorAll(".slide")[0].hidden'), 'Vuốt sang slide kế tiếp');

// Tạo ảnh lỗi trong DOM kiểm thử rồi gắn lại riêng phần xử lý ảnh của source thật.
await evaluate(`new Promise(resolve => {
    const image = document.createElement('img');
    image.className = 'slide-poster';
    image.id = 'test-broken-image';
    image.onerror = resolve;
    image.src = '/images/khong-ton-tai-test.jpg';
    document.body.append(image);
})`);
const script = await readFile('src/YeuMinhEmCinema.Web/wwwroot/js/site.js', 'utf8');
await evaluate('(() => {' + script.split('// Form GET')[0] + '})()');
check(await evaluate('document.getElementById("test-broken-image").src.endsWith("/images/poster-placeholder.svg")'), 'Ảnh lỗi trước khi gắn listener được thay thế');
await evaluate('document.getElementById("test-broken-image").remove()');

// Nội dung dài chỉ thay trong phiên trình duyệt để thử bố cục; không ghi database.
await evaluate('document.querySelectorAll("h3,h4,.cinema-card p").forEach(e => { e.textContent = "Tên nội dung dài ".repeat(30); })');
for (const width of [1366, 390, 320]) {
    await send('Emulation.setDeviceMetricsOverride', { width, height: 900, deviceScaleFactor: 1, mobile: width < 600 });
    check(await evaluate('document.documentElement.scrollWidth <= innerWidth'), 'Tên dài không tràn ngang: ' + width);
}
await send('Browser.close');
socket.close();
