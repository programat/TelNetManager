-- DDL code

-- ATS (Automatic Telephone System)
create table ats
(
    id_ats            INTEGER generated always as identity
        constraint ats_pk
            primary key,
    name              nvarchar2(100),
    is_working        varchar2(1) default 'Y' not null,
    free_ports        INTEGER      default 0   not null,
    tech_check_date   DATE         default sysdate,
    type              varchar2(4)  default 'city',
    constraint ats_type_check
        check (type IN ('ins', 'dep', 'city') ),
    constraint ats_is_working_check
        check ( is_working IN ('Y', 'N'))
)
/

comment on table ats is 'General table for all ATSs (Automatic Telephone Systems)'
/

-- City ATS
create table city_ats
(
    id_ats  INTEGER not null
        constraint city_ats_pk
            primary key
        constraint city_ats_ATS_ID_ATS_fk
            references ats
                on delete cascade,
    type varchar2(50)
)
/

comment on table city_ats is 'Table inherited from the common ATS table'
/

-- Institutional ATS
create table institutional_ats
(
    id_ats              INTEGER                  not null
        constraint institutional_ats_pk
            primary key
        constraint institutional_ats_ATS_ID_ATS_fk
            references ats
                on delete cascade,
    intercity_access   varchar2(1) default 'Y' not null,
    institution_name   nvarchar2(100),
    connection_opened  varchar2(1) default 'Y' not null,
    constraint institutional_ats_connection_check
        check ( connection_opened IN ('Y', 'N')),
    constraint institutional_ats_intercity_check
        check ( intercity_access IN ('Y', 'N'))
)
/

comment on table institutional_ats is 'Table inherited from the common ATS table'
/

comment on column institutional_ats.connection_opened is 'Y - opened, N - closed'
/


-- Departmental ATS
create table departmental_ats
(
    id_ats             INTEGER                  not null
        constraint departmental_ats_pk
            primary key
        constraint departmental_ats_ATS_ID_ATS_fk
            references ats
                on delete cascade,
    intercity_access  varchar2(1) default 'Y' not null,
    department_name   nvarchar2(100),
    connection_opened varchar2(1) default 'Y' not null,
    constraint departmental_ats_connection_check
        check ( connection_opened IN ('Y', 'N')),
    constraint departmental_ats_intercity_check
        check ( intercity_access IN ('Y', 'N'))
)
/

comment on table departmental_ats is 'Table inherited from the common ATS table'
/

comment on column departmental_ats.connection_opened is 'Y - opened, N - closed'
/

-- Subscriber
create table subscriber
(
    id_subscriber                  INTEGER generated always as identity
        constraint subscriber_pk
            primary key,
    subscription_fee               FLOAT                    not null,
    intercity_call_cost            float                    not null,
    last_name                      nvarchar2(20)             not null,
    first_name                     nvarchar2(20),
    middle_name                    nvarchar2(20),
    gender                         varchar2(1) default 'N' not null,
    age                            INTEGER                  not null,
    intercity_access               varchar2(1) default 'Y' not null,
    preferential_status            varchar2(1) default 'N' not null,
    debtor_subscription            varchar2(1) default 'N' not null,  -- статус должника по абонплате
    debtor_intercity               varchar2(1) default 'N' not null,  -- статус должника по межгороду
    constraint subscriber_age_check
        check (age >= 18 and age <= 150),
    constraint subscriber_intercity_access_check
        check (intercity_access in ('Y', 'N')),
    constraint subscriber_preferential_status_check
        check (preferential_status in ('Y', 'N')),
    constraint subscriber_gender_check
        check (gender in ('M', 'F', 'N')),
    constraint subscriber_debtor_check
        check (debtor_subscription in ('Y', 'N')),
        check (debtor_intercity in ('Y', 'N'))
)
/

comment on column subscriber.gender is 'M - male, F - female, N - not specified'
/

-- необходимость в этой таблице пропала
-- Subscribers to ATS
-- create table subscribers_to_ats
-- (
--     id_subscriber INTEGER not null
--         constraint subscribers_to_ats_SUBSCRIBER_ID_SUBSCRIBER_fk
--             references SUBSCRIBER,
--     id_ats        INTEGER not null
--         constraint subscribers_to_ats_ATS_ID_ATS_fk
--             references ATS,
--     constraint subscribers_to_ats_pk
--         primary key (id_ats, id_subscriber)
-- )
-- /

-- District
create table district
(
    id_district                  INTEGER generated always as identity
        constraint district_pk
            primary key,
    name                         nvarchar2(100)             not null,
    cable_availability          varchar2(1) default 'Y' not null,
    free_channel_availability    varchar2(1) default 'Y' not null,
    constraint district_cable_check
        check (cable_availability in ('Y', 'N')),
    constraint district_channel_check
        check (free_channel_availability in ('Y', 'N'))
)
/


