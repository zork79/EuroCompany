namespace EuroCompany.BaseApp.Inventory.Tracking;

using Microsoft.Inventory.Tracking;

tableextension 80033 "Tracking Specification" extends "Tracking Specification"
{
    fields
    {
        field(50000; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
            Editable = false;
        }
        field(50001; "ecCreation Process"; Enum "ecLot Creation Process")
        {
            Caption = 'Creation process';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_008';
            Editable = false;
        }
    }
}
