Bot user;
Bot user2;
Bot user3;
Bot user4;



void setup() {

  size(400,400);

  background(255);

  user = new Bot(100,100);
  user2 = new Bot(300,100);
  user3 = new Bot(100,300);
  user4 = new Bot(300,300);

}



void draw() {

  user.display();

  user.step();
  
  user2.display();

  user2.step();
  
  user3.display();

  user3.step();
  
  user4.display();

  user4.step();

}