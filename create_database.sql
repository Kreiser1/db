CREATE TABLE IF NOT EXISTS Contracts (
	id VARCHAR(50) PRIMARY KEY NOT NULL UNIQUE,
	status VARCHAR(50) NOT NULL,
	expiration TIMESTAMP NOT NULL,
	creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT Contracts_status_check CHECK (status IN ('Открыт', 'Закрыт', 'Приостановлен')),
	CONSTRAINT Contracts_id_check CHECK (id ~ '^ДОП/\d{2}-\d{10}$')
);

CREATE TABLE IF NOT EXISTS Companies (
	contractId VARCHAR(50) PRIMARY KEY NOT NULL UNIQUE,
	representativePosition VARCHAR(50) NOT NULL,
	fullName VARCHAR(100) NOT NULL UNIQUE,
	shortName VARCHAR(50) NOT NULL UNIQUE,
	physicalAddress VARCHAR(50) NOT NULL,
	legalAddress VARCHAR(50) NOT NULL,
	contactPhone VARCHAR(50) NOT NULL UNIQUE,
	companyType VARCHAR(50) NOT NULL,
	CONSTRAINT Companies_contractId_FK FOREIGN KEY (contractId) 
		REFERENCES Contracts(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT Companies_contactPhone_check CHECK (contactPhone IS NULL or contactPhone ~ '^\+7\(\d{3}\)\d{3}-\d{2}-\d{2}$')
);

CREATE TABLE IF NOT EXISTS Staff (
	login VARCHAR(50) PRIMARY KEY NOT NULL UNIQUE,
	password VARCHAR(50) NOT NULL,
	firstName VARCHAR(50) NOT NULL,
	lastName VARCHAR(50) NOT NULL,
	patronymic VARCHAR(50) DEFAULT 'Нет данных',
	contractId VARCHAR(50),
	department VARCHAR(50) NOT NULL,
	position VARCHAR(50) NOT NULL,
	contactPhone VARCHAR(50) UNIQUE,
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
	CONSTRAINT Staff_patronymic_check CHECK (
		patronymic IS NULL
		OR patronymic = 'Нет данных'
		OR patronymic NOT LIKE '% %'
	),
	CONSTRAINT Staff_contractId_FK FOREIGN KEY (contractId) 
		REFERENCES Companies(contractId) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT Staff_contactPhone_check CHECK (contactPhone IS NULL OR contactPhone ~ '^\+7\(\d{3}\)\d{3}-\d{2}-\d{2}$')
);

CREATE TABLE IF NOT EXISTS Transport(
	id VARCHAR(50) PRIMARY KEY NOT NULL UNIQUE,
	manufacturer VARCHAR(50) NOT NULL,
	model VARCHAR(50) NOT NULL,
	color VARCHAR(50) NOT NULL,
	driverLogin VARCHAR(50) NOT NULL,
	CONSTRAINT Transport_login_FK FOREIGN KEY (driverLogin)
		REFERENCES Staff(login) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT Transport_id_check CHECK (id ~ '^[АВЕКМНОРСТУХавекмнорстух]{1}\d{3}[АВЕКМНОРСТУХавекмнорстух]{2}\s\d{2,3}$'),
	CONSTRAINT Transport_color_check CHECK (color NOT LIKE '% %')
);

CREATE TABLE IF NOT EXISTS Hardware (
	id SERIAL PRIMARY KEY NOT NULL UNIQUE,
	contractId VARCHAR(50),
	description TEXT NOT NULL UNIQUE,
	CONSTRAINT Hardware_contractId_FK FOREIGN KEY (contractId) 
		REFERENCES Companies(contractId) ON DELETE SET NULL ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Requests (
	id VARCHAR(50) PRIMARY KEY NOT NULL UNIQUE,
	hardwareId INTEGER NOT NULL,
	contractId VARCHAR(50),
	responsibleLogin VARCHAR(50),
	text TEXT NOT NULL,
	creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT Requests_hardwareId_FK FOREIGN KEY (hardwareId) 
		REFERENCES Hardware(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT Requests_contractId_FK FOREIGN KEY (contractId) 
		REFERENCES Companies(contractId) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT Requests_responsibleLogin_FK FOREIGN KEY (responsibleLogin)
		REFERENCES Staff(login) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT Requests_id_check CHECK (id ~ '^З-\d{8}-\d{2}$')
);

CREATE TABLE IF NOT EXISTS Tasks (
	id VARCHAR(50) PRIMARY KEY NOT NULL UNIQUE,
	parentId VARCHAR(50),
	task TEXT NOT NULL,
	requestId VARCHAR(50) NOT NULL,
	executorLogin VARCHAR(50),
	creation TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CONSTRAINT tasks_parentId_FK FOREIGN KEY (parentId) 
		REFERENCES Tasks(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT tasks_requestId_FK FOREIGN KEY (requestId) 
		REFERENCES Requests(id) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT tasks_executorLogin_FK FOREIGN KEY (executorLogin) 
		REFERENCES Staff(login) ON DELETE RESTRICT ON UPDATE CASCADE,
	CONSTRAINT tasks_id_check CHECK (id ~ '^TSK-[0-9]{6}$'),
	CONSTRAINT tasks_parentId_check CHECK (parentId IS NULL or parentId ~ '^TSK-[0-9]{6}$')
);

CREATE INDEX IF NOT EXISTS idx_hardware_contractId ON Hardware(contractId);
CREATE INDEX IF NOT EXISTS idx_staff_contractId ON Staff(contractId);
CREATE INDEX IF NOT EXISTS idx_requests_contractId ON Requests(contractId);
CREATE INDEX IF NOT EXISTS idx_requests_hardwareId ON Requests(hardwareId);
CREATE INDEX IF NOT EXISTS idx_tasks_requestId ON Tasks(requestId);
CREATE INDEX IF NOT EXISTS idx_tasks_executorLogin ON Tasks(executorLogin);
CREATE INDEX IF NOT EXISTS idx_tasks_parentId ON Tasks(parentId);
CREATE INDEX IF NOT EXISTS idx_requests_responsibleLogin ON Requests(responsibleLogin);
CREATE INDEX IF NOT EXISTS idx_transport_driverLogin ON Transport(driverLogin);
