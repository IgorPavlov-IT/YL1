table 60000 CourseParticipants
{

    Caption = 'Course Participants', Comment = 'et-EE=Koolitusel osalejad';

    // Info:
    // Nagu all näha on fieldide numbrid 1,2,3,4,8... Numbrite väljade nummerdamisel võib olla harilik jätta lüngad, mis võimaldab hiljem vahele asju lisada
    // ilma vajaduseta muuta kõikide väljade nummerdamist. Selle näite puhul tuli see kasuks, kuna Employee tabelis on Eesnimi ja Perekonnanimi eraldi lahtrites.
    // Kuna tabelite põhjal on loodud SQL andmebaasid ja SQL on pirtsakas, võib esineda probleeme või raskusi, kui on proovitud "olemasoleva" tabeli andmeid või nimesid muuta.
    // 


    // Küsimused:
    // Kui minul on vaja võrrelda/vaadata mingit tabelit või andmeid, näiteks see-sama "Employee" tabel, kuidas seda kõige kiiremini teha?
    // Mida annab ValidateTableRelation = true; Valideerib, et tabelite kanded on vastavuses? Või vastavuse olemasolul teeb mingi järgneva rehkenduse (näiteks võtab vastava töötaja nime?)
    // Mida annab trigger onValidate? 
    // FindSet()   // Millal/Kus ma seda saan kasutada? 
    // Millal kasutatakse FlowFilterit või mis on näited?
    // 

    fields
    {
        field(1; "Course Nr."; Code[8])
        {
            Caption = 'Course Nr.', Comment = 'et-EE=Koolituse Nr.';
            NotBlank = true;        // Soovituslik, kuid mitte nõutud PK tabelitel
            TableRelation = Courses."Course Nr.";
            // Tabelisuhe "Courses" tabelis "Course Nr." lahtriga.  

        }
        field(2; "Employee Nr."; Code[20])
        {

            Caption = 'Employee Nr.', Comment = 'et-EE=Töötaja Nr.';
            Editable = true;
            TableRelation = Employee."No.";
            // Tabelisuhe "Employee" tabelis "No." lahtriga. 
            ValidateTableRelation = true;
            trigger OnValidate()                // See blokk on arusaamatu selle vajalikuse ja otstarbe kohta. 
            begin
                CalcFields("Employee firstname");    // Sammuti, milleks meie Arvutame? Töötaja nime? 
                CalcFields("Employee lastname")
            end;

        }
        field(3; "Employee firstname"; Text[50])
        {

            Caption = 'Employee firstname', Comment = 'et-EE=Töötaja eesnimi';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."First Name" WHERE("No." = field("Employee Nr.")));
            // ANSWER: Cannot lookup several at once! 
        }


        field(4; "Employee lastname"; Text[50])
        {

            Caption = 'Employee surname', Comment = 'et-EE=Töötaja perekonna nimi';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Last Name" WHERE("No." = field("Employee Nr.")));
            // ANSWER: Cannot lookup several at once! 
        }
        field(5; "Position"; Text[50])
        {
            Caption = 'Employee job position', Comment = 'et-EE=Töötaja ametinimetus';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee."Job Title" WHERE("No." = field("Employee Nr.")));
        }

        field(6; "Status"; Option)
        {
            Caption = 'Employee Status', Comment = 'et-EE=Töötaja staatus';
            Editable = false;
            OptionCaption = 'Active,Inactive,Terminated';
            OptionMembers = Active,Inactive,Terminated;
            FieldClass = FlowField;
            CalcFormula = lookup(Employee.Status WHERE("No." = field("Employee Nr.")));
        }

        field(8; "Dimension Set ID"; Integer)     // This is a "Dimension SET ID", kas vaja?
        {

            Caption = 'Dimension Set ID', Comment = 'et-EE=Dimensioonide kompl ID';


        }
        field(9; "Employee training cost"; Decimal)
        {
            Caption = 'Employee training cost', Comment = 'et-EE=Töötaja koolituskulu';
            Editable = true;
            FieldClass = FlowField;         // Could be optional 
            CalcFormula = lookup(Courses."Training cost per Employee" WHERE("Course Nr." = field("Course Nr.")));
        }

    }

    keys
    {
        key(PK; "Course Nr.", "Employee Nr.")
        {
            Clustered = true;
        }
    }

}