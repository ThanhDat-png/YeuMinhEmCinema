import { readFile } from 'node:fs/promises';
import { runInNewContext } from 'node:vm';

// Chạy đúng phần xử lý ảnh trong source, mô phỏng cả ảnh thay thế cũng bị lỗi.
const source = (await readFile('src/YeuMinhEmCinema.Web/wwwroot/js/site.js', 'utf8')).split('// Form GET')[0];
for (const early of [true, false]) {
    const listeners = new Set();
    let changes = 0;
    const image = {
        complete: early,
        naturalWidth: 0,
        classList: { contains() { return true; } },
        addEventListener(name, callback) { listeners.add(callback); },
        removeEventListener(name, callback) { listeners.delete(callback); },
        set src(value) {
            changes++;
            if (changes > 1) {
                throw new Error('Ảnh thay thế bị lặp');
            }
            // Phát lỗi ngay để chứng minh listener đã được gỡ trước đổi src.
            for (const listener of Array.from(listeners)) {
                listener();
            }
        }
    };
    runInNewContext(source, { document: { querySelector() { return null; }, querySelectorAll() { return [image]; } } });
    if (!early) {
        for (const listener of Array.from(listeners)) {
            listener();
        }
    }
    if (changes !== 1 || listeners.size !== 0) {
        throw new Error('FAIL: xử lý poster');
    }
    console.log('PASS: ảnh lỗi ' + (early ? 'trước' : 'sau') + ' khi gắn listener, ảnh thay thế lỗi không lặp');
}
