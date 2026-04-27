DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'administrator') THEN
        CREATE ROLE administrator;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'company') THEN
        CREATE ROLE company;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'executor') THEN
        CREATE ROLE executor;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'distributor') THEN
        CREATE ROLE distributor;
    END IF;

    GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO administrator;
    GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO administrator;
    GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO administrator;
    GRANT ALL PRIVILEGES ON ALL PROCEDURES IN SCHEMA public TO administrator;
    GRANT CREATE ON SCHEMA public TO administrator;
    
    GRANT USAGE ON SCHEMA public TO company, executor, distributor;
    
    GRANT EXECUTE ON PROCEDURE Requests_Insert(VARCHAR, INTEGER, TEXT, VARCHAR, VARCHAR, TIMESTAMP) TO company;
    GRANT EXECUTE ON PROCEDURE Requests_FormatId(TIMESTAMP) TO company;
    GRANT SELECT ON TABLE Hardware TO company;
    GRANT SELECT ON TABLE Requests TO company;
    
    GRANT EXECUTE ON PROCEDURE Tasks_Insert(VARCHAR, TEXT, VARCHAR, TIMESTAMP, VARCHAR, VARCHAR, TIMESTAMP) TO distributor;
    GRANT EXECUTE ON PROCEDURE Tasks_Update(VARCHAR, VARCHAR, TEXT, VARCHAR, VARCHAR, TIMESTAMP, TIMESTAMP) TO distributor;
    GRANT EXECUTE ON PROCEDURE Tasks_Delete(VARCHAR) TO distributor;
    GRANT EXECUTE ON PROCEDURE Requests_Delete(VARCHAR) TO distributor;
    GRANT SELECT ON TABLE Requests TO distributor;
    GRANT SELECT ON TABLE Staff TO distributor;
    GRANT SELECT ON TABLE Tasks TO distributor;
    
    GRANT SELECT ON TABLE Tasks TO executor;
    GRANT SELECT ON TABLE Hardware TO executor;
END;
$$;
