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
    
    REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM company, worker, executive, distributor;
    REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public FROM company, worker, executive, distributor;
    
    GRANT USAGE ON SCHEMA public TO company, worker, executive, distributor;
    
    GRANT EXECUTE ON PROCEDURE add_company(VARCHAR(50), VARCHAR(50), VARCHAR(100), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(15)) TO company;
    GRANT EXECUTE ON PROCEDURE update_company(VARCHAR(50), VARCHAR(50), VARCHAR(100), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(15)) TO company;
    GRANT EXECUTE ON PROCEDURE remove_company(VARCHAR(50)) TO company;
    
    GRANT EXECUTE ON PROCEDURE add_contract(VARCHAR(50), BIT(1), TIMESTAMP) TO company;
    GRANT EXECUTE ON PROCEDURE update_contract(VARCHAR(50), BIT(1), TIMESTAMP) TO company;
    GRANT EXECUTE ON PROCEDURE remove_contract(VARCHAR(50)) TO company;
    
    GRANT EXECUTE ON PROCEDURE add_hardware(VARCHAR(50), TEXT) TO company;
    GRANT EXECUTE ON PROCEDURE update_hardware(INTEGER, VARCHAR(50), TEXT) TO company;
    GRANT EXECUTE ON PROCEDURE remove_hardware(INTEGER) TO company;
    
    GRANT EXECUTE ON PROCEDURE add_staff(VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50)) TO company;
    GRANT EXECUTE ON PROCEDURE update_staff(VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50), VARCHAR(50)) TO company;
    GRANT EXECUTE ON PROCEDURE remove_staff(VARCHAR(50)) TO company;
    
    GRANT EXECUTE ON PROCEDURE add_request(INTEGER, VARCHAR(50), VARCHAR(50), TEXT) TO company;
    GRANT EXECUTE ON PROCEDURE update_request(INTEGER, INTEGER, VARCHAR(50), VARCHAR(50), TEXT) TO company;
    GRANT EXECUTE ON PROCEDURE remove_request(INTEGER) TO company;
    
    GRANT EXECUTE ON PROCEDURE add_request(INTEGER, VARCHAR(50), VARCHAR(50), TEXT) TO worker;
    GRANT EXECUTE ON PROCEDURE update_request(INTEGER, INTEGER, VARCHAR(50), VARCHAR(50), TEXT) TO worker;
    GRANT EXECUTE ON PROCEDURE remove_request(INTEGER) TO worker;
    
    GRANT EXECUTE ON PROCEDURE add_task(INTEGER, TEXT, INTEGER, VARCHAR(50)) TO distributor;
    GRANT EXECUTE ON PROCEDURE update_task(INTEGER, INTEGER, TEXT, INTEGER, VARCHAR(50)) TO distributor;
    GRANT EXECUTE ON PROCEDURE remove_task(INTEGER) TO distributor;
    
    GRANT SELECT ON TABLE Requests TO executive;
    GRANT SELECT ON TABLE Tasks TO executive;
    
    GRANT SELECT ON TABLE Requests TO distributor;
    GRANT SELECT ON TABLE Staff TO distributor;
END;
$$ LANGUAGE plpgsql;
