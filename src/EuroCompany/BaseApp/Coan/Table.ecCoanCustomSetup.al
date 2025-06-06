namespace EuroCompany.BaseApp.Coan;
using Microsoft.Finance.Dimension;

table 50048 "ecCoan Custom Setup"
{
    Caption = 'Coan Custom Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Dimension 1 code"; Code[20])
        {
            Caption = 'Dimension 1 code';
            TableRelation = Dimension.Code;
        }
        field(3; "Dimension 2 code"; Code[20])
        {
            Caption = 'Dimension 2 code';
            TableRelation = Dimension.Code;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

}