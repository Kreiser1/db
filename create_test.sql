CREATE OR REPLACE PROCEDURE create_test()
AS $$
BEGIN
    DELETE FROM Tasks;
    DELETE FROM Requests;
    DELETE FROM Staff;
    DELETE FROM Hardware;
    DELETE FROM Contracts;
    DELETE FROM Companies;
    
    CALL add_contract('ДОУ-000001', B'1', '2027-12-31 23:59:59');
    CALL add_contract('ДОУ-000002', B'1', '2028-06-30 23:59:59');
    CALL add_contract('ДОУ-000003', B'1', '2029-03-15 23:59:59');
    
    CALL add_company(
        'ДОУ-000001', 
        'Генеральный директор', 
        'Общество с ограниченной ответственностью "Уцйцууйц"', 
        'Уцйцууйц', 
        'г. Москва, ул. Ленина, 10', 
        'г. Москва, ул. Ленина, 10', 
        '+71231231212'
    );
    
    CALL add_company(
        'ДОУ-000002', 
        'Исполнительный директор', 
        'Акционерное общество "Хзъйзц"', 
        'Хзъйзц', 
        'г. Санкт-Петербург, Невский пр., 25', 
        'г. Санкт-Петербург, Невский пр., 25', 
        '+71234567890'
    );
    
    CALL add_company(
        'ДОУ-000003', 
        'Директор по развитию', 
        'Закрытое акционерное общество "ИТ-Решения"', 
        'ИТ-Решения', 
        'г. Новосибирск, ул. Советская, 50', 
        'г. Новосибирск, ул. Советская, 50', 
        '+71234567291'
    );
    
    CALL add_hardware('ДОУ-000001', 'Сервер HP ProLiant DL380 Gen10');
    CALL add_hardware('ДОУ-000001', 'Сетевое хранилище Synology RS3618xs');
    CALL add_hardware('ДОУ-000001', 'Маршрутизатор Cisco ISR 4331');
    CALL add_hardware('ДОУ-000001', 'Коммутатор Cisco Catalyst 9300');
    
    CALL add_hardware('ДОУ-000002', 'Лазерный нивелир Bosch GLL 3-80');
    CALL add_hardware('ДОУ-000002', 'Тахеометр Leica TS16');
    CALL add_hardware('ДОУ-000002', 'GPS-приемник Trimble R10');
    CALL add_hardware('ДОУ-000002', 'Принтер 5');
    
    CALL add_hardware('ДОУ-000003', 'Рабочая станция Dell Precision 7920');
    CALL add_hardware('ДОУ-000003', 'Монитор Eizo ColorEdge CG319X');
    CALL add_hardware('ДОУ-000003', 'Планшет Wacom Cintiq Pro 32');
    CALL add_hardware('ДОУ-000003', '3D-принтер Formlabs Form 3');
    CALL add_hardware('ДОУ-000003', 'Сканер документов Fujitsu fi-7700');
    
    CALL add_staff(
        'ivanov', 
        'pass123', 
        'Иван', 
        'Иванов', 
        'Петрович', 
        'ДОУ-000001', 
        'ИТ-отдел', 
        'Системный администратор'
    );
    
    CALL add_staff(
        'petrova', 
        'buhg456', 
        'Анна', 
        'Петрова', 
        'Сергеевна', 
        'ДОУ-000001', 
        'Бухгалтерия', 
        'Главный бухгалтер'
    );
    
    CALL add_staff(
        'sidorov', 
        'admin789', 
        'Петр', 
        'Сидоров', 
        NULL, 
        'ДОУ-000001', 
        'ИТ-отдел', 
        'Руководитель ИТ-отдела'
    );
    
    CALL add_staff(
        'smirnov', 
        'smir1', 
        'Алексей', 
        'Смирнов', 
        'Иванович', 
        'ДОУ-000002', 
        'Производственный отдел', 
        'Главный инженер'
    );
    
    CALL add_staff(
        'kuznetsova', 
        '44425', 
        'Елена', 
        'Кузнецова', 
        'Дмитриевна', 
        'ДОУ-000002', 
        'Геодезический отдел', 
        'Геодезист'
    );
    
    CALL add_staff(
        'volkov', 
        'developer3', 
        'Дмитрий', 
        'Волков', 
        'Александрович', 
        'ДОУ-000003', 
        'Отдел разработки', 
        'Ведущий разработчик'
    );
    
    CALL add_staff(
        'morozova', 
        'design4', 
        'Татьяна', 
        'Морозова', 
        'Викторовна', 
        'ДОУ-000003', 
        'Дизайн-отдел', 
        'UX/UI дизайнер'
    );
    
    CALL add_staff(
        'pavlov', 
        'admin5', 
        'Константин', 
        'Павлов', 
        'Николаевич', 
        'ДОУ-000003', 
        'Системное администрирование', 
        'Системный администратор'
    );
    
    CALL add_staff(
        'distributor_1', 
        'dist123', 
        'Алексей', 
        'Распределителев', 
        'Сергеевич', 
        NULL, 
        'Отдел распределения', 
        'Распределитель заявок'
    );
    
    CALL add_staff(
        'tech_master', 
        'tech456', 
        'Дмитрий', 
        'Мастеров', 
        'Иванович', 
        NULL, 
        'Технический отдел', 
        'Технический специалист'
    );
    
    CALL add_staff(
        'repair_engineer', 
        'repair789', 
        'Сергей', 
        'Ремонтов', 
        'Петрович',
        NULL, 
        'Ремонтный отдел', 
        'Инженер по ремонту'
    );
    
    CALL add_staff(
        'network_admin', 
        'net321', 
        'Михаил', 
        'Сетевой', 
        'Андреевич', 
        NULL, 
        'Сетевое администрирование', 
        'Сетевой администратор'
    );
    
    CALL add_staff(
        'service_manager', 
        'manager654', 
        'Елена', 
        'Сервисная', 
        'Владимировна', 
        NULL, 
        'Сервисный отдел', 
        'Менеджер сервисного обслуживания'
    );
    
    CALL add_request(
        1,
        'ДОУ-000001',
        'distributor_1',
        'Сервер периодически сам перезагружается. Требуется диагностика и ремонт. Ошибки в логах указывают на проблемы с блоком питания.'
    );
    
    CALL add_request(
        5,
        'ДОУ-000002',
        'distributor_1',
        'Лазерный нивелир не включается, возможно поврежден шнур питания или блок. Требуется срочный ремонт для полевых работ.'
    );
    
    CALL add_request(
        9,
        'ДОУ-000003',
        'distributor_1',
        'Видеокарта выдает артефакты изображения, возможно перегрев или выход из строя. Требуется диагностика и замена при необходимости.'
    );
    
    CALL add_request(
        3,
        'ДОУ-000001',
        'distributor_1',
        'Периодические обрывы связи, требуется настройка QoS и проверка конфигурации.'
    );
    
    CALL add_task(
        NULL,
        'Провести первичную диагностику сервера, проверить блок питания и логи ошибок',
        1,
        'tech_master'
    );
    
    CALL add_task(
        1,
        'Приобрести и заменить блок питания сервера, провести стресс-тестирование',
        1,
        'repair_engineer'
    );
    
    CALL add_task(
        2,
        'Обновить драйверы и прошивку, проверить стабильность работы',
        1,
        'network_admin'
    );
    
    CALL add_task(
        NULL,
        'Проверить целостность кабеля питания и блока питания нивелира',
        2,
        'tech_master'
    );
    
    CALL add_task(
        4,
        'Выполнить ремонт или замену блока питания, откалибровать прибор',
        2,
        'repair_engineer'
    );
    
    CALL add_task(
        5,
        'Провести контрольное тестирование точности измерений',
        2,
        'service_manager'
    );
    
    CALL add_task(
        NULL,
        'Провести диагностику видеокарты: проверить температуру, вентиляторы, стресс-тест',
        3,
        'tech_master'
    );
    
    CALL add_task(
        7,
        'При подтверждении неисправности - заменить видеокарту на новую NVIDIA',
        3,
        'repair_engineer'
    );
    
    CALL add_task(
        8,
        'Установить драйверы, проверить работу в графических приложениях',
        3,
        'network_admin'
    );
    
    CALL add_task(
        NULL,
        'Проанализировать текущую конфигурацию маршрутизатора и журналы ошибок',
        4,
        'network_admin'
    );
    
    CALL add_task(
        10,
        'Настроить QoS для приоритизации трафика, обновить конфигурацию',
        4,
        'network_admin'
    );
    
    CALL add_task(
        11,
        'Провести мониторинг стабильности соединения в течение 24 часов',
        4,
        'service_manager'  --
    );
    
    DO $$
    DECLARE
        company_count INTEGER;
        contract_count INTEGER;
        hardware_count INTEGER;
        staff_count INTEGER;
        request_count INTEGER;
        task_count INTEGER;
        internal_staff_count INTEGER;
        distributor_count INTEGER;
    BEGIN
        SELECT COUNT(*) INTO company_count FROM Companies;
        SELECT COUNT(*) INTO contract_count FROM Contracts;
        SELECT COUNT(*) INTO hardware_count FROM Hardware;
        SELECT COUNT(*) INTO staff_count FROM Staff;
        SELECT COUNT(*) INTO request_count FROM Requests;
        SELECT COUNT(*) INTO task_count FROM Tasks;
      SELECT COUNT(*) INTO internal_staff_count FROM Staff WHERE contractId IS NULL;
        SELECT COUNT(*) INTO distributor_count FROM Staff WHERE login = 'distributor_1';
        
        RAISE NOTICE 'Компаний-клиентов: %', company_count;
        RAISE NOTICE 'Контрактов: %', contract_count;
        RAISE NOTICE 'Оборудования: %', hardware_count;
        RAISE NOTICE 'Сотрудников (всего): %', staff_count;
        RAISE NOTICE '  - Внешних сотрудников (клиенты): %', staff_count - internal_staff_count;
        RAISE NOTICE '  - Внутренних сотрудников (исполнители): %', internal_staff_count;
        RAISE NOTICE '  - Распределителей: %', distributor_count;
        RAISE NOTICE 'Заявок: %', request_count;
        RAISE NOTICE 'Задач: %', task_count;
    END;
    $$;
$$ LANGUAGE plpgsql;

call create_test();
