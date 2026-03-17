CREATE OR REPLACE PROCEDURE drop_database()
AS $$
BEGIN
    SET CONSTRAINTS ALL DEFERRED;
    
    DELETE FROM Tasks;
    DELETE FROM Requests;
    DELETE FROM Staff;
    DELETE FROM Hardware;
    DELETE FROM Contracts;
    DELETE FROM Companies;
    
    PERFORM setval('hardware_id_seq', 1, false);
    PERFORM setval('requests_id_seq', 1, false);
    PERFORM setval('tasks_taskid_seq', 1, false);
    
    SET CONSTRAINTS ALL IMMEDIATE;
END;
$$ LANGUAGE plpgsql;

call drop_database();
