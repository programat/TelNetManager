-- Создание процедуры для проверки и обработки должников
CREATE OR REPLACE PROCEDURE check_payment_log_and_add_debt AS
BEGIN
    -- Проверяем абонентов, у которых не найдена запись оплаты за текущий месяц
    FOR subscriber_rec IN (SELECT s.id_subscriber
                           FROM subscriber s
                           WHERE NOT EXISTS (SELECT 1
                                             FROM payment_log pl
                                             WHERE pl.id_subscriber = s.id_subscriber
                                               AND TRUNC(pl.payment_date, 'MM') = TRUNC(SYSDATE, 'MM'))) LOOP
        DECLARE
            v_calls_exists NUMBER := 0;
            v_sub_exists NUMBER := 0;
        BEGIN
            -- Проверяем наличие записи об оплате междугородних разговоров
            SELECT COUNT(*)
            INTO v_calls_exists
            FROM payment_log pl
            WHERE pl.id_subscriber = subscriber_rec.id_subscriber
              AND pl.payment_type = 'calls'
              AND TRUNC(pl.payment_date, 'MM') = TRUNC(SYSDATE, 'MM');

            -- Проверяем наличие записи об оплате абонплаты
            SELECT COUNT(*)
            INTO v_sub_exists
            FROM payment_log pl
            WHERE pl.id_subscriber = subscriber_rec.id_subscriber
              AND pl.payment_type = 'sub'
              AND TRUNC(pl.payment_date, 'MM') = TRUNC(SYSDATE, 'MM');

            -- Если нет записи об оплате междугородних разговоров
            IF v_calls_exists = 0 THEN
                -- Заносим долг в таблицу subscriber_debt и устанавливаем аргументы debtor_intercity и debtor_subscription
                INSERT INTO subscriber_debt (id_subscriber, amount, dept_type)
                VALUES (subscriber_rec.id_subscriber,
                        (SELECT subscription_fee FROM subscriber WHERE id_subscriber = subscriber_rec.id_subscriber),
                        'calls');

                UPDATE subscriber
                SET debtor_intercity = 'Y'
                WHERE id_subscriber = subscriber_rec.id_subscriber;
            END IF;

            -- Если нет записи об оплате абонплаты
            IF v_sub_exists = 0 THEN
                -- Заносим долг в таблицу subscriber_debt и устанавливаем аргумент debtor_subscription
                INSERT INTO subscriber_debt (id_subscriber, amount, dept_type)
                VALUES (subscriber_rec.id_subscriber,
                        (SELECT intercity_call_cost FROM subscriber WHERE id_subscriber = subscriber_rec.id_subscriber),
                        'sub');

                UPDATE subscriber
                SET debtor_subscription = 'Y'
                WHERE id_subscriber = subscriber_rec.id_subscriber;
            END IF;
        END;
    END LOOP;
END;
/


-- Создание джобса для запуска процедуры check_and_process_debt на 20-е число каждого месяца
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'CHECK_DEBT_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN check_payment_log_and_add_debt; END;',
        start_date      => TO_TIMESTAMP_TZ('2024-02-20 00:00:00 Europe/Moscow', 'YYYY-MM-DD HH24:MI:SS TZR'),
        repeat_interval => 'FREQ=MONTHLY;BYMONTHDAY=20',
        enabled         => TRUE
    );
END;
/

-- Создание процедуры для отключения услуг
create PROCEDURE disable_services AS
BEGIN
    -- Отключаем услуги по абонентской плате
    FOR sub_debt_rec IN (SELECT sd.id_subscriber, sd.dept_type
                         FROM subscriber_debt sd
                         WHERE sd.dept_type = 'sub') LOOP
        UPDATE subscriber
        SET debtor_subscription = 'Y'
        WHERE id_subscriber = sub_debt_rec.id_subscriber;
    END LOOP;

    -- Отключаем услуги по межгородним звонкам
    FOR calls_debt_rec IN (SELECT sd.id_subscriber, sd.dept_type
                           FROM subscriber_debt sd
                           WHERE sd.dept_type = 'calls') LOOP
        UPDATE subscriber
        SET INTERCITY_ACCESS = 'N', debtor_intercity = 'Y'
        WHERE id_subscriber = calls_debt_rec.id_subscriber;
    END LOOP;
END;
/

