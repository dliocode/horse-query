program Sample;

uses
  Horse,
  Horse.Jhonson, Horse.Query,
  FireDAC.Comp.Client,
  Data.DB,
  System.SysUtils;

begin
  THorse.Use(Jhonson);
  THorse.Use(Query); //Must come after Jhonson middleware

  THorse.Get('/ping',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      Memtable: TFDMemtable;
    begin
      Memtable := TFDMemtable.Create(nil);
      Memtable.FieldDefs.Add('Codigo', ftInteger, 0, False);
      Memtable.FieldDefs.Add('Nome', ftString, 100, False);

      Memtable.LogChanges := False;
      Memtable.CachedUpdates := True;

      Memtable.Close;
      Memtable.CreateDataSet;
      Memtable.Open;

      Memtable.Append;
      Memtable.FieldByName('Codigo').AsInteger := 1;
      Memtable.FieldByName('Nome').AsString := 'Ping';
      Memtable.Post;

      Memtable.Append;
      Memtable.FieldByName('Codigo').AsInteger := 2;
      Memtable.FieldByName('Nome').AsString := 'Pong';
      Memtable.Post;

      Memtable.ApplyUpdates;

      Res.Send<TFDMemtable>(Memtable);
    end);

  THorse.Listen(9000,
    procedure(Horse: THorse)
    begin
      Writeln(Format('Server started in %s:%d', [THorse.Host, THorse.Port]));
      Writeln('Press return to stop...');
    end);
end.
