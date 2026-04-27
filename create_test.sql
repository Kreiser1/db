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

CALL Contracts_Insert('ДОУ-000000001', 'Открыт', '2027-12-31 23:59:59');
CALL Companies_Insert('ДОУ-000000001', '7933736782', 'Директор', 'ООО ТестоваяОрганизация', 'ТестОрг', 'г. Москва, ул. Тестовая, д. 1', 'г. Москва, ул. Тестовая, д. 1', '+7(999)123-45-67', 'Заказчик');

CALL Contracts_Insert('ДОУ-000000002', 'Открыт', '2027-12-31 23:59:59');
CALL Companies_Insert('ДОУ-000000002', '12345678', 'Директор', 'ООО Ромашка', 'Ромашка', 'г. Москва', 'г. Москва', '+7(999)111-22-33', 'Заказчик');
CALL Staff_Insert('clt_User_1', 'password1', 'Иван', 'Иванов', 'Отдел закупок');
CALL Hardware_Insert('Сервер Huawei 2288H V5');

CALL Contracts_Insert('ДОУ-000000003', 'Открыт', '2027-12-31 23:59:59');
CALL Companies_Insert('ДОУ-000000003', '87654321', 'Директор', 'ООО ФирмПром', 'ФирмПром', 'г. Москва', 'г. Москва', '+7(999)333-44-55', 'Посредник');
CALL Staff_Insert('driver_01', 'password2', 'Петр', 'Петров', 'Транспортный отдел', 'Нет данных', 'ДОУ-000000003');
CALL Transport_Insert('А123ВС 77', 'Lada', 'Vesta', 'Белый', 'driver_01');

CALL Staff_Insert('petrovpp', 'password3', 'Пётр', 'Петров', 'Отдел поставок');
CALL Positions_Insert('petrovpp', 'Заместитель главного распределителя');

CALL Staff_Insert('User_01', 'password4', 'Семен', 'Семенов', 'Технический отдел');
CALL Hardware_Insert('МФУ Kyocera TASKalfa 4053ci');
CALL Requests_Insert('З-00000001-23', 2, 'Заправка картриджа', 'ДОУ-000000001');
CALL Tasks_Insert('TSK-000001', 'Заправить картридж', 'З-00000001-23', '2026-12-31 23:59:59', NULL, 'User_01');
CALL Companies_Insert('ДОУ-000000001', '7933736782', 'Директор', 'ООО Дубль', 'Дубль', 'г. Москва', 'г. Москва', '+7(999)555-66-77', 'Заказчик');