-- Создание джобса для отключения услуг на 22-е число каждого месяца
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'DISABLE_SERVICES_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN disable_services; END;',
        start_date      => TO_TIMESTAMP_TZ('2024-02-22 00:00:00 Europe/Moscow', 'YYYY-MM-DD HH24:MI:SS TZR'),
        repeat_interval => 'FREQ=MONTHLY;BYMONTHDAY=22',
        enabled         => TRUE
    );
END;

CREATE OR REPLACE PROCEDURE calculate_subscription_fee AS
BEGIN
    FOR sub_rec IN (SELECT s.id_subscriber,
                           s.intercity_access,
                           COUNT(sp.id_phone) AS phone_count,
                           MIN(CASE
                                    WHEN p.phone_type = 'regular' THEN 450
                                    WHEN p.phone_type = 'paired' THEN 350
                                    WHEN p.phone_type = 'parallel' THEN 300
                                    ELSE 0
                                END) AS phone_type_fee,
                           MIN(CASE
                                    WHEN a.type = 'city' THEN 1
                                    WHEN a.type IN ('ins', 'dep') THEN 0.8
                                    ELSE 0
                                END) AS ats_multiplier,
                            MIN(CASE
                                    WHEN s.PREFERENTIAL_STATUS = 'N' THEN 1
                                    ELSE 0.7
                                END) as pref_status
                    FROM subscriber s
                             JOIN subscribers_phones sp ON s.id_subscriber = sp.id_subscriber
                             JOIN phone p ON sp.id_phone = p.id_phone
                             JOIN ats a ON p.id_ats = a.id_ats
                    WHERE s.debtor_subscription = 'N'

                    GROUP BY s.id_subscriber, s.intercity_access) LOOP

        -- Рассчитываем абонентскую плату в зависимости от количества телефонов и их типов
        UPDATE subscriber
        SET subscription_fee = (sub_rec.phone_type_fee * sub_rec.ats_multiplier) * sub_rec.phone_count * sub_rec.pref_status
        WHERE id_subscriber = sub_rec.id_subscriber;
    END LOOP;
END;
/

-- Создание джобса для расчета абонентской платы на 18-е число
BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
        job_name        => 'CALCULATE_SUBSCRIPTION_FEE_JOB',
        job_type        => 'PLSQL_BLOCK',
        job_action      => 'BEGIN calculate_subscription_fee; END;',
        start_date      => TO_TIMESTAMP_TZ('2024-02-18 00:00:00 Europe/Moscow', 'YYYY-MM-DD HH24:MI:SS TZR'),
        repeat_interval => 'FREQ=MONTHLY;BYMONTHDAY=18',
        enabled         => TRUE
    );
END;
/

CREATE OR REPLACE PROCEDURE check_installation_availability (p_queue_id IN INTEGER)
AS
    v_cable_avail          district.cable_availability%TYPE;
    v_channel_avail        district.free_channel_availability%TYPE;
    v_phone_is_free        phone.is_free%TYPE;
    v_installation_possible installation_queue.installation_possible%TYPE;
BEGIN
    -- Получение информации о кабеле и каналах из таблицы district
    SELECT cable_availability, free_channel_availability
    INTO v_cable_avail, v_channel_avail
    FROM district d
    JOIN address a ON d.id_district = a.id_district
    WHERE a.id_address = (SELECT id_address FROM installation_queue WHERE id_record = p_queue_id);

    -- Проверка наличия свободных телефонных номеров
    SELECT is_free
    INTO v_phone_is_free
    FROM phone
    WHERE id_address = (SELECT id_address FROM installation_queue WHERE id_record = p_queue_id)
    AND is_free = 'Y'
    AND ROWNUM = 1;

    -- Установка значения INSTALLATION_POSSIBLE на основе проверок
    IF v_cable_avail = 'Y' AND v_channel_avail = 'Y' AND v_phone_is_free = 'Y' THEN
        v_installation_possible := 'Y';
    ELSE
        v_installation_possible := 'N';
    END IF;

    -- Обновление значения INSTALLATION_POSSIBLE в таблице installation_queue
    UPDATE installation_queue
    SET installation_possible = v_installation_possible
    WHERE id_record = p_queue_id;

    -- Коммит транзакции
    COMMIT;
EXCEPTION
    WHEN OTHERS THEN
        -- Логирование ошибок или обработка исключений
        NULL;
END check_installation_availability;
/

