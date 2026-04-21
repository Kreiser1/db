CREATE OR REPLACE PROCEDURE Contracts_Insert(
    p_id          VARCHAR(50),
    p_status      VARCHAR(15),
    p_expiration  TIMESTAMP,
    p_creation    TIMESTAMP DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_id !~ '^ДОП/\d{2}-\d{10}$' THEN
        RAISE EXCEPTION 'Некорректный формат ID.';
    END IF;

    IF p_status NOT IN ('Открыт', 'Закрыт', 'Приостановлен') THEN
        RAISE EXCEPTION 'Некорректное значение статуса.';
    END IF;

	IF p_creation IS NOT NULL AND p_creation > CURRENT_TIMESTAMP THEN
		RAISE EXCEPTION 'Дата создания % не является достоверной.', p_creation
	END IF;

	IF p_expiration IS NOT NULL AND p_expiration <= CURRENT_TIMESTAMP THEN
		RAISE EXCEPTION 'Дата истечения % не является достоверной.', p_creation
	END IF;

    IF EXISTS (SELECT 1 FROM Contracts WHERE id = p_id) THEN
        RAISE EXCEPTION 'Договор с ID % уже существует.', p_id;
    END IF;

    INSERT INTO Contracts (id, status, expiration, creation)
    VALUES (
        p_id,
        p_status,
        p_expiration,
        COALESCE(p_creation, CURRENT_TIMESTAMP)
    );
END;
$$;


CREATE OR REPLACE PROCEDURE Contracts_Update(
    p_id          VARCHAR(50),
    p_status      VARCHAR(15) DEFAULT NULL,
    p_expiration  TIMESTAMP   DEFAULT NULL,
    p_creation    TIMESTAMP   DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Contracts WHERE id = p_id) THEN
        RAISE EXCEPTION 'Договор с ID % не найден.', p_id;
    END IF;

    IF p_status NOT IN ('Открыт', 'Закрыт', 'Приостановлен') THEN
        RAISE EXCEPTION 'Некорректное значение статуса.';
    END IF;

	IF p_creation IS NOT NULL AND p_creation > CURRENT_TIMESTAMP THEN
		RAISE EXCEPTION 'Дата создания % не является достоверной.', p_creation
	END IF;

	IF p_expiration IS NOT NULL AND p_expiration <= CURRENT_TIMESTAMP THEN
		RAISE EXCEPTION 'Дата истечения % не является достоверной.', p_creation
	END IF;

    UPDATE Contracts
    SET
        status     = COALESCE(p_status, status),
        expiration = COALESCE(p_expiration, expiration),
        creation   = COALESCE(p_creation, creation)
    WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Contracts_Delete(
    p_id VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Contracts WHERE id = p_id) THEN
        RAISE EXCEPTION 'Договор с ID % не найден.', p_id;
    END IF;

    IF EXISTS (SELECT 1 FROM Companies WHERE contractId = p_id) THEN
        RAISE EXCEPTION 'Невозможно удалить договор с ID %: имеются связанные организации.', p_id;
    END IF;

    DELETE FROM Contracts WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Companies_Insert(
    p_contractId            VARCHAR(50),
    p_representativePosition VARCHAR(50),
    p_fullName              VARCHAR(100),
    p_shortName             VARCHAR(50),
    p_physicalAddress       VARCHAR(50),
    p_legalAddress          VARCHAR(50),
    p_contactPhone          VARCHAR(15),
    p_companyType           VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Contracts WHERE id = p_contractId) THEN
        RAISE EXCEPTION 'Договор с ID % не найден.', p_contractId;
    END IF;

    IF p_contactPhone IS NOT NULL AND p_contactPhone !~ '^\+7\(\d{3}\)\d{3}-\d{2}-\d{2}$' THEN
        RAISE EXCEPTION 'Некорректный формат номера телефона.';
    END IF;

    IF EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % уже существует.', p_contractId;
    END IF;

    IF EXISTS (SELECT 1 FROM Companies WHERE fullName = p_fullName) THEN
        RAISE EXCEPTION 'Организация с наименованием "%" уже существует.', p_fullName;
    END IF;

    IF EXISTS (SELECT 1 FROM Companies WHERE shortName = p_shortName) THEN
        RAISE EXCEPTION 'Организация с кратким наименованием "%" уже существует.', p_shortName;
    END IF;

    IF EXISTS (SELECT 1 FROM Companies WHERE contactPhone = p_contactPhone) THEN
        RAISE EXCEPTION 'Организация с телефоном "%" уже существует.', p_contactPhone;
    END IF;

    INSERT INTO Companies (
        contractId,
        representativePosition,
        fullName,
        shortName,
        physicalAddress,
        legalAddress,
        contactPhone,
        companyType
    )
    VALUES (
        p_contractId,
        p_representativePosition,
        p_fullName,
        p_shortName,
        p_physicalAddress,
        p_legalAddress,
        p_contactPhone,
        p_companyType
    );
END;
$$;


CREATE OR REPLACE PROCEDURE Companies_Update(
    p_contractId             VARCHAR(50),
    p_representativePosition VARCHAR(50) DEFAULT NULL,
    p_fullName               VARCHAR(100) DEFAULT NULL,
    p_shortName              VARCHAR(50) DEFAULT NULL,
    p_physicalAddress        VARCHAR(50) DEFAULT NULL,
    p_legalAddress           VARCHAR(50) DEFAULT NULL,
    p_contactPhone           VARCHAR(15) DEFAULT NULL,
    p_companyType            VARCHAR(50) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF p_contactPhone IS NOT NULL AND p_contactPhone !~ '^\+7\(\d{3}\)\d{3}-\d{2}-\d{2}$' THEN
        RAISE EXCEPTION 'Некорректный формат номера телефона.';
    END IF;

    IF p_fullName IS NOT NULL AND EXISTS (
        SELECT 1 FROM Companies
        WHERE fullName = p_fullName AND contractId != p_contractId
    ) THEN
        RAISE EXCEPTION 'Организация с наименованием "%" уже существует.', p_fullName;
    END IF;

    IF p_shortName IS NOT NULL AND EXISTS (
        SELECT 1 FROM Companies
        WHERE shortName = p_shortName AND contractId != p_contractId
    ) THEN
        RAISE EXCEPTION 'Организация с кратким наименованием "%" уже существует.', p_shortName;
    END IF;

    IF p_contactPhone IS NOT NULL AND EXISTS (
        SELECT 1 FROM Companies
        WHERE contactPhone = p_contactPhone AND contractId != p_contractId
    ) THEN
        RAISE EXCEPTION 'Организация с телефоном "%" уже существует.', p_contactPhone;
    END IF;

    UPDATE Companies
    SET
        representativePosition = COALESCE(p_representativePosition, representativePosition),
        fullName               = COALESCE(p_fullName, fullName),
        shortName              = COALESCE(p_shortName, shortName),
        physicalAddress        = COALESCE(p_physicalAddress, physicalAddress),
        legalAddress           = COALESCE(p_legalAddress, legalAddress),
        contactPhone           = COALESCE(p_contactPhone, contactPhone),
        companyType            = COALESCE(p_companyType, companyType)
    WHERE contractId = p_contractId;
END;
$$;


CREATE OR REPLACE PROCEDURE Companies_Delete(
    p_contractId VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF EXISTS (SELECT 1 FROM Staff WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Невозможно удалить организацию с ID %: имеются связанные сотрудники.', p_contractId;
    END IF;

    IF EXISTS (SELECT 1 FROM Hardware WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Невозможно удалить организацию с ID %: имеется связанное оборудование.', p_contractId;
    END IF;

    IF EXISTS (SELECT 1 FROM Requests WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Невозможно удалить организацию с ID %: имеются связанные заявки.', p_contractId;
    END IF;

    DELETE FROM Companies WHERE contractId = p_contractId;
END;
$$;


CREATE OR REPLACE PROCEDURE Staff_Insert(
    p_login        VARCHAR(50),
    p_password     VARCHAR(50),
    p_firstName    VARCHAR(50),
    p_lastName     VARCHAR(50),
    p_patronymic   VARCHAR(50) DEFAULT NULL,
    p_contractId   VARCHAR(50) DEFAULT NULL,
    p_department   VARCHAR(50),
    p_position     VARCHAR(50),
    p_contactPhone VARCHAR(50) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF LENGTH(p_login) < 4 OR p_login LIKE '% %' THEN
        RAISE EXCEPTION 'Некорректный формат логина.';
    END IF;

    IF LENGTH(p_password) < 5 OR p_password LIKE '% %' THEN
        RAISE EXCEPTION 'Некорректный формат пароля.';
    END IF;

    IF p_firstName LIKE '% %' THEN
        RAISE EXCEPTION 'Имя не должно содержать пробелы.';
    END IF;

    IF p_lastName LIKE '% %' THEN
        RAISE EXCEPTION 'Фамилия не должна содержать пробелы.';
    END IF;

    IF p_patronymic IS NOT NULL
       AND p_patronymic != 'Нет данных'
       AND p_patronymic LIKE '% %' THEN
        RAISE EXCEPTION 'Отчество не должно содержать пробелы.';
    END IF;

    IF p_contactPhone IS NOT NULL AND p_contactPhone !~ '^\+7\(\d{3}\)\d{3}-\d{2}-\d{2}$' THEN
        RAISE EXCEPTION 'Некорректный формат номера телефона.';
    END IF;

    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF EXISTS (SELECT 1 FROM Staff WHERE login = p_login) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" уже существует.', p_login;
    END IF;

    IF p_contactPhone IS NOT NULL AND EXISTS (SELECT 1 FROM Staff WHERE contactPhone = p_contactPhone) THEN
        RAISE EXCEPTION 'Сотрудник с телефоном "%" уже существует.', p_contactPhone;
    END IF;

    INSERT INTO Staff (
        login,
        password,
        firstName,
        lastName,
        patronymic,
        contractId,
        department,
        position,
        contactPhone
    )
    VALUES (
        p_login,
        p_password,
        p_firstName,
        p_lastName,
        COALESCE(p_patronymic, 'Нет данных'),
        p_contractId,
        p_department,
        p_position,
        p_contactPhone
    );
END;
$$;


CREATE OR REPLACE PROCEDURE Staff_Update(
    p_login        VARCHAR(50),
    p_password     VARCHAR(50) DEFAULT NULL,
    p_firstName    VARCHAR(50) DEFAULT NULL,
    p_lastName     VARCHAR(50) DEFAULT NULL,
    p_patronymic   VARCHAR(50) DEFAULT NULL,
    p_contractId   VARCHAR(50) DEFAULT NULL,
    p_department   VARCHAR(50) DEFAULT NULL,
    p_position     VARCHAR(50) DEFAULT NULL,
    p_contactPhone VARCHAR(50) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_login) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_login;
    END IF;

    IF p_password IS NOT NULL AND (LENGTH(p_password) < 5 OR p_password LIKE '% %') THEN
        RAISE EXCEPTION 'Некорректный формат пароля.';
    END IF;

    IF p_firstName IS NOT NULL AND p_firstName LIKE '% %' THEN
        RAISE EXCEPTION 'Имя не должно содержать пробелы.';
    END IF;

    IF p_lastName IS NOT NULL AND p_lastName LIKE '% %' THEN
        RAISE EXCEPTION 'Фамилия не должна содержать пробелы.';
    END IF;

    IF p_patronymic IS NOT NULL
       AND p_patronymic != 'Нет данных'
       AND p_patronymic LIKE '% %' THEN
        RAISE EXCEPTION 'Отчество не должно содержать пробелы.';
    END IF;

    IF p_contactPhone IS NOT NULL AND p_contactPhone !~ '^\+7\(\d{3}\)\d{3}-\d{2}-\d{2}$' THEN
        RAISE EXCEPTION 'Некорректный формат номера телефона.';
    END IF;

    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF p_contactPhone IS NOT NULL AND EXISTS (
        SELECT 1 FROM Staff
        WHERE contactPhone = p_contactPhone AND login != p_login
    ) THEN
        RAISE EXCEPTION 'Сотрудник с телефоном "%" уже существует.', p_contactPhone;
    END IF;

    UPDATE Staff
    SET
        password     = COALESCE(p_password, password),
        firstName    = COALESCE(p_firstName, firstName),
        lastName     = COALESCE(p_lastName, lastName),
        patronymic   = COALESCE(p_patronymic, patronymic),
        contractId   = COALESCE(p_contractId, contractId),
        department   = COALESCE(p_department, department),
        position     = COALESCE(p_position, position),
        contactPhone = COALESCE(p_contactPhone, contactPhone)
    WHERE login = p_login;
END;
$$;


CREATE OR REPLACE PROCEDURE Staff_Delete(
    p_login VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_login) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_login;
    END IF;

    IF EXISTS (SELECT 1 FROM Transport WHERE driverLogin = p_login) THEN
        RAISE EXCEPTION 'Невозможно удалить сотрудника "%": имеется связанный транспорт.', p_login;
    END IF;

    IF EXISTS (SELECT 1 FROM Requests WHERE responsibleLogin = p_login) THEN
        RAISE EXCEPTION 'Невозможно удалить сотрудника "%": имеются связанные заявки.', p_login;
    END IF;

    IF EXISTS (SELECT 1 FROM Tasks WHERE executorLogin = p_login) THEN
        RAISE EXCEPTION 'Невозможно удалить сотрудника "%": имеются связанные задачи.', p_login;
    END IF;

    DELETE FROM Staff WHERE login = p_login;
END;
$$;


CREATE OR REPLACE PROCEDURE Transport_Insert(
    p_id          VARCHAR(15),
    p_manufacturer VARCHAR(50),
    p_model       VARCHAR(50),
    p_color       VARCHAR(50),
    p_driverLogin VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_id !~ '^[АВЕКМНОРСТУХавекмнорстух]{1}\d{3}[АВЕКМНОРСТУХавекмнорстух]{2}\s\d{2,3}$' THEN
        RAISE EXCEPTION 'Некорректный формат ID.';
    END IF;

    IF p_color LIKE '% %' THEN
        RAISE EXCEPTION 'Цвет не должен содержать пробелы.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_driverLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_driverLogin;
    END IF;

    IF EXISTS (SELECT 1 FROM Transport WHERE id = p_id) THEN
        RAISE EXCEPTION 'Транспорт с ID % уже существует.', p_id;
    END IF;

    INSERT INTO Transport (id, manufacturer, model, color, driverLogin)
    VALUES (p_id, p_manufacturer, p_model, p_color, p_driverLogin);
END;
$$;


CREATE OR REPLACE PROCEDURE Transport_Update(
    p_id           VARCHAR(15),
    p_manufacturer VARCHAR(50) DEFAULT NULL,
    p_model        VARCHAR(50) DEFAULT NULL,
    p_color        VARCHAR(50) DEFAULT NULL,
    p_driverLogin  VARCHAR(50) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Transport WHERE id = p_id) THEN
        RAISE EXCEPTION 'Транспорт с ID % не найден.', p_id;
    END IF;

    IF p_color IS NOT NULL AND p_color LIKE '% %' THEN
        RAISE EXCEPTION 'Цвет не должен содержать пробелы.';
    END IF;

    IF p_driverLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_driverLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_driverLogin;
    END IF;

    UPDATE Transport
    SET
        manufacturer = COALESCE(p_manufacturer, manufacturer),
        model        = COALESCE(p_model, model),
        color        = COALESCE(p_color, color),
        driverLogin  = COALESCE(p_driverLogin, driverLogin)
    WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Transport_Delete(
    p_id VARCHAR(15)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Transport WHERE id = p_id) THEN
        RAISE EXCEPTION 'Транспорт с ID % не найден.', p_id;
    END IF;

    DELETE FROM Transport WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Hardware_Insert(
    p_contractId VARCHAR(50) DEFAULT NULL,
    p_description TEXT
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF EXISTS (SELECT 1 FROM Hardware WHERE description = p_description) THEN
        RAISE EXCEPTION 'Оборудование с таким описанием уже существует.';
    END IF;

    INSERT INTO Hardware (contractId, description)
    VALUES (p_contractId, p_description);
END;
$$;


CREATE OR REPLACE PROCEDURE Hardware_Update(
    p_id          INTEGER,
    p_contractId  VARCHAR(50) DEFAULT NULL,
    p_description TEXT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Hardware WHERE id = p_id) THEN
        RAISE EXCEPTION 'Оборудование с ID % не найдено.', p_id;
    END IF;

    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF p_description IS NOT NULL AND EXISTS (
        SELECT 1 FROM Hardware
        WHERE description = p_description AND id != p_id
    ) THEN
        RAISE EXCEPTION 'Оборудование с таким описанием уже существует.';
    END IF;

    UPDATE Hardware
    SET
        contractId  = COALESCE(p_contractId, contractId),
        description = COALESCE(p_description, description)
    WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Hardware_Delete(
    p_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Hardware WHERE id = p_id) THEN
        RAISE EXCEPTION 'Оборудование с ID % не найдено.', p_id;
    END IF;

    IF EXISTS (SELECT 1 FROM Requests WHERE hardwareId = p_id) THEN
        RAISE EXCEPTION 'Невозможно удалить оборудование с ID %: имеются связанные заявки.', p_id;
    END IF;

    DELETE FROM Hardware WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Requests_Insert(
    p_id              VARCHAR(50),
    p_hardwareId      INTEGER,
    p_contractId      VARCHAR(50) DEFAULT NULL,
    p_responsibleLogin VARCHAR(50) DEFAULT NULL,
    p_text            TEXT,
    p_creation        TIMESTAMP DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_id !~ '^З-\d{8}-\d{2}$' THEN
        RAISE EXCEPTION 'Некорректный формат ID.';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Hardware WHERE id = p_hardwareId) THEN
        RAISE EXCEPTION 'Оборудование с ID % не найдено.', p_hardwareId;
    END IF;

    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF p_responsibleLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_responsibleLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_responsibleLogin;
    END IF;

    IF EXISTS (SELECT 1 FROM Requests WHERE id = p_id) THEN
        RAISE EXCEPTION 'Заявка с ID % уже существует.', p_id;
    END IF;

    INSERT INTO Requests (id, hardwareId, contractId, responsibleLogin, text, creation)
    VALUES (
        p_id,
        p_hardwareId,
        p_contractId,
        p_responsibleLogin,
        p_text,
        COALESCE(p_creation, CURRENT_TIMESTAMP)
    );
END;
$$;


CREATE OR REPLACE PROCEDURE Requests_Update(
    p_id               VARCHAR(50),
    p_hardwareId       INTEGER DEFAULT NULL,
    p_contractId       VARCHAR(50) DEFAULT NULL,
    p_responsibleLogin VARCHAR(50) DEFAULT NULL,
    p_text             TEXT DEFAULT NULL,
    p_creation         TIMESTAMP DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Requests WHERE id = p_id) THEN
        RAISE EXCEPTION 'Заявка с ID % не найдена.', p_id;
    END IF;

    IF p_hardwareId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Hardware WHERE id = p_hardwareId) THEN
        RAISE EXCEPTION 'Оборудование с ID % не найдено.', p_hardwareId;
    END IF;

    IF p_contractId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Companies WHERE contractId = p_contractId) THEN
        RAISE EXCEPTION 'Организация с ID договора % не найдена.', p_contractId;
    END IF;

    IF p_responsibleLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_responsibleLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_responsibleLogin;
    END IF;

    UPDATE Requests
    SET
        hardwareId       = COALESCE(p_hardwareId, hardwareId),
        contractId       = COALESCE(p_contractId, contractId),
        responsibleLogin = COALESCE(p_responsibleLogin, responsibleLogin),
        text             = COALESCE(p_text, text),
        creation         = COALESCE(p_creation, creation)
    WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Requests_Delete(
    p_id VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Requests WHERE id = p_id) THEN
        RAISE EXCEPTION 'Заявка с ID % не найдена.', p_id;
    END IF;

    IF EXISTS (SELECT 1 FROM Tasks WHERE requestId = p_id) THEN
        RAISE EXCEPTION 'Невозможно удалить заявку с ID %: имеются связанные задачи.', p_id;
    END IF;

    DELETE FROM Requests WHERE id = p_id;
END;
$$;

CREATE OR REPLACE PROCEDURE Tasks_Insert(
    p_id            VARCHAR(50),
    p_parentId      VARCHAR(50) DEFAULT NULL,
    p_task          TEXT,
    p_requestId     VARCHAR(50),
    p_executorLogin VARCHAR(50) DEFAULT NULL,
    p_creation      TIMESTAMP DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_id !~ '^TSK-[0-9]{6}$' THEN
        RAISE EXCEPTION 'Некорректный формат ID.';
    END IF;

    IF p_parentId IS NOT NULL AND p_parentId !~ '^TSK-[0-9]{6}$' THEN
        RAISE EXCEPTION 'Некорректный формат ID родительской задачи.';
    END IF;

    IF p_parentId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Tasks WHERE id = p_parentId) THEN
        RAISE EXCEPTION 'Родительская задача с ID % не найдена.', p_parentId;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM Requests WHERE id = p_requestId) THEN
        RAISE EXCEPTION 'Заявка с ID % не найдена.', p_requestId;
    END IF;

    IF p_executorLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_executorLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_executorLogin;
    END IF;

    IF EXISTS (SELECT 1 FROM Tasks WHERE id = p_id) THEN
        RAISE EXCEPTION 'Задача с ID % уже существует.', p_id;
    END IF;

    INSERT INTO Tasks (id, parentId, task, requestId, executorLogin, creation)
    VALUES (
        p_id,
        p_parentId,
        p_task,
        p_requestId,
        p_executorLogin,
        COALESCE(p_creation, CURRENT_TIMESTAMP)
    );
END;
$$;


CREATE OR REPLACE PROCEDURE Tasks_Update(
    p_id            VARCHAR(50),
    p_parentId      VARCHAR(50) DEFAULT NULL,
    p_task          TEXT DEFAULT NULL,
    p_requestId     VARCHAR(50) DEFAULT NULL,
    p_executorLogin VARCHAR(50) DEFAULT NULL,
    p_creation      TIMESTAMP DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tasks WHERE id = p_id) THEN
        RAISE EXCEPTION 'Задача с ID % не найдена.', p_id;
    END IF;

    IF p_parentId IS NOT NULL AND p_parentId !~ '^TSK-[0-9]{6}$' THEN
        RAISE EXCEPTION 'Некорректный формат ID родительской задачи.';
    END IF;

    IF p_parentId IS NOT NULL
       AND p_parentId != p_id
       AND NOT EXISTS (SELECT 1 FROM Tasks WHERE id = p_parentId) THEN
        RAISE EXCEPTION 'Родительская задача с ID % не найдена.', p_parentId;
    END IF;

    IF p_parentId IS NOT NULL AND p_parentId = p_id THEN
        RAISE EXCEPTION 'Задача не может быть родительской для самой себя.';
    END IF;

    IF p_requestId IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Requests WHERE id = p_requestId) THEN
        RAISE EXCEPTION 'Заявка с ID % не найдена.', p_requestId;
    END IF;

    IF p_executorLogin IS NOT NULL AND NOT EXISTS (SELECT 1 FROM Staff WHERE login = p_executorLogin) THEN
        RAISE EXCEPTION 'Сотрудник с логином "%" не найден.', p_executorLogin;
    END IF;

    UPDATE Tasks
    SET
        parentId      = COALESCE(p_parentId, parentId),
        task          = COALESCE(p_task, task),
        requestId     = COALESCE(p_requestId, requestId),
        executorLogin = COALESCE(p_executorLogin, executorLogin),
        creation      = COALESCE(p_creation, creation)
    WHERE id = p_id;
END;
$$;


CREATE OR REPLACE PROCEDURE Tasks_Delete(
    p_id VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Tasks WHERE id = p_id) THEN
        RAISE EXCEPTION 'Задача с ID % не найдена.', p_id;
    END IF;

    IF EXISTS (SELECT 1 FROM Tasks WHERE parentId = p_id) THEN
        RAISE EXCEPTION 'Невозможно удалить задачу с ID %: имеются связанные дочерние задачи.', p_id;
    END IF;

    DELETE FROM Tasks WHERE id = p_id;
END;
$$;
