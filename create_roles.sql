CREATE OR REPLACE FUNCTION create_roles()
RETURNS void AS $$
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
    
    GRANT SELECT, INSERT, UPDATE ON TABLE Companies TO company;
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Hardware TO company;
    GRANT SELECT, INSERT, UPDATE ON TABLE Requests TO company;
    GRANT USAGE ON SEQUENCE hardware_id_seq TO company;
    GRANT USAGE ON SEQUENCE requests_id_seq TO company;
    
    GRANT SELECT, INSERT, UPDATE ON TABLE Requests TO worker;
    GRANT USAGE ON SEQUENCE requests_id_seq TO worker;
    
    GRANT SELECT ON TABLE Tasks TO executive;
    GRANT SELECT ON TABLE Requests TO executive;
    
    GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Tasks TO distributor;
    GRANT SELECT ON TABLE Requests TO distributor;
    GRANT SELECT ON TABLE Staff TO distributor;
    GRANT USAGE ON SEQUENCE tasks_taskid_seq TO distributor;

    GRANT SELECT ON TABLE Companies TO company, worker, executive, distributor;
    GRANT SELECT ON TABLE Contracts TO company, worker, executive, distributor;
    GRANT SELECT ON TABLE Hardware TO company, worker, executive, distributor;
    GRANT SELECT ON TABLE Staff TO company, worker, executive, distributor;
END;
$$ LANGUAGE plpgsql;
