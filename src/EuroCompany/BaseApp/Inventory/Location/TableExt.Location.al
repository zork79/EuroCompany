namespace EuroCompany.BaseApp.Inventory.Location;
using Microsoft.Inventory.Location;
using Microsoft.Warehouse.Structure;

tableextension 80103 Location extends Location
{
    fields
    {
        field(50000; "ecPallets Bin Code"; Code[20])
        {
            DataClassification = CustomerContent;
            Caption = 'Pallets Bin Code';
            TableRelation = Bin.Code where("Location Code" = field(Code));
        }
    }
}