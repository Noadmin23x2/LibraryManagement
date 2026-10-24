USE master;
GO

-- Nếu Database đã tồn tại thì xóa đi tạo lại cho sạch sẽ
IF EXISTS (SELECT name FROM sys.databases WHERE name = N'LibraryManagementDB')
BEGIN
    ALTER DATABASE LibraryManagementDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LibraryManagementDB;
END
GO

-- 1. Tạo Database mới
CREATE DATABASE LibraryManagementDB;
GO

USE LibraryManagementDB;
GO

-- 2. Tạo 9 bảng theo đúng thiết kế chuẩn (Chưa gộp các lệnh ALTER TABLE constraint)
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName NVARCHAR(100) NOT NULL,
    Description NVARCHAR(255)
);

CREATE TABLE Publishers (
    PublisherID INT PRIMARY KEY,
    PublisherName NVARCHAR(150) NOT NULL,
    Address NVARCHAR(255),
    Email VARCHAR(100)
);

CREATE TABLE Authors (
    AuthorID INT PRIMARY KEY,
    AuthorName NVARCHAR(100) NOT NULL,
    Biography NVARCHAR(500)
);

CREATE TABLE Books (
    BookID INT PRIMARY KEY,
    ISBN VARCHAR(20) NOT NULL,
    Title NVARCHAR(200) NOT NULL,
    PublishYear INT,
    TotalQuantity INT NOT NULL,
    AvailableQuantity INT NOT NULL,
    CategoryID INT FOREIGN KEY REFERENCES Categories(CategoryID),
    PublisherID INT FOREIGN KEY REFERENCES Publishers(PublisherID)
);

CREATE TABLE BookAuthors (
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    AuthorID INT FOREIGN KEY REFERENCES Authors(AuthorID),
    PRIMARY KEY (BookID, AuthorID)
);

CREATE TABLE Members (
    MemberID INT PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    RegistrationDate DATE,
    Status NVARCHAR(20)
);

CREATE TABLE Staff (
    StaffID INT PRIMARY KEY,
    FullName NVARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL,
    Phone VARCHAR(15),
    Role NVARCHAR(50)
);

CREATE TABLE BorrowRecords (
    BorrowID INT PRIMARY KEY,
    MemberID INT FOREIGN KEY REFERENCES Members(MemberID),
    StaffID INT FOREIGN KEY REFERENCES Staff(StaffID),
    BorrowDate DATE NOT NULL,
    DueDate DATE NOT NULL
);

CREATE TABLE BorrowDetails (
    BorrowID INT FOREIGN KEY REFERENCES BorrowRecords(BorrowID),
    BookID INT FOREIGN KEY REFERENCES Books(BookID),
    ReturnDate DATE NULL,
    FineAmount DECIMAL(10, 2),
    PRIMARY KEY (BorrowID, BookID)
);
GO