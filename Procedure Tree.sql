--Vincent Mark - 6182101013
ALTER PROCEDURE tree
    @root int,
    @n int
AS
    DECLARE @child TABLE (
        idMember int,
        idParent int
    )

    DECLARE @i int
    SET @i = 1

    -- Get root's child(ren)
    INSERT INTO @child (idMember, idParent)
    SELECT idMember, idParent
    FROM Tree
    WHERE idParent = @root

    -- Loop through depth tree
    WHILE @i < @n
    BEGIN
        INSERT INTO @child (idMember, idParent)
        SELECT  t.idMember, t.idParent
        FROM Tree as t
        JOIN @child as c ON t.idParent = c.idMember

        SET @i = @i + 1
    END

    SELECT * FROM @child
go

exec getTree @root = 4, @n = 2
