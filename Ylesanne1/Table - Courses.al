table 60200 Courses
{

    Caption = 'Courses', Comment = 'et-EE=Koolitused';
    // LookupPageId = "Course List"; - ANSWER: See on Dropdown menu kasutuse jaoks 
    // DataClassification = ToBeClassified; - ANSWER - data classification, but in Itera not used.
    // Kas nimetused teha kohe inglisekeeles ja tõlgime kommentiga - ANSWER : Jah, kogu arendus on alati täiesti Inglisekeelne.
    // Tabel on kõige aluseks, selle sees hoiame meie andmeid. Sellest kuvame välja andmeid erinevatel viisidel (muuhulgas Listina)
    // List on page'i üks liik või alam liik, samamoodi nagu kaart või Document vms. Listi andmete allikaks on alati tabel.
    // Kui listis on mõned lahtrid muust tabelist siis need toome eraldi välja viitega. 
    // Card lehed on enamjaolt seotud listiga ning tavaliselt kõik muudatused tehakse kaartidel, mis kajastub listis ning list 
    // annab ülevaate ning üldiselt on muutumatu. 
    // Millal kasutame "CodeUnit"it? - ANSWER : Kui vaja tihti või rohkem kui 1s kohas kasutada. 
    // DataClassification = ToBeClassified;  - meie Iteras ei kasuta ja käsitleme seda funktsionaalsust rollidega.
    // AL - keel ei ole "Case-Sensitive" SeEgA vÕiB kirJuTada vÄGa eriNeVa SuUr/vÄiKe alGuS täHegA. Oluline, et on loetav, seega Camel-case on hea mõte.
    // ApplicationArea = All on vaja sisuliselt korduvalt igale poole kirjutada. 

    // AdditionalSearchTerms = 'courses', 'koolitus', 'koolitused';   Search --- ? Millele lisatakse, millal? 
    // Mida täpsemalt teeb"To assign a closing date to a variable, use the CLOSINGDATE Function (Date)." funktsioon, kas/millal kasutame?
    // Kuidas lisada igale reale suffiks € (lõppu euro märk) või midagi muud? - Part-ANSWER : Tavaliselt meie ei kuva/näita rahaühikuid lahtrites.
    // Mis "väärtused" on tüüpiliselt default väljadele? "Editable" ""
    // FlowField , FlowFilter, mis on need, millal ja milleks kasutame. 


    //CalcFormula = Exist("Comment Line" WHERE("Table Name" = CONST(Job),
    //                                          "No." = FIELD("No.")));
    //ANSWER: answer is in boolean = true/false not good for counting or other mathematical oprations, good for "IF-statements"


    fields
    {
        field(1; "Course Nr."; Code[8])
        {

            Caption = 'Course Nr.', Comment = 'et-EE=Koolituse Nr.';
            NotBlank = true;    // - not needed.



        }
        field(2; "Name"; Text[80])
        {

            Caption = 'Name', Comment = 'et-EE=Nimetus';

        }
        field(3; "Description"; Text[200])
        {

            Caption = 'Description', Comment = 'et-EE=Kirjeldus';

        }

        field(4; "Location"; Text[50])
        {

            Caption = 'Location', Comment = 'et-EE=Asukoht';

        }
        field(5; "Date from"; Date)    // Date on põhiline kuupäeva formaat ning DateFormat on arvutuste jaoks vajalik formaat. 
        {

            Caption = 'Date from', Comment = 'et-EE=Algus';

        }
        field(6; "Date to"; Date)
        {

            Caption = 'Date to', Comment = 'et-EE=Lõpp';

        }
        field(7; "Price"; Decimal)

        {

            Caption = 'Price', Comment = 'et-EE=Hind';

        }

        field(8; "Participants"; Integer)
        {

            Caption = 'Participants', Comment = 'et-EE=Osalejaid';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = count("CourseParticipants" WHERE("Course Nr." = FIELD("Course Nr.")));
            // Count in Table/File/List CourseParticipants WHERE "Course Nr" (in that file) corresponds to this file FIELD "Course Nr"
            // ANSWER : Other functions can be FIELD, FILTER, CONST. CONSTR or FIELD are most commonly used.  

        }

        field(9; "Dimension Set ID"; Integer)     // This is a "Dimension SET ID"
        {

            Caption = 'Dimension Set ID', Comment = 'et-EE=Dimensioonide kompl ID';
            Editable = false;

        }

        field(11; "Maximum participants"; Integer)
        {
            Caption = 'Maximum participants', Comment = 'et-EE=Maks osalejate arv';    // 
            Editable = true;
            InitValue = 10;                 // Esialgne/"Default" väärtus kõigil nendel lahtritel. 
        }

        field(12; "Involvement"; Decimal)
        {
            Caption = 'Involvement', Comment = 'et-EE=Kaasatuse %';
            DecimalPlaces = 0 : 5;
            Editable = false;
            MaxValue = 100;
            MinValue = 0;


        }
        field(13; "DescriptionBLOB"; BLOB)
        {
            Caption = 'Description', Comment = 'et-EE=Kirjeldus';

        }
        field(14; "Training cost per Employee"; Decimal)
        {

            Caption = 'Training cost per participant', Comment = 'et-EE=Koolituskulud ühe töötaja kohta';
            Editable = false;
            DecimalPlaces = 0 : 5;

        }

    }

    keys
    {
        key(PK; "Course Nr.")
        {
            Clustered = true;
        }
    }

    procedure ParticipationPercentageCalc()
    begin
        CalcFields(Participants);           // See command tagab selle, et meie arvutame kindlasti Participantsi väärtuse välja enne, kui seda kasutame järnevas valemis.
        Involvement := ("Participants" * 100) / ("Maximum Participants");
        // ANSWER : Vaja lisada if condition, muidu jagame 0'ga kui max participants on 0 või täitmata. Või Max participants peab omama "InitValue".
    end;

    procedure CostPerParticipant()
    begin
        CalcFields(Participants);
        if rec.Participants = 0 then begin
            "Training cost per Employee" := 0;
        end
        else begin
            "Training cost per Employee" := rec.Price / rec.Participants;
        end;
    end;

    procedure SetActivityDescription(NewActivityDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("DescriptionBLOB");
        "DescriptionBLOB".CreateOutStream(OutStream);
        OutStream.WriteText(NewActivityDescription);
        Modify;
    end;

    procedure GetActivityDescription(var ExistingActivityDescription: Text)
    var
        InStream: InStream;
    begin
        CalcFields("DescriptionBLOB");
        if DescriptionBLOB.HasValue() then begin
            DescriptionBLOB.CreateInStream(InStream);
            InStream.ReadText(ExistingActivityDescription);
        end else
            ExistingActivityDescription := 'No value on the BLOB field';
        "DescriptionBLOB".CreateInStream(InStream);
    end;

}