page 60202 FactBoxEmployee
{

    Caption = 'FactBoxEmployee';
    PageType = CardPart;
    SourceTable = Employee;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Full Name"; Rec."First Name" + ' ' + rec."Last Name")
                {
                    ApplicationArea = All;
                }
                group("Additional info")
                {
                    field(Status; Status)
                    {
                        ApplicationArea = All;
                    }


                    field("Job Title"; "Job Title")
                    {
                        ApplicationArea = All;
                    }
                }
            }
        }
    }
}
