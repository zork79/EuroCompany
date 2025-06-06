namespace EuroCompany.BaseApp.Manufacturing.Planning;

using Microsoft.Manufacturing.Planning;

reportextension 80009 "Calculate Plan - Plan. Wksh." extends "Calculate Plan - Plan. Wksh."
{
    dataset
    {
        modify(Item)
        {
            trigger OnBeforePreDataItem()
            begin
                //EC365-s
                StartingDateTime := CurrentDateTime;
                //EC365-e
            end;

            trigger OnBeforePostDataItem()
            begin
                //EC365-s
                EndingDateTime := CurrentDateTime;
                //EC365-e
            end;

            trigger OnAfterPostDataItem()
            begin
                //EC365-s
                DurationTime := EndingDateTime - StartingDateTime;
                Message(lDurationMsg, Format(StartingDateTime), Format(EndingDateTime), Format(DurationTime));
                //EC365-e
            end;
        }
    }

    var
        StartingDateTime: DateTime;
        EndingDateTime: DateTime;
        DurationTime: Duration;

        lDurationMsg: Label 'Processing times summary\ \Operation started on: %1\Operation ended on: %2\Operation completed in: %3';
}
