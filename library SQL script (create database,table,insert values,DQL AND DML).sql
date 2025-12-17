create database LibraryDB;
use LibraryDB 

---create library table

create table Library (
    library_id int identity primary key,
    name varchar(50) not null unique,
    location varchar(100) not null,
    contact_number varchar(20) not null,
    established_year int
);

---create table book

create table Book (
    book_id int identity primary key,
    ISBN varchar(20) not null unique,
    title varchar(150) not null,
    genre varchar(20) not null,
    price decimal(10,2) check (price > 0),                                     --PRICE must be greater than zero
    shelf_location varchar(50) not null,
    availabilitystatus bit default 1,                                     ----- DEFAULT ---Book IsAvailable = TRUE 
    LIB_id int not null,

    constraint ck_book_genre                                                                   -----CHECK constraints
        check (genre in ('fiction','non-fiction','reference','children')),

    constraint fk_book_library            
        foreign key (LIB_id)references library(library_id)             
        on delete cascade                                                            -------- foreign keys ON DELETE CASCADE. 
        on update cascade                                                         -----------foreign keys ON UPDATE CASCADE.
);

---create table member

create table Member (
    member_id int identity primary key,
    full_name varchar(50),
    email varchar(100) not null unique,
    phone_number varchar(20),
    membership_start_date date not null
);


-----create table staff

create table staff (
    staff_id int identity primary key,
    full_name varchar(100),
    contact_number varchar(20),
    LIB_id int not null,

    constraint fk_staff_library
        foreign key (LIB_id)references library(library_id)
        on delete cascade                                                                  
        on update cascade       	                                              
)


-------CREATE TABLE loan (weak entity – composite primary key)

create table loan (
    loan_date date not null,
    MEM_id int not null,
    B_id int not null,
    due_date date not null,
    return_date date,
    status varchar(20) not null default 'issued',                                       ------- DEFAULT ---Loan Status = 'Issued' 

    constraint pk_loan
        primary key (loan_date, MEM_id, B_id),                                      -----CPK

    constraint ck_loan_status                                                         ---CHECK Loan Status
        check (status in ('issued','returned','overdue')),

    constraint ck_return_date
        check (return_date is null or return_date >= loan_date),                                  ----CHECK --Return Date must be greater than or equal to Loan Date

    constraint fk_loan_member
        foreign key (MEM_id)references member(member_id)
        on delete cascade                                                     
        on update cascade,                                                     

    constraint fk_loan_book
        foreign key (B_id)references book(book_id)
        on delete cascade                                                
        on update cascade                                                     
);


----create table payment

create table payment (
    payment_id int identity primary key,
    payment_date date not null,
    amount decimal(10,2) not null check (amount > 0),                                             --Payment Amount must be greater than zero                                        
    payment_method varchar(50),
    LON_date date not null,
    MEM_id int not null,
    B_id int not null,

    constraint fk_payment_loan
        foreign key (LON_date, MEM_id, B_id) references loan(loan_date, MEM_id, B_id)
        on delete cascade
        on update cascade
);


--------create table review (weak entity – composite primary key)

create table review (
    review_date date not null,
    MEM_id int not null,
    B_id int not null,
    rating int not null,
    comments varchar(255) default 'no comments',                  --------Review Comments = 'No comments' if not provided 

    constraint pk_review
        primary key (review_date, MEM_id, B_id),                     --CPK

    constraint ck_review_rating
        check (rating between 1 and 5),                               ----Review Rating between 1 and 5 

    constraint fk_review_member
        foreign key (MEM_id)references member(member_id)
        on delete cascade
        on update cascade,

    constraint fk_review_book
        foreign key (B_id)references book(book_id)
        on delete cascade
        on update cascade
);



---- insert values to table

---library

insert into Library (name, location, contact_number, established_year)
values
('central library', 'muscat', '24567890', 2005),
('city library', 'salalah', '23214567', 2010),
('university library', 'sohar', '26889977', 2015),
('public library', 'nizwa', '25443322', 2012);

select*from library

---member

insert into Member (full_name, email, phone_number, membership_start_date)
values
('ahmed ali', 'ahmed@gmail.com', '91234567', '2023-01-10'),
('fatma salim', 'fatma@gmail.com', '92345678', '2023-02-15'),
('khalid nasser', 'khalid@gmail.com', '93456789', '2023-03-01'),
('aisha saad', 'aisha@gmail.com', '94567890', '2023-04-12'),
('omar yusuf', 'omar@gmail.com', '95678901', '2023-05-20');

select*from Member

---staff

insert into staff (full_name, contact_number, LIB_id)
values
('sara hassan', '90011122', 1),
('mohammed saad', '90033344', 2),
('ali khamees', '90055566', 3),
('noor abdullah', '90077788', 4);

select*from staff

----book

