page 60105 "CourseParticipantsCard"
{

    Caption = 'Course ParticipantsCard';
    PageType = ListPart;
    SourceTable = CourseParticipants;
    ModifyAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Course Nr."; Rec."Course Nr.")
                {
                    ApplicationArea = All;
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    ApplicationArea = All;
                }
                field("Employee Nr."; Rec."Employee Nr.")
                {
                    ApplicationArea = All;
                }
                field("Employee firstname"; Rec."Employee firstname")
                {
                    ApplicationArea = All;
                }
                field("Employee lastname"; Rec."Employee lastname")
                {
                    ApplicationArea = All;
                }
                field("Employee training cost"; "Employee training cost")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    var
        CoursesVariable: Record Courses;                            // Kas see Triggeri alla või eraldi siia (Global'iks)
        CoursesParticVariable: Record CourseParticipants;



    trigger OnAfterGetRecord()

    begin
        if CoursesVariable.get("Course Nr.") then begin             // Miks?! Kui ma lisan "Course Nr." asemel CoursesParticVariable."Course Nr." 
            CoursesVariable.CalcFields(Participants);
            "Employee training cost" := CoursesVariable.Price / CoursesVariable.Participants        // Miks?! Kui lisan CoursesParticVariable."Employee training cost" siis BC arvutab 0-i?

            // Modify siia kuidagi või?
        end
    end;
    // CoursesVariable.Modify(false); 

}
