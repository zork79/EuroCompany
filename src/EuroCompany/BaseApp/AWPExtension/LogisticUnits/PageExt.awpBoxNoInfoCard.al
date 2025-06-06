namespace EuroCompany.BaseApp.AWPExtension.LogisticUnits;

pageextension 80138 "awpBox No. Info Card" extends "AltAWPBox No. Info Card"
{
    layout
    {
        addbefore(Log)
        {
            group(CustomAttributes)
            {
                Caption = 'Custom attributes';
                Description = 'CS_ACQ_013';

                field("ecNo. Of Parcels"; Rec."ecNo. Of Parcels")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                    Editable = false;
                }
                field("ecUnit Weight"; Rec."ecUnit Weight")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                    Editable = false;
                }
                field("ecTotal Weight"; Rec."ecTotal Weight")
                {
                    ApplicationArea = All;
                    Description = 'CS_ACQ_013';
                    Editable = false;
                }
            }
        }
    }
}
