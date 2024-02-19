-- Subscriber
INSERT ALL
    INTO subscriber (subscription_fee, intercity_call_cost, last_name, first_name, middle_name, gender, age,
                     intercity_access, preferential_status)
    select
    1000.0, 5.0, 'Иванов', 'Иван', 'Иванович', 'M', 25, 'Y', 'N' from dual

    union all
    select 1200.0, 6.0, 'Петров', 'Петр', 'Петрович', 'M', 30, 'Y', 'Y' from dual
    union all
    select 1500.0, 7.0, 'Сидорова', 'Мария', 'Петровна', 'F', 22, 'Y', 'N' from dual
    union all
    select 1100.0, 5.5, 'Козлов', 'Александр', 'Иванович', 'M', 28, 'Y', 'N' from dual
    union all
    select 1300.0, 6.5, 'Михайлова', 'Ольга', 'Александровна', 'F', 35, 'Y', 'N' from dual
    union all
    select 900.0, 4.0, 'Иванова', 'Анна', 'Игоревна', 'F', 29, 'Y', 'N' from dual
    union all
    select 1080.0, 5.0, 'Кузнецов', 'Артем', 'Сергеевич', 'M', 32, 'Y', 'Y' from dual
    union all
    select 1350.0, 6.5, 'Смирнов', 'Екатерина', 'Александровна', 'F', 24, 'Y', 'N' from dual
    union all
    select 990.0, 4.0, 'Попов', 'Дмитрий', 'Владимирович', 'M', 27, 'Y', 'N' from dual
    union all
    select 1070.0, 5.5, 'Михайлов', 'Игорь', 'Анатольевич', 'M', 31, 'Y', 'N' from dual;

-- District
INSERT ALL
    INTO district (name, cable_availability, free_channel_availability)
    SELECT 'Северный', 'Y', 'N' FROM dual
    UNION ALL
    SELECT 'Южный', 'N', 'Y' FROM dual
    UNION ALL
    SELECT 'Западный', 'N', 'N' FROM dual
    UNION ALL
    SELECT 'Восточный', 'Y', 'Y' FROM dual
    UNION ALL
    SELECT 'Северо-Западный', 'Y', 'N' FROM dual
    UNION ALL
    SELECT 'Юго-Восточный', 'N', 'Y' FROM dual
    UNION ALL
    SELECT 'Средний', 'N', 'N' FROM dual
    UNION ALL
    SELECT 'Зеленоградский', 'Y', 'Y' FROM dual
    UNION ALL
    SELECT 'Троицкий', 'Y', 'N' FROM dual;

