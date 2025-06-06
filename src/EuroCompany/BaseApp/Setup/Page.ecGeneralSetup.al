namespace EuroCompany.BaseApp.Setup;

page 50000 "ecGeneral Setup"
{
    AdditionalSearchTerms = 'EC Setup,Eurocompany Setup,Custom Setup', Locked = true;
    ApplicationArea = All;
    Caption = 'Custom features setup';
    PageType = Card;
    SourceTable = "ecGeneral Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Administration)
            {
                Caption = 'Administration';

                field("Bio Dimension Code"; Rec."Bio Dimension Code")
                {
                    Description = 'GAP_VEN_002';
                }
            }
            group(Production)
            {
                Caption = 'Production';

                field("Cons. Correction Reason Code"; Rec."Cons. Correction Reason Code")
                {
                    Description = 'CS_PRO_050';
                }
                field("Pick On Reserved Bin"; Rec."Pick On Reserved Bin")
                {
                    Description = 'CS_PRO_018';
                }
                group(TimeCheck)
                {
                    Caption = 'Time check';

                    field("Check Setup Time"; Rec."Check Setup Time")
                    {
                        Caption = 'Check setup time';
                        Description = 'CS_PRO_039';
                    }
                    field("Min. Time Control Type"; Rec."Min. Time Control Type")
                    {
                        Caption = 'Run time control type';
                        Description = 'CS_PRO_039';
                    }
                    field("Run Time Tolerance %"; Rec."Min. Time Tolerance %")
                    {
                        Caption = 'Run time tolerance %';
                        Description = 'CS_PRO_039';
                    }

                }
                group(ConsumptionCheck)
                {
                    Caption = 'Cosumption check';

                    field("Min. Consumption Control Type"; Rec."Min. Consumption Control Type")
                    {
                        Caption = 'Consumption control type';
                        Description = 'CS_PRO_039';
                    }
                    field("Consumption Tolerance %"; Rec."Min. Consumption Tolerance %")
                    {
                        Caption = 'Consumption tolerance %';
                        Description = 'CS_PRO_039';
                    }
                }
            }
            group(Finance)
            {
                Caption = 'Finance';
                field("Use Custom Calc. Due Date"; Rec."Use Custom Calc. Due Date")
                {
                    trigger OnValidate()
                    begin
                        if Rec."Use Custom Calc. Due Date" then
                            UseDocDateDefaultEditable := true;

                        if not Rec."Use Custom Calc. Due Date" then begin
                            Rec."Use Document Date As Default" := false;
                            UseDocDateDefaultEditable := false;
                        end;

                        CurrPage.Update();
                    end;
                }
                field("Use Document Date As Default"; Rec."Use Document Date As Default")
                {
                    Editable = UseDocDateDefaultEditable;
                }
                group(Selex)
                {
                    Caption = 'Selex Export';
                    field("Internal Code"; Rec."Internal Code")
                    {
                    }
                    field("Business Segment Selex"; Rec."Business Segment Selex")
                    {
                    }
                    field("Product Segment Selex"; Rec."Product Segment Selex")
                    {
                    }
                    group(SelexUOMManagement)
                    {
                        Caption = 'Selex UoM Management';
                        field("UoM To Convert"; Rec."UoM To Convert")
                        {
                        }
                        field("Allowed UoM KG"; Rec."Allowed UoM KG")
                        {
                        }
                        field("Allowed UoM LT"; Rec."Allowed UoM LT")
                        {
                        }
                        field("Allowed UoM PZ"; Rec."Allowed UoM CONF")
                        {
                        }
                    }
                }
                group(Intrastat)
                {
                    Caption = 'Intrastat';
                    field("Enable Item Tracing Intrastat"; Rec."Enable Item Tracing Intrastat")
                    {
                    }
                }
                // group(CustomDeclaration)
                // {
                //     Caption = 'Custom declaration';

                //     field("Enable Customs Declarations"; Rec."Enable Customs Declarations")
                //     {
                //         ApplicationArea = All;

                //         trigger OnValidate()
                //         begin
                //             EditableCustDecl := false;

                //             if Rec."Enable Customs Declarations" then
                //                 EditableCustDecl := true;

                //             CurrPage.Update();
                //         end;
                //     }
                //     field("No. Series Cust. Declaration"; Rec."No. Series Cust. Declaration")
                //     {
                //         ApplicationArea = All;
                //         Editable = EditableCustDecl;
                //     }
                // }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';

                group(PalletMgt)
                {
                    Caption = 'Pallet management';

                    field("Journal Template Name"; Rec."Journal Template Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Journal Batch Name"; Rec."Journal Batch Name")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(CPR)
            {
                Caption = 'CPR', Locked = true;

                field("CPR Counterparty Code"; Rec."CPR Counterparty Code")
                {
                    ApplicationArea = All;
                }
                field("CPR Download CSV Path"; Rec."CPR Download CSV Path")
                {
                    ApplicationArea = All;
                }
                field("CPR Pallets Identif. Code"; Rec."CPR Pallets Identif. Code")
                {
                    ApplicationArea = All;
                }
            }
            #region 306
            group(EDI)
            {
                Caption = 'EDI', Locked = true;

                field("ecPrice Diff. Tolerance %"; Rec."ecPrice Diff. Tolerance %")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Difference Tolerance % field.';
                }
            }
            #endregion 306
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        // EditableCustDecl := false;

        // if Rec."Enable Customs Declarations" then
        //     EditableCustDecl := true;

        // CurrPage.Update();
    end;


    var
        UseDocDateDefaultEditable: Boolean;
    // EditableCustDecl: Boolean;
}