insert into book (ISBN, title, genre, price, shelf_location, LIB_id)
values
('9781111111111', 'database systems', 'reference', 25.50, 'a1', 1),
('9782222222222', 'children stories', 'children', 15.00, 'b2', 1),
('9783333333333', 'modern fiction', 'fiction', 20.00, 'c3', 2),
('9784444444444', 'history of oman', 'non-fiction', 30.00, 'd4', 3),
('9785555555555', 'science basics', 'reference', 22.00, 'e5', 4);

select*from book


----loan

insert into loan (loan_date, MEM_id, B_id, due_date, status)
values
('2024-03-01', 1, 1, '2024-03-15', 'issued'),
('2024-03-02', 2, 2, '2024-03-16', 'issued'),
('2024-03-03', 3, 3, '2024-03-17', 'returned'),
('2024-03-04', 4, 4, '2024-03-18', 'overdue'),
('2024-03-05', 5, 5, '2024-03-19', 'issued');

select*from loan

-----payment

insert into payment (payment_date, amount, payment_method, LON_date, MEM_id, B_id)
values
('2024-03-05', 5.00, 'cash', '2024-03-01', 1, 1),
('2024-03-06', 3.00, 'card', '2024-03-02', 2, 2),
('2024-03-07', 4.50, 'cash', '2024-03-03', 3, 3),
('2024-03-08', 6.00, 'card', '2024-03-04', 4, 4);

select*from payment

----review

insert into review (review_date, MEM_id, B_id, rating)
values
('2024-03-10', 1, 1, 5),
('2024-03-11', 2, 2, 4),
('2024-03-12', 3, 3, 3),
('2024-03-13', 4, 4, 5);

select*from review


----DQL (Data Query Language)


---1. Display all book records.

select * from book;


---2. Display each book’s title, genre, and availability

select title, genre,  availabilitystatus
from book;



-----3. Display all member names, email, and membership start date.

select full_name, email, membership_start_date
from member;



---4. Display each book’s title and price as BookPrice.

select title, price as bookprice
from book;


---5. List books priced above 250 LE.

select *
from book
where price > 250;



---6. List members who joined before 2023.

select *
from member
where membership_start_date < '2023-01-01';



---7. Display books published after 2018.

---Add published_year column to book table

alter table book
add published_year int;

alter table book
add constraint ck_book_published_year
check (published_year >= 1900);

---Update sample data in published_year

update book set published_year = 2017 where book_id = 1;
update book set published_year = 2019 where book_id = 2;
update book set published_year = 2021 where book_id = 3;
update book set published_year = 2016 where book_id = 4;
update book set published_year = 2022 where book_id = 5;

---Display books published after 2018
select *
from book
where published_year > 2018;



---8. Display books ordered by price descending.

select *
from book
order by price desc;



----9. Display the maximum, minimum, and average book price

select 
    max(price) as max_price,
    min(price) as min_price,
    avg(price) as avg_price
from book;


---10. Display total number of books.

select count(*) as total_books
from book;

---11. Display members with NULL email.

select *
from member
where email is null;

---12. Display books whose title contains 'Data'.

select *
from book
where title like '%data%';



---DML (Data Manipulation Language)


--13. Insert yourself as a member (Member ID = 405).

set identity_insert member on;

insert into member (member_id, full_name, email, membership_start_date)
values (405, 'Widaad khalifa', 'Widaad@email.com', getdate());

set identity_insert member off;

select*from Member

--14. Register yourself to borrow book ID 1011.


   -- 1. Insert a book

 SET IDENTITY_INSERT Book ON;

INSERT INTO Book (book_id, ISBN, title, genre, price, shelf_location, LIB_id)
VALUES (1011, '978-5555555555', 'Database Systems', 'fiction', 49.99, 'A1', 1);

SET IDENTITY_INSERT Book OFF;


    -- Suppose the book_id returned is 1011

     -- 2. Insert a loan for an existing member (member_id = 405)

	 INSERT INTO Loan (loan_date, MEM_id, B_id, due_date)
VALUES (GETDATE(), 405, 1011, DATEADD(DAY, 14, GETDATE()));

   ---see the result

SELECT * FROM Book WHERE book_id = 1011;

---or

SELECT * FROM Loan WHERE B_id = 1011;


--15. Insert another member with NULL email and phone.


---Drop NOT NULL constraint on email

alter table member
alter column email varchar(100) null;

--Now insert NULL email

insert into member (full_name, email, phone_number, membership_start_date)
values ('test member', null, null, getdate());

select*from Member


--16. Update the return date of your loan to today.

update loan
set return_date = getdate(),
    status = 'returned'
where MEM_id = 405;

select*from loan

--17. Increase book prices by 5% for books priced under 200.

update book
set price = price * 1.05
where price < 200;

select*from Book


-----18. Update member status to 'Active' for recently joined members.

----add status column IN MEMBER

alter table member
add status varchar(20) default 'active';

---UPDATE value

update member
set status = 'active'
where membership_start_date >= '2023-01-01';

select*from Member

---19. Delete members who never borrowed a book.

delete from member
where member_id not in (
    select distinct member_id
    from loan
);


select*from Member