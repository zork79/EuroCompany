namespace EuroCompany.BaseApp.UserExperience.RoleCenters;
using EuroCompany.BaseApp.Inventory.Item;
using EuroCompany.BaseApp.Restrictions.Rules;
using EuroCompany.BaseApp.Setup;

page 50048 "ecCustom Features RoleCenter"
{
    ApplicationArea = All;
    Caption = 'Custom Features';
    PageType = RoleCenter;
    UsageCategory = None;

    layout
    {
        area(rolecenter)
        {
        }
    }

    actions
    {
        area(Sections)
        {
            group(Production)
            {
                Caption = 'Production';

                action(RestrictionRules)
                {
                    Caption = 'Restriction Rules';
                    Description = 'CS_PRO_011';
                    RunObject = page "ecRestriction Rules";
                }
                action(Commercial_ProductiveRestrictions)
                {
                    Caption = 'Commercial and Productive Restrictions';
                    Description = 'CS_PRO_011';
                    RunObject = page "ecRestriction Rules";
                }
            }

            group(Setup)
            {
                action(GeneralSetup)
                {
                    Caption = 'Custom features setup';
                    RunObject = page "ecGeneral Setup";
                }
            }
        }
    }
}
