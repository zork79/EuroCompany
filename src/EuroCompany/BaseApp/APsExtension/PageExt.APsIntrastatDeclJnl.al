namespace EuroCompany.BaseApp.APsExtension;
using EuroCompany.BaseApp.Setup;
using Microsoft.Inventory.Tracking;

pageextension 80131 "APsIntrastat Decl. Jnl." extends "APsIntrastat Decl. Jnl."
{
    actions
    {
        addafter(CreateFile)
        {
            #region 219
            action(CalcItemTracing)
            {
                ApplicationArea = All;
                Caption = 'Calculate item tracing';
                Image = Calculate;

                trigger OnAction()
                var
                    ConfirmCalculationLbl: Label 'Are you sure you want to calculate tracking for shipping lines?';
                    CurrentLineIsNotShippingTypeLineMsg: Label 'The current row is not a "Shipping" row!';
                begin
                    EcSetup.Get();
                    EcSetup.TestField("Enable Item Tracing Intrastat");

                    if Confirm(ConfirmCalculationLbl) then
                        if Rec.Type = Rec.Type::Shipment then
                            FindRecords()
                        else
                            Message(CurrentLineIsNotShippingTypeLineMsg);
                end;
            }
            #endregion 219
        }

        addlast(processing)
        {
            #region 379
            action(AltItemChargesAssignment)
            {
                ApplicationArea = All;
                Caption = 'Item Charges Assignment';
                Image = GetEntries;

                trigger OnAction()
                var
                    IntraDeclJnlLine: Record "APsIntrastat Decl. Jnl. Line";
                    ecApsGenericFunctions: Codeunit "ecApsGeneric Functions";
                begin
                    CurrPage.SetSelectionFilter(IntraDeclJnlLine);

                    if IntraDeclJnlLine.FindSet() then
                        repeat
                            ecApsGenericFunctions.ItemChargesAssignment(IntraDeclJnlLine);
                        until IntraDeclJnlLine.Next() = 0;

                    CurrPage.Update(false);
                end;
            }
            #endregion 379
        }
    }

    #region 219
    local procedure FindRecords()
    var
        ecApsGenericFunctions: Codeunit "ecApsGeneric Functions";
        ItemTracing: Page "Item Tracing";
        ShipmentFilter: Text;
        LotFilter: Text;
    begin
        ecApsGenericFunctions.GenerateShipmentAndLotConcatenatedFilters(Rec, ShipmentFilter, LotFilter);

        LotFilter := DelChr(LotFilter, '>', '|');

        ItemTracing.SetItemFilters(0, 1, ShipmentFilter, LotFilter, '', '');
        ItemTracing.SetShipmentNo(ShipmentFilter);

        EcSetup."Show Only Run Intrastat Page" := true;
        EcSetup.Modify();

        ItemTracing.Run();
    end;
    #endregion 219

    var
        EcSetup: Record "ecGeneral Setup";
}