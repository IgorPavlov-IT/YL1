pageextension 50100 "Exmployee Card Courses Info" extends "Employee Card"
{

    layout
    {


        addlast(General)
        {

            field("Course Cost"; "Course Cost")
            {
                ApplicationArea = All;


            }

            // field("TotalExpenses"; Integer)                    // Siin peaks teoorias lisama lhatri kuhu arvutama koolituse kulud.
            // {
            //     ApplicationArea = All
            //     FieldClass = Flowfield;
            //     CalcFormula = sum (CourseParticipants."Employee training cost" where (Employee Nr.= Employee."No."));
            //     Editable = false;
            // }            

            // field("Employee training costs"; )

            // {
            //     ApplicationArea = All;

            //     Editable = false;
            //     FieldClass = FlowField;
            //     CalcFormula = sum(Courses."Training cost per Employee" WHERE(Courses."Course Nr." = field("Course Nr.")));
            // }


        }
    }


    // actions
    // {
    //     addlast(Navigation)
    //     {
    //         action("Show all existing/available courses")
    //         {
    //             ApplicationArea = All;
    //             RunObject = page "Cource List";

    //         }
    //     }
    //     addlast(Navigation)
    //     // {

    //     //     action("Show taken courses")
    //     //     {
    //     //         ApplicationArea = All;

    //     //         RunObject = page "Course.ParticipantsCard";
    //     //                         RunPageLink = "Employee Nr." = field("No.");
    //     //         // SetFilter(Courses."Employee Nr" = Employee."No.");        // Mis siin valesti on?
    //     //         // Milline üldiselt on järjekord data otsimise ja filtreerimisega?

    //     //     }
    //     // }

    // }
    trigger OnAfterGetRecord()              // Kas globaalseid muutujaid on vaja dubleerida? 
    var                                     // Kuidas ma saan kätte või näen kõik globaalsed muutujad?
        CoursesVariable: Record Courses;
        CoursesParticVariable: Record CourseParticipants;
        EmployeeRec: Record Employee;
        CostSum: Decimal;
    begin
        CostSum := 0;
        if CoursesParticVariable.get(EmployeeRec."No.") then repeat until Next() = 0;     // See võiks olla kasutatav funktsioon või "loop"
        begin
            //CoursesVariable.CalcFields(Participants);                                   // alternatiivina võin panna mingi conditioni või repeateri, mis
            //CostSum += CoursesVariable.Price / CoursesVariable.Participants             // veendub selles, et kui töötaja ID ilmub mitmes kirjes, siis kõikide
            // kirjetega tehakse rehkendus.
            CostSum += CoursesParticVariable."Employee training cost"  //  <--- Alternative. (Ülemine moodus tuleb "Divide by zero")
                                                                       // Siinkohal ongi küsimus, kas ma nüüd "loop"ina
                                                                       // rehkendan kõik arvutused uuesti, või leian rea
                                                                       // tabelist (kui see töötab), kust võtan väärtuse?
        end;
        "Course Cost" := CostSum;
    end;

}