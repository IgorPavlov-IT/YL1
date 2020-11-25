page 60011 "Course Card"
{
    Caption = 'Course card', Comment = 'et-EE=Koolituste kaart';
    PageType = Card;
    SourceTable = Courses;           // Viiteks on endiselt ikkagi TABEL, kust tulevad andmed, mitte list. 
                                     // Lihtsuse mõttes ma "praegu" kasutasin Employee asemel oma loodud Participants tabeli, kus on loodud
                                     // mitu-mitmele seosed vastavalt kursuste ja töötajate vahel. 
                                     // Tahan veenduda, et peale sidumise muu loogika töötas.




    layout
    {

        area(Content)
        {



            group(Info)
            {
                Caption = 'Info', Comment = 'et-EE=Info';


                field("Course Nr."; "Course Nr.")
                {
                    ApplicationArea = All;
                }
                field("Name"; "Name")
                {

                    ApplicationArea = All;
                }
                field(DescriptionBLOB; DescriptionBLOB2)
                {
                    ApplicationArea = All;
                    MultiLine = true;
                    Caption = 'Description', Comment = 'et-EE=Kirjeldus';
                    trigger OnValidate()
                    begin
                        SetActivityDescription(DescriptionBLOB2);
                    end;

                }

                field("Price"; "Price")
                {

                    ApplicationArea = All;
                }
            }
            group(Details)
            {
                Caption = 'Details', Comment = 'et-EE=Lisa info';
                field("Participants"; "Participants")
                {
                    ApplicationArea = All;
                }
            }
            group("Participant info")
            {

                Caption = 'Participant info', Comment = 'et-EE=Osaleja Info';
                part("Course ParticipantsCardPart"; "CourseParticipantsCard")

                {

                    ApplicationArea = All;
                    SubPageLink = "Course Nr." = field("Course Nr.");

                }
            }

        }
        area(FactBoxes)
        {
            part(FactBoxEmployee; FactBoxEmployee)
            {
                Provider = "Course ParticipantsCardPart";
                ApplicationArea = All;
                SubPageLink = "No." = field("Employee Nr.");        //subPageView kasutame harva 
            }

        }
    }
    trigger OnAfterGetRecord()          // Erinevus selle ja OnAfteRGetCurrRecord vahel 
    begin
        GetActivityDescription(DescriptionBLOB2);
        CostPerParticipant();
    end;

    var
        DescriptionBLOB2: text;

}