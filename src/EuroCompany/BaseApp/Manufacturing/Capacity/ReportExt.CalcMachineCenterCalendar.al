namespace EuroCompany.BaseApp.Manufacturing.Capacity;

using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.MachineCenter;
using Microsoft.Manufacturing.WorkCenter;

reportextension 80003 "Calc. Machine Center Calendar" extends "Calc. Machine Center Calendar"
{
    dataset
    {
        modify("Machine Center")
        {
            trigger OnBeforeAfterGetRecord()
            var
                lWorkCenter: Record "Work Center";
                lSessionDataStore: Codeunit "AltATSSession Data Store";
            begin
                //CS_PRO_018-s
                lWorkCenter.Get("Work Center No.");
                lSessionDataStore.AddSessionSetting('CalcScheduleCapacityType', "Capacity Type"::"Machine Center");
                lSessionDataStore.AddSessionSetting('CalcScheduleNo', "No.");
                lSessionDataStore.AddSessionSetting('CalcScheduleWorkCenterNo', "Work Center No.");
                lSessionDataStore.AddSessionSetting('DefaultWorkCenterCalendar', lWorkCenter."Shop Calendar Code");
                //CS_PRO_018-e
            end;

            trigger OnAfterAfterGetRecord()
            var
                lSessionDataStore: Codeunit "AltATSSession Data Store";
            begin
                //CS_PRO_018-s
                lSessionDataStore.RemoveSessionSetting('CalcScheduleCapacityType');
                lSessionDataStore.RemoveSessionSetting('CalcScheduleNo');
                lSessionDataStore.RemoveSessionSetting('CalcScheduleWorkCenterNo');
                lSessionDataStore.RemoveSessionSetting('DefaultWorkCenterCalendar');
                //CS_PRO_018-e
            end;
        }
    }
}
