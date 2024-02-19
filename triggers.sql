-- Business triggers

-- Subscriber
CREATE OR REPLACE TRIGGER check_age
BEFORE INSERT OR UPDATE ON subscriber
FOR EACH ROW
BEGIN
    IF :NEW.age < 18 OR :NEW.age > 150 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Subscriber age must be between 18 and 150.');
    END IF;
END;
/

-- ATS
CREATE OR REPLACE TRIGGER update_tech_check_date
BEFORE UPDATE ON ats
FOR EACH ROW
BEGIN
    IF :NEW.is_working = 'Y' AND :OLD.is_working = 'N' THEN
        :NEW.tech_check_date := sysdate;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER create_ats
AFTER INSERT ON ats
FOR EACH ROW
BEGIN
    IF :NEW.type = 'ins' THEN
        INSERT INTO institutional_ats (id_ats, intercity_access, institution_name, connection_opened)
        VALUES (:NEW.id_ats, 'Y', NULL, 'Y');
    ELSIF :NEW.type = 'dep' THEN
        INSERT INTO departmental_ats (id_ats, intercity_access, department_name, connection_opened)
        VALUES (:NEW.id_ats, 'Y', NULL, 'Y');
    ELSIF :NEW.type = 'city' THEN
        INSERT INTO city_ats (id_ats, type)
        VALUES (:NEW.id_ats, NULL);
    END IF;
END;
/

-- Common Phones
CREATE OR REPLACE TRIGGER update_free_ports_on_common_phone_insert
AFTER INSERT ON public_phones
FOR EACH ROW
BEGIN
    UPDATE ats SET free_ports = free_ports - 1 WHERE id_ats = :NEW.id_ats;
END;
/

CREATE OR REPLACE TRIGGER update_free_ports_on_common_phone_delete
BEFORE DELETE ON public_phones
FOR EACH ROW
BEGIN
    UPDATE ats SET free_ports = free_ports + 1 WHERE id_ats = :OLD.id_ats;
END;
/

CREATE OR REPLACE TRIGGER check_public_phone_association
BEFORE INSERT ON public_phones
FOR EACH ROW
DECLARE
    v_ats_type VARCHAR2(20);
BEGIN
    SELECT type INTO v_ats_type FROM ats WHERE id_ats = :NEW.id_ats;

    IF v_ats_type != 'city' THEN
        RAISE_APPLICATION_ERROR(-20003, 'Phone can only be associated with a city ATS.');
    END IF;
END;
/

-- Phone Number
CREATE OR REPLACE TRIGGER update_free_ports_on_number_insert
AFTER INSERT ON phone
FOR EACH ROW
BEGIN
    UPDATE ats SET free_ports = free_ports - 1 WHERE id_ats = :NEW.id_ats;
END;
/

CREATE OR REPLACE TRIGGER update_free_ports_on_number_delete
BEFORE DELETE ON phone
FOR EACH ROW
BEGIN
    UPDATE ats SET free_ports = free_ports + 1 WHERE id_ats = :OLD.id_ats;
END;
/

CREATE OR REPLACE TRIGGER check_phone_type
BEFORE INSERT OR UPDATE ON phone
FOR EACH ROW
DECLARE
    v_building_count INTEGER;
