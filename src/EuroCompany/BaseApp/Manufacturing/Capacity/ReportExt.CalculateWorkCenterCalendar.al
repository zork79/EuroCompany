namespace EuroCompany.BaseApp.Manufacturing.Capacity;

using Microsoft.Manufacturing.Capacity;
using Microsoft.Manufacturing.WorkCenter;


reportextension 80001 "Calculate Work Center Calendar" extends "Calculate Work Center Calendar"
{
    dataset
    {
        modify("Work Center")
        {
            trigger OnBeforeAfterGetRecord()
            var
                lWorkCenter: Record "Work Center";
                lSessionDataStore: Codeunit "AltATSSession Data Store";
            begin
                //CS_PRO_018-s
                lWorkCenter.Get("No.");
                lSessionDataStore.AddSessionSetting('CalcScheduleCapacityType', "Capacity Type"::"Work Center");
                lSessionDataStore.AddSessionSetting('CalcScheduleNo', "No.");
                lSessionDataStore.AddSessionSetting('CalcScheduleWorkCenterNo', "No.");
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