-- Address
INSERT ALL
    INTO address (id_district, postal_code, street, house, apartment_location)
    SELECT 1, '123456', 'Центральная', '10', '101' FROM dual
    UNION ALL
    SELECT 2, '654321', 'Северная', '15', '202' FROM dual
    UNION ALL
    SELECT 3, '987654', 'Южная', '20', '303' FROM dual
    UNION ALL
    SELECT 4, '456789', 'Западная', '25', '404' FROM dual
    UNION ALL
    SELECT 5, '321987', 'Восточная', '30', '505' FROM dual
    UNION ALL
    SELECT 6, '789654', 'Северо-Западная', '35', '606' FROM dual
    UNION ALL
    SELECT 7, '456123', 'Юго-Восточная', '40', '707' FROM dual
    UNION ALL
    SELECT 8, '159357', 'Средняя', '45', '808' FROM dual
    UNION ALL
    SELECT 9, '753951', 'Зеленоградская', '50', '909' FROM dual
    UNION ALL
    SELECT 1, '852369', 'Троицкая', '55', '1010' FROM dual
    UNION ALL
    SELECT 1, '123456', 'Пушкинская', '10', '5' FROM dual
    UNION ALL
    SELECT 2, '654321', 'Ломоносова', '25', '12' FROM dual
    UNION ALL
    SELECT 3, '987654', 'Солнечная', '7', '3' FROM dual
    UNION ALL
    SELECT 4, '456789', 'Лесная', '15', '8' FROM dual
    UNION ALL
    SELECT 5, '111222', 'Мира', '20', '2' FROM dual
    UNION ALL
    SELECT 6, '333444', 'Гагарина', '30', '11' FROM dual
    UNION ALL
    SELECT 7, '555666', 'Советская', '5', '7' FROM dual
    UNION ALL
    SELECT 8, '777888', 'Центральная', '12', '6' FROM dual
    UNION ALL
    SELECT 9, '999000', 'Парковая', '18', '4' FROM dual
    UNION ALL
    SELECT 3, '444555', 'Трудовая', '22', '9' FROM dual
    UNION ALL
    SELECT 1, '135792', 'Октябрьская', '14', '3' FROM dual
    UNION ALL
    SELECT 2, '246813', 'Весенняя', '9', '6' FROM dual
    UNION ALL
    SELECT 3, '876543', 'Грушевая', '11', '8' FROM dual
    UNION ALL
    SELECT 4, '135798', 'Новая', '17', '5' FROM dual
    UNION ALL
    SELECT 5, '975318', 'Зеленая', '23', '10' FROM dual
    UNION ALL
    SELECT 6, '641237', 'Сиреневая', '28', '7' FROM dual
    UNION ALL
    SELECT 7, '543216', 'Тенистая', '13', '2' FROM dual
    UNION ALL
    SELECT 8, '135246', 'Майская', '19', '4' FROM dual
    UNION ALL
    SELECT 9, '987123', 'Полевая', '21', '9' FROM dual
    UNION ALL
    SELECT 9, '789456', 'Главная', '26', '12' FROM dual;


-- ATS (Automatic Telephone System)
INSERT ALL
    INTO ats (name, is_working, free_ports, tech_check_date, type)
    SELECT 'ATS1', 'Y', 50, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS2', 'N', 20, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'ins' FROM dual
    UNION ALL
    SELECT 'ATS3', 'Y', 30, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS4', 'Y', 40, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'dep' FROM dual
    UNION ALL
    SELECT 'ATS5', 'N', 15, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS6', 'Y', 25, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'ins' FROM dual
    UNION ALL
    SELECT 'ATS7', 'Y', 35, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS8', 'N', 10, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS9', 'Y', 45, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'dep' FROM dual
    UNION ALL
    SELECT 'ATS10', 'Y', 18, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'ins' FROM dual
    UNION ALL
    SELECT 'ATS11', 'N', 28, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS12', 'Y', 38, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS13', 'Y', 48, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'ins' FROM dual
    UNION ALL
    SELECT 'ATS14', 'N', 13, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS15', 'Y', 23, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'dep' FROM dual
    UNION ALL
    SELECT 'ATS16', 'Y', 33, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS17', 'N', 8, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS18', 'Y', 43, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'ins' FROM dual
    UNION ALL
    SELECT 'ATS19', 'Y', 16, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual
    UNION ALL
    SELECT 'ATS20', 'N', 26, TO_DATE('2024-01-23', 'YYYY-MM-DD'), 'city' FROM dual;


