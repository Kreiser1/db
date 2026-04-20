CREATE OR REPLACE PROCEDURE Contracts_Insert(
    p_id VARCHAR(50),
    p_status VARCHAR(15),
    p_expiration TIMESTAMP,
    p_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO Contracts (id, status, expiration, creation)
    VALUES (p_id, p_status, p_expiration, p_creation);
END;
$$;

CREATE OR REPLACE PROCEDURE Contracts_Update(
    p_id VARCHAR(50),
    p_status VARCHAR(15),
    p_expiration TIMESTAMP,
    p_creation TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Contracts
    SET status = p_status,
        expiration = p_expiration,
        creation = p_creation
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Contracts_Remove(p_id VARCHAR(50))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Contracts WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Companies_Insert(
    p_contractId VARCHAR(50),
    p_representativePosition VARCHAR(50),
    p_fullName VARCHAR(100),
    p_shortName VARCHAR(50),
    p_physicalAddress VARCHAR(50),
    p_legalAddress VARCHAR(50),
    p_contactPhone VARCHAR(15),
    p_companyType VARCHAR(50)
)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Contracts WHERE id = p_contractId) THEN
        RAISE EXCEPTION 'Договор с ID % не существует.', p_contractId;
    END IF;
    
    INSERT INTO Companies (contractId, representativePosition, fullName, shortName,
		physicalAddress, legalAddress, contactPhone, companyType)
    VALUES (p_contractId, p_representativePosition, p_fullName, p_shortName,
		p_physicalAddress, p_legalAddress, p_contactPhone, p_companyType);
END;
$$;

CREATE OR REPLACE PROCEDURE Companies_Update(
    p_contractId VARCHAR(50),
    p_representativePosition VARCHAR(50),
    p_fullName VARCHAR(100),
    p_shortName VARCHAR(50),
    p_physicalAddress VARCHAR(50),
    p_legalAddress VARCHAR(50),
    p_contactPhone VARCHAR(15),
    p_companyType VARCHAR(50)
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE Companies
    SET representativePosition = p_representativePosition,
        fullName = p_fullName,
        shortName = p_shortName,
        physicalAddress = p_physicalAddress,
        legalAddress = p_legalAddress,
        contactPhone = p_contactPhone,
        companyType = p_companyType
    WHERE contractId = p_contractId;
END;
$$;

CREATE OR REPLACE PROCEDURE Companies_Remove(p_contractId VARCHAR(50))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Companies WHERE contractId = p_contractId;
END;
$$;

CREATE OR REPLACE PROCEDURE Staff_Insert(
    p_login VARCHAR(50),
    p_password VARCHAR(50),
    p_firstName VARCHAR(50),
    p_lastName VARCHAR(50),
    p_patronymic VARCHAR(50) DEFAULT 'Нет данных',
    p_contractId VARCHAR(50) DEFAULT NULL,
    p_department VARCHAR(50),
    p_position VARCHAR(50),
    p_contactPhone VARCHAR(50) DEFAULT NULL
)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Компания с ID договора % не существует.', p_contractId;
    END IF;
    
    INSERT INTO Staff (login, password, firstName, lastName, patronymic,
		contractId, department, position, contactPhone)
    VALUES (p_login, p_password, p_firstName, p_lastName, p_patronymic,
		p_contractId, p_department, p_position, p_contactPhone);
END;
$$;

CREATE OR REPLACE PROCEDURE Staff_Update(
    p_login VARCHAR(50),
    p_password VARCHAR(50),
    p_firstName VARCHAR(50),
    p_lastName VARCHAR(50),
    p_patronymic VARCHAR(50),
    p_contractId VARCHAR(50),
    p_department VARCHAR(50),
    p_position VARCHAR(50),
    p_contactPhone VARCHAR(50)
)
LANGUAGE plpgsql AS $$
BEGIN
	IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Компания с ID договора % не существует.', p_contractId;
    END IF;
	
    UPDATE Staff
    SET password = p_password,
        firstName = p_firstName,
        lastName = p_lastName,
        patronymic = p_patronymic,
        contractId = p_contractId,
        department = p_department,
        position = p_position,
        contactPhone = p_contactPhone
    WHERE login = p_login;
END;
$$;

CREATE OR REPLACE PROCEDURE Staff_Remove(p_login VARCHAR(50))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Staff WHERE login = p_login;
END;
$$;

CREATE OR REPLACE PROCEDURE Transport_Insert(
    p_id VARCHAR(15),
    p_manufacturer VARCHAR(50),
    p_model VARCHAR(50),
    p_color VARCHAR(25),
    p_driverLogin VARCHAR(50)
)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_driverLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином % не существует.', p_driverLogin;
    END IF;
    
    INSERT INTO Transport (id, manufacturer, model, color, driverLogin)
    VALUES (p_id, p_manufacturer, p_model, p_color, p_driverLogin);
END;
$$;

CREATE OR REPLACE PROCEDURE Transport_Update(
    p_id VARCHAR(15),
    p_manufacturer VARCHAR(50),
    p_model VARCHAR(50),
    p_color VARCHAR(25),
    p_driverLogin VARCHAR(50)
)
LANGUAGE plpgsql AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_driverLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином % не существует.', p_driverLogin;
    END IF;
	
    UPDATE Transport
    SET manufacturer = p_manufacturer,
        model = p_model,
        color = p_color,
        driverLogin = p_driverLogin
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Transport_Remove(p_id VARCHAR(15))
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Transport WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Hardware_Insert(
    p_contractId VARCHAR(50) DEFAULT NULL,
    p_description TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Компания с ID договора % не существует.', p_contractId;
    END IF;
    
    INSERT INTO Hardware (contractId, description)
    VALUES (p_contractId, p_description);
END;
$$;

CREATE OR REPLACE PROCEDURE Hardware_Update(
    p_id INTEGER,
    p_contractId VARCHAR(50),
    p_description TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
	IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Компания с ID договора % не существует.', p_contractId;
    END IF;
	
    UPDATE Hardware
    SET contractId = p_contractId,
        description = p_description
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Hardware_Remove(p_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Hardware WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Requests_Insert(
    p_hardwareId INTEGER,
    p_contractId VARCHAR(50) DEFAULT NULL,
    p_responsibleLogin VARCHAR(50) DEFAULT NULL,
    p_text TEXT,
    p_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Hardware WHERE id = p_hardwareId) THEN
        RAISE EXCEPTION 'Оборудования с ID % не существует.', p_hardwareId;
    END IF;
    
    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Компания с ID договора % не существует.', p_contractId;
    END IF;
    
    IF p_responsibleLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_responsibleLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином % не существует.', p_responsibleLogin;
    END IF;
    
    INSERT INTO Requests (hardwareId, contractId, responsibleLogin, text, creation)
    VALUES (p_hardwareId, p_contractId, p_responsibleLogin, p_text, p_creation);
END;
$$;

CREATE OR REPLACE PROCEDURE Requests_Update(
    p_id INTEGER,
    p_hardwareId INTEGER,
    p_contractId VARCHAR(50),
    p_responsibleLogin VARCHAR(50),
    p_text TEXT,
    p_creation TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Hardware WHERE id = p_hardwareId) THEN
        RAISE EXCEPTION 'Оборудования с ID % не существует.', p_hardwareId;
    END IF;
    
    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Компания с ID договора % не существует.', p_contractId;
    END IF;
    
    IF p_responsibleLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_responsibleLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином % не существует.', p_responsibleLogin;
    END IF;
	
    UPDATE Requests
    SET hardwareId = p_hardwareId,
        contractId = p_contractId,
        responsibleLogin = p_responsibleLogin,
        text = p_text,
        creation = p_creation
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Requests_Remove(p_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Requests WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Tasks_Insert(
    p_parentId INTEGER DEFAULT NULL,
    p_task TEXT,
    p_requestId INTEGER,
    p_executorLogin VARCHAR(50) DEFAULT NULL,
    p_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
    IF p_parentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tasks WHERE id = p_parentId) THEN
        RAISE EXCEPTION 'Задача с ID % не существует.', p_parentId;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Requests WHERE id = p_requestId) THEN
        RAISE EXCEPTION 'Заявка с ID % не существует.', p_requestId;
    END IF;
    
    IF p_executorLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_executorLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином % не существует.', p_executorLogin;
    END IF;
    
    INSERT INTO Tasks (parentId, task, requestId, executorLogin, creation)
    VALUES (p_parentId, p_task, p_requestId, p_executorLogin, p_creation);
END;
$$;

CREATE OR REPLACE PROCEDURE Tasks_Update(
    p_id INTEGER,
    p_parentId INTEGER,
    p_task TEXT,
    p_requestId INTEGER,
    p_executorLogin VARCHAR(50),
    p_creation TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
	IF p_parentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tasks WHERE id = p_parentId) THEN
        RAISE EXCEPTION 'Задача с ID % не существует.', p_parentId;
    END IF;
    
    IF NOT EXISTS (SELECT 1 FROM Requests WHERE id = p_requestId) THEN
        RAISE EXCEPTION 'Заявка с ID % не существует.', p_requestId;
    END IF;
    
    IF p_executorLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_executorLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином % не существует.', p_executorLogin;
    END IF;
	
    UPDATE Tasks
    SET parentId = p_parentId,
        task = p_task,
        requestId = p_requestId,
        executorLogin = p_executorLogin,
        creation = p_creation
    WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Tasks_Remove(p_id INTEGER)
LANGUAGE plpgsql AS $$
BEGIN
    DELETE FROM Tasks WHERE id = p_id;
END;
$$;
