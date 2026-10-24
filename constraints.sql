USE LibraryManagementDB;
GO

-- =============================================
-- LOẠI 1: UNIQUE CONSTRAINTS (Ràng buộc duy nhất)
-- =============================================
-- Mã ISBN của mỗi đầu sách không được trùng nhau
ALTER TABLE Books
ADD CONSTRAINT UQ_Books_ISBN UNIQUE (ISBN);

-- Email của độc giả và nhân viên không được trùng nhau
ALTER TABLE Members
ADD CONSTRAINT UQ_Members_Email UNIQUE (Email);

ALTER TABLE Staff
ADD CONSTRAINT UQ_Staff_Email UNIQUE (Email);
GO

-- =============================================
-- LOẠI 2: CHECK CONSTRAINTS (Ràng buộc kiểm tra điều kiện)
-- =============================================
-- Tổng số sách phải > 0; Số lượng còn trong kho phải >= 0 và <= Tổng số sách
ALTER TABLE Books
ADD CONSTRAINT CHK_Books_Quantity 
CHECK (TotalQuantity > 0 AND AvailableQuantity >= 0 AND AvailableQuantity <= TotalQuantity);

-- Năm xuất bản phải hợp lệ (từ năm 1900 đến năm hiện tại)
ALTER TABLE Books
ADD CONSTRAINT CHK_Books_PublishYear 
CHECK (PublishYear >= 1900 AND PublishYear <= YEAR(GETDATE()));

-- Hạn trả sách (DueDate) phải lớn hơn hoặc bằng ngày mượn (BorrowDate)
ALTER TABLE BorrowRecords
ADD CONSTRAINT CHK_BorrowRecords_Dates 
CHECK (DueDate >= BorrowDate);

-- Ngày trả thực tế (ReturnDate) nếu có thì không được nhỏ hơn tiền phạt âm
ALTER TABLE BorrowDetails
ADD CONSTRAINT CHK_BorrowDetails_Fine 
CHECK (FineAmount >= 0);

-- Trạng thái thẻ độc giả chỉ nhận 'Active' (Hoạt động) hoặc 'Blocked' (Bị khóa)
ALTER TABLE Members
ADD CONSTRAINT CHK_Members_Status 
CHECK (Status IN ('Active', 'Blocked'));
GO

-- =============================================
-- LOẠI 3: DEFAULT CONSTRAINTS (Ràng buộc giá trị mặc định)
-- =============================================
-- Mặc định ngày đăng ký thẻ là ngày hiện tại
ALTER TABLE Members
ADD CONSTRAINT DF_Members_RegistrationDate DEFAULT GETDATE() FOR RegistrationDate;

-- Mặc định trạng thái thẻ mới tạo là 'Active'
ALTER TABLE Members
ADD CONSTRAINT DF_Members_Status DEFAULT 'Active' FOR Status;

-- Mặc định tiền phạt ban đầu là 0
ALTER TABLE BorrowDetails
ADD CONSTRAINT DF_BorrowDetails_FineAmount DEFAULT 0 FOR FineAmount;
GO