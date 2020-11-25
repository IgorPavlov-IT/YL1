tableextension 60300 "Employee table ext" extends Employee
{
    fields
    {
        field(60301; "Course Cost"; Decimal)        // Currently returns 0 as value.. 
        {
            Editable = false;
            DecimalPlaces = 0 : 5;
            Caption = 'Expenses on Courses';

            // FieldClass = FlowField;

            // CalcFormula = Sum(CourseParticipants."Employee training cost" WHERE("Employee Nr." = field("No.")));

        }

    }
}
