namespace EuroCompany.BaseApp.Finance.Dimension;

using EuroCompany.BaseApp.Setup;
using Microsoft.Finance.Dimension;

tableextension 80015 "Dimension Value" extends "Dimension Value"
{
    trigger OnBeforeRename()
    var
        lGeneralSetup: Record "ecGeneral Setup";

        lRenameBIOErr: Label 'Is not possible to rename record of Bio dimension!';
    begin
        //GAP_VEN_002-s
        if lGeneralSetup.Get() and (lGeneralSetup."Bio Dimension Code" <> '') and
           (Rec."Dimension Code" = lGeneralSetup."Bio Dimension Code")
        then begin
            Error(lRenameBIOErr);
        end;
        //GAP_VEN_002-e
    end;
}
