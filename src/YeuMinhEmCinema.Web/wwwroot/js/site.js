// Ảnh thiếu hoặc đường dẫn WinForms không truy cập được dùng ảnh thay thế trung tính.
// Khoảng neo theo chiều cao menu thực tế, kể cả tên khách dài và menu nhiều hàng.
const header = document.querySelector('.site-header');
if (header) {
    const resize = new ResizeObserver(function () {
        document.documentElement.style.setProperty('--header-offset', (header.getBoundingClientRect().height + 20) + 'px');
    });
    resize.observe(header);
}

document.querySelectorAll('img').forEach(function (image) {
    if (image.classList.contains('slide-poster') || image.closest('.poster-wrap')) {
        // complete/naturalWidth phát hiện lỗi xảy ra trước khi script gắn sự kiện.
        // Gỡ listener trước khi đổi src để ảnh thay thế lỗi không tạo vòng lặp.
        let replaced = false;
        function replacePoster() {
            if (replaced) {
                return;
            }
            replaced = true;
            image.removeEventListener('error', replacePoster);
            image.src = '/images/poster-placeholder.svg';
        }
        image.addEventListener('error', replacePoster);
        if (image.complete && image.naturalWidth === 0) {
            replacePoster();
        }
    }
});

// Form GET vẫn hoạt động khi tắt JavaScript. Khóa nút trong lúc chờ trang mới.
document.querySelectorAll('form[data-loading]').forEach(function (form) {
    form.addEventListener('submit', function () {
        form.querySelector('button[type="submit"]').disabled = true;
        form.querySelector('.loading').hidden = false;
        form.setAttribute('aria-busy', 'true');
    });
});
window.addEventListener('pageshow', function () {
    document.querySelectorAll('form[data-loading]').forEach(function (form) {
        form.querySelector('button[type="submit"]').disabled = false;
        form.querySelector('.loading').hidden = true;
        form.removeAttribute('aria-busy');
    });
});

// Slide chỉ chuyển thủ công; không có timer hoặc nút tự chuyển.
const featured = document.querySelector('.featured');
if (featured) {
    const slides = Array.from(featured.querySelectorAll('.slide'));
    const dots = Array.from(featured.querySelectorAll('[data-slide]'));
    let index = 0;
    // Cập nhật đồng thời slide và chỉ báo để trạng thái không lệch nhau.
    function show(next) {
        index = (next + slides.length) % slides.length;
        slides.forEach(function (slide, position) {
            slide.hidden = position !== index;
        });
        dots.forEach(function (dot, position) {
            dot.setAttribute('aria-pressed', String(position === index));
        });
    }
    if (slides.length > 1) {
        featured.querySelector('.slide-controls').hidden = false;
        document.getElementById('previous').addEventListener('click', function () {
            show(index - 1);
        });
        document.getElementById('next').addEventListener('click', function () {
            show(index + 1);
        });
        dots.forEach(function (dot) {
            dot.addEventListener('click', function () {
                show(Number(dot.dataset.slide));
            });
        });
        let touchX = null;
        featured.addEventListener('touchstart', function (event) {
            touchX = event.changedTouches[0].clientX;
        }, { passive: true });
        featured.addEventListener('touchend', function (event) {
            if (touchX !== null) {
                const difference = event.changedTouches[0].clientX - touchX;
                if (Math.abs(difference) > 45) {
                    show(index + (difference < 0 ? 1 : -1));
                }
            }
            touchX = null;
        }, { passive: true });
    }
}

// Giữ giá trị nút vừa bấm trước khi khóa để form nhiều kết quả không mất thông tin.
document.querySelectorAll('form[data-submit]').forEach(function (form) {
    form.addEventListener('submit', function (event) {
        if (form.dataset.busy === 'true') {
            event.preventDefault();
            return;
        }
        form.dataset.busy = 'true';
        const submitter = event.submitter;
        if (submitter && submitter.name) {
            const hidden = document.createElement('input');
            hidden.type = 'hidden';
            hidden.name = submitter.name;
            hidden.value = submitter.value;
            form.append(hidden);
        }
        form.querySelectorAll('button[type="submit"]').forEach(function (button) {
            button.disabled = true;
        });
        form.setAttribute('aria-busy', 'true');
    });
});
window.addEventListener('pageshow', function () {
    document.querySelectorAll('form[data-submit]').forEach(function (form) {
        form.dataset.busy = 'false';
        form.removeAttribute('aria-busy');
        form.querySelectorAll('button[type="submit"]').forEach(function (button) {
            button.disabled = false;
        });
    });
});

// Tổng này chỉ để xem trước; SQL luôn tính lại và giữ giá chính thức trong đơn.
const fnb = document.querySelector('[data-fnb]');
if (fnb) {
    const money = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' });
    function updateEstimate() {
        let total = Number(fnb.dataset.ticketTotal);
        fnb.querySelectorAll('input[data-price]').forEach(function (input) {
            const amount = Number(input.dataset.price) * Number(input.value);
            total += amount;
            input.closest('article').querySelector('[data-line-total]').textContent = money.format(amount);
        });
        document.getElementById('estimated-total').textContent = money.format(total);
    }
    fnb.addEventListener('input', updateEstimate);
    updateEstimate();
}

document.querySelectorAll('[data-print]').forEach(function (button) {
    button.addEventListener('click', function () {
        window.print();
    });
});

// Đồng hồ chỉ hiển thị; không tự đổi trạng thái đơn hoặc phát hành vé ở trình duyệt.
const deadline = document.querySelector('[data-deadline]');
if (deadline) {
    function updateDeadline() {
        const seconds = Math.max(0, Math.floor((Date.parse(deadline.dataset.deadline) - Date.now()) / 1000));
        if (seconds === 0) {
            deadline.textContent = 'Đã tới hạn giữ ghế. Tải lại để kiểm tra trạng thái từ server.';
        }
        else {
            deadline.textContent = 'Thời gian còn lại: ' + Math.floor(seconds / 60) + ' phút ' + seconds % 60 + ' giây';
        }
    }
    updateDeadline();
    setInterval(updateDeadline, 1000);
}
