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
    GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO administrator;
    
    GRANT INSERT ON TABLE Hardware TO company;
    GRANT INSERT ON TABLE Requests TO company;

    GRANT INSERT ON TABLE Requests TO worker;
    
    GRANT SELECT ON TABLE Tasks TO executive;
    GRANT SELECT ON TABLE Requests TO executive;
    
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Tasks TO distributor;
    GRANT SELECT ON TABLE Requests TO distributor;
    GRANT SELECT ON TABLE Staff TO distributor;

    GRANT SELECT ON TABLE Companies TO distributor;
    GRANT SELECT ON TABLE Contracts TO distributor;
END;
$$ LANGUAGE plpgsql;
