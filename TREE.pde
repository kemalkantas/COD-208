class Tree {
  float angle = 30;
  float range = 15;
  float x = 0;
  float y = 0;

  float aniFacAng;
  float opacityFac;

  void display(float range, float angle, float x, float y) {
    pushMatrix();
    translate(width*0.5, height*0.5);
    branch(x + aniFacAng, y + aniFacAng, angle);
    popMatrix();

    aniFacAng = sin(millis()* 0.001) * range;
  }

  void branch(float len, float wid, float angle) {
    stroke(255, 255, 255);
    line(0, 0, -wid, -len);
    translate(-wid, -len);

    if (len>2 || wid>2 || len<-2 || wid<-2) {
      pushMatrix();
      rotate(radians(angle + aniFacAng));
      branch(len*0.67, wid*0.67, angle);
      popMatrix();

      pushMatrix();
      rotate(radians(-angle + aniFacAng));
      branch(len*0.67, wid*0.67, angle);
      popMatrix();
      if (len<10 || wid<10 || len>-10 || wid>-10) {
        noStroke();
        opacityFac = map(aniFacAng, -5, 5, 0, 255);
        fill(0, 0, 0, opacityFac);
        if (aniFacAng<5) {
          ellipse(0, 0, 3+aniFacAng, 3+aniFacAng);
        } else {
          ellipse(0, 0, 10, 10);
        }
      }
    }
  }
}