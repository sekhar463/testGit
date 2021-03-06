/*
This migration script replaces uncommitted changes made to these objects:
BusinessEntity
Person
NameStyle
Name
AdditionalContactInfoSchemaCollection
IndividualSurveySchemaCollection
Person

Use this script to make necessary schema and data changes for these objects only. Schema changes to any other objects won't be deployed.

Schema changes and migration scripts are deployed in the order they're committed.
*/

SET NUMERIC_ROUNDABORT OFF
GO
SET ANSI_PADDING, ANSI_WARNINGS, CONCAT_NULL_YIELDS_NULL, ARITHABORT, QUOTED_IDENTIFIER, ANSI_NULLS ON
GO
PRINT N'Creating schemas'
GO
CREATE SCHEMA [Person]
AUTHORIZATION [dbo]
GO
PRINT N'Creating XML schema collections'
GO
CREATE XML SCHEMA COLLECTION [Person].[AdditionalContactInfoSchemaCollection] 
AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactInfo">
  <xsd:element name="AdditionalContactInfo">
    <xsd:complexType mixed="true">
      <xsd:complexContent mixed="true">
        <xsd:restriction base="xsd:anyType">
          <xsd:sequence>
            <xsd:any namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" minOccurs="0" maxOccurs="unbounded" />
          </xsd:sequence>
        </xsd:restriction>
      </xsd:complexContent>
    </xsd:complexType>
  </xsd:element>
</xsd:schema>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactRecord">
  <xsd:element name="ContactRecord">
    <xsd:complexType mixed="true">
      <xsd:complexContent mixed="true">
        <xsd:restriction base="xsd:anyType">
          <xsd:choice minOccurs="0" maxOccurs="unbounded">
            <xsd:any namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" />
          </xsd:choice>
          <xsd:attribute name="date" type="xsd:date" />
        </xsd:restriction>
      </xsd:complexContent>
    </xsd:complexType>
  </xsd:element>
</xsd:schema>
<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" elementFormDefault="qualified">
  <xsd:element name="eMail" type="t:eMailType" />
  <xsd:element name="facsimileTelephoneNumber" type="t:phoneNumberType" />
  <xsd:element name="homePostalAddress" type="t:addressType" />
  <xsd:element name="internationaliSDNNumber" type="t:phoneNumberType" />
  <xsd:element name="mobile" type="t:phoneNumberType" />
  <xsd:element name="pager" type="t:phoneNumberType" />
  <xsd:element name="physicalDeliveryOfficeName" type="t:addressType" />
  <xsd:element name="registeredAddress" type="t:addressType" />
  <xsd:element name="telephoneNumber" type="t:phoneNumberType" />
  <xsd:element name="telexNumber" type="t:phoneNumberType" />
  <xsd:complexType name="addressType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="Street" type="xsd:string" maxOccurs="2" />
          <xsd:element name="City" type="xsd:string" />
          <xsd:element name="StateProvince" type="xsd:string" />
          <xsd:element name="PostalCode" type="xsd:string" minOccurs="0" />
          <xsd:element name="CountryRegion" type="xsd:string" />
          <xsd:element name="SpecialInstructions" type="t:specialInstructionsType" minOccurs="0" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="eMailType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="eMailAddress" type="xsd:string" />
          <xsd:element name="SpecialInstructions" type="t:specialInstructionsType" minOccurs="0" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="phoneNumberType">
    <xsd:complexContent>
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:element name="number">
            <xsd:simpleType>
              <xsd:restriction base="xsd:string">
                <xsd:pattern value="[0-9\(\)\-]*" />
              </xsd:restriction>
            </xsd:simpleType>
          </xsd:element>
          <xsd:element name="SpecialInstructions" type="t:specialInstructionsType" minOccurs="0" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
  <xsd:complexType name="specialInstructionsType" mixed="true">
    <xsd:complexContent mixed="true">
      <xsd:restriction base="xsd:anyType">
        <xsd:sequence>
          <xsd:any namespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/ContactTypes" minOccurs="0" maxOccurs="unbounded" />
        </xsd:sequence>
      </xsd:restriction>
    </xsd:complexContent>
  </xsd:complexType>
