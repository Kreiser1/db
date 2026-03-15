CREATE OR REPLACE PROCEDURE create_roles()
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'administrator') THEN
        CREATE ROLE administrator;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'company') THEN
        CREATE ROLE company;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'worker') THEN
        CREATE ROLE worker;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'executive') THEN
        CREATE ROLE executive;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'distributor') THEN
        CREATE ROLE distributor;
    END IF;

    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrator;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO administrator;
    GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO administrator;
    GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO administrator;
    GRANT CREATE ON SCHEMA public TO administrator;
    
    GRANT EXECUTE ON PROCEDURE add_hardware(VARCHAR(50), TEXT) TO company;
    GRANT EXECUTE ON PROCEDURE add_request(INTEGER, VARCHAR(50), VARCHAR(50), TEXT) TO company;

    GRANT EXECUTE ON PROCEDURE add_request(INTEGER, VARCHAR(50), VARCHAR(50), TEXT) TO worker;
    
    GRANT EXECUTE ON PROCEDURE add_task(TEXT, INTEGER, VARCHAR(50), INTEGER) TO distributor;
    GRANT EXECUTE ON PROCEDURE reassign_tasks(VARCHAR(50), VARCHAR(50)) TO distributor;
    GRANT EXECUTE ON FUNCTION get_department_staff(VARCHAR(50), VARCHAR(50)) TO distributor;

    REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM company, worker, executive, distributor;
    REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM company, worker, executive, distributor;
    
    GRANT USAGE ON SCHEMA public TO company, worker, executive, distributor;
    GRANT SELECT, INSERT, UPDATE ON TABLE Companies TO company;
    GRANT SELECT, INSERT ON TABLE Hardware TO company;
    GRANT SELECT, INSERT ON TABLE Requests TO company, worker;
    GRANT SELECT, INSERT, UPDATE ON TABLE Tasks TO distributor;
    GRANT SELECT ON TABLE Requests TO distributor, executive;
    GRANT SELECT ON TABLE Staff TO distributor, executive;
    GRANT SELECT ON TABLE Companies TO distributor;
    GRANT SELECT ON TABLE Contracts TO distributor;
    GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO company, distributor;
END;
$$ LANGUAGE plpgsql;
