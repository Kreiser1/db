SET CONSTRAINTS ALL DEFERRED;

DELETE FROM Tasks;
DELETE FROM Requests;
DELETE FROM Transport;
DELETE FROM Positions;
DELETE FROM Hardware;
DELETE FROM Staff;
DELETE FROM Companies;
DELETE FROM Contracts;

ALTER SEQUENCE hardware_id_seq RESTART WITH 1;
ALTER SEQUENCE positions_id_seq RESTART WITH 1;

SET CONSTRAINTS ALL IMMEDIATE;

CALL Contracts_Insert('ДОУ-000000001', 'Открыт', '2027-12-31 23:59:59', '2024-10-10 00:00:00');
CALL Contracts_Insert('ДОУ-000000002', 'Открыт', '2027-01-09 23:59:59', '2024-01-10 00:00:00');
CALL Contracts_Insert('ДОУ-000000003', 'Открыт', '2027-12-31 23:59:59', '2024-11-07 00:00:00');

CALL Companies_Insert(
    'ДОУ-000000001', '6683972257', 'Начальник отдела',
    'ООО «Телекоммуникации города»', 'ООО «ТелекоммГор»',
    'г. Москва, Пропект Вернадского, д.26, к. 2',
    'г. Москва, ул. Кропоткинская д. 15, стр. 1',
    '+7(495)492-77-25', 'Заказчик'
);

CALL Companies_Insert(
    'ДОУ-000000003', '7933736782', 'Начальник Отдела',
    'ПАО «Офис Связь»', 'ПАО «ОфСв»',
    'г. Москва, ул. Арбатская, д. 8, стр.6',
    'г. Москва, ул. Садовая, д.69, стр. 2',
    '+7(495)227-77-36', 'Заказчик'
);

CALL Staff_Insert('clt_User_1', 'Pa$$w0rd', 'Георгий', 'Владимиров', 'Отдел кадров', 'Алексеевич', 'ДОУ-000000001', NULL);
CALL Staff_Insert('clt_User_2', 'Pa$$w0rd', 'Иван', 'Павлов', 'Отдел кадров', NULL, 'ДОУ-000000001', NULL);
CALL Staff_Insert('clt_User_3', 'Pa$$w0rd', 'Егор', 'Дмитриев', 'Отдел кадров', 'Алексеевич', 'ДОУ-000000001', NULL);

CALL Staff_Insert('clt_User_4', 'Pa$$w0rd', 'Пётр', 'Иванов', 'Отдел договоров и услуг', 'Андреевич', 'ДОУ-000000001', NULL);
CALL Staff_Insert('clt_User_5', 'Pa$$w0rd', 'Роман', 'Семёнов', 'Отдел договоров и услуг', 'Алексеевич', 'ДОУ-000000001', NULL);
CALL Staff_Insert('clt_User_6', 'Pa$$w0rd', 'Андрей', 'Смирнов', 'КПП', 'Павлович', 'ДОУ-000000001', NULL);

CALL Staff_Insert('clt_User_7', 'Pa$$w0rd', 'Олег', 'Петров', 'Отдел кадров', 'Геннадьевич', 'ДОУ-000000003', NULL);
CALL Staff_Insert('clt_User_8', 'Pa$$w0rd', 'Кирилл', 'Андреев', 'Отдел бухгалтерии', 'Николаевич', 'ДОУ-000000003', NULL);
CALL Staff_Insert('clt_User_9', 'Pa$$w0rd', 'Иван', 'Романов', 'Отдел бухгалтерии', 'Олегович', 'ДОУ-000000003', NULL);
CALL Staff_Insert('clt_User_10', 'Pa$$w0rd', 'Дмитрий', 'Кириллов', 'Отдел бухгалтерии', 'Дмитриевич', 'ДОУ-000000003', NULL);

