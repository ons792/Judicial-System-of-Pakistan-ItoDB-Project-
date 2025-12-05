CREATE DATABASE Judiciary;
USE Judiciary;

CREATE TABLE Court
(
  Court_ID INT NOT NULL,
  Court_Name VARCHAR(50) NOT NULL,
  Address VARCHAR(100) NOT NULL,
  PRIMARY KEY (Court_ID)
);

CREATE TABLE `Case`
(
  Case_ID INT NOT NULL,
  Case_Title VARCHAR(50) NOT NULL,
  Case_Description VARCHAR(100) NOT NULL,
  Date_Filed DATE NOT NULL,
  Date_Resolved DATE NOT NULL,
  Case_Status VARCHAR(20) NOT NULL,
  PRIMARY KEY (Case_ID)
);

CREATE TABLE Judge
(
  Judge_ID INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  Designation VARCHAR(50) NOT NULL,
  Court_ID INT NOT NULL,
  PRIMARY KEY (Judge_ID),
  FOREIGN KEY (Court_ID) REFERENCES Court(Court_ID)
);

CREATE TABLE Party
(
  Party_ID INT NOT NULL,
  Party_Name VARCHAR(50) NOT NULL,
  Party_Type VarCHAR(50) NOT NULL,
  Address VARCHAR(50) NOT NULL,
  Contact_Number FLOAT NOT NULL,
  PRIMARY KEY (Party_ID)
);

CREATE TABLE Hearing
(
  Hearing_ID INT NOT NULL,
  Hearing_Date DATE NOT NULL,
  Hearing_Outcome VARCHAR(100) NOT NULL,
  Judge_ID INT NOT NULL,
  Case_ID INT NOT NULL,
  PRIMARY KEY (Hearing_ID),
  FOREIGN KEY (Judge_ID) REFERENCES Judge(Judge_ID),
  FOREIGN KEY (Case_ID) REFERENCES `Case`(Case_ID)
);

CREATE TABLE Lawyer
(
  Lawyer_ID INT NOT NULL,
  Fname VARCHAR(50) NOT NULL,
  Lname VARCHAR(50) NOT NULL,
  Hearing_Date DATE NOT NULL,
  Party_ID INT NOT NULL,
  Case_ID INT NOT NULL,
  PRIMARY KEY (Lawyer_ID),
  FOREIGN KEY (Party_ID) REFERENCES Party(Party_ID),
  FOREIGN KEY (Case_ID) REFERENCES `Case`(Case_ID)
);

INSERT INTO Court (Court_ID, Court_Name, Address) VALUES
(1, 'District Court', 'Lower Mall Road, Data Gunj Buksh Town, Lahore'),
(2, 'Supreme Court', 'Ustad Allah Bakhsh Rd, near GPO, Mateen Avenue, Lahore'),
(3, 'High Court', 'Shahra-e-Quaid-e-Azam, Lahore'),
(4, 'Aiwan-e-Adal', 'Dev Samaj Road, Islampura, Lahore'),
(5, 'Appellate Court', 'Ustad Allah Bakhsh Rd, near GPO, Mateen Avenue, Lahore'),
(6, 'Family Court', 'Model Town, Lahore'),
(7, 'Juvenile Court', 'Garden Town, Lahore'),
(8, 'Labor Court', 'Muslim Town, Ferozepur Road, Lahore'),
(9, 'Banking Court', 'Muslim Town, Ferozepur Road, Lahore'),
(10, 'Tribunal Court', 'Gulberg II, Lahore');

INSERT INTO `Case` (Case_ID, Case_Title, Case_Description, Date_Filed, Date_Resolved, Case_Status) VALUES
(1, 'The State Vs. Ishaq Ali', 'Murder Case', '2023-01-01', 2023-02-15, 'Resolved'),
(2, 'The State Vs. Ali Khan', 'Murder Case', '2023-02-10', null, 'Pending'),
(3, 'MEDWAY Infrastructure pvt. ltd Vs. Saeed Anwar', 'Property Case', '2023-03-05', '2023-04-10', 'Resolved'),
(4, 'Alina Latif Vs. Jhangir Ali', 'Divorce Case', '2023-04-15', '2023-05-05', 'Resolved'),
(5, 'Shafique Khan Vs. Shezad Ashraf', 'Property Case', '2023-05-10', null, 'Pending'),
(6, 'The State Vs. Raza Khan', 'Assault Case', '2023-06-10', null, 'Pending'),
(7, 'The State Vs. Rehman Ali', 'Fraud Case', '2023-06-20', null, 'Pending'),
(8, 'Tech Solutions Pvt. Ltd Vs. Koders Pvt. Ltd', 'Contract Dispute', '2023-07-01', null, 'Pending'),
(9, 'Hassan Ali Vs. Ayesha Malik', 'Custody Case', '2023-07-15', null, 'Pending'),
(10, 'The State Vs. Bilal Nawaz', 'Murder Case', '2023-08-05', null, 'Pending');

