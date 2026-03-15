CREATE OR REPLACE PROCEDURE create_requests()
AS $$
BEGIN
    CREATE OR REPLACE PROCEDURE add_company(
        p_contractId VARCHAR(50),
        p_representativePosition VARCHAR(50),
        p_fullName VARCHAR(100),
        p_shortName VARCHAR(50),
        p_phyicalAddress VARCHAR(50),
        p_legalAddress VARCHAR(50),
        p_contactPhone VARCHAR(15)
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Companies (contractId, representativePosition, fullName, shortName, phyicalAddress, legalAddress, contactPhone)
        VALUES (p_contractId, p_representativePosition, p_fullName, p_shortName, p_phyicalAddress, p_legalAddress, p_contactPhone);
    END;
    $$;

    CREATE OR REPLACE PROCEDURE update_company(
        p_contractId VARCHAR(50),
        p_representativePosition VARCHAR(50) DEFAULT NULL,
        p_fullName VARCHAR(100) DEFAULT NULL,
        p_shortName VARCHAR(50) DEFAULT NULL,
        p_phyicalAddress VARCHAR(50) DEFAULT NULL,
        p_legalAddress VARCHAR(50) DEFAULT NULL,
        p_contactPhone VARCHAR(15) DEFAULT NULL
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Companies 
        SET representativePosition = COALESCE(p_representativePosition, representativePosition),
            fullName = COALESCE(p_fullName, fullName),
            shortName = COALESCE(p_shortName, shortName),
            phyicalAddress = COALESCE(p_phyicalAddress, phyicalAddress),
            legalAddress = COALESCE(p_legalAddress, legalAddress),
            contactPhone = COALESCE(p_contactPhone, contactPhone)
        WHERE contractId = p_contractId;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE delete_company(p_contractId VARCHAR(50))
    LANGUAGE plpgsql
    AS $$
    BEGIN
        DELETE FROM Companies WHERE contractId = p_contractId;
    END;
    $$;

    \CREATE OR REPLACE PROCEDURE add_staff(
        p_login VARCHAR(50),
        p_password VARCHAR(50),
        p_firstName VARCHAR(50),
        p_lastName VARCHAR(50),
        p_patronymic VARCHAR(50),
        p_contractId VARCHAR(50),
        p_department VARCHAR(50),
        p_position VARCHAR(50)
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Staff (login, password, firstName, lastName, patronymic, contractId, department, position)
        VALUES (p_login, p_password, p_firstName, p_lastName, p_patronymic, p_contractId, p_department, p_position);
    END;
    $$;

    CREATE OR REPLACE FUNCTION get_department_staff(
        p_contractId VARCHAR(50),
        p_department VARCHAR(50) DEFAULT NULL
    )
    RETURNS TABLE(
        login VARCHAR(50),
        firstName VARCHAR(50),
        lastName VARCHAR(50),
        patronymic VARCHAR(50),
        position VARCHAR(50),
        department VARCHAR(50)
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        RETURN QUERY
        SELECT s.login, s.firstName, s.lastName, s.patronymic, s.position, s.department
        FROM Staff s
        WHERE s.contractId = p_contractId
        AND (p_department IS NULL OR s.department = p_department)
        ORDER BY s.department, s.lastName, s.firstName;
    END;
    $$;

    CREATE OR REPLACE PROCEDURE add_hardware(
        p_contractId VARCHAR(50),
        p_description TEXT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Hardware (contractId, description)
        VALUES (p_contractId, p_description);
    END;
    $$;

    CREATE OR REPLACE PROCEDURE add_request(
        p_hardwareId INTEGER,
        p_contractId VARCHAR(50),
        p_responsibleLogin VARCHAR(50),
        p_text TEXT
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Requests (hardwareId, contractId, responsibleLogin, text, createdAt)
        VALUES (p_hardwareId, p_contractId, p_responsibleLogin, p_text, CURRENT_TIMESTAMP);
    END;
    $$;

    CREATE OR REPLACE PROCEDURE add_task(
        p_task TEXT,
        p_requestId INTEGER,
        p_executorLogin VARCHAR(50),
        p_parentTaskId INTEGER DEFAULT NULL
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        INSERT INTO Tasks (task, requestId, executorLogin, parentTaskId, createdAt)
        VALUES (p_task, p_requestId, p_executorLogin, p_parentTaskId, CURRENT_TIMESTAMP);
    END;
    $$;

    CREATE OR REPLACE PROCEDURE reassign_tasks(
        p_oldLogin VARCHAR(50),
        p_newLogin VARCHAR(50)
    )
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE Requests 
        SET responsibleLogin = p_newLogin 
        WHERE responsibleLogin = p_oldLogin;
        
        UPDATE Tasks 
        SET executorLogin = p_newLogin 
        WHERE executorLogin = p_oldLogin;
    END;
    $$;
END;
$$ LANGUAGE plpgsql;
