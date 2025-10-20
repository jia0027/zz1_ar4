@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Email'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZZ1_I_AddressEmailAddress_2 as select from I_AddressEmailAddress_2
{
    key AddressID,
    key AddressPersonID,
    key CommMediumSequenceNumber,
    EmailAddress,
    EmailAddressIsCurrentDefault,
    CommLineNotForUnsolicitedCntct,
    ValidityStartDate,
    ValidityEndDate,
    /* Associations */
    _AddressCommunicationRemark,
    _AddressCommunicationUsage,
    _AddressPersonName,
    _OrgNamePostalAddress
}
