CREATE OR REPLACE PROCEDURE drop_database()
AS $$
BEGIN
    DROP TABLE IF EXISTS Tasks CASCADE;
    DROP TABLE IF EXISTS Requests CASCADE;
    DROP TABLE IF EXISTS Staff CASCADE;
    DROP TABLE IF EXISTS Hardware CASCADE;
    DROP TABLE IF EXISTS Contracts CASCADE;
    DROP TABLE IF EXISTS Companies CASCADE;

    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'distributor') THEN
        DROP ROLE distributor;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'executive') THEN
        DROP ROLE executive;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'worker') THEN
        DROP ROLE worker;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'company') THEN
        DROP ROLE company;
    END IF;
    
    IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'administrator') THEN
        DROP ROLE administrator;
    END IF;
END;
$$ LANGUAGE plpgsql;