-- Address
create table address
(
    id_address          INTEGER generated always as identity
        constraint address_pk
            primary key,
    id_district         INTEGER       not null
        constraint address_district_ID_district_fk
            references DISTRICT,
    postal_code         nvarchar2(6)   not null,
    street              nvarchar2(50)  not null,
    house               nvarchar2(5)   not null,
    apartment_location nvarchar2(5)   not null
)
/

-- Phone
create table phone
(
    id_phone      INTEGER generated always as identity
        constraint phone_pk
            primary key,
    id_ats        INTEGER                  not null
        constraint phone_ATS_ID_ATS_fk
            references ATS,
    id_address    INTEGER                  not null
        constraint phone_Address_ID_ADDRESS_fk
            references ADDRESS,
    phone_number        nvarchar2(20)             not null,
    phone_type    nvarchar2(20)             not null,
    is_free       nvarchar2(1) default 'Y' not null,
    constraint phone_phone_type_check
        check (phone_type in ('parallel', 'paired', 'regular')),
    constraint phone_is_free_check
        check (is_free in ('Y', 'N'))
)
/

-- Queue for Installation
create table installation_queue
(
    id_record              INTEGER generated always as identity
        constraint installation_queue_pk
            primary key,
    id_subscriber         INTEGER                        not null
        constraint installation_queue_SUBSCRIBER_ID_SUBSCRIBER_fk
            references SUBSCRIBER,
    id_phone           INTEGER                        not null
        constraint installation_queue_phone_ID_PHONE_fk
            references phone,
    queue_type             varchar2(10) default 'simple' not null,
    installation_possible  varchar2(1) default 'Y'       not null,
    constraint installation_queue_type_check
        check (queue_type in ('simple', 'privileged')),
    constraint installation_queue_possible_check
        check (installation_possible in ('Y', 'N'))
)
/

-- Subscribers' Phones
create table subscribers_phones
(
    id_subscriber INTEGER not null
        constraint subscribers_phones_SUBSCRIBER_ID_SUBSCRIBER_fk
            references SUBSCRIBER,
    id_phone      INTEGER not null
        constraint subscribers_phones_phone_ID_PHONE_fk
            references phone,
    constraint subscribers_phones_pk
        primary key (id_subscriber, id_phone)
)
/

-- Public Phones and Payphones
create table public_phones
(
    id_public_phone INTEGER generated always as identity
        constraint id_public_phone_pk
            primary key,
    id_address       INTEGER not null
        constraint public_phones_address_ID_ADDRESS_fk
            references ADDRESS,
    id_ATS           INTEGER not null
        constraint public_phones_ATS_ID_ATS_fk
            references ATS,
    phone_type       varchar2(20)
)
/

-- Subscriber Debt
create table subscriber_debt
(
    id_debt             INTEGER generated always as identity
        constraint id_debt_subscriber_pk
            primary key,
    id_subscriber       INTEGER not null
        constraint subscriber_debt_subscriber_id_subscriber_fk
            references subscriber,
    amount              float   not null,
    dept_type varchar2(5) not null,
    constraint subscriber_debt_type_check
        check (dept_type in ('sub', 'calls')),
    constraint subscriber_debt_amount_check
        check (amount > 0)
--     constraint subscriber_debt_term_check
--         check (debt_term > 0)
)
/

comment on column subscriber_debt.dept_type is 'sub - subscription, calls - intercity calls';



-- Payment Log
create table payment_log
(
    id_payment   INTEGER generated always as identity
        constraint payment_log_pk
            primary key,
    id_subscriber  INTEGER                        not null
        constraint payment_log_SUBSCRIBER_ID_SUBSCRIBER_fk
            references SUBSCRIBER,
    amount       float                          not null,
    payment_date date                           not null,
    payment_type varchar2(5) default 'sub'      not null,
    constraint payment_log_amount_check
        check (amount > 0),
    constraint payment_log_payment_type_check
        check (payment_type in ('sub', 'calls'))
)
/

comment on column payment_log.payment_type is 'sub - subscription, calls - intercity calls';

-- Internal Calls
create table internal_calls
(
    id_payment      INTEGER generated always as identity
        constraint internal_calls_pk
            primary key,
    id_phone_from  INTEGER not null
        constraint internal_calls_phone_from_ID_PHONE_fk
            references phone,
    id_phone_to    INTEGER not null
        constraint internal_calls_phone_to_ID_PHONE_fk
            references phone,
    duration       float   not null,
    call_date      date    not null,
    constraint internal_calls_duration_check
        check (duration > 0)
)
/

-- Interurban Calls
create table interurban_calls
(
    id_payment      INTEGER generated always as identity
        constraint interurban_calls_pk
            primary key,
    id_phone_from  INTEGER       not null
        constraint interurban_calls_phone_from_ID_PHONE_fk
            references phone,
    destination    varchar2(20) not null,
    duration       float         not null,
    call_date      date          not null,
    constraint interurban_calls_duration_check
        check (duration > 0)
)
/
