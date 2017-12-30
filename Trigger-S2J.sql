/*						S2J APARTMENT DB 
	Shafira Az'zahra, Julius Danes Nugroho, Jofanto Alfaj
*/

		--- USE DATBASE ---
USE S2J_ApartmentDB
GO

		--- TRIGGER ---
-- Trigger Insert Transaction
CREATE TRIGGER trgTrans
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

SP_HELP 'Transactions.MainTrans'						
EXEC sp_helptrigger 'Transactions.MainTrans ';

DISABLE TRIGGER trgTrans6
ON Transactions.MainTrans;  

	SELECT ROM
	SELECT RoomAvailable FROM Services.RoomType
	WHERE RTypeID = (
					SELECT RTypeID FROM vRoom
					WHERE RoomNum = 'RS306'
					);