INSERT INTO Judge (Judge_ID, Fname, Lname, Designation, Court_ID) VALUES
(1, 'Syed Ali', 'Rizvi', 'Majistrate Judge Class 2', 1),
(2, 'Muhammad Faiz', 'Aamir', 'Justice', 2),
(3, 'Komal', 'Ali', 'Justice', 3),
(4, 'Gohar', 'Sohail', 'Civil Judge Class 3', 4),
(5, 'Nisar', 'Hazeef', 'Justice', 5),
(6, 'Fatima', 'Saeed', 'Family Court Judge', 6),
(7, 'Ali Raza', 'Khan', 'Juvenile Court Judge', 7),
(8, 'Sadia', 'Khalid', 'Labor Court Judge', 8),
(9, 'Adnan', 'Rasheed', 'Banking Court Judge', 9),
(10, 'Hina', 'Khan', 'Tribunal Court Judge', 10);

INSERT INTO Party (Party_ID, Party_Name, Party_Type, Address, Contact_Number) VALUES
(1, 'Ishaq Ali', 'Individual', '123 Abubakr Street', 1234567890),
(2, 'Ali Khan', 'Individual', '456 Omar Street', 9876543210),
(3, 'MEDWAY Infrastructure Pvt. Ltd', 'Company', '789 Gulberg III', 1112223333),
(4, 'Saeed Anwar', 'Individual', '101 Usman Street', 4445556666),
(5, 'Alina Latif', 'Individual', '222 Ali Street', 7778889999),
(6, 'Jhangir Ali', 'Individual', '321 Main Street', 5551110000),
(7, 'Shafique Khan', 'Individual', '654 Stadium Road', 6669993333),
(8, 'Shezad Ashraf', 'Indivisual', '987 Gulberg V', 2223334444),
(9, 'Asad Hassan', 'Individual', '111 Liberty Road', 3337771111),
(10, 'Sana Ali', 'Individual', '333 XYZ Street', 4448882222),
(11, 'Koders Pvt. Ltd', 'Company', '555 ABC Street', 7774441111),
(12, 'Tech Solutions Pvt. Ltd', 'Company', '777 Sunshine Road', 8885552222),
(13, 'Hassan Ali', 'Individual', '999 XYZ Road', 9994447777),
(14, 'Ayesha Malik', 'Individual', '222 Liberty Street', 1110003333),
(15, 'Bilal Nawaz', 'Individual', '444 Jinnah Avenue', 2227774444);

INSERT INTO Hearing (Hearing_ID, Hearing_Date, Hearing_Outcome, Judge_ID, Case_ID) VALUES
(1, '2023-01-15', 'Ishaq Ali sentenced to 2 back to back life sentences without apeal', 1, 1),
(2, '2023-02-20', 'Pending', 2, 2),
(3, '2023-03-10', 'MEDWAY Infrastructure pvt. ltd won the case', 3, 3),
(4, '2023-04-05', 'Alina Latif divorced her husband Jhangir Ali and took the custody of kids', 4, 4),
(5, '2023-05-15', 'Pending', 5, 5),
(6, '2023-06-25', 'Pending', 6, 6),
(7, '2023-07-05', 'Pending', 7, 7),
(8, '2023-07-20', 'Pending', 8, 8),
(9, '2023-08-10', 'Pending', 9, 9),
(10, '2023-08-25', 'Pending', 10, 10);

