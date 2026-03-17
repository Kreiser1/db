CREATE OR REPLACE PROCEDURE add_company(
    p_contractId VARCHAR(50),
    p_representativePosition VARCHAR(50),
    p_fullName VARCHAR(100),
    p_shortName VARCHAR(50),
    p_physicalAddress VARCHAR(50),
    p_legalAddress VARCHAR(50),
    p_contactPhone VARCHAR(15)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Companies (contractId, representativePosition, fullName, shortName, physicalAddress, legalAddress, contactPhone)
    VALUES (p_contractId, p_representativePosition, p_fullName, p_shortName, p_physicalAddress, p_legalAddress, p_contactPhone);
END;
$$;

CREATE OR REPLACE PROCEDURE update_company(
    p_contractId VARCHAR(50),
    p_representativePosition VARCHAR(50),
    p_fullName VARCHAR(100),
    p_shortName VARCHAR(50),
    p_physicalAddress VARCHAR(50),
    p_legalAddress VARCHAR(50),
    p_contactPhone VARCHAR(15)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Companies
    SET representativePosition = p_representativePosition,
        fullName = p_fullName,
        shortName = p_shortName,
        physicalAddress = p_physicalAddress,
        legalAddress = p_legalAddress,
        contactPhone = p_contactPhone
    WHERE contractId = p_contractId;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_company(p_contractId VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Companies WHERE contractId = p_contractId;
END;
$$;

CREATE OR REPLACE PROCEDURE add_contract(
    p_id VARCHAR(50),
    p_status BIT(1),
    p_expirationTime TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Contracts (id, status, expirationTime)
    VALUES (p_id, p_status, p_expirationTime);
END;
$$;

CREATE OR REPLACE PROCEDURE update_contract(
    p_id VARCHAR(50),
    p_status BIT(1),
    p_expirationTime TIMESTAMP
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Contracts
    SET status = p_status,
        expirationTime = p_expirationTime
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_contract(p_id VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Contracts WHERE id = p_id;
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

CREATE OR REPLACE PROCEDURE update_hardware(
    p_id INTEGER,
    p_contractId VARCHAR(50),
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Hardware
    SET contractId = p_contractId,
        description = p_description
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_hardware(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Hardware WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE add_staff(
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

CREATE OR REPLACE PROCEDURE update_staff(
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
    UPDATE Staff
    SET password = p_password,
        firstName = p_firstName,
        lastName = p_lastName,
        patronymic = p_patronymic,
        contractId = p_contractId,
        department = p_department,
        position = p_position
    WHERE login = p_login;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_staff(p_login VARCHAR(50))
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Staff WHERE login = p_login;
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
    INSERT INTO Requests (hardwareId, contractId, responsibleLogin, text)
    VALUES (p_hardwareId, p_contractId, p_responsibleLogin, p_text);
END;
$$;

CREATE OR REPLACE PROCEDURE update_request(
    p_id INTEGER,
    p_hardwareId INTEGER,
    p_contractId VARCHAR(50),
    p_responsibleLogin VARCHAR(50),
    p_text TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Requests
    SET hardwareId = p_hardwareId,
        contractId = p_contractId,
        responsibleLogin = p_responsibleLogin,
        text = p_text
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_request(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Requests WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE add_task(
    p_parentTaskId INTEGER,
    p_task TEXT,
    p_requestId INTEGER,
    p_executorLogin VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO Tasks (parentTaskId, task, requestId, executorLogin)
    VALUES (p_parentTaskId, p_task, p_requestId, p_executorLogin);
END;
$$;

CREATE OR REPLACE PROCEDURE update_task(
    p_taskId INTEGER,
    p_parentTaskId INTEGER,
    p_task TEXT,
    p_requestId INTEGER,
    p_executorLogin VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE Tasks
    SET parentTaskId = p_parentTaskId,
        task = p_task,
        requestId = p_requestId,
        executorLogin = p_executorLogin
    WHERE taskId = p_taskId;
END;
$$;

CREATE OR REPLACE PROCEDURE remove_task(p_taskId INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM Tasks WHERE taskId = p_taskId;
END;
$$;
