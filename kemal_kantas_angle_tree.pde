Tree user;
Tree user2;
Tree user3;
Tree user4;
Tree user5;
Tree user6;
Tree user7;
Tree user8;
Tree user9;
Tree user10;
Tree user11;
Tree user12;

float angle = 30;
float range = 15;

import controlP5.*;
ControlP5 cp5;

void setup() {
  size(500, 500);
  cp5 = new ControlP5(this);
  user = new Tree();
  user2 = new Tree();
  user3 = new Tree();
  user4 = new Tree();
  user5 = new Tree();
  user6 = new Tree();
  user7 = new Tree();
  user8 = new Tree();
  user9 = new Tree();
  user10 = new Tree();
  user11 = new Tree();
  user12 = new Tree();

  cp5.addSlider("angle").setPosition(20, 20).setRange(0, 180);
  cp5.addSlider("range").setPosition(360, 20).setRange(5, 50);
}

void draw() {
  background(#524d9c);
  user.display(range, angle, 60, 0);
  user2.display(range, angle, -60, 0);
  user3.display(range, angle, 0, 60);
  user4.display(range, angle, 0, -60);
  user5.display(range, angle, 30, 30);
  user6.display(range, angle, 30, -30);
  user7.display(range, angle, -30, 30);
  user8.display(range, angle, -30, -30);
  user9.display(range, angle, 60, 30);
  user10.display(range, angle, -60, 30);
  user11.display(range, angle, 30, 60);
  user12.display(range, angle, -30, -60);
}