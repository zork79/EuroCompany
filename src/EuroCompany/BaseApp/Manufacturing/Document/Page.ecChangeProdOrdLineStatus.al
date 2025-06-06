namespace EuroCompany.BaseApp.Manufacturing.Document;
using Microsoft.Manufacturing.Document;

page 50042 "ecChange Prod.Ord. Line Status"
{
    ApplicationArea = All;
    Caption = 'Change Prod.Ord. Line Status';
    DeleteAllowed = false;
    Description = 'CS_PRO_039';
    InsertAllowed = false;
    InstructionalText = 'Select new productive status';
    ModifyAllowed = false;
    PageType = ConfirmationDialog;

    layout
    {
        area(Content)
        {
            field(ProdOrderLineStatus; ProdOrderLineStatus."ecProductive Status")
            {
                Caption = 'New status';
                ValuesAllowed = Released, Scheduled, Activated, Suspended, Completed;
            }
        }
    }

    var
        ProdOrderLineStatus: Record "Prod. Order Line";

    procedure SetProdOrderLineStatus(pProdOrderLine: Record "Prod. Order Line")
    begin
        //if pProdOrderLine."ecProductive Status" = pProdOrderLine."ecProductive Status"::Completed then
        //    pProdOrderLine.FieldError("ecProductive Status");

        ProdOrderLineStatus."ecProductive Status" := pProdOrderLine."ecProductive Status";
    end;

    procedure GetNewStatus(): Enum "ecProductive Status"
    begin
        exit(ProdOrderLineStatus."ecProductive Status");
    end;
}