BEGIN
    -- Проверка, что номер параллельный и принадлежит только одному зданию
    IF :NEW.phone_type = 'parallel' THEN
        SELECT COUNT(DISTINCT id_address)
        INTO v_building_count
        FROM phone
        WHERE phone_type = 'parallel' AND id_address = :NEW.id_address;

        -- Проверка, что для параллельных телефонов новый телефон находится в том же здании
        IF :NEW.id_address != :OLD.id_address THEN
            RAISE_APPLICATION_ERROR(-20002, 'Нельзя создать параллельный телефон в другом здании.');
        END IF;
    END IF;

    -- Проверка, что номер спаренный и принадлежит только одному зданию
    IF :NEW.phone_type = 'paired' THEN
        SELECT COUNT(DISTINCT id_address)
        INTO v_building_count
        FROM phone
        WHERE phone_type = 'paired' AND id_address = :NEW.id_address;

        IF v_building_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20003, 'Нельзя создать/изменить спаренный телефон в одном здании, если уже существует телефон с таким номером.');
        END IF;

        -- Проверка, что для спаренных телефонов новый телефон находится в том же здании
        IF :NEW.id_address != :OLD.id_address THEN
            RAISE_APPLICATION_ERROR(-20005, 'Нельзя создать спаренный телефон в другом здании.');
        END IF;
    END IF;

    -- Если меняется тип телефона, добавляем новую запись и удаляем старую
    IF :NEW.id_phone IS NOT NULL AND :NEW.phone_type != :OLD.phone_type THEN
        INSERT INTO phone (id_ats, id_address, phone_number, phone_type, is_free)
        VALUES (:NEW.id_ats, :NEW.id_address, :NEW.phone_number, :NEW.phone_type, :NEW.is_free);

        DELETE FROM phone WHERE id_phone = :NEW.id_phone;
    END IF;
END;
/

CREATE OR REPLACE TRIGGER check_regular_phones_for_unique
    BEFORE UPDATE or INSERT
    on PHONE
    FOR EACH ROW
DECLARE
    v_phone_count integer;
BEGIN
    if :NEW.phone_type = 'regular' then
        SELECT COUNT(*)
        INTO v_phone_count
        FROM phone
        WHERE phone_type = 'regular'
          AND phone_number = :NEW.phone_number;

        IF v_phone_count > 0 THEN
            RAISE_APPLICATION_ERROR(-20006, 'Номер телефона для regular телефона должен быть уникальным.');
        END IF;
    end if;
end;
/

CREATE OR REPLACE TRIGGER prevent_delete_address
BEFORE DELETE ON address
FOR EACH ROW
DECLARE
    v_phone_count INTEGER;
    v_public_phone_count INTEGER;
BEGIN
    -- Подсчет обычных телефонов
    SELECT COUNT(*)
    INTO v_phone_count
    FROM phone
    WHERE id_address = :OLD.id_address;

    -- Добавление к подсчету общественных телефонов
    SELECT COUNT(*)
    INTO v_public_phone_count
    FROM public_phones
    WHERE id_address = :OLD.id_address;

    IF (v_phone_count + v_public_phone_count) > 0 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Нельзя удалить адрес, к которому привязаны номера телефонов (обычных и общественных).');
    END IF;
END;
/

-- Institutional ATS
CREATE OR REPLACE TRIGGER update_exit_on_international_ins
BEFORE UPDATE ON institutional_ats
FOR EACH ROW
BEGIN
    IF :NEW.connection_opened = 'N' THEN
        :NEW.intercity_access := 'N';
    END IF;
END;
/

-- Departmental ATS
-- CREATE OR REPLACE TRIGGER check_departmental_ats_from_dep_table
-- AFTER INSERT ON departmental_ats
-- FOR EACH ROW
-- DECLARE
--     v_ats_type VARCHAR2(3);
-- BEGIN
--     SELECT type INTO v_ats_type FROM ats WHERE id_ats = :NEW.id_ats;
--
--     IF v_ats_type IS NULL THEN
--         RAISE_APPLICATION_ERROR(-20003, 'ATS with the specified ID does not exist in the ATS table.');
--     ELSIF v_ats_type != 'dep' THEN
--         RAISE_APPLICATION_ERROR(-20004, 'ATS with the specified ID in the ATS table is not of type "dep".');
--     END IF;
-- END;
-- /

-- District
CREATE OR REPLACE TRIGGER check_district_cable_availability
BEFORE INSERT OR UPDATE ON district
FOR EACH ROW
BEGIN
    IF :NEW.cable_availability NOT IN ('Y', 'N') THEN
        RAISE_APPLICATION_ERROR(-20005, 'Cable availability must be either "Y" or "N".');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER check_district_channel_availability
BEFORE INSERT OR UPDATE ON district
FOR EACH ROW
BEGIN
    IF :NEW.free_channel_availability NOT IN ('Y', 'N') THEN
        RAISE_APPLICATION_ERROR(-20006, 'Free channel availability must be either "Y" or "N".');
    END IF;
