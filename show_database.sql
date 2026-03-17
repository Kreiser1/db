SELECT 'Организация: ' || fullName || ' (' || shortName || ')' as info FROM Companies
UNION ALL
SELECT 'Юр. адрес: ' || legalAddress || ', физ. адрес: ' || physicalAddress || ', тел: ' || contactPhone FROM Companies;

SELECT 'Договор: ' || c.contractId || ', ' || c.shortName FROM Companies c;

SELECT '  Отдел: ' || department || ', ' || position || ' - ' || 
       lastName || ' ' || firstName || ' (' || login || ', ' || password || ')'
FROM Staff WHERE contractId IS NOT NULL;

SELECT 'Исполнитель: ' || lastName || ' ' || firstName || ' - ' || 
       position || ' (' || login || ', ' || password || ')'
FROM Staff WHERE contractId IS NULL;

SELECT 'Заявка: ' || id || ', от ' || creationTime || ', договор: ' || contractId || ', заявитель: ' || responsibleLogin
FROM Requests;

SELECT '  Оборудование: ' || h.description 
FROM Requests r JOIN Hardware h ON r.hardwareId = h.id;

SELECT '  Задача: ' || t.task || ' (' || s.lastName || ', ' || t.executorLogin || ')'
FROM Tasks t JOIN Staff s ON t.executorLogin = s.login;
