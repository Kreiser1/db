SELECT 
    c.shortName AS "Краткое наименование",
    c.fullName AS "Полное наименование",
    c.representativePosition AS "Должность представителя",
    c.contactPhone AS "Телефон",
    c.physicalAddress AS "Физический адрес",
    c.legalAddress AS "Юридический адрес",
    c.contractId AS "Номер контракта"
FROM Companies c
ORDER BY c.shortName ASC;

SELECT 
    s.contractId AS "Контракт",
    s.lastName AS "Фамилия",
    s.firstName AS "Имя",
    s.patronymic AS "Отчество",
    s.position AS "Должность",
    s.department AS "Отдел",
    s.login AS "Логин"
FROM Staff s
ORDER BY s.login ASC;