</xsd:schema>'
GO
CREATE XML SCHEMA COLLECTION [Person].[IndividualSurveySchemaCollection] 
AS N'<xsd:schema xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:t="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey" targetNamespace="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey" elementFormDefault="qualified">
  <xsd:element name="IndividualSurvey">
    <xsd:complexType>
      <xsd:complexContent>
        <xsd:restriction base="xsd:anyType">
          <xsd:sequence>
            <xsd:element name="TotalPurchaseYTD" type="xsd:decimal" minOccurs="0" />
            <xsd:element name="DateFirstPurchase" type="xsd:date" minOccurs="0" />
            <xsd:element name="BirthDate" type="xsd:date" minOccurs="0" />
            <xsd:element name="MaritalStatus" type="xsd:string" minOccurs="0" />
            <xsd:element name="YearlyIncome" type="t:SalaryType" minOccurs="0" />
            <xsd:element name="Gender" type="xsd:string" minOccurs="0" />
            <xsd:element name="TotalChildren" type="xsd:int" minOccurs="0" />
            <xsd:element name="NumberChildrenAtHome" type="xsd:int" minOccurs="0" />
            <xsd:element name="Education" type="xsd:string" minOccurs="0" />
            <xsd:element name="Occupation" type="xsd:string" minOccurs="0" />
            <xsd:element name="HomeOwnerFlag" type="xsd:string" minOccurs="0" />
            <xsd:element name="NumberCarsOwned" type="xsd:int" minOccurs="0" />
            <xsd:element name="Hobby" type="xsd:string" minOccurs="0" maxOccurs="unbounded" />
            <xsd:element name="CommuteDistance" type="t:MileRangeType" minOccurs="0" />
            <xsd:element name="Comments" type="xsd:string" minOccurs="0" />
          </xsd:sequence>
        </xsd:restriction>
      </xsd:complexContent>
    </xsd:complexType>
  </xsd:element>
  <xsd:simpleType name="MileRangeType">
    <xsd:restriction base="xsd:string">
      <xsd:enumeration value="0-1 Miles" />
      <xsd:enumeration value="1-2 Miles" />
      <xsd:enumeration value="2-5 Miles" />
      <xsd:enumeration value="5-10 Miles" />
      <xsd:enumeration value="10+ Miles" />
    </xsd:restriction>
  </xsd:simpleType>
  <xsd:simpleType name="SalaryType">
    <xsd:restriction base="xsd:string">
      <xsd:enumeration value="0-25000" />
      <xsd:enumeration value="25001-50000" />
      <xsd:enumeration value="50001-75000" />
      <xsd:enumeration value="75001-100000" />
      <xsd:enumeration value="greater than 100000" />
    </xsd:restriction>
  </xsd:simpleType>
