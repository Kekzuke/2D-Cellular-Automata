uses GraphWPF;
    
function MatrFill(w, h, size : integer) : array [ , ] of integer; // first matrix random generation
begin
  w := Trunc(w / size);
  h := Trunc(h / size);
  result := new integer[w,h];
  
  for var x := 0 to w - 1 do
    for var y := 0 to h - 1 do
      result[x, y] := Random(0, 1);
end;


function NextGeneration(Generation : array [,] of integer) : array [,] of integer; // Next Generation function
begin
  result := new integer[Generation.RowCount, Generation.ColCount];
  
  for var x := 1 to Generation.RowCount - 2 do
    for var y := 1 to Generation.ColCount - 2 do
    begin
      var neighbours := 0;
      
      for var i := -1 to 1 do // neighbours count
        for var j := -1 to 1 do
          neighbours += Generation[x + i, y + j];
      
      neighbours -= Generation[x, y]; // subtract the current cell's state
      
      if ((Generation[x, y] = 1) and (neighbours < 2)) then // rules of automata(Game of Life)
        result[x, y] := 0
      else if ((Generation[x, y] = 1) and (neighbours > 3)) then
        result[x, y] := 0
      else if ((Generation[x, y] = 0) and (neighbours = 3)) then
        result[x, y] := 1
      else
        result[x, y] := Generation[x, y];
    end;
end;

begin
  // settings
  var width := 900;
  var height := 800;
  var size := 10;
  var FPS := 20;
  
  Window.SetSize(width, height);
  Window.CenterOnScreen;
  
  var (w, h) := (Trunc(Window.Width), Trunc(Window.Height));
  
  var Generation := MatrFill(w, h, size);
  
  while True do // main cycle for drawing cells
  begin
    Sleep(Trunc(1000 / FPS));
    Window.Clear(Colors.Gray);
    
    for var x := 0 to w step size do
      Line(x, 0, x, h);

    for var y := 0 to h step size do
      Line(0, y, w, y);
    
    Generation := NextGeneration(Generation);
    
    for var x := 0 to Generation.RowCount - 1 do
      for var y := 0 to Generation.ColCount - 1 do
      begin
        if Generation[x, y] = 1 then
          Rectangle(x * size , y * size, size, size);
      end;
  end;
end.