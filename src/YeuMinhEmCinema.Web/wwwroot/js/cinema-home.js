// Chỉ điều khiển phần giới thiệu. Không tự chuyển để người xem có đủ thời gian đọc.
// Khi tắt JavaScript, poster vẫn mở trang chi tiết bằng đường dẫn MVC thật.
(function () {
    'use strict';

    const spotlight = document.querySelector('[data-spotlight]');
    if (!spotlight) {
        return;
    }

    const slides = Array.from(spotlight.querySelectorAll('.spotlight-slide'));
    const choices = Array.from(spotlight.querySelectorAll('[data-spotlight-choice]'));
    const controls = spotlight.querySelector('.spotlight-controls');
    const counter = spotlight.querySelector('[data-spotlight-counter]');
    let current = 0;

    function show(position) {
        current = (position + slides.length) % slides.length;
        slides.forEach(function (slide, index) {
            slide.hidden = index !== current;
        });
        choices.forEach(function (choice, index) {
            choice.classList.toggle('is-active', index === current);
            choice.setAttribute('aria-pressed', String(index === current));
        });
        if (counter) {
            counter.textContent = (current + 1) + ' / ' + slides.length;
        }
    }

    choices.forEach(function (choice, index) {
        choice.setAttribute('role', 'button');
        choice.setAttribute('aria-pressed', String(index === current));
        choice.addEventListener('click', function (event) {
            // Ctrl/Cmd/Shift + bấm giữ hành vi mở liên kết trong tab/cửa sổ mới.
            if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) {
                return;
            }
            event.preventDefault();
            show(index);
        });
        choice.addEventListener('keydown', function (event) {
            if (event.key === ' ') {
                event.preventDefault();
                show(index);
            }
        });
    });

    if (slides.length > 1 && controls) {
        controls.hidden = false;
        spotlight.querySelector('[data-spotlight-previous]').addEventListener('click', function () {
            show(current - 1);
        });
        spotlight.querySelector('[data-spotlight-next]').addEventListener('click', function () {
            show(current + 1);
        });
    }
})();