END;
/

-- payment_log
CREATE OR REPLACE TRIGGER payment_log_after_insert
AFTER INSERT ON payment_log
FOR EACH ROW
DECLARE
    v_debt_exists NUMBER;
BEGIN
    -- Проверяем, если оплата была после 22-го числа
    IF TO_CHAR(:NEW.payment_date, 'DD') > '22' THEN
        -- Проверяем, является ли абонент должником
        SELECT COUNT(*)
        INTO v_debt_exists
        FROM subscriber_debt sd
        WHERE sd.id_subscriber = :NEW.id_subscriber
          AND sd.dept_type IN ('sub', 'calls');

        -- Если абонент является должником, убираем данные о задолженности и восстанавливаем доступ
        IF v_debt_exists > 0 THEN
            -- Удаляем данные о задолженности из таблицы subscriber_debt
            DELETE FROM subscriber_debt
            WHERE id_subscriber = :NEW.id_subscriber
              AND dept_type IN ('sub', 'calls');

            -- Восстанавливаем доступ в зависимости от оплаченной услуги
            IF :NEW.payment_type = 'sub' THEN
                UPDATE subscriber
                SET debtor_subscription = 'N', intercity_access = 'Y'
                WHERE id_subscriber = :NEW.id_subscriber;
            ELSE
                UPDATE subscriber
                SET debtor_intercity = 'N', intercity_access = 'Y'
                WHERE id_subscriber = :NEW.id_subscriber;
            END IF;
        END IF;
    END IF;
END;
/


CREATE OR REPLACE TRIGGER payment_log_after_insert
AFTER INSERT ON payment_log
FOR EACH ROW
DECLARE
    v_debt_exists NUMBER;
    v_remaining_debt FLOAT;
BEGIN
    -- Проверяем, если оплата была после 22-го числа
    IF TO_CHAR(:NEW.payment_date, 'DD') > '22' THEN
        -- Проверяем, является ли абонент должником
        SELECT COUNT(*)
        INTO v_debt_exists
        FROM subscriber_debt sd
        WHERE sd.id_subscriber = :NEW.id_subscriber
          AND sd.dept_type IN ('sub', 'calls');

        -- Если абонент является должником, убираем данные о задолженности и восстанавливаем доступ
        IF v_debt_exists > 0 THEN
            -- Удаляем данные о задолженности из таблицы subscriber_debt
            DELETE FROM subscriber_debt
            WHERE id_subscriber = :NEW.id_subscriber
              AND dept_type IN ('sub', 'calls');

            -- Обновляем размер задолженности, если оплата не соответствует размеру задолженности
            IF :NEW.payment_type = 'sub' THEN
                SELECT CASE
                           WHEN :NEW.amount >= (SELECT subscription_fee FROM subscriber WHERE id_subscriber = :NEW.id_subscriber) THEN
                               0
                           ELSE
                               (SELECT subscription_fee FROM subscriber WHERE id_subscriber = :NEW.id_subscriber) - :NEW.amount
                       END
                INTO v_remaining_debt
                FROM dual;

                UPDATE subscriber
                SET debtor_subscription = 'N', intercity_access = 'Y', subscription_fee = v_remaining_debt
                WHERE id_subscriber = :NEW.id_subscriber;
            ELSE
                SELECT CASE
                           WHEN :NEW.amount >= (SELECT intercity_call_cost FROM subscriber WHERE id_subscriber = :NEW.id_subscriber) THEN
                               0
                           ELSE
                               (SELECT intercity_call_cost FROM subscriber WHERE id_subscriber = :NEW.id_subscriber) - :NEW.amount
                       END
                INTO v_remaining_debt
                FROM dual;

                UPDATE subscriber
                SET debtor_intercity = 'N', intercity_access = 'Y', intercity_call_cost = v_remaining_debt
                WHERE id_subscriber = :NEW.id_subscriber;
            END IF;
        END IF;
    END IF;
END;
/
