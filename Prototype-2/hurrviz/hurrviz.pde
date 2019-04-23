// CSci-5609 Project
import controlP5.*;
import org.gicentre.geomap.*;
import java.util.List;
import java.util.ArrayList;

ControlFrame cf;
ControlP5 cp5;

Chart myChart;
boolean toggleValue;
PFont myFont1;
PFont myFont2;
int displayMode = 1;
float lerpAmount = 0;
boolean lerpit = true;
int last;
int factor = 5;
String[] filenames;
List<Hurricane> hurs = new ArrayList<Hurricane>();
String path;
GeoMap geoMap;
float xo,yo;
float zoom = 6;
List<Integer> years = new ArrayList<Integer>();;

// Temp values;
//String str;



void settings() {
  //fullScreen();
  size(1600,800, P3D);  // Use the P3D renderer for 3D graphics
  smooth(4);
}


void setup() {
  cf = new ControlFrame(this, 400, 800, "Controls");
  surface.setLocation(420, 10);
  //years.add(2014);
  /*
  
  for (int i = 0; i <8; i++){
    hurs.add( new Hurricane());
  
  }*/
  // ================== Set up Map ========================
  
  geoMap = new GeoMap(this);  // Create the geoMap object.
  //geoMap = new GeoMap(-2500,-1500,1600*7,800*7,this);
  geoMap.readFile("world");   // Read shapefile.
  

  //================== zoom in/out ========================
  xo=420;
  yo=240;
  noStroke();
  


  // ================== Read File ========================
  
  path = sketchPath()+"/data/HurricaneData";
  filenames = listFileNames(path);
  //printArray( filenames);

  // ================== Load H ========================
  int t = 0;
  PVector[] track_points;

  for(String str:filenames){
    if (str.charAt(str.length() - 1) == 'v'){
    
      Hurricane new_hurr = new Hurricane();
      
      // load in .csv files
      new_hurr.track = loadTable(path + '/' + str); 
    
      // TODO: create object based on paras
      new_hurr.name = new_hurr.track.getString(0,2);
      new_hurr.year = new_hurr.track.getInt(0,3);
      new_hurr.level = new_hurr.track.getInt(3,6);
      //println(t, new_hurr.name, new_hurr.year);
      
      new_hurr.track.removeRow(0);
      new_hurr.track.removeRow(0);
      new_hurr.track.removeRow(0);
      track_points = new PVector[new_hurr.track.getRowCount()];
      
      for (int i = 0; i < new_hurr.track.getRowCount(); i++) {
        track_points[i] = new PVector(new_hurr.track.getFloat(i, 4), 
                                      new_hurr.track.getFloat(i, 2));
      }
      new_hurr.points = track_points;
      hurs.add( new_hurr );
      ++t;
    } // end if
  } // end for
  //====================Graph Chart============================
 /*
  cp5 = new ControlP5(this);
  myChart = cp5.addChart("dataflow")
               .setPosition(50, 50)
               .setSize(1600, 700)
               .setRange(-20, 20)
               .setView(Chart.LINE) // use Chart.LINE, Chart.PIE, Chart.AREA, Chart.BAR_CENTERED
               .setStrokeWeight(1.5)
               .setColorCaptionLabel(color(40))
               ;

  myChart.addDataSet("incoming");
  myChart.setData("incoming", new float[100]);

*/
  
  


} // end set-up


String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list();
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}


void draw() {
  
  background(0);  // Ocean colour
  
  toggleValue = cf.getToggleValue();
    //====================Swtich button=============
   //probably we can insert a graph or something for this

   pushMatrix();
  if(toggleValue){
      
    
      translate(50,30); // the location for graph to pop out
      zoom=1;
      //insert graph here
      fill(255);
      rect(0,0,1600,600);
    //myChart.push("incoming", (sin(frameCount*0.1)*10));
      
  }
  popMatrix();

 
    //Anthing we don't want to zoom should be placed above
    //==================zoom ========================
  translate(xo,yo);
  scale(zoom);
  translate(-xo,-yo);

  // ================== Draw Map ========================

  stroke(220);              // Boundary colour
  
strokeWeight(1);
  // Draw entire world map.
  fill(180);        // Land colour
  geoMap.draw();              // Draw the entire map.
/*
  // Find the country at the mouse position and draw it in different colour.
  int id = geoMap.getID(mouseX, mouseY);
  if (id != -1)
  {
    fill(100);      // Highlighted land colour.
    geoMap.draw(id);
  }
  */
  // ================== Draw Hurr ========================
float x,y;

strokeWeight(1.0);
strokeJoin(ROUND);

List<Integer> t_years = new ArrayList<Integer>(years);

  noFill();
    for (int this_year:t_years){
      for(Hurricane temp: hurs){
    
//println(this_year - 2002);
          stroke(cf.get_color(this_year-2001),170);
          strokeWeight(0.7+temp.level/8.0);

         
        last = temp.points.length-1;
        beginShape();
        for (int i = 0; i < last; i+=10){
          if (temp.points[i] != null) {
            //println(track_points[i].x,track_points[i].y);
              x = temp.points[i].x;
              y = temp.points[i].y;
              x = (180-x)*width/360;
              y = (85-y) * height/180;
              if(temp.getYear() == this_year){
                curveVertex(x,y);
              }
          }
        }
        endShape();
      
      }
    }
}


void keyPressed(){
  if (key == 'r'){
      zoom = 6;
    }else if (key == 'a'){
      zoom = 1;
    }
  if (key == CODED){
    if (keyCode == UP){
      zoom += .1;
    }else if (keyCode == DOWN){
      zoom -= .1;
    }
  }
}
void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if(e == 1.0){
    zoom += .1;
  }else if(e == -1.0){
    zoom -= .1;
  }
}

void add_year(int year){
  if (years.contains(year)){
    //years.remove(year);
  } else {
    years.add(year);
  }

}

void remove_year(int year){
  int i = years.indexOf(year);
  
  if (i != -1){
    years.remove(i);
  }

}
