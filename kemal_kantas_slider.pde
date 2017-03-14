import controlP5.*;
ControlP5 cp5;

float r = 200;
float s = 200;
float theta = 0;
float x;
float y;
float n = 20;
float d = 9;
float c = 0.1;
float k = 5;

void setup() {
  size(600, 600);
  cp5 = new ControlP5(this);
  cp5.addSlider("s")
  .setPosition(20, 20)
  .setRange(0, 300)
  ;  
  cp5.addSlider("n")
  .setPosition(20, 40)
  .setRange(0, 400)
  ;
  cp5.addSlider("d")
  .setPosition(20, 60)
  .setRange(0, 400)
  ;
  cp5.addSlider("c")
  .setPosition(20, 80)
  .setRange(0, 1)
  ;

}

void draw() {
  background(0);
  
  
  k=n/d;
  
  pushMatrix();
  translate(width/2, height/2);

  noFill();
  beginShape();

  for (int i=0; i<250*d ; i= i+1) {

    theta = map(i, 0, 250, 0, TWO_PI);

    r = s * cos(k*theta)*c ;
    x = cos(theta)*r;
    y = sin(theta)*r;


    stroke(255);

    vertex(x, y);
    //point(x,y);
  }

  endShape(CLOSE);
  popMatrix();
}