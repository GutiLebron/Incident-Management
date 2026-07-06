using { API_BUSINESS_PARTNER as external } from './external/API_BUSINESS_PARTNER';

service RemoteService {

    @UI: {
        SelectionFields: ['ID', 'name'],
        LineItem: [
            { Value: ID },
            { Value: name },
            { Value: email }
        ],
        Identification: [
            { Value: name },
            { Value: email }
        ]
    }
    entity BusinessPartner as projection on external.A_BusinessPartner {
        key BusinessPartner as ID,
        BusinessPartnerName as name
    }

    entity PartnerAddress as projection on external.A_BusinessPartnerAddress {
        key BusinessPartner as ID,
        AddressID,
        to_EmailAddress.EmailAddress as email
    }

    @UI: {
        SelectionFields: ['ID', 'name', 'email'],
        LineItem: [
            { Value: ID },
            { Value: name },
            { Value: email }
        ],
        Identification: [
            { Value: name },
            { Value: email }
        ],
        HeaderInfo: {
            TypeName: 'Customer',
            TypeNamePlural: 'Customers',
            Title: { Value: name },
            Description: { Value: email }
        }
    }
    entity RemoteCustomers as select from BusinessPartner
        left join PartnerAddress
            on BusinessPartner.ID = PartnerAddress.ID {
        key BusinessPartner.ID as ID,
            BusinessPartner.name as name,
            PartnerAddress.email as email
    }
}
