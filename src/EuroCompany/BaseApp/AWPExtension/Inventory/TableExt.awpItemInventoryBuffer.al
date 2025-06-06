namespace EuroCompany.BaseApp.AWPExtension.Inventory;
using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Restrictions;
using Microsoft.Inventory.Item;

tableextension 80057 "awpItem Inventory Buffer" extends "AltAWPItem Inventory Buffer"
{
    fields
    {
        field(50000; "ecItem Type"; Enum "ecItem Type")
        {
            CalcFormula = lookup(Item."ecItem Type" where("No." = field("Item No.")));
            Caption = 'Item Type';
            Description = 'CS_PRO_043';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50001; "ecRestrictions Check Result"; Enum "ecRestrictions Check Result")
        {
            Caption = 'Restrictions Check Result';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_011';
            Editable = false;
        }
        field(50002; ecRestrictions; Text[100])
        {
            Caption = 'Restrictions';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_011';
            Editable = false;
        }
        field(50005; "ecMax Usable Date"; Date)
        {
            Caption = 'Max Usable Date';
            DataClassification = CustomerContent;
            Description = 'CS_PRO_018';
            Editable = false;
        }
    }
}