INSERT INTO Lawyer (Lawyer_ID, Fname, Lname, Hearing_Date, Party_ID, Case_ID) VALUES
(1, 'Syed Hassan', 'Naqvi', '2023-01-15', 1, 1),
(2, 'Dawood', 'Ali', '2023-02-20', 2, 2),
(3, 'Shawwal', 'Nadeem', '2023-03-10', 3, 3),
(4, 'Mahnoor', 'Liaqat', '2023-04-05', 4, 3),
(5, 'Saleem', 'Sheikh', '2023-05-15', 5, 4),
(6, 'Amir', 'Hussain', '2023-06-20', 6, 4),
(7, 'Farah', 'Khan', '2023-07-01', 7, 5),
(8, 'Usman', 'Ali', '2023-07-15', 8, 5),
(9, 'Saima', 'Akhtar', '2023-08-05', 9, 6),
(10, 'Ahmed', 'Khalid', '2023-08-20', 10, 7),
(11, 'Sadia', 'Raza', '2023-09-01', 11, 8),
(12, 'Zubair', 'Ahmed', '2023-09-15', 12, 8),
(13, 'Nadia', 'Malik', '2023-10-05', 13, 9),
(14, 'Imran', 'Ahsan', '2023-10-20', 14, 9),
(15, 'Sara', 'Nawaz', '2023-11-01', 15, 10);





CREATE VIEW ResolvedCases AS
SELECT Case_ID, Case_Title, Case_Description, Date_Filed, Date_Resolved, Case_Status
FROM `Case`
WHERE Case_Status = 'Resolved';

SELECT * FROM ResolvedCases;

CREATE VIEW OngoingCases AS
SELECT Case_ID, Case_Title, Case_Description, Date_Filed, Case_Status
FROM `Case`
WHERE Case_Status = 'Pending';

SELECT * FROM OngoingCases;

CREATE VIEW JudgeCourts AS
SELECT j.Judge_ID, j.Fname, j.Lname, j.Designation, c.Court_Name
FROM Judge j
INNER JOIN Court c ON j.Court_ID = c.Court_ID;

SELECT * FROM JudgeCourts;

CREATE VIEW HearingOutcomes AS
SELECT h.Hearing_ID, h.Hearing_Date, h.Hearing_Outcome, j.Fname, j.Lname, c.Case_Title
FROM Hearing h
INNER JOIN Judge j ON h.Judge_ID = j.Judge_ID
INNER JOIN `Case` c ON h.Case_ID = c.Case_ID;

SELECT * FROM HearingOutcomes;


CALL GetCaseDetails(10);


SELECT c.Case_ID, c.Case_Title, p.Party_Name, p.Party_Type
FROM `Case` c
INNER JOIN Party p ON c.Case_ID = p.Case_ID
WHERE c.Case_Status = 'Resolved';

SELECT j.Judge_ID, j.Fname, j.Lname, j.Designation
FROM Judge j
INNER JOIN `Case` c ON j.Court_ID = c.Court_ID
WHERE c.Case_Status = 'Pending';

SELECT c.Case_ID, c.Case_Title, c.Case_Description
FROM `Case` c
WHERE c.Case_Status = 'Pending'
AND c.Case_ID IN (SELECT Party_ID FROM Party WHERE Party_Name = 'Ishaq Ali');

SELECT c.Case_ID, c.Case_Title, c.Case_Description
FROM `Case` c
WHERE c.Case_Status = 'Resolved'
AND c.Court_ID = (SELECT Court_ID FROM Court WHERE Court_Name = 'District Court');

SELECT c.Case_ID, c.Case_Title, c.Case_Description
FROM `Case` c
WHERE c.Case_ID IN (SELECT Case_ID FROM Hearing WHERE Judge_ID = 1);



SELECT l.Fname AS LawyerFirstName, l.Lname AS LawyerLastName, c.Case_Title
FROM Lawyer l
INNER JOIN `Case` c ON l.Case_ID = c.Case_ID
WHERE l.Hearing_Date >= '2023-06-01' AND l.Hearing_Date <= '2023-06-30';

SELECT Judge_ID, Fname, Lname, Court_Name
FROM Judge
LEFT JOIN Court ON Judge.Court_ID = Court.Court_ID;

SELECT j.Fname, j.Lname, h.Hearing_Date, h.Hearing_Outcome
FROM Judge j
RIGHT JOIN Hearing h ON j.Judge_ID = h.Judge_ID;

SELECT j.Fname, j.Lname, c.Court_Name
FROM Judge j
CROSS JOIN Court c;

SELECT c1.Court_Name, c2.Court_Name
FROM Court c1, Court c2
WHERE c1.Court_ID <> c2.Court_ID;
