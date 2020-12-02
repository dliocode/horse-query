unit Horse.Query;

interface

uses
  Horse,
  DataSet.Serialize, DataSet.Serialize.Config,
  Data.DB,
  System.JSON, System.SysUtils;

procedure Query(Req: THorseRequest; Res: THorseResponse; Next: TProc);

implementation

procedure Query(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  LContent: TObject;
  LJA: TJSONArray;
  LOldLowerCamelCase: Boolean;
begin
  try
    Next;
  finally
    LContent := THorseHackResponse(Res).GetContent;

    if Assigned(LContent) and LContent.InheritsFrom(TDataSet) then
    begin
      LOldLowerCamelCase := TDataSetSerializeConfig.GetInstance.LowerCamelCase;
      TDataSetSerializeConfig.GetInstance.LowerCamelCase := False;

      try
        LJA := TDataSet(LContent).ToJSONArray;
      finally
        TDataSetSerializeConfig.GetInstance.LowerCamelCase := LOldLowerCamelCase;
      end;

      if Assigned(LJA) then
      begin
        Res.Send(LJA.ToString);
        FreeAndNil(LJA);
      end
      else
        Res.Send('[]');
    end;
  end;
end;

end.