tableextension 31054 "Direct Trans. Header CZL" extends "Direct Trans. Header"
{
    fields
    {
        field(31000; "Intrastat Exclude CZL"; Boolean)
        {
            Caption = 'Intrastat Exclude';
            DataClassification = CustomerContent;
#if not CLEAN22
            ObsoleteState = Pending;
            ObsoleteTag = '22.0';
#else
            ObsoleteState = Removed;
            ObsoleteTag = '25.0';
#endif
            ObsoleteReason = 'Intrastat related functionalities are moved to Intrastat extensions. This field is not used any more.';
        }
    }

    var
        GlobalDocumentNo: Code[20];
        GlobalIsIntrastatTransaction: Boolean;

    procedure IsIntrastatTransactionCZL(): Boolean
    begin
        if ("No." <> GlobalDocumentNo) or ("No." = '') then begin
            GlobalDocumentNo := "No.";
            GlobalIsIntrastatTransaction := UpdateGlobalIsIntrastatTransaction();
        end;
        exit(GlobalIsIntrastatTransaction);
    end;

    local procedure UpdateGlobalIsIntrastatTransaction(): Boolean
    var
        CountryRegion: Record "Country/Region";
        CompanyInformation: Record "Company Information";
    begin
#if not CLEAN22
#pragma warning disable AL0432
        if "Intrastat Exclude CZL" then
            exit(false);
#pragma warning restore AL0432
#endif
        if "Trsf.-from Country/Region Code" = "Trsf.-to Country/Region Code" then
            exit(false);

        CompanyInformation.Get();
        if "Trsf.-from Country/Region Code" in ['', CompanyInformation."Country/Region Code"] then
            exit(CountryRegion.IsIntrastatCZL("Trsf.-to Country/Region Code", false));
        if "Trsf.-to Country/Region Code" in ['', CompanyInformation."Country/Region Code"] then
            exit(CountryRegion.IsIntrastatCZL("Trsf.-from Country/Region Code", false));
        exit(false);
    end;
}