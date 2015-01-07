Table       table;
DataView    dataView;
float       timeSteps;
float       timeStepsMark;
float       xOffset = 0;
float       minVal = 0;
float       maxVal = 1000;
ArrayList<DataView> dataViews = new ArrayList<DataView>();


void setup()
{
  size(1200, 600);
  
  // load the signal file
  selectInput("Select a file to process:", "loadSelectedFile");
  
  noLoop();
}

void loadSelectedFile(File selection)
{  
  if (selection == null) {
    println("Window was closed or the user hit cancel. Exiting...");
    exit();
  }
  else {
    println("User selected " + selection.getAbsolutePath());
    
    table = loadTable(selection.getAbsolutePath(), "csv");
    afterSelectFile();
  }
}

void afterSelectFile()
{
  println(table.getRowCount() + " total rows in table");

  resetView();

  // load data
  dataViews.add(new DataView(table, 0, timeSteps, color(255, 0, 0)));
  dataViews.add(new DataView(table, 1, timeSteps, color(0, 255, 0)));
  dataViews.add(new DataView(table, 2, timeSteps, color(0, 0, 255)));
  dataViews.add(new DataView(table, 3, timeSteps, color(0, 255, 255)));
 
  redraw();
}

void resetView()
{
  xOffset = 0;
  timeSteps = 1;
  timeStepsMark = timeSteps * 1;
}

void draw()
{
  background(255);

  stroke(0);
  noFill();

  translate(xOffset, height/2);

  // draw the data
  if (dataViews.size() > 0) {
    
    for (int i = 0; i < dataViews.size(); i++) {
      DataView view = dataViews.get(i);
      
      view.setLeveling(height/2-20, 0);
      view.draw(view._color);
    }

    // draw the background grid
    drawBackground();
  }
}

void drawBackground()
{
  stroke(0, 0, 0, 50);
  line(0, 0, dataViews.get(0).getWidth(), 0);
  line(0, -height/2, 0, height/2);

  stroke(0, 0, 0, 50);
  strokeWeight(1);
  float steps = timeSteps * timeStepsMark;
  if (steps >= 5)
  {
    for (float x=0 ; x < dataViews.get(0).getWidth() + 1; x += steps)
      line(x, -height/2, x, height/2);
  }
}

void mousePressed()
{
  redraw();
}

void mouseDragged()
{
  if (mouseButton == RIGHT)
  { // scroll horizontal
    xOffset += mouseX - pmouseX;
    redraw();
  }
  else if (mouseButton == LEFT)
    // select picking point
    redraw();
}

void mouseWheel(MouseEvent event)
{
  if (event.getAmount() > 0)
    timeSteps *= 1.1;
  else
    timeSteps *= .9;

  // change the scale of the view
  for (int i = 0; i < dataViews.size(); i++) {
    dataViews.get(i)._timeSteps = timeSteps; 
  }

  redraw();
}

void keyPressed()
{
  println("redraw");
  redraw();
}