-- Phone Number
/*
INSERT ALL
    INTO phone (id_ats, id_address, phone_number, phone_type, is_free)
    SELECT id_ats, id_address, phone_number, phone_type, is_free
    FROM (SELECT id_ats, id_address, phone_number, phone_type, is_free, ROWNUM as rnum
          FROM (SELECT 1           as id_ats,
                       1           as id_address,
                       '123456789' as phone_number,
                       'parallel'  as phone_type,
                       'Y'         as is_free
                FROM dual
                UNION ALL
                SELECT 2, 2, '987654321', 'paired', 'N'
                FROM dual
                UNION ALL
                SELECT 3, 3, '111223344', 'regular', 'Y'
                FROM dual
                UNION ALL
                SELECT 4, 4, '555666777', 'parallel', 'Y'
                FROM dual
                UNION ALL
                SELECT 5, 5, '999000111', 'paired', 'N'
                FROM dual
                UNION ALL
                SELECT 6, 6, '444555666', 'regular', 'Y'
                FROM dual
                UNION ALL
                SELECT 7, 7, '777888999', 'parallel', 'Y'
                FROM dual
                UNION ALL
                SELECT 8, 8, '222333444', 'paired', 'N'
                FROM dual
                UNION ALL
                SELECT 9, 9, '888777666', 'regular', 'Y'
                FROM dual
                UNION ALL
                SELECT 10, 10, '123987456', 'parallel', 'Y'
                FROM dual
                UNION ALL
                SELECT 1, 11, '456789012', 'paired', 'N'
                FROM dual
                UNION ALL
                SELECT 2, 12, '555444333', 'regular', 'Y'
                FROM dual
                UNION ALL
                SELECT 3, 13, '666777888', 'parallel', 'Y'
                FROM dual
                UNION ALL
                SELECT 4, 14, '777666555', 'paired', 'N'
                FROM dual
                UNION ALL
                SELECT 5, 15, '888999000', 'regular', 'Y'
                FROM dual
                UNION ALL
                SELECT 6, 16, '999888777', 'parallel', 'Y'
                FROM dual
                UNION ALL
                SELECT 7, 17, '111222333', 'paired', 'N'
                FROM dual
                UNION ALL
                SELECT 8, 18, '444555666', 'regular', 'Y'
                FROM dual
                UNION ALL
                SELECT 9, 19, '777888999', 'parallel', 'Y'
                FROM dual
                UNION ALL
                SELECT 10, 20, '555444333', 'paired', 'N'
                FROM dual
            )
        )
        where ROWNUM <= 20;
*/

INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (1, 1, '123456789', 'parallel', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (2, 2, '987654321', 'paired', 'N');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (3, 3, '111223344', 'regular', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (4, 4, '555666777', 'parallel', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (5, 5, '999000111', 'paired', 'N');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (6, 6, '444555666', 'regular', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (7, 7, '777888999', 'parallel', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (8, 8, '222333444', 'paired', 'N');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (9, 9, '888777666', 'regular', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (10, 10, '123987456', 'parallel', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (1, 11, '456789012', 'paired', 'N');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (2, 12, '555444333', 'regular', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (3, 13, '666777888', 'parallel', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (4, 14, '777666555', 'paired', 'N');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (5, 15, '888999000', 'regular', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (6, 16, '999888777', 'parallel', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (7, 17, '111222333', 'paired', 'N');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (8, 18, '444555777', 'regular', 'Y');
INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free) VALUES (9, 19, '777888999', 'parallel', 'Y');


-- subscribers_phones
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (2, 2);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (3, 3);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (4, 4);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (5, 5);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (6, 6);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (7, 7);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (8, 8);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (9, 9);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (10, 10);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (1, 11);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (2, 12);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (3, 13);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (4, 14);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (5, 15);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (6, 16);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (7, 17);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (8, 18);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (9, 19);
INSERT INTO subscribers_phones (id_subscriber, id_phone) VALUES (10, 19);


-- installation_queue
INSERT ALL
    INTO installation_queue (id_subscriber, id_phone, queue_type, installation_possible)
    SELECT id_subscriber, id_phone, queue_type, installation_possible
    FROM (
        SELECT id_subscriber, id_phone, queue_type, installation_possible, ROWNUM as rnum
        FROM (
            SELECT 1 as id_subscriber, 1 as id_phone, 'simple' as queue_type, 'Y' as installation_possible FROM dual
            UNION ALL
            SELECT 2, 2, 'privileged', 'Y' FROM dual
            UNION ALL
            SELECT 3, 3, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 4, 4, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 5, 5, 'privileged', 'N' FROM dual
            UNION ALL
            SELECT 6, 6, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 7, 7, 'privileged', 'Y' FROM dual
            UNION ALL
            SELECT 8, 8, 'simple', 'N' FROM dual
            UNION ALL
            SELECT 9, 9, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 10, 10, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 1, 11, 'privileged', 'Y' FROM dual
            UNION ALL
            SELECT 2, 12, 'simple', 'N' FROM dual
            UNION ALL
            SELECT 3, 13, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 4, 14, 'privileged', 'Y' FROM dual
            UNION ALL
            SELECT 5, 15, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 6, 16, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 7, 17, 'privileged', 'N' FROM dual
            UNION ALL
            SELECT 8, 18, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 9, 19, 'simple', 'Y' FROM dual
            UNION ALL
            SELECT 10, 19, 'privileged', 'Y' FROM dual
        )
    )
    WHERE rnum <= 20;

-- public_phones
INSERT ALL
    INTO public_phones (id_address, id_ATS, phone_type)
    SELECT id_address, id_ATS, CASE WHEN ROWNUM <= 10 THEN 'payphone' ELSE 'public_phone' END
    FROM (
        SELECT id_address, id_ATS, ROWNUM as rnum
        FROM (
            SELECT 1 as id_address, 1 as id_ATS FROM dual
            UNION ALL
            SELECT 2, 3 FROM dual
            UNION ALL
            SELECT 3, 3 FROM dual
            UNION ALL
            SELECT 4, 5 FROM dual
            UNION ALL
            SELECT 5, 5 FROM dual
            UNION ALL
            SELECT 6, 7 FROM dual
            UNION ALL
            SELECT 7, 7 FROM dual
            UNION ALL
            SELECT 8, 8 FROM dual
            UNION ALL
            SELECT 9, 7 FROM dual
            UNION ALL
            SELECT 10, 11 FROM dual
            UNION ALL
            SELECT 1, 11 FROM dual
            UNION ALL
            SELECT 2, 12 FROM dual
            UNION ALL
            SELECT 3, 12 FROM dual
            UNION ALL
            SELECT 4, 14 FROM dual
            UNION ALL
            SELECT 5, 14 FROM dual
            UNION ALL
            SELECT 6, 16 FROM dual
            UNION ALL
            SELECT 7, 17 FROM dual
            UNION ALL
            SELECT 8, 19 FROM dual
            UNION ALL
            SELECT 9, 19 FROM dual
            UNION ALL
            SELECT 10, 20 FROM dual
        )
    )
    WHERE rnum <= 20;


-- payment_log
INSERT ALL
    INTO payment_log (id_subscriber, amount, payment_date)
    SELECT 1, 500.0, TO_DATE('2024-01-23', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 2, 700.0, TO_DATE('2024-01-24', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 3, 400.0, TO_DATE('2024-01-25', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 4, 600.0, TO_DATE('2024-01-26', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 5, 800.0, TO_DATE('2024-01-27', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 6, 450.0, TO_DATE('2024-01-28', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 7, 550.0, TO_DATE('2024-01-29', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 8, 900.0, TO_DATE('2024-01-30', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 9, 350.0, TO_DATE('2024-01-31', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 10, 750.0, TO_DATE('2024-02-01', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 1, 480.0, TO_DATE('2024-02-02', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 2, 620.0, TO_DATE('2024-02-03', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 3, 380.0, TO_DATE('2024-02-04', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 4, 580.0, TO_DATE('2024-02-05', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 5, 780.0, TO_DATE('2024-02-06', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 6, 420.0, TO_DATE('2024-02-07', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 7, 510.0, TO_DATE('2024-02-08', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 8, 870.0, TO_DATE('2024-02-09', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 9, 320.0, TO_DATE('2024-02-10', 'YYYY-MM-DD') FROM dual
    UNION ALL
    SELECT 10, 700.0, TO_DATE('2024-02-11', 'YYYY-MM-DD') FROM dual;
