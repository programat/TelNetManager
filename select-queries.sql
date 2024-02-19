--1. Получить перечень и общее число абонентов указанной АТС полностью, только льготников, по возрастному признаку, по группе фамилий.

-- Получить общее число абонентов всех атс
select count(*) as "Total Subscribers"
from SUBSCRIBER;

-- Получить перечень абонентов всех атс
select LAST_NAME, FIRST_NAME, GENDER, AGE, preferential_status, subscription_fee
from SUBSCRIBER
order by LAST_NAME;

-- Получить число абонентов указанной атс
SELECT COUNT(DISTINCT sub.id_subscriber) AS "Число абонентов атс"
FROM subscriber sub, subscribers_phones sub_to_ph, phone ph
WHERE ph.id_ats = :ats_identificator and sub_to_ph.ID_PHONE = ph.ID_PHONE and sub.ID_SUBSCRIBER = sub_to_ph.ID_SUBSCRIBER;


-- Получить число абонентов по атс (для себя)
SELECT ID_ATS,
       COUNT(DISTINCT id_subscriber) AS "Число абонентов атс",
       LISTAGG(id_subscriber || ': ' || last_name, ', ') WITHIN GROUP (ORDER BY id_subscriber) AS "Абоненты атс"
FROM (
    SELECT DISTINCT ph.ID_ATS, sub.id_subscriber, sub.last_name
    FROM subscriber sub, subscribers_phones sub_to_ph, phone ph
        where sub.ID_SUBSCRIBER = sub_to_ph.ID_SUBSCRIBER
            and sub_to_ph.ID_PHONE = ph.ID_PHONE
)
GROUP BY ID_ATS
ORDER BY ID_ATS;


-- только льготников
SELECT distinct
    CASE
        WHEN sub.preferential_status = 'Y' THEN 'льготник'
        WHEN sub.preferential_status = 'N' THEN 'без льгот'
        ELSE 'неизвестно'
    END AS benefits,
    sub.*
FROM
    SUBSCRIBER sub, PHONE ph, ATS, SUBSCRIBERS_PHONES subph
where
    ATS.ID_ATS = :идентификатор_атс
    and ATS.ID_ATS = ph.ID_ATS
    and sub.preferential_status = 'Y'
    and sub.ID_SUBSCRIBER = subph.ID_SUBSCRIBER
    and subph.id_phone = ph.ID_PHONE
ORDER BY
    sub.last_name;

-- по возрастному признаку
SELECT
    возрастная_группа,
    COUNT(*) AS общее_число_абонентов,
    LISTAGG('id: ' || unique_sub.id_subscriber || ' ' || unique_sub.last_name || ' ' || unique_sub.first_name || ', ', ' ') WITHIN GROUP (ORDER BY unique_sub.last_name, unique_sub.first_name) AS список_абонентов
FROM (
    SELECT DISTINCT
        sub.id_subscriber,
        sub.last_name,
        sub.first_name,
        CASE
            WHEN sub.age BETWEEN 18 AND 27 THEN 'from 18 to 27'
            WHEN sub.age BETWEEN 28 AND 40 THEN 'from 28 to 40'
            WHEN sub.age BETWEEN 41 AND 65 THEN 'from 41 to 65'
            ELSE 'above 65'
        END AS возрастная_группа
    FROM
        SUBSCRIBER sub, PHONE ph, ATS, SUBSCRIBERS_PHONES subph
    WHERE
        ATS.ID_ATS = :идентификатор_атс
        AND ATS.ID_ATS = ph.ID_ATS
        AND sub.preferential_status = 'Y'
        AND sub.ID_SUBSCRIBER = subph.ID_SUBSCRIBER
        AND subph.id_phone = ph.ID_PHONE
) unique_sub
GROUP BY
    возрастная_группа
ORDER BY
    возрастная_группа;



-- по группе фамилий
SELECT
    SUBSTR(sub.last_name, 1, 1) AS группа_фамилий,
    COUNT(*) AS общее_число_абонентов,
    LISTAGG(sub.last_name, ', ') WITHIN GROUP (ORDER BY sub.last_name) AS список_абонентов
FROM
        SUBSCRIBER sub, PHONE ph, ATS, SUBSCRIBERS_PHONES subph
    WHERE
        ATS.ID_ATS = :идентификатор_атс
        AND ATS.ID_ATS = ph.ID_ATS
        AND sub.preferential_status = 'Y'
        AND sub.ID_SUBSCRIBER = subph.ID_SUBSCRIBER
        AND subph.id_phone = ph.ID_PHONE
GROUP BY
    SUBSTR(sub.last_name, 1, 1)
ORDER BY
    группа_фамилий;


-- 2. Получить перечень и общее число свободных телефонных номеров на указанной АТС, по всей ГТС, по признаку возможности установки телефона в данном районе.

SELECT
    district.name AS district_name,
    ats.name AS ATS_name,
    COUNT(*) AS total_free_numbers,
    LISTAGG(phone_number, ', ') WITHIN GROUP (ORDER BY phone_number) AS free_numbers
FROM
    phone
JOIN
    ats ON phone.id_ats = ats.id_ats
JOIN
    address ON phone.id_address = address.id_address
JOIN
    district ON address.id_district = district.id_district
WHERE
    phone.is_free = 'Y'
    AND district.FREE_CHANNEL_AVAILABILITY = 'Y'
--     AND ats.id_ats = :ats_identifier -- если убрать, то будет по всей ГТС
GROUP BY
    district.name,
    ats.name
ORDER BY
    district_name, ATS_name;

-- 5. Получить перечень и общее число общественных телефонов и таксофонов во всем городе, принадлежащих указанной АТС, по признаку нахождения в данном районе.

SELECT
    district.name AS district_name,
    ats.name AS ATS_name,
    COUNT(*) AS total_public_phones_and_payphones,
    LISTAGG(public_phones.phone_type, ', ') WITHIN GROUP (ORDER BY public_phones.phone_type) AS types_of_public_phones_and_payphones
FROM
    public_phones
JOIN
    ats ON public_phones.id_ATS = ats.id_ats
JOIN
    address ON public_phones.id_address = address.id_address
JOIN
    district ON address.id_district = district.id_district
WHERE
    ats.id_ats = :ATS_identifier
GROUP BY
    district.name,
    ats.name
ORDER BY
    district_name, ATS_name;

-- 10. Получение полной информации об абонентах с заданным телефонным номером.

-- через where
select subscriber.*
from SUBSCRIBER, SUBSCRIBERS_PHONES, PHONE_NUMBER
where SUBSCRIBER.ID_SUBSCRIBER = SUBSCRIBERS_PHONES.ID_SUBSCRIBER and subscribers_phones.id_phone = phone_number.id_phone and PHONE_NUMBER.number = :phone_number
order by SUBSCRIBER.ID_SUBSCRIBER;

-- через джоины
SELECT
    SUBSCRIBER.*,
    phone_number.number,
    phone_number.phone_type
FROM
    subscribers_phones
JOIN
    SUBSCRIBER ON subscribers_phones.id_subscriber = SUBSCRIBER.id_subscriber
JOIN
    phone_number ON subscribers_phones.id_phone = phone_number.id_phone
WHERE
    phone_number.number = :phone_number;
