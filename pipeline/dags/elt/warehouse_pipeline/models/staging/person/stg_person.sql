select
    businessentityid as person_id,
    persontype as person_type,
    namestyle as name_style,
    title as title,
    firstname as first_name,
    middlename as middle_name,
    lastname as last_name,
    suffix as suffix,
    emailpromotion as email_promotion,
    additionalcontactinfo as additional_contact_info,
    demographics as demographics,
    rowguid as row_guid,
    modifieddate as modified_date
from {{ source('raw_person', 'person') }}