</xsd:schema>'
GO
PRINT N'Creating types'
GO
CREATE TYPE [dbo].[NameStyle] FROM bit NOT NULL
GO
CREATE TYPE [dbo].[Name] FROM nvarchar (50) NULL
GO
PRINT N'Creating [Person].[Person]'
GO
CREATE TABLE [Person].[Person]
(
[BusinessEntityID] [int] NOT NULL,
[PersonType] [nchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[NameStyle] [dbo].[NameStyle] NOT NULL CONSTRAINT [DF_Person_NameStyle] DEFAULT ((0)),
[Title] [nvarchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[FirstName] [dbo].[Name] NOT NULL,
[MiddleName] [dbo].[Name] NULL,
[LastName] [dbo].[Name] NOT NULL,
[Suffix] [nvarchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmailPromotion] [int] NOT NULL CONSTRAINT [DF_Person_EmailPromotion] DEFAULT ((0)),
[AdditionalContactInfo] [xml] (CONTENT [Person].[AdditionalContactInfoSchemaCollection]) NULL,
[Demographics] [xml] (CONTENT [Person].[IndividualSurveySchemaCollection]) NULL,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_Person_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Person_ModifiedDate] DEFAULT (getdate())
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_Person_BusinessEntityID] on [Person].[Person]'
GO
ALTER TABLE [Person].[Person] ADD CONSTRAINT [PK_Person_BusinessEntityID] PRIMARY KEY CLUSTERED  ([BusinessEntityID]) ON [PRIMARY]
GO
PRINT N'Creating index [IX_Person_LastName_FirstName_MiddleName] on [Person].[Person]'
GO
CREATE NONCLUSTERED INDEX [IX_Person_LastName_FirstName_MiddleName] ON [Person].[Person] ([LastName], [FirstName], [MiddleName]) ON [PRIMARY]
GO
PRINT N'Creating index [AK_Person_rowguid] on [Person].[Person]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_Person_rowguid] ON [Person].[Person] ([rowguid]) ON [PRIMARY]
GO
PRINT N'Creating index [PXML_Person_AddContact] on [Person].[Person]'
GO
CREATE PRIMARY XML INDEX [PXML_Person_AddContact]
ON [Person].[Person] ([AdditionalContactInfo])
GO
PRINT N'Creating index [PXML_Person_Demographics] on [Person].[Person]'
GO
CREATE PRIMARY XML INDEX [PXML_Person_Demographics]
ON [Person].[Person] ([Demographics])
GO
PRINT N'Creating index [XMLPATH_Person_Demographics] on [Person].[Person]'
GO
CREATE XML INDEX [XMLPATH_Person_Demographics]
ON [Person].[Person] ([Demographics])
USING XML INDEX [PXML_Person_Demographics]
FOR PATH
GO
PRINT N'Creating index [XMLPROPERTY_Person_Demographics] on [Person].[Person]'
GO
CREATE XML INDEX [XMLPROPERTY_Person_Demographics]
ON [Person].[Person] ([Demographics])
USING XML INDEX [PXML_Person_Demographics]
FOR PROPERTY
GO
PRINT N'Creating index [XMLVALUE_Person_Demographics] on [Person].[Person]'
GO
CREATE XML INDEX [XMLVALUE_Person_Demographics]
ON [Person].[Person] ([Demographics])
USING XML INDEX [PXML_Person_Demographics]
FOR VALUE
GO
PRINT N'Creating trigger [Person].[iuPerson] on [Person].[Person]'
GO

CREATE TRIGGER [Person].[iuPerson] ON [Person].[Person] 
AFTER INSERT, UPDATE NOT FOR REPLICATION AS 
BEGIN
    DECLARE @Count int;

    SET @Count = @@ROWCOUNT;
    IF @Count = 0 
        RETURN;

    SET NOCOUNT ON;

    IF UPDATE([BusinessEntityID]) OR UPDATE([Demographics]) 
    BEGIN
        UPDATE [Person].[Person] 
        SET [Person].[Person].[Demographics] = N'<IndividualSurvey xmlns="http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"> 
            <TotalPurchaseYTD>0.00</TotalPurchaseYTD> 
            </IndividualSurvey>' 
        FROM inserted 
        WHERE [Person].[Person].[BusinessEntityID] = inserted.[BusinessEntityID] 
            AND inserted.[Demographics] IS NULL;
        
        UPDATE [Person].[Person] 
        SET [Demographics].modify(N'declare default element namespace "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
            insert <TotalPurchaseYTD>0.00</TotalPurchaseYTD> 
            as first 
            into (/IndividualSurvey)[1]') 
        FROM inserted 
        WHERE [Person].[Person].[BusinessEntityID] = inserted.[BusinessEntityID] 
            AND inserted.[Demographics] IS NOT NULL 
            AND inserted.[Demographics].exist(N'declare default element namespace 
                "http://schemas.microsoft.com/sqlserver/2004/07/adventure-works/IndividualSurvey"; 
                /IndividualSurvey/TotalPurchaseYTD') <> 1;
    END;
END;
GO
PRINT N'Creating [Person].[BusinessEntity]'
GO
CREATE TABLE [Person].[BusinessEntity]
(
[BusinessEntityID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[rowguid] [uniqueidentifier] NOT NULL ROWGUIDCOL CONSTRAINT [DF_BusinessEntity_rowguid] DEFAULT (newid()),
[ModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_BusinessEntity_ModifiedDate] DEFAULT (getdate())
) ON [PRIMARY]
GO
PRINT N'Creating primary key [PK_BusinessEntity_BusinessEntityID] on [Person].[BusinessEntity]'
GO
ALTER TABLE [Person].[BusinessEntity] ADD CONSTRAINT [PK_BusinessEntity_BusinessEntityID] PRIMARY KEY CLUSTERED  ([BusinessEntityID]) ON [PRIMARY]
GO
PRINT N'Creating index [AK_BusinessEntity_rowguid] on [Person].[BusinessEntity]'
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_BusinessEntity_rowguid] ON [Person].[BusinessEntity] ([rowguid]) ON [PRIMARY]
GO
PRINT N'Adding constraints to [Person].[Person]'
GO
ALTER TABLE [Person].[Person] ADD CONSTRAINT [CK_Person_PersonType] CHECK (([PersonType] IS NULL OR upper([PersonType])='GC' OR upper([PersonType])='SP' OR upper([PersonType])='EM' OR upper([PersonType])='IN' OR upper([PersonType])='VC' OR upper([PersonType])='SC'))
GO
ALTER TABLE [Person].[Person] ADD CONSTRAINT [CK_Person_EmailPromotion] CHECK (([EmailPromotion]>=(0) AND [EmailPromotion]<=(2)))
GO
PRINT N'Adding foreign keys to [Person].[Person]'
GO
ALTER TABLE [Person].[Person] ADD CONSTRAINT [FK_Person_BusinessEntity_BusinessEntityID] FOREIGN KEY ([BusinessEntityID]) REFERENCES [Person].[BusinessEntity] ([BusinessEntityID])
GO
PRINT N'Creating extended properties'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Source of the ID that connects vendors, customers, and employees with address and contact information.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for all customers, vendors, and employees.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'COLUMN', N'BusinessEntityID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'CONSTRAINT', N'DF_BusinessEntity_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'CONSTRAINT', N'DF_BusinessEntity_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'CONSTRAINT', N'PK_BusinessEntity_BusinessEntityID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'INDEX', N'AK_BusinessEntity_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'BusinessEntity', 'INDEX', N'PK_BusinessEntity_BusinessEntityID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Human beings involved with AdventureWorks: employees, customer contacts, and vendor contacts.', 'SCHEMA', N'Person', 'TABLE', N'Person', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Additional contact information about the person stored in xml format. ', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'AdditionalContactInfo'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key for Person records.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'BusinessEntityID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Personal information such as hobbies, and income collected from online shoppers. Used for sales analysis.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'Demographics'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = Contact does not wish to receive e-mail promotions, 1 = Contact does wish to receive e-mail promotions from AdventureWorks, 2 = Contact does wish to receive e-mail promotions from AdventureWorks and selected partners. ', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'EmailPromotion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'First name of the person.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'FirstName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Last name of the person.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'LastName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Middle name or middle initial of the person.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'MiddleName'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Date and time the record was last updated.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'0 = The data in FirstName and LastName are stored in western style (first name, last name) order.  1 = Eastern style (last name, first name) order.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'NameStyle'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary type of person: SC = Store Contact, IN = Individual (retail) customer, SP = Sales person, EM = Employee (non-sales), VC = Vendor contact, GC = General contact', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'PersonType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'ROWGUIDCOL number uniquely identifying the record. Used to support a merge replication sample.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Surname suffix. For example, Sr. or Jr.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'Suffix'
GO
EXEC sp_addextendedproperty N'MS_Description', N'A courtesy title. For example, Mr. or Ms.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'COLUMN', N'Title'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [EmailPromotion] >= (0) AND [EmailPromotion] <= (2)', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'CK_Person_EmailPromotion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Check constraint [PersonType] is one of SC, VC, IN, EM or SP.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'CK_Person_PersonType'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_EmailPromotion'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of GETDATE()', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_ModifiedDate'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of 0', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_NameStyle'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Default constraint value of NEWID()', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'DF_Person_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Foreign key constraint referencing BusinessEntity.BusinessEntityID.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'FK_Person_BusinessEntity_BusinessEntityID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary key (clustered) constraint', 'SCHEMA', N'Person', 'TABLE', N'Person', 'CONSTRAINT', N'PK_Person_BusinessEntityID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Unique nonclustered index. Used to support replication samples.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'AK_Person_rowguid'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Clustered index created by a primary key constraint.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'PK_Person_BusinessEntityID'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'PXML_Person_AddContact'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Primary XML index.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'PXML_Person_Demographics'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary XML index for path.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'XMLPATH_Person_Demographics'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary XML index for property.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'XMLPROPERTY_Person_Demographics'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Secondary XML index for value.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'INDEX', N'XMLVALUE_Person_Demographics'
GO
EXEC sp_addextendedproperty N'MS_Description', N'AFTER INSERT, UPDATE trigger inserting Individual only if the Customer does not exist in the Store table and setting the ModifiedDate column in the Person table to the current date.', 'SCHEMA', N'Person', 'TABLE', N'Person', 'TRIGGER', N'iuPerson'
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the AdditionalContactInfo column in the Person.Contact table.', 'SCHEMA', N'Person', 'XML SCHEMA COLLECTION', N'AdditionalContactInfoSchemaCollection', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Collection of XML schemas for the Demographics column in the Person.Person table.', 'SCHEMA', N'Person', 'XML SCHEMA COLLECTION', N'IndividualSurveySchemaCollection', NULL, NULL
GO
EXEC sp_addextendedproperty N'MS_Description', N'Contains objects related to names and addresses of customers, vendors, and employees', 'SCHEMA', N'Person', NULL, NULL, NULL, NULL
GO

