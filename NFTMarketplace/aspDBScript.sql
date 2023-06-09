USE [master]
GO
/****** Object:  Database [Team108DB]    Script Date: 6/8/2023 2:10:48 PM ******/
CREATE DATABASE [Team108DB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Team108DB', FILENAME = N'S:\SQLData\MSSQL15.CISWEB\MSSQL\Data\Team108DB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Team108DB_log', FILENAME = N'L:\SQLLogs\MSSQL15.CISWEB\MSSQL\Logs\Team108DB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [Team108DB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Team108DB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Team108DB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Team108DB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Team108DB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Team108DB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Team108DB] SET ARITHABORT OFF 
GO
ALTER DATABASE [Team108DB] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Team108DB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Team108DB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Team108DB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Team108DB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Team108DB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Team108DB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Team108DB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Team108DB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Team108DB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Team108DB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Team108DB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Team108DB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Team108DB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Team108DB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Team108DB] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Team108DB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Team108DB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Team108DB] SET  MULTI_USER 
GO
ALTER DATABASE [Team108DB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Team108DB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Team108DB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Team108DB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Team108DB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Team108DB] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'Team108DB', N'ON'
GO
ALTER DATABASE [Team108DB] SET QUERY_STORE = OFF
GO
USE [Team108DB]
GO
/****** Object:  User [raspy]    Script Date: 6/8/2023 2:10:48 PM ******/
CREATE USER [raspy] FOR LOGIN [raspy] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [COLOSTATE\rousan]    Script Date: 6/8/2023 2:10:48 PM ******/
CREATE USER [COLOSTATE\rousan] FOR LOGIN [COLOSTATE\rousan] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [COLOSTATE\hkavadia]    Script Date: 6/8/2023 2:10:48 PM ******/
CREATE USER [COLOSTATE\hkavadia] FOR LOGIN [COLOSTATE\hkavadia] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [raspy]
GO
ALTER ROLE [db_owner] ADD MEMBER [COLOSTATE\rousan]
GO
ALTER ROLE [db_owner] ADD MEMBER [COLOSTATE\hkavadia]
GO
/****** Object:  Table [dbo].[tabCustomer]    Script Date: 6/8/2023 2:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tabCustomer](
	[CustomerID] [int] IDENTITY(1,1) NOT NULL,
	[Type] [varchar](50) NULL,
	[CardNumber] [varchar](20) NULL,
	[BillingAddress] [varchar](50) NULL,
	[CardName] [varchar](50) NULL,
	[CardValidity] [date] NULL,
	[CardCvv] [varchar](3) NULL,
	[UserName] [varchar](10) NULL,
	[UserPassword] [varchar](500) NULL,
	[Role] [nvarchar](10) NULL,
	[Email] [varchar](50) NULL,
	[DoB] [date] NULL,
	[FullName] [varchar](50) NULL,
	[Token] [nvarchar](200) NULL,
 CONSTRAINT [PK_tabCustomer] PRIMARY KEY CLUSTERED 
(
	[CustomerID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tabItem]    Script Date: 6/8/2023 2:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tabItem](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[UnitPrice] [float] NULL,
	[Sold] [int] NULL,
	[ProductImage] [nvarchar](500) NULL,
	[DigitalSignature] [nvarchar](70) NULL,
	[Description] [nvarchar](250) NULL,
	[ImageName] [nvarchar](20) NULL,
	[CreatedBy] [int] NULL,
 CONSTRAINT [PK_tabItem] PRIMARY KEY CLUSTERED 
(
	[ItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tabOrder]    Script Date: 6/8/2023 2:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tabOrder](
	[OrderID] [int] IDENTITY(1,1) NOT NULL,
	[OrderDate] [date] NULL,
	[CustomerFK] [int] NULL,
	[Processed] [int] NOT NULL,
 CONSTRAINT [PK_tabOrder] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tabOrderLineItem]    Script Date: 6/8/2023 2:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tabOrderLineItem](
	[OrderItemID] [int] IDENTITY(1,1) NOT NULL,
	[OrderName] [int] NULL,
	[ItemName] [int] NULL,
	[ItemPrice] [float] NULL,
	[ItemTax] [float] NULL,
 CONSTRAINT [PK_tabOrderLineItem] PRIMARY KEY CLUSTERED 
(
	[OrderItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tabProduct]    Script Date: 6/8/2023 2:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tabProduct](
	[ProductPK] [int] NOT NULL,
	[CategoryPK] [int] NOT NULL,
	[SubCategoryPK] [int] NOT NULL,
	[ModelNumber] [varchar](50) NULL,
	[ProductImage] [varchar](100) NULL,
	[UnitCost] [decimal](18, 0) NULL,
	[Description] [text] NULL,
 CONSTRAINT [PK_tabProduct] PRIMARY KEY CLUSTERED 
(
	[ProductPK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tabReview]    Script Date: 6/8/2023 2:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tabReview](
	[ReviewID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [date] NULL,
	[Review] [varchar](100) NULL,
	[ReviewBy] [int] NULL,
	[OnItem] [int] NULL,
 CONSTRAINT [PK_tabReview] PRIMARY KEY CLUSTERED 
(
	[ReviewID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tabUser]    Script Date: 6/8/2023 2:10:49 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tabUser](
	[UserID] [int] NOT NULL,
	[Email] [varchar](50) NULL,
	[DoB] [date] NULL,
	[SignupDate] [date] NULL,
	[LoggedIn] [int] NULL,
	[Password] [nvarchar](255) NULL,
	[Fullname] [nvarchar](100) NULL,
 CONSTRAINT [PK_tabUser] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[tabCustomer] ON 

INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (0, N'Buyer', N'2345-2345-2345-2345', N'Buyer Road', N'Buyer B', CAST(N'2023-12-01' AS Date), N'123', N'buyer', N'$2a$11$ConDtUXMR2HbPPFUU7W5keSk2G5cHIFodOTk7ugN1HDkUohs.Bw56', N'Buyer', N'yo@waddup.com', CAST(N'2022-04-03' AS Date), N'Buyer B', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (3, NULL, NULL, N'test', N'test', CAST(N'2033-01-01' AS Date), N'111', N'test', N'$2a$11$l9/dR8MzHkXohDd6DYQxJ.4AQZXTQBgpAdM68kOI6.F.zNrzx9r.W', N'Buyer', N'test@ymail.com', CAST(N'1982-01-01' AS Date), N'Test Test', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (4, N'Seller', N'2345-2345-2345-2345', N'Seller Street', N'Seller S', CAST(N'2027-11-01' AS Date), N'567', N'seller', N'$2a$11$hAKBmQ5CWtDVmeNCkF28dOHVFQHaMVS6J.rRJOeeSW.2x2i4nZuVi', N'Seller', N'seller@nomail.com', CAST(N'2023-03-26' AS Date), N'Seller S', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (8, NULL, N'1234-1234-1234-1243', N'New Seller Avenue', N'New Seller', CAST(N'2024-08-01' AS Date), N'123', N'newseller', N'$2a$11$Iv7yt15ETYodLLlMLJ54Ru2jZpIBqElP3C.L3HolPmlgdEhGbZTtC', N'Seller', N'newseller@nomail.com', CAST(N'2023-04-03' AS Date), N'Seller Panda', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (9, NULL, N'4308-3322-6677-9087', N'302, s clg ave', N'anil saini', CAST(N'2026-05-01' AS Date), N'890', N'anil0327', N'$2a$11$CKFu6PMAClLTLAbKQ0fcquofUxOOPG2/xbqQXj./rXbQGz7PO5Pae', N'Seller', N'anil.saini@colostate.edu', CAST(N'2004-03-27' AS Date), N'anil saini', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (18, NULL, N'4566-4563-3466-4566', N'Rams Village', N'Arjit Gupta', CAST(N'2026-06-01' AS Date), N'345', N'arjitg', N'$2a$11$tFOBti0ix9OLzToB9bUFAe8PexRV6HNFdc5gW6gDX6IXZbXoj3Wp2', N'Seller', N'arjitg@colostate.edu.com', CAST(N'1991-12-29' AS Date), N'Arjit Gupta', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (19, NULL, N'3453-2345-1234-6789', N'New Roads', N'Anon Seller', CAST(N'2021-04-01' AS Date), N'234', N'anon', N'$2a$11$UhC7oP/bpWSzvuI8ndTjpeFdgFFp4oHg7VpftqwsHAsxC.gKnYvJ6', N'Seller', N'anon@ymail.com', CAST(N'2023-04-03' AS Date), N'Mr Webster', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (20, NULL, N'1234-1234-1234-1234', N'Pune', N'Sneha', CAST(N'2023-07-01' AS Date), N'123', N'Sneha', N'$2a$11$yq3UOHbErGE71S2rnlq45upfLxgYrWtrI3WCDFSsLmJWVSeee/zEa', N'Buyer', N'sneha@nomail.com', CAST(N'1998-01-06' AS Date), N'Sneha Gupta', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (21, NULL, N'1234-1234-1234-1234', NULL, N'test', CAST(N'2023-04-01' AS Date), NULL, N'testtest', N'$2a$11$HQ.zQ1ztbgSiN2w/cPkTauNH.fgnA2QbAsGPi5E6Lggq/meWXa3dG', N'Buyer', NULL, CAST(N'2023-03-27' AS Date), N'Test Test', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (22, NULL, N'1234-1234-1234-1234', N'test', N'test', CAST(N'2020-12-01' AS Date), N'111', N'testtest2', N'$2a$11$5j1Ne8G3mIyP1DWcQrr1aOHm2Q/sJVzULEKJXKy4bRRh4Zw0a0ZhC', N'Seller', N'testtest2@ymail.com', CAST(N'2023-04-26' AS Date), N'Test Trst', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (25, NULL, N'4566-4563-3466-4566', N'Arjit Palace Street', N'Arjit Gupta', CAST(N'2025-06-01' AS Date), N'345', N'nodetest', N'$2a$10$idLNbTQUBmhOxqzY22nRT.rWsS8PoocMOemZgXzz3jgB.JqL081Le', N'Buyer', N'arjitg@nodetest.org', CAST(N'1994-04-23' AS Date), N'Arjit Gupta', NULL)
INSERT [dbo].[tabCustomer] ([CustomerID], [Type], [CardNumber], [BillingAddress], [CardName], [CardValidity], [CardCvv], [UserName], [UserPassword], [Role], [Email], [DoB], [FullName], [Token]) VALUES (26, NULL, N'1234-1234-1234-1234', N'Address', N'Card Cards', CAST(N'2023-10-01' AS Date), N'123', N'welcome', N'$2a$10$ucJadGz6GDhndabEsgKKYOnAMzpkCteT4ziZbMAE/mxalmSDn8ZSW', N'Buyer', N'welcome@yahoo.com', CAST(N'1994-04-23' AS Date), N'Saaa Gooo', N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwayI6MjYsImlhdCI6MTY4MzczOTEyOCwiZXhwIjoxNjgzNzQyNzI4fQ.wwLQSnEmrLDlH4QwNe1kDjmflv-gzslXiA5IfWq0wuk')
SET IDENTITY_INSERT [dbo].[tabCustomer] OFF
GO
SET IDENTITY_INSERT [dbo].[tabItem] ON 

INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (7, 350, 1, N'bird.jpg', N'1C47766FD11828DD7ACBE8B92D5C8AE5A9D9A1922F4F9E2D3E885B8A55DFE29F', N'Parrots, also known as psittacines, are birds of the roughly 398 species in 92 genera comprising the order Psittaciformes.', N'Parrot', 4)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (17, 200, 1, N'chickenNFT.jpg', N'B28AF24D5FFEF75D8206201833D871F292976DE87F631EAEB98EC95D06D14CD2', N'Chicken getting ready for a fight. This NFT image is a part of a rare collection fom the great artist Arjit Gupta.', N'ChickenNFT', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (20, 500, 0, N'AI designed future cities.jpg', N'4EDBF6527B735ACC14F858338C3DAA5877DF6ACF115E455E6289D3B93A44ED7C', N'This is an image of AI generated future cities that will be modern in every way in addition to taking care of the environment.', N'AI designed Cities', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (21, 900, 1, N'COB.jpg', N'4D9A1FC1EB77995671959F101652B8B776EBA768398B01201A355FCAE38D6A6C', N'Image of college of business at CSU which is known for its excellence in Impact MBA and MCIS programs.', N'College of Business', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (22, 900, 0, N'CSU flag.jpg', N'B95B7A31D954A416293E1A0DA634076BCA0710D4E3195A31A9B593AC63EBFAED', N'Flag of Colorado State University. This university is one of the finest in Colorado.', N'CSU Flag', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (23, 800, 0, N'Flower Garden.jpg', N'08ED29E237EB1A7D60AF91AB66F730BB0BAD5EDDCADEEF98467C4FD5B9930FD5', N'This is a digital image of a flower garden having different varieties.', N'Garden Image', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (24, 850, 0, N'Lory-Student-Center.jpg', N'B162A3BD23361D9EE1637DB01C8F949BA2475E005438744BDD3F0F16CDF7BD44', N'Image of Lory Student Center at CSU which is known for its excellence and is a home to various student clubs and organizations.', N'Lory Student Center', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (25, 750, 0, N'MarvellousArchitecture.jpg', N'30BDD3DD7043B08B02248B1E4330B90B3AD472B69D093AC362171EB8275C9AAA', N'This is an image that shows the skyscrapers having an amazing architecture.', N'Skyscrapers', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (26, 250, 0, N'Masih Alinejad.jpg', N'87F21C813586ED9388C84AD126DED9310407ED5D544CB4667E953131BDFFEB60', N'This is a digital image of Masih Alinejad. She is one of the times woman for the year 2023.', N'Masih Alinejad', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (27, 450, 1, N'Mountain Lake photo.jpg', N'63E4D82CB7DC42540DF3C87042EF209B0BEEE41EDAC7714AF5AE8AA61DFE6F0B', N'Image showing amazing reflection of a mountain in a lake during the spring season.', N'Mountain Lake', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (28, 480, 0, N'NFT-Genie.jpg', N'0A3C71A3244C776C8F0064ACE5236B4FBC29B42986DF7EA1C070820B3E92C4B2', N'Digital Image of a genie. Genie is a mystical and supernatural creature founding place in folk tales.', N'Genie NFT image', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (29, 900, 0, N'peacock.jpg', N'7A860C7A18E9C82D05E11B2001E5A3413DECD605745D91C98AC1BCDCA453B272', N'This is an image of a Peacock. Its the national bird of India and is consodered sacred.', N'Peacock', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (30, 870, 0, N'ROCKY-MOUNTAINS.jpg', N'42B89A6123B49C18503D14D25BC0B804CF34B617CDEAFE4781A6F01B3A60D4C2', N'The Rocky Mountains also known as the Rockies are a major mountain range in USA.', N'Rocky Mountains', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (31, 280, 0, N'Tiger taking a lesiure walk.jpg', N'3EA266BEE231A2EEECE731F4C28CE0A25B9EF9DE619CC2C1024527ED21E48105', N'A Tiger taking a leisure walk in the forest. Its the national animal of India and is protected species.', N'Tiger', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (32, 120, 0, N'World''s tallest building.jpg', N'E25F0431091C802F113EDA25AC280B87A109800F814A6658134F1E90BFD2F81F', N'This is the world''s tallest building called Burj Khalifa and is located in Dubai.', N'Burj Khalifa', 9)
INSERT [dbo].[tabItem] ([ItemID], [UnitPrice], [Sold], [ProductImage], [DigitalSignature], [Description], [ImageName], [CreatedBy]) VALUES (36, -1234, 0, N'googlelogo_color_272x92dp.png', N'5A8BA537A72B43DFADA99A5D91008A0BA007704E98D352EF3433BFCBD1B52056', N'Nice', NULL, 22)
SET IDENTITY_INSERT [dbo].[tabItem] OFF
GO
SET IDENTITY_INSERT [dbo].[tabOrder] ON 

INSERT [dbo].[tabOrder] ([OrderID], [OrderDate], [CustomerFK], [Processed]) VALUES (16, CAST(N'2023-04-14' AS Date), 0, 1)
INSERT [dbo].[tabOrder] ([OrderID], [OrderDate], [CustomerFK], [Processed]) VALUES (17, CAST(N'2023-04-14' AS Date), 0, 1)
INSERT [dbo].[tabOrder] ([OrderID], [OrderDate], [CustomerFK], [Processed]) VALUES (20, CAST(N'2023-04-23' AS Date), 21, 1)
INSERT [dbo].[tabOrder] ([OrderID], [OrderDate], [CustomerFK], [Processed]) VALUES (22, CAST(N'2023-04-23' AS Date), 21, 1)
SET IDENTITY_INSERT [dbo].[tabOrder] OFF
GO
SET IDENTITY_INSERT [dbo].[tabOrderLineItem] ON 

INSERT [dbo].[tabOrderLineItem] ([OrderItemID], [OrderName], [ItemName], [ItemPrice], [ItemTax]) VALUES (16, 16, 7, 350, 1.2)
INSERT [dbo].[tabOrderLineItem] ([OrderItemID], [OrderName], [ItemName], [ItemPrice], [ItemTax]) VALUES (17, 17, 27, 450, 1.2)
INSERT [dbo].[tabOrderLineItem] ([OrderItemID], [OrderName], [ItemName], [ItemPrice], [ItemTax]) VALUES (20, 20, 21, 900, 1.2)
INSERT [dbo].[tabOrderLineItem] ([OrderItemID], [OrderName], [ItemName], [ItemPrice], [ItemTax]) VALUES (22, 22, 17, 200, 1.2)
SET IDENTITY_INSERT [dbo].[tabOrderLineItem] OFF
GO
INSERT [dbo].[tabProduct] ([ProductPK], [CategoryPK], [SubCategoryPK], [ModelNumber], [ProductImage], [UnitCost], [Description]) VALUES (1, 1, 1, N'1234', N'https://cloudfour.com/examples/img-currentsrc/images/kitten-large.png', CAST(25 AS Decimal(18, 0)), N'An image of kitten')
INSERT [dbo].[tabProduct] ([ProductPK], [CategoryPK], [SubCategoryPK], [ModelNumber], [ProductImage], [UnitCost], [Description]) VALUES (2, 2, 2, N'2345', N'https://cisweb.biz.colostate.edu/cis665/Team108/images/bird.jpg', CAST(30 AS Decimal(18, 0)), N'Image from Team108 folder')
GO
SET IDENTITY_INSERT [dbo].[tabReview] ON 

INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (5, CAST(N'2023-04-14' AS Date), N'Its a lucky parrot', 0, 7)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (6, CAST(N'2023-04-14' AS Date), N'Must visit for this summer', 0, 27)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (7, CAST(N'2023-04-14' AS Date), N'Happy with my purchase. This digital image is of high quality. Value for Money.', 9, 7)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (8, CAST(N'2023-04-14' AS Date), N'High Quality Digital image. Must buy. Available at a discount currently.', 9, 17)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (10, CAST(N'2023-04-14' AS Date), N'High Quality Digital image. Must buy. Available at a discount currently.', 9, 32)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (11, CAST(N'2023-04-14' AS Date), N'Photo by an award winning photographer. Close up shoot of a tiger.', 9, 31)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (12, CAST(N'2023-04-14' AS Date), N'Must visit place during spring and summers.', 9, 30)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (13, CAST(N'2023-04-14' AS Date), N'Very vibrant showing the full colors in peacock feathers.', 9, 29)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (14, CAST(N'2023-04-14' AS Date), N'Own this mysterious and mythical creature image.', 9, 28)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (15, CAST(N'2023-04-14' AS Date), N'Highly satisfied with my purchase. this image is a nice addition to my collection.', 9, 27)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (16, CAST(N'2023-04-14' AS Date), N'Masih fighting for the rights of Iranian women.', 9, 26)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (17, CAST(N'2023-04-14' AS Date), N'View of Manhattan skyscrapers taken from a helicopter.', 9, 25)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (18, CAST(N'2023-04-14' AS Date), N'This center welcomes students from all races, religions and ethnicities.', 9, 24)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (19, CAST(N'2023-04-14' AS Date), N'A blooming garden near the rocky mountains area.', 9, 23)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (20, CAST(N'2023-04-14' AS Date), N'Buy this flag to support your favorite team at sports events.', 9, 22)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (21, CAST(N'2023-04-14' AS Date), N'This image taken by a College of business student showcases the front entrance.', 9, 21)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (22, CAST(N'2023-04-14' AS Date), N'Would you imagine to live in eco friendly future cities? Own this piece of art from an AI.', 9, 20)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (23, CAST(N'2023-04-14' AS Date), N'It feels great to have made this.', 18, 17)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (24, CAST(N'2023-04-23' AS Date), NULL, 21, 7)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (25, CAST(N'2023-04-23' AS Date), N'test', 22, 36)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (26, CAST(N'2023-04-07' AS Date), N'A review by arjitg', 25, 20)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (27, CAST(N'2023-04-07' AS Date), N'Nodejs API review test', 25, 20)
INSERT [dbo].[tabReview] ([ReviewID], [Date], [Review], [ReviewBy], [OnItem]) VALUES (28, CAST(N'2023-04-10' AS Date), N'Test Today!', 26, 20)
SET IDENTITY_INSERT [dbo].[tabReview] OFF
GO
ALTER TABLE [dbo].[tabOrder] ADD  CONSTRAINT [DF_tabOrder_OrderDate]  DEFAULT (getdate()) FOR [OrderDate]
GO
ALTER TABLE [dbo].[tabUser] ADD  CONSTRAINT [DF_tabUser_SignupDate]  DEFAULT (getdate()) FOR [SignupDate]
GO
ALTER TABLE [dbo].[tabItem]  WITH CHECK ADD  CONSTRAINT [FK_tabItem_tabCustomer] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[tabCustomer] ([CustomerID])
GO
ALTER TABLE [dbo].[tabItem] CHECK CONSTRAINT [FK_tabItem_tabCustomer]
GO
ALTER TABLE [dbo].[tabOrder]  WITH CHECK ADD  CONSTRAINT [FK_tabOrder_tabCustomer] FOREIGN KEY([CustomerFK])
REFERENCES [dbo].[tabCustomer] ([CustomerID])
GO
ALTER TABLE [dbo].[tabOrder] CHECK CONSTRAINT [FK_tabOrder_tabCustomer]
GO
ALTER TABLE [dbo].[tabOrderLineItem]  WITH CHECK ADD  CONSTRAINT [FK_tabOrderLineItem_tabItem] FOREIGN KEY([ItemName])
REFERENCES [dbo].[tabItem] ([ItemID])
GO
ALTER TABLE [dbo].[tabOrderLineItem] CHECK CONSTRAINT [FK_tabOrderLineItem_tabItem]
GO
ALTER TABLE [dbo].[tabOrderLineItem]  WITH CHECK ADD  CONSTRAINT [FK_tabOrderLineItem_tabOrder] FOREIGN KEY([OrderName])
REFERENCES [dbo].[tabOrder] ([OrderID])
GO
ALTER TABLE [dbo].[tabOrderLineItem] CHECK CONSTRAINT [FK_tabOrderLineItem_tabOrder]
GO
ALTER TABLE [dbo].[tabReview]  WITH CHECK ADD  CONSTRAINT [FK_tabReview_tabCustomer] FOREIGN KEY([ReviewBy])
REFERENCES [dbo].[tabCustomer] ([CustomerID])
GO
ALTER TABLE [dbo].[tabReview] CHECK CONSTRAINT [FK_tabReview_tabCustomer]
GO
ALTER TABLE [dbo].[tabReview]  WITH CHECK ADD  CONSTRAINT [FK_tabReview_tabItem] FOREIGN KEY([OnItem])
REFERENCES [dbo].[tabItem] ([ItemID])
GO
ALTER TABLE [dbo].[tabReview] CHECK CONSTRAINT [FK_tabReview_tabItem]
GO
USE [master]
GO
ALTER DATABASE [Team108DB] SET  READ_WRITE 
GO
