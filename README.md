# Horse-Query

![](https://img.shields.io/github/stars/dliocode/horse-query.svg) ![](https://img.shields.io/github/forks/dliocode/horse-query.svg) ![](https://img.shields.io/github/v/tag/dliocode/horse-query.svg) ![](https://img.shields.io/github/v/release/dliocode/horse-query.svg) ![](https://img.shields.io/github/issues/dliocode/horse-query.svg)

Support: developer.dlio@gmail.com

Middleware for Horse. Use to send a dataset in json format.

### For install in your project using [boss](https://github.com/HashLoad/boss):
``` sh
$ boss install github.com/dliocode/horse-query
```

## Usage

*You can use any component inherited from TDataSet*

```delphi
uses
  Horse,
  Horse.Jhonson, Horse.Query,
  FireDAC.Comp.Client, Data.DB,
  System.SysUtils;

begin
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

  THorse.Listen(9000);
end.
```


```delphi
uses
  Horse,
  Horse.Jhonson, Horse.Query,
  FireDAC.Comp.Client, Data.DB;

begin
  THorse.Use(Jhonson);
  THorse.Use(Query); //Must come after Jhonson middleware

  THorse.Get('/list',
    procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
    var
      List: TFDQuery;
    begin
      List := TFDQuery.Create(nil);
      List.Open('SELECT * FROM LIST');

      Res.Send<TFDQuery>(List);
    end);

  THorse.Listen(9000);
end.
```

## License

MIT © [Danilo Lucas](https://github.com/dliocode/)