CALL Staff_Insert('User_01', 'Pa$$vv0RD', 'Иван', 'Иванов', 'Отдел распределения', 'Иванович', NULL, NULL);
CALL Staff_Insert('User_02', 'Pa$$vv0RD', 'Пётр', 'Петров', 'Отдел распределения', 'Петрович', NULL, NULL);
CALL Staff_Insert('User_03', 'Pa$$vv0RD', 'Алексей', 'Алексеев', 'Технический отдел', 'Алексеевич', NULL, NULL);
CALL Staff_Insert('User_04', 'Pa$$vv0RD', 'Андрей', 'Андреев', 'Технический отдел', 'Андреевич', NULL, NULL);

CALL Positions_Insert('clt_User_1', 'Начальник отдела');
CALL Positions_Insert('clt_User_4', 'Начальник отдела');
CALL Positions_Insert('clt_User_6', 'Начальник поста');
CALL Positions_Insert('clt_User_7', 'Начальник Отдела');
CALL Positions_Insert('clt_User_8', 'Главный бухгалтер');
CALL Positions_Insert('User_01', 'Главный по распределению задач');
CALL Positions_Insert('User_02', 'Заместитель главного распределителя');
CALL Positions_Insert('User_02', 'Технический эксперт');
CALL Positions_Insert('User_03', 'Технический эксперт');
CALL Positions_Insert('User_04', 'Помощник технического эксперта');

CALL Hardware_Insert('Ноутбук Asus RT-1000 (Intel Core I6, RAM: 8 Gb; SSD: 100Gb, HDD: 256 Gb, Windows 8.1)', 'ДОУ-000000001');
CALL Hardware_Insert('Принтер HP-WV123', 'ДОУ-000000001');
CALL Hardware_Insert('Сканер Samsung SH-200', 'ДОУ-000000001');
CALL Hardware_Insert('Ноутбук Lenovo LVT-14000 (Intel Core I7, RAM: 16 GB; SSD: 256 GB, Windows 10 Professional)', 'ДОУ-000000003');
CALL Hardware_Insert('МФУ Xerox 75-AR-200', 'ДОУ-000000001');

CALL Requests_Insert(
    'З-00000001-27', 1, 'Не запускается операционная система',
    'ДОУ-000000001', 'clt_User_1', '2027-11-20 17:14:23'
);
CALL Requests_Insert(
    'З-00000002-27', 2, 'Заживал лист бумаги',
    'ДОУ-000000001', 'clt_User_5', '2027-06-11 08:01:59'
);
CALL Requests_Insert(
    'З-00000003-27', 3, 'Не работает дисплей',
    'ДОУ-000000001', 'clt_User_5', '2027-06-11 08:01:59'
);
CALL Requests_Insert(
    'З-00000004-27', 4, 'Не подаёт признаков жизни',
    'ДОУ-000000003', 'clt_User_7', '2027-06-11 11:54:02'
);
CALL Requests_Insert(
    'З-00000005-27', 5, 'Не работает копировальное оборудование',
    'ДОУ-000000001', 'clt_User_3', '2027-08-27 15:06:54'
);

CALL Tasks_Insert('TSK-000001', 'Произвести полную диагностику файловых носителей', 'З-00000001-27', '2027-11-30 23:59:59', NULL, 'User_01', '2027-11-20 17:14:23');
CALL Tasks_Insert('TSK-000004', 'Проверить шлейфы работы оборудования дисплея', 'З-00000003-27', '2027-06-17 23:59:59', NULL, 'User_02', '2027-06-11 08:01:59');
CALL Tasks_Insert('TSK-000006', 'Проверка аппаратной части', 'З-00000004-27', '2027-06-15 23:59:59', NULL, 'User_03', '2027-06-11 11:54:02');
CALL Tasks_Insert('TSK-000007', 'Разборка и диагностика ППК на отсутствие коррозий и повреждения магистралей печатной платы', 'З-00000004-27', '2027-06-12 23:59:59', 'TSK-000006', 'User_04', '2027-06-11 11:54:02');
