page 60001 "Cource List"                // SQL tabeli nimi oli varem Cource List, seega vb on vaja overwrite'ida, kui tahan nimetada Course List
                                        // Küsida üle kuidas ümber nimetamisega ja SQL baasi tühjendamist teha jms. 

//Siia tuleb Excel Bufferi block.

{
    Caption = 'Cource List', Comment = 'et-EE=Koolituste nimekiri';
    // AdditionalSearchTerms = 'Koolitused';
    PageType = List;
    SourceTable = "Courses";
    UsageCategory = Lists;
    ApplicationArea = All;
    CardPageId = "Course Card";
    Editable = true;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    // Viimased 3-4 on näited parameetritest, mida võib või on hea tava kasutada. Vähemalt listi puhul 

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Course Nr."; "Course Nr.")
                {
                    ApplicationArea = All;
                }

                field(Name; Name)
                {
                    ApplicationArea = All;
                }

                field("Date from"; "Date from")
                {
                    ApplicationArea = All;
                }

                field("Date to"; "Date to")
                {
                    ApplicationArea = All;
                }

                field(Participants; Participants)
                {
                    ApplicationArea = All;
                }

                field("Maximum participants"; "Maximum participants")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {

        area(Processing)
        {
            action(Import_Excel)
            {
                ApplicationArea = All;
                Caption = 'Import Excel';
                Image = ImportExcel;

                trigger OnAction()
                begin
                    ImportCoursesExcel();
                    Rec_ExcelBuffer.DeleteAll();
                end;

            }


            action(Export_Excel)
            {
                ApplicationArea = All;
                Caption = 'Export Excel';
                Image = ExportToExcel;

                trigger OnAction()
                var
                    CoursesExpBufferLine: Record "Courses";
                begin
                    Rec_Courses.Copy(Rec);
                    Currpage.SetSelectionFilter(Rec_Courses);
                    ExportCoursesBuffer();
                end;
            }
        }

    }


    var
        Rec_ExcelBuffer: Record "Excel Buffer";
        Rows: Integer;
        Columns: Integer;
        Filename: Text;
        FileMgmt: Codeunit "File Management";
        ExcelFile: File;
        Instr: InStream;
        Sheetname: Text;
        FileUploaded: Boolean;
        RowNo: Integer;
        ColNo: Integer;
        Rec_Courses: Record Courses;

    procedure ImportCoursesExcel()
    var
    begin
        Rec_ExcelBuffer.DeleteAll();
        Rows := 0;
        Columns := 0;
        FileUploaded := UploadIntoStream('Select File to Upload', '', '', Filename, Instr);

        if Filename <> '' then
            Sheetname := Rec_ExcelBuffer.SelectSheetsNameStream(Instr)
        else
            exit;


        Rec_ExcelBuffer.Reset;
        Rec_ExcelBuffer.OpenBookStream(Instr, Sheetname);
        Rec_ExcelBuffer.ReadSheet();

        Commit();
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Column No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Rows := Rows + 1;
            until Rec_ExcelBuffer.Next() = 0;
        //Message(Format(Rows));

        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.SetRange("Row No.", 1);
        if Rec_ExcelBuffer.FindFirst() then
            repeat
                Columns := Columns + 1;
            until Rec_ExcelBuffer.Next() = 0;
        //Message(Format(Columns));
        //Modify or Insert
        for RowNo := 2 to Rows do begin
            Rec_Courses.Reset();
            if Rec_Courses.Get(GetValueAtIndex(RowNo, 1)) then begin            // Cut out    , GetValueAtIndex(RowNo, 2), GetValueAtIndex(RowNo, 3)
                Evaluate(Rec_Courses.Name, GetValueAtIndex(RowNo, 2));
                Rec_Courses.Validate(Name);
                Evaluate(Rec_Courses.Description, GetValueAtIndex(RowNo, 3));
                Rec_Courses.Validate(Description);
                // Evaluate(Rec_Courses."Date from", GetValueAtIndex(RowNo, 4));
                Evaluate(Rec_Courses."Date from", Rec_ExcelBuffer."Cell Value as Text");        // Temporary replacement for test
                Rec_Courses.Validate("Date from");
                // Evaluate(Rec_Courses."Date to", GetValueAtIndex(RowNo, 5));
                Evaluate(Rec_Courses."Date to", Rec_ExcelBuffer."Cell Value as Text");           // Temporary replacement for test
                Rec_Courses.Validate("Date to");
                Evaluate(Rec_Courses.Participants, GetValueAtIndex(RowNo, 6));
                Rec_Courses.Validate(Participants);
                Evaluate(Rec_Courses."Maximum participants", GetValueAtIndex(RowNo, 7));
                Rec_Courses.Validate("Maximum participants");
                Evaluate(Rec_Courses.Location, GetValueAtIndex(RowNo, 8));
                Rec_Courses.Validate(Location);



                // RowNo osas on küsimus, ma "eeldan", et esimesed Kolm on: "Journal Template Name", "Journal Batch Name" ja "Line No."
                // Kas see mõjutab seda kuidas mina oma koodis neid kirjutan? Mis on lubatud ja ei ole lubatud ning mis vajalik sellist laadi
                // koodi puhul 

                // Evaluate(Rec_Courses.Amount, GetValueAtIndex(RowNo, 11));
                // Rec_Courses.Validate(Amount);
                // Evaluate(Rec_Courses."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 12));
                // Rec_Courses.Validate(Rec_Courses."Shortcut Dimension 2 Code");
                // Rec_Courses.Modify(true);

            end
            else begin
                Rec_Courses.Init();
                Evaluate(Rec_Courses."Course Nr.", GetValueAtIndex(RowNo, 1));
                Evaluate(Rec_Courses.Name, GetValueAtIndex(RowNo, 2));
                Evaluate(Rec_Courses.Description, GetValueAtIndex(RowNo, 3));
                Evaluate(Rec_Courses."Date from", GetValueAtIndex(RowNo, 4));
                Evaluate(Rec_Courses."Date to", GetValueAtIndex(RowNo, 5));
                Evaluate(Rec_Courses.Participants, GetValueAtIndex(RowNo, 6));
                Evaluate(Rec_Courses."Maximum participants", GetValueAtIndex(RowNo, 7));
                Rec_Courses.Validate("Course Nr.");                                         // Kas seda on vaja teha vaid PK jaoks?
                Evaluate(Rec_Courses.Location, GetValueAtIndex(RowNo, 8));
                // Evaluate(Rec_Courses.LeaseNo, GetValueAtIndex(RowNo, 9));
                // Evaluate(Rec_Courses.Description, GetValueAtIndex(RowNo, 10));
                // Evaluate(Rec_Courses.Amount, GetValueAtIndex(RowNo, 11));
                // Evaluate(Rec_Courses."Shortcut Dimension 2 Code", GetValueAtIndex(RowNo, 12));

                Rec_Courses.Validate(Name);
                // Rec_Courses.Validate("Document No.");
                // Rec_Courses.Validate(LeaseNo);
                // Rec_Courses.Validate("Shortcut Dimension 1 Code");
                // Rec_Courses.Validate("Shortcut Dimension 2 Code");
                Rec_Courses.Insert();
            end;

        end;
        Message('%1 Rows Imported Successfully!!', Rows - 1);


    end;

    local procedure GetValueAtIndex(RowNo: Integer; ColNo: Integer): Text
    var
    begin
        Rec_ExcelBuffer.Reset();
        IF Rec_ExcelBuffer.Get(RowNo, ColNo) then
            exit(Rec_ExcelBuffer."Cell Value as Text");
    end;

    procedure ExportCoursesBuffer()
    var
        myInt: Integer;
    begin
        ExportHeaderCourses();
        Rec_Courses.SetRange("Course Nr.", 'GENERAL');              // Kas siia võibolla GENERAL asemel "võiks" tulla mingi number?
        if Rec_Courses.FindFirst() then begin                       // või hoopis siia võis "Course Nr." asemel olla teine lahter näiteks Description vms?
            repeat
                Rec_ExcelBuffer.NewRow();
                Rec_ExcelBuffer.AddColumn(Format(Rec_Courses."Course Nr."), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Number);
                Rec_ExcelBuffer.AddColumn(Format(Rec_Courses."Name"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Rec_Courses.Description, false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
                Rec_ExcelBuffer.AddColumn(Rec_Courses."Date from", false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Date);
                Rec_ExcelBuffer.AddColumn(Format(Rec_Courses."Date to"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Date);
                Rec_ExcelBuffer.AddColumn(Format(Rec_Courses.Participants), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Number);
                Rec_ExcelBuffer.AddColumn(Format(Rec_Courses."Maximum participants"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Number);
                Rec_ExcelBuffer.AddColumn(Format(Rec_Courses.Location), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
            // Rec_ExcelBuffer.AddColumn(Format(Rec_Courses.LeaseNo), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
            // Rec_ExcelBuffer.AddColumn(Format(Rec_Courses.Description), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
            // Rec_ExcelBuffer.AddColumn(Rec_Courses.Amount, false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Number);
            // Rec_ExcelBuffer.AddColumn(Format(Rec_Courses."Shortcut Dimension 2 Code"), false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
            // Rec_ExcelBuffer.AddColumn('', false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
            // Rec_ExcelBuffer.AddColumn('', false, '', false, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);

            until Rec_Courses.next = 0;
            Rec_ExcelBuffer.CreateNewBook('General Journal');                           // Sellest sektsioonist ei saa eriti aru
            Rec_ExcelBuffer.WriteSheet('General Journal', CompanyName(), UserId());     // Kas see on sisuliselt nagu Logi operatsioonidest
            Rec_ExcelBuffer.CloseBook();
            Rec_ExcelBuffer.OpenExcel();


        end;
    end;

    local procedure ExportHeaderCourses()
    begin
        Rec_ExcelBuffer.Reset();
        Rec_ExcelBuffer.DeleteAll();
        Rec_ExcelBuffer.Init();
        Rec_ExcelBuffer.AddColumn('Course Nr.', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Name', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Description', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Date from', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Date to', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Participants', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Maximum participants.', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        Rec_ExcelBuffer.AddColumn('Location', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        // Rec_ExcelBuffer.AddColumn('Lease No.', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        // Rec_ExcelBuffer.AddColumn('Description', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        // Rec_ExcelBuffer.AddColumn('Amount', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        // Rec_ExcelBuffer.AddColumn('Credit Grade Code', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        // Rec_ExcelBuffer.AddColumn('Customer Type Code', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);
        // Rec_ExcelBuffer.AddColumn('SBU Code', false, '', true, false, false, '', Rec_ExcelBuffer."Cell Type"::Text);

    end;
}




