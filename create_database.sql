CREATE OR REPLACE PROCEDURE create_database()
LANGUAGE plpgsql
AS $$
BEGIN
    CREATE TABLE IF NOT EXISTS Companies (
        contractId VARCHAR(50) PRIMARY KEY,
        representativePosition VARCHAR(50) NOT NULL,
        fullName VARCHAR(100) NOT NULL,
        shortName VARCHAR(50) NOT NULL,
        phyicalAddress VARCHAR(50) NOT NULL,
        legalAddress VARCHAR(50) NOT NULL,
        contactPhone INTEGER NOT NULL
    );

    CREATE TABLE IF NOT EXISTS Contracts (
        id VARCHAR(50) PRIMARY KEY,
        status BIT(1) NOT NULL,
        expirationTime TIMESTAMP NOT NULL
    );

    CREATE TABLE IF NOT EXISTS Hardware (
        id INTEGER PRIMARY KEY NOT NULL,
        contractId VARCHAR(50) NOT NULL,
        description TEXT NOT NULL,
        CONSTRAINT Hardware_contractId_FK FOREIGN KEY (contractId) 
            REFERENCES Companies(contractId) ON DELETE RESTRICT ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Staff (
        login VARCHAR(50) PRIMARY KEY,
        password VARCHAR(50) NOT NULL,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        patronymic VARCHAR(50),
        contractId VARCHAR(50) NOT NULL,
        department VARCHAR(50) NOT NULL,
        position VARCHAR(50) NOT NULL,
        CONSTRAINT Staff_login_check CHECK (
            LENGTH(login) >= 4 
            AND login NOT LIKE '% %'
        ),
        CONSTRAINT Staff_password_check CHECK (
            LENGTH(password) >= 5 
            AND password NOT LIKE '% %'
        ),
        CONSTRAINT Staff_firstName_check CHECK (firstName NOT LIKE '% %'),
        CONSTRAINT Staff_lastName_check CHECK (lastName NOT LIKE '% %'),
        CONSTRAINT Staff_patronymic_check CHECK (patronymic IS NULL OR patronymic NOT LIKE '% %'),
        CONSTRAINT Staff_contractId_FK FOREIGN KEY (contractId) 
            REFERENCES Companies(contractId) ON DELETE RESTRICT ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Requests (
        id INTEGER PRIMARY KEY NOT NULL,
        hardwareId INTEGER NOT NULL,
        contractId VARCHAR(50) NOT NULL,
        responsibleLogin VARCHAR(50) NOT NULL,
        text TEXT NOT NULL,
        CONSTRAINT Requests_hardwareId_FK FOREIGN KEY (hardwareId) 
            REFERENCES Hardware(id) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT Requests_contractId_FK FOREIGN KEY (contractId) 
            REFERENCES Companies(contractId) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT Requests_responsibleLogin_FK FOREIGN KEY (responsibleLogin) 
            REFERENCES Staff(login) ON DELETE RESTRICT ON UPDATE CASCADE
    );

    CREATE TABLE IF NOT EXISTS Tasks (
        taskId INTEGER PRIMARY KEY,
        parentTaskId INTEGER,
        task TEXT NOT NULL,
        requestId INTEGER NOT NULL,
        executorLogin VARCHAR(50) NOT NULL,
        CONSTRAINT tasks_parentTaskId_FK FOREIGN KEY (parentTaskId) 
            REFERENCES Tasks(taskId) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT tasks_requestId_FK FOREIGN KEY (requestId) 
            REFERENCES Requests(id) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT tasks_executorLogin_FK FOREIGN KEY (executorLogin) 
            REFERENCES Staff(login) ON DELETE RESTRICT ON UPDATE CASCADE
    );

END;
$$;
