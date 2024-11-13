create Table Users
(
User_ID int primary key ,
Name varchar(255),
Age int,
Gender varchar(10),
Profile_Picture varchar(255),
Address varchar(255)
)

create Table Posts
(
Post_ID int primary key,
User_ID int,
Content text,
Date datetime,
Foreign Key (User_ID) references Users(User_ID)
)

create Table Post_Images
(
Post_Images_ID int primary key,
Post_ID int,
Images_url varchar(255),
Foreign Key (Post_ID) references Posts(Post_ID)
)

create Table Comments
(
Comment_ID int primary key,
User_ID int,
Post_ID int,
Content text,
Date datetime,
Foreign Key (User_ID) references Users(User_ID),
Foreign Key (Post_ID) references Posts(Post_ID)
)

create Table Comment_Images
(
Comment_Images_ID int primary key,
Comment_ID int,
Images_url varchar(255),
Foreign Key (Comment_ID) references Comments(Comment_ID)
)

create Table Messages
(
Message_ID int primary key,
Sender_ID int,
Reciver_ID int,
Contect text,
Date datetime,
Foreign Key (Sender_ID) references Users(User_ID),
Foreign Key (Reciver_ID) references Users(User_ID)
)

create Table Reactions
(
Reaction_ID int primary key,
User_ID int,
Post_ID int,
Comment_ID int,
Reation varchar(255),
Foreign Key (User_ID) references Users(User_ID),
Foreign Key (Post_ID) references Posts(Post_ID),
Foreign Key (Comment_ID) references Comments(Comment_ID)
)

