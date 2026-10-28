# Đối chiếu mã commit sau khi đổi thông điệp

Ngày 28/10/2026, người dùng yêu cầu thông điệp commit tiếng Việt, không tiền tố feat/fix; cho phép đổi các commit Admin trước và push toàn bộ T07.

Các mã cũ trong nhật ký và minh chứng là mốc lịch sử, đối chiếu với mã mới dưới đây. Chỉ thông điệp và mã cha thay đổi; cây nội dung từng commit giữ nguyên. Không sửa lịch sử trước mốc 5a0ee37 của nhóm.

- `ed8b4a2` → `69e1fcb`.
- `834ab95` → `a45af77`.
- `47a3f9a` → `c196163`.
- `c6db703` → `df0e724`.
- `a4e3ae6` → `94838a7`.

Ref dự phòng chỉ trên máy: `refs/backup/admin-before-vietnamese-20261028`. Push main dùng force-with-lease với mã remote đã kiểm tra, không đẩy ref dự phòng. T07 được commit mới sau bước đổi thông điệp.
