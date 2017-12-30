/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- TRIGGER ---
-- Trigger Insert Transaction
CREATE TRIGGER trgInsTrans
ON Transactions.MainTrans 
FOR INSERT AS
	UPDATE Services.RoomType
	SET RoomAvailable = RoomAvailable - 1,
		RoomIsUsed = RoomIsUsed + 1
	WHERE RTypeID = (
					SELECT RTypeID FROM vRoom
					WHERE RoomNum = (SELECT RoomNum FROM INSERTED)
					)
	UPDATE Services.RoomNum
	SET Status = 'Booked'
	WHERE RoomNum = (SELECT RoomNum FROM INSERTED)
GO


-- Trigger Delete Transaction
CREATE TRIGGER trgDelTrans
ON Transactions.MainTrans 
FOR DELETE AS
	UPDATE Services.RoomType
	SET RoomAvailable = RoomAvailable + 1,
		RoomIsUsed = RoomIsUsed - 1
	WHERE RTypeID = (
					SELECT RTypeID FROM vRoom
					WHERE RoomNum = (SELECT RoomNum FROM DELETED)
					)
	UPDATE Services.RoomNum
	SET Status = 'Available'
	WHERE RoomNum = (SELECT RoomNum FROM DELETED)
	UPDATE Transactions.TransHistory
	SET Status = 'Cancelled'
	WHERE TransID = (SELECT TransID FROM DELETED)
GO




SP_HELP 'Transactions.MainTrans'						
EXEC sp_helptrigger 'Transactions.MainTrans ';

DISABLE TRIGGER trgTrans6
ON Transactions.MainTrans;  

	SELECT RoomAvailable FROM Services.RoomType
	WHERE RTypeID = (
					SELECT RTypeID FROM vRoom
					WHERE RoomNum = 'RS306'
					);