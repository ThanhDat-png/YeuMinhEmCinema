import { writeFile, mkdir } from 'node:fs/promises';

// Dành cho Web thử nghiệm ở cổng 5187 chạy không cấu hình kết nối.
const base = 'http://localhost:5187';
const response = await fetch(base);
if (response.status !== 503 || !(await response.text()).includes('Dữ liệu tạm thời chưa sẵn sàng')) {
    throw new Error('FAIL: không trả 503 với thông báo an toàn');
}
console.log('PASS: HTTP thiếu cấu hình trả 503');
const targets = await (await fetch('http://localhost:9226/json')).json();
const socket = new WebSocket(targets.find(target => target.type === 'page').webSocketDebuggerUrl);
await new Promise(resolve => socket.addEventListener('open', resolve, { once: true }));
let id = 0;
const callbacks = new Map();
socket.addEventListener('message', event => {
    const message = JSON.parse(event.data);
    if (callbacks.has(message.id)) {
        callbacks.get(message.id)(message.result);
        callbacks.delete(message.id);
    }
});
function send(method, params = {}) {
    return new Promise(resolve => {
        callbacks.set(++id, resolve);
        socket.send(JSON.stringify({ id, method, params }));
    });
}
await send('Page.enable');
await send('Page.navigate', { url: base });
for (let i = 0; i < 50; i++) {
    const state = await send('Runtime.evaluate', { expression: 'document.readyState === "complete" && !!document.querySelector("[role=alert]")', returnByValue: true });
    if (state.result.value) {
        break;
    }
    await new Promise(resolve => setTimeout(resolve, 100));
}
await mkdir('Tests/WebSmoke/bin/screenshots', { recursive: true });
for (const width of [1366, 390, 320]) {
    await send('Emulation.setDeviceMetricsOverride', { width, height: 900, deviceScaleFactor: 1, mobile: width < 600 });
    const result = await send('Runtime.evaluate', { expression: 'document.documentElement.scrollWidth <= innerWidth && !!document.querySelector("[role=alert]")', returnByValue: true });
    if (!result.result.value) {
        throw new Error('FAIL: trang lỗi bị tràn hoặc thiếu thông báo');
    }
    const screenshot = await send('Page.captureScreenshot', { format: 'png' });
    await writeFile('Tests/WebSmoke/bin/screenshots/error-' + width + '.png', Buffer.from(screenshot.data, 'base64'));
    console.log('PASS: trang lỗi không tràn ngang ' + width);
}
await send('Browser.close');
socket.close();
