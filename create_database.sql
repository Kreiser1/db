    CREATE TABLE IF NOT EXISTS Companies (
        contractId VARCHAR(50) PRIMARY KEY NOT NULL,
        representativePosition VARCHAR(50) NOT NULL,
        fullName VARCHAR(100) NOT NULL,
        shortName VARCHAR(50) NOT NULL UNIQUE,
        physicalAddress VARCHAR(50) NOT NULL,
        legalAddress VARCHAR(50) NOT NULL,
        contactPhone VARCHAR(15) NOT NULL,
        CONSTRAINT Companies_shortName_unique UNIQUE (shortName),
        CONSTRAINT Companies_fullName_unique UNIQUE (fullName)
    );
    
    CREATE TABLE IF NOT EXISTS Contracts (
        id VARCHAR(50) PRIMARY KEY NOT NULL,
        status BIT(1) NOT NULL,
        expirationTime TIMESTAMP NOT NULL
    );
    
    CREATE TABLE IF NOT EXISTS Hardware (
        id SERIAL PRIMARY KEY NOT NULL,
        contractId VARCHAR(50) NOT NULL,
        description TEXT NOT NULL,
        CONSTRAINT Hardware_contractId_FK FOREIGN KEY (contractId) 
            REFERENCES Companies(contractId) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT Hardware_contractId_description_unique UNIQUE (contractId, description)
    );
    
    CREATE TABLE IF NOT EXISTS Staff (
        login VARCHAR(50) PRIMARY KEY NOT NULL,
        password VARCHAR(50) NOT NULL,
        firstName VARCHAR(50) NOT NULL,
        lastName VARCHAR(50) NOT NULL,
        patronymic VARCHAR(50),
        contractId VARCHAR(50),
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
            REFERENCES Companies(contractId) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT Staff_contractId_department_position_unique UNIQUE (contractId, department, position)
    );
    
    CREATE TABLE IF NOT EXISTS Requests (
        id SERIAL PRIMARY KEY,
        hardwareId INTEGER NOT NULL,
        contractId VARCHAR(50) NOT NULL,
        responsibleLogin VARCHAR(50) NOT NULL,
        text TEXT NOT NULL,
        creationTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT Requests_hardwareId_FK FOREIGN KEY (hardwareId) 
            REFERENCES Hardware(id) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT Requests_contractId_FK FOREIGN KEY (contractId) 
            REFERENCES Companies(contractId) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT Requests_responsibleLogin_FK FOREIGN KEY (responsibleLogin) 
            REFERENCES Staff(login) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT Requests_contractId_hardwareId_unique UNIQUE (contractId, hardwareId)
    );
    
    CREATE TABLE IF NOT EXISTS Tasks (
        taskId SERIAL PRIMARY KEY,
        parentTaskId INTEGER,
        task TEXT NOT NULL,
        requestId INTEGER NOT NULL,
        executorLogin VARCHAR(50) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        CONSTRAINT tasks_parentTaskId_FK FOREIGN KEY (parentTaskId) 
            REFERENCES Tasks(taskId) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT tasks_requestId_FK FOREIGN KEY (requestId) 
            REFERENCES Requests(id) ON DELETE RESTRICT ON UPDATE CASCADE,
        CONSTRAINT tasks_executorLogin_FK FOREIGN KEY (executorLogin) 
            REFERENCES Staff(login) ON DELETE RESTRICT ON UPDATE CASCADE
    );
    
    CREATE INDEX IF NOT EXISTS idx_hardware_contractId ON Hardware(contractId);
    CREATE INDEX IF NOT EXISTS idx_staff_contractId ON Staff(contractId);
    CREATE INDEX IF NOT EXISTS idx_requests_contractId ON Requests(contractId);
    CREATE INDEX IF NOT EXISTS idx_requests_hardwareId ON Requests(hardwareId);
    CREATE INDEX IF NOT EXISTS idx_tasks_requestId ON Tasks(requestId);
    CREATE INDEX IF NOT EXISTS idx_tasks_executorLogin ON Tasks(executorLogin);
    
    ALTER TABLE Hardware ALTER COLUMN id SET DEFAULT nextval('hardware_id_seq');
    ALTER TABLE Requests ALTER COLUMN id SET DEFAULT nextval('requests_id_seq');
    ALTER TABLE Tasks ALTER COLUMN taskId SET DEFAULT nextval('tasks_taskid_seq');
END;
$$ LANGUAGE plpgsql;

call create_database();
