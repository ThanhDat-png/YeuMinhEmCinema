import { readFile } from 'node:fs/promises';
import { runInNewContext } from 'node:vm';
import assert from 'node:assert/strict';

// Kiểm tra các sự kiện và timer từ source thật, không cần SQL Server.
class Element {
    constructor() {
        this.listeners = {};
        this.attributes = {};
        this.dataset = {};
        this.hidden = false;
        this.classList = { toggle() {} };
    }
    addEventListener(name, handler) {
        (this.listeners[name] ??= []).push(handler);
    }
    fire(name, event = {}) {
        for (const handler of this.listeners[name] ?? []) handler(event);
    }
    setAttribute(name, value) {
        this.attributes[name] = value;
    }
}
const source = await readFile('src/YeuMinhEmCinema.Web/wwwroot/js/site.js', 'utf8');
const slides = Array.from({length: 3}, () => new Element());
const dots = Array.from({length: 3}, (_, i) => {
    const dot = new Element();
    dot.dataset.slide = String(i);
    return dot;
});
const pause = new Element();
const controls = new Element();
const previous = new Element();
const next = new Element();
const featured = new Element();
featured.querySelectorAll = selector => selector === '.slide' ? slides : dots;
featured.querySelector = selector => selector === '[data-slide-pause]' ? pause : controls;
featured.contains = node => node === pause;
const doc = new Element();
doc.hidden = false;
doc.activeElement = null;
doc.querySelector = () => featured;
const reduced = new Element();
reduced.matches = false;
let scheduled = null;
const win = {
    matchMedia() { return reduced; },
    clearInterval() { scheduled = null; },
    setInterval(callback, delay) {
        assert.equal(delay, 5000);
        scheduled = callback;
        return 1;
    },
    setTimeout(callback) { callback(); }
};
doc.getElementById = id => id === 'previous' ? previous : next;
runInNewContext(source.slice(source.indexOf('// Tự chuyển sau'), source.indexOf('// Giữ giá trị nút')), {
    document: doc, window: win
});
scheduled();
assert.equal(slides[1].hidden, false);
featured.fire('mouseenter');
assert.equal(scheduled, null);
next.fire('click');
assert.equal(slides[2].hidden, false);
featured.fire('mouseleave');
assert.equal(typeof scheduled, 'function');
doc.activeElement = pause;
featured.fire('focusin');
assert.equal(scheduled, null);
doc.activeElement = null;
featured.fire('focusout');
pause.fire('click');
assert.equal(scheduled, null);
pause.fire('click');
assert.equal(typeof scheduled, 'function');
doc.hidden = true;
doc.fire('visibilitychange');
assert.equal(scheduled, null);
console.log('PASS: slide tự chạy 5 giây, nút tiếp theo, hover, focus, dừng/tự chạy và tab ẩn');

// Bản giao diện hiện tại bỏ nút dừng và các chấm, JS vẫn phải hoạt động.
featured.querySelector = selector => selector === '[data-slide-pause]' ? null : controls;
featured.querySelectorAll = selector => selector === '.slide' ? slides : [];
doc.hidden = false;
doc.activeElement = null;
runInNewContext(source.slice(source.indexOf('// Tự chuyển sau'), source.indexOf('// Giữ giá trị nút')), {
    document: doc, window: win
});
scheduled();
assert.equal(slides[1].hidden, false);
console.log('PASS: slide vẫn tự chạy khi không có nút dừng và chấm chỉ vị trí');

const fnb = new Element();
fnb.dataset.ticketTotal = '95000';
const card = new Element();
const input = new Element();
input.value = '0';
input.dataset.price = '79000';
const select = new Element();
const quantity = new Element();
const line = new Element();
const total = new Element();
const minus = new Element();
minus.dataset.quantityStep = '-1';
const plus = new Element();
plus.dataset.quantityStep = '1';
card.querySelector = selector => {
    if (selector === 'input[data-price]') return input;
    if (selector === '[data-fnb-select]') return select;
    if (selector === '.fnb-quantity') return quantity;
    return line;
};
card.querySelectorAll = () => [minus, plus];
input.closest = () => card;
fnb.querySelectorAll = selector => selector === '.fnb-card' ? [card] : [input];
doc.querySelector = () => fnb;
doc.getElementById = () => total;
runInNewContext(source.slice(source.indexOf('const fnb ='), source.indexOf("document.querySelectorAll('[data-print]')")), {
    document: doc, Intl
});
assert.equal(quantity.hidden, true);
select.fire('click');
assert.equal(input.value, '1');
assert.equal(quantity.hidden, false);
plus.fire('click');
assert.equal(input.value, '2');
input.value = '';
input.fire('input');
assert.equal(quantity.hidden, false);
input.value = '3';
input.fire('change');
assert.ok(total.textContent.includes('332.000'));
input.value = '100';
input.fire('change');
assert.equal(input.value, '99');
select.fire('click');
assert.equal(input.value, '0');
assert.equal(quantity.hidden, true);
assert.ok(total.textContent.includes('95.000'));
console.log('PASS: chọn/bỏ món, tăng số lượng, nhập trống rồi gõ, giới hạn 99 và tổng tiền');
