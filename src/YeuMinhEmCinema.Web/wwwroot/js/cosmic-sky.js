/* Nền trang trí độc lập: không truy cập dữ liệu, biểu mẫu hay nghiệp vụ đặt vé. */
(() => {
    "use strict";

    const canvas = document.getElementById("cosmic-sky-canvas");
    const toggle = document.querySelector(".cosmic-motion-toggle");

    if (!canvas || !toggle) {
        return;
    }

    const context = canvas.getContext("2d");

    if (!context) {
        return;
    }

    // Đổi giá trị tại đây để điều chỉnh chuyển động (đơn vị: pixel / giây).
    const settings = {
        meteorSpeed: 30,
        desktopMeteorCount: 5,
        mobileMeteorCount: 3
    };

    const reducedMotion = window.matchMedia("(prefers-reduced-motion: reduce)");
    let paused = reducedMotion.matches;
    let width = 0;
    let height = 0;
    let stars = [];
    let edges = [];
    let meteors = [];
    let animationFrame = 0;
    let lastFrameTime = 0;
    let elapsed = 0;
    let resizeTimer = 0;
    let pageActive = true;

    const random = (min, max) => min + Math.random() * (max - min);

    function createMeteor(index, initial = false) {
        return {
            x: initial ? random(0, width) : random(-width * .3, width * .7),
            y: initial ? random(0, height) : random(-height * .4, -50),
            length: random(85, 150),
            speedFactor: random(.7, 1),
            delay: initial ? index * 1.4 : random(0, 4)
        };
    }

    function createScene() {
        const count = Math.round(Math.min(175, Math.max(55, width * height / 7500)));

        stars = Array.from({ length: count }, () => ({
            x: random(0, width),
            y: random(0, height),
            radius: random(.5, 1.4),
            phase: random(0, Math.PI * 2)
        }));

        // Chỉ tính các cạnh khi thay đổi kích thước, không tính lại mỗi khung hình.
        edges = [];

        for (let i = 0; i < stars.length; i++) {
            const neighbours = [];

            for (let j = i + 1; j < stars.length; j++) {
                const distance = Math.hypot(
                    stars[i].x - stars[j].x,
                    stars[i].y - stars[j].y
                );

                if (distance < 120) {
                    neighbours.push({ index: j, distance });
                }
            }

            neighbours.sort((a, b) => a.distance - b.distance);
            neighbours.slice(0, 2).forEach(neighbour => {
                edges.push([i, neighbour.index, 1 - neighbour.distance / 120]);
            });
        }

        const meteorCount = width < 700
            ? settings.mobileMeteorCount
            : settings.desktopMeteorCount;

        meteors = Array.from({ length: meteorCount }, (_, index) => createMeteor(index, true));
    }

    function resize() {
        width = window.innerWidth;
        height = window.innerHeight;

        // Giới hạn DPR để giảm bộ nhớ canvas trên màn hình có mật độ điểm ảnh cao.
        const ratio = Math.min(window.devicePixelRatio || 1, 2);
        canvas.width = Math.round(width * ratio);
        canvas.height = Math.round(height * ratio);
        context.setTransform(ratio, 0, 0, ratio, 0, 0);

        createScene();
        draw(0);
    }

    function draw(delta) {
        context.clearRect(0, 0, width, height);
        elapsed += delta;

        edges.forEach(([from, to, strength]) => {
            context.strokeStyle = `rgba(63, 171, 255, ${.04 + .18 * strength})`;
            context.lineWidth = .65;
            context.beginPath();
            context.moveTo(stars[from].x, stars[from].y);
            context.lineTo(stars[to].x, stars[to].y);
            context.stroke();
        });

        stars.forEach(star => {
            const opacity = .65 + Math.sin(elapsed * .4 + star.phase) * .2;
            context.fillStyle = `rgba(123, 222, 255, ${opacity})`;
            context.shadowColor = "#42cfff";
            context.shadowBlur = star.radius > 1.2 ? 9 : 0;
            context.beginPath();
            context.arc(star.x, star.y, star.radius, 0, Math.PI * 2);
            context.fill();
        });

        context.shadowBlur = 0;

        meteors.forEach((meteor, index) => {
            if (meteor.delay > 0) {
                meteor.delay -= delta;
                return;
            }

            // x và y cùng tăng: đầu sao luôn đi từ trên trái xuống dưới phải.
            meteor.x += delta * settings.meteorSpeed * meteor.speedFactor * .77;
            meteor.y += delta * settings.meteorSpeed * meteor.speedFactor * .64;

            if (meteor.x > width + meteor.length || meteor.y > height + meteor.length) {
                meteors[index] = createMeteor(index);
                return;
            }

            const tailX = meteor.x - meteor.length * .77;
            const tailY = meteor.y - meteor.length * .64;
            const trail = context.createLinearGradient(tailX, tailY, meteor.x, meteor.y);
            trail.addColorStop(0, "rgba(56, 140, 255, 0)");
            trail.addColorStop(.65, "rgba(82, 186, 255, .3)");
            trail.addColorStop(1, "rgba(183, 246, 255, .9)");

            context.strokeStyle = trail;
            context.lineWidth = 1.4;
            context.beginPath();
            context.moveTo(tailX, tailY);
            context.lineTo(meteor.x, meteor.y);
            context.stroke();
            context.shadowColor = "#4acfff";
            context.shadowBlur = 13;
            context.fillStyle = "#d2faff";
            context.beginPath();
            context.arc(meteor.x, meteor.y, 1.6, 0, Math.PI * 2);
            context.fill();
            context.shadowBlur = 0;
        });
    }

    function tick(now) {
        animationFrame = 0;

        if (paused || document.hidden || !pageActive) {
            return;
        }

        const delta = lastFrameTime ? Math.min((now - lastFrameTime) / 1000, .06) : 0;
        lastFrameTime = now;
        draw(delta);
        animationFrame = window.requestAnimationFrame(tick);
    }

    function syncAnimation() {
        window.cancelAnimationFrame(animationFrame);
        animationFrame = 0;
        lastFrameTime = 0;
        toggle.textContent = paused ? "Bật sao băng" : "Tạm dừng sao băng";
        toggle.setAttribute("aria-label", paused ? "Bật hiệu ứng sao băng" : "Tạm dừng hiệu ứng sao băng");
        toggle.setAttribute("aria-pressed", String(paused));

        if (!paused && !document.hidden && pageActive) {
            animationFrame = window.requestAnimationFrame(tick);
        }
    }

    toggle.addEventListener("click", () => {
        paused = !paused;
        syncAnimation();
    });

    reducedMotion.addEventListener("change", () => {
        paused = reducedMotion.matches;
        syncAnimation();
    });

    document.addEventListener("visibilitychange", syncAnimation);

    window.addEventListener("resize", () => {
        window.clearTimeout(resizeTimer);
        resizeTimer = window.setTimeout(resize, 120);
    });

    window.addEventListener("pagehide", () => {
        pageActive = false;
        window.clearTimeout(resizeTimer);
        syncAnimation();
    });

    window.addEventListener("pageshow", () => {
        pageActive = true;
        syncAnimation();
    });

    resize();
    toggle.hidden = false;
    syncAnimation();
})();
