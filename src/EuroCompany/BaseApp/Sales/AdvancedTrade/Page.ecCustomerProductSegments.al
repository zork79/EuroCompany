namespace EuroCompany.BaseApp.Sales.AdvancedTrade;
using EuroCompany.BaseApp.Sales;

page 50032 "ecCustomer Product Segments"
{
    ApplicationArea = All;
    Caption = 'Customer Product Segments';
    DelayedInsert = true;
    Description = 'CS_VEN_032';
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "ecCustomer Product Segments";
    SourceTableView = sorting("Customer No.", "Product Segment No.", "Starting Date") order(ascending);
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Customer No."; Rec."Customer No.")
                {
                    Visible = false;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    DrillDown = false;
                    Visible = false;
                }
                field("Product Segment No."; Rec."Product Segment No.")
                {
                }
                field("Product Segment Description"; Rec."Product Segment Description")
                {
                    DrillDown = false;
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("Sales Manager Code"; Rec."Sales Manager Code")
                {
                }
                field("Sales Manager Name"; Rec."Sales Manager Name")
                {
                    DrillDown = false;
                }
                field("Shipping Agent Code"; Rec."Shipping Agent Code")
                {
                }
                field("Shipping Agent Service Code"; Rec."Shipping Agent Service Code")
                {
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    Editable = false;
                    Visible = false;
                }
                field(SystemCreatedBy; atsSystemUtilities.GetUserNameBySecurityID(Rec.SystemCreatedBy))
                {
                    Caption = 'Created By', Comment = 'Creato da';
                    Editable = false;
                    Visible = false;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    Editable = false;
                    Visible = false;
                }
                field(SystemModifiedBy; atsSystemUtilities.GetUserNameBySecurityID(Rec.SystemModifiedBy))
                {
                    Caption = 'Modified By', Comment = 'Modificato da';
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Comments)
            {
                Caption = 'Comments';
                Image = ViewComments;

                trigger OnAction()
                var
                    lSalesFunctions: Codeunit "ecSales Functions";
                begin
                    lSalesFunctions.ShowProductSegmentComment(Rec);
                end;
            }
        }
        area(Promoted)
        {
            actionref(CommentsPromoted; Comments) { }
        }
    }

    var
        atsSystemUtilities: Codeunit "AltATSSystem Utilities";
}
