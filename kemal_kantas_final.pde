 
import controlP5.*;


import java.util.Date;
import ddf.minim.*;
import ddf.minim.analysis.*;
import processing.serial.*;
import processing.sound.*;

Minim minim;
AudioPlayer song;
BeatDetect beat;
BeatListener bl;

//Mikrofon girişi için
AudioIn input;
Amplitude rms;
char Keyboard='.';//bos
int scale=1;

Serial myPort;  // Create object from Serial class
int val;        // Data received from the serial port
int[] serialInArray = new int[3]; 
Boolean firstContact;
int serialCount = 0;
float rectW;

int red, green, blue;
byte [] arr = {2, 3, 4};

float redSize, greenSize, blueSize;

String songList [] = {""};
int currentSongId = 0;

int defaultScene=0;
String portName=null;

float n,n1;


class BeatListener implements AudioListener
{
  private BeatDetect beat;
  private AudioPlayer source;

  BeatListener(BeatDetect beat, AudioPlayer source)
  {
    this.source = source;
    this.source.addListener(this);
    this.beat = beat;
  }

  void samples(float[] samps)
  {
    beat.detect(source.mix);
  }

  void samples(float[] sampsL, float[] sampsR)
  {
    beat.detect(source.mix);
  }
}

void setup()
{
  size(512, 200, P3D);


  portName = Serial.list()[0];
  myPort = new Serial(this, portName, 9600);
  minim = new Minim(this);
  myPort.bufferUntil('\n'); 


  textFont(createFont("Helvetica", 16));
  textAlign(CENTER);

  println("Bir Seçim Yapınız:");
  println("m - Microphone");
  println("s - Music list");
  println("n - change song");
  println("q - quit");
  
  
  
}

//music list tanımlama yeri //
void SoundRunning() {    
  if (portName == null)
  {
  }

  println("\nListing info about all files in a directory and all subdirectories: ");
  ArrayList<File> allFiles = listFilesRecursive(sketchPath() + "/data");

  for (int i =0; i < allFiles.size(); i++) {
    if (i != 0) { 
      if (songList[0] != allFiles.get(i).getName())
      {
        songList=append(songList, allFiles.get(i).getName());
      }
      // println(allFiles.get(i).getName());
    }
  } 
  currentSongId++;
  playASong(songList[currentSongId]);
}

// mikrofon input kısmı//
void MicrofonRunning() { 
  background(255);
  input = new AudioIn(this, 0); 
  input.start(); 
  rms = new Amplitude(this); 
  rms.input(input);
}

void draw()
{ 
  switch(Keyboard) {
    
    // mikrofon okuma yeri//
  case 'm':
    background(255, 160, 0);

    // adjust the volume of the audio input
    input.amp(map(mouseY, 0, height, 0.0, 1.0));

    // rms.analyze() return a value between 0 and 1. To adjust
    // the scaling and mapping of an ellipse we scale from 0 to 0.5
    scale=int(map(rms.analyze(), 0, 0.5, 1, 350));
    noStroke();

    fill(255, 0, 0);
    // We draw an ellispe coupled to the audio analysis
    ellipse(width/2, height/2, 1*scale, 1*scale);



    int red = int(map(scale*10,1,350,150,255));
    int green = int(map(scale*4,1,350,20,255));
    int blue = int(map(scale*.5,1,350,0,255));
  
    if(red < 10) {
      red = 0; 
    }
    
    if(green < 30) {
      red = 0; 
    }
    
    if(blue < 40) {
      red = 0; 
    }

    myPort.write(red);
    myPort.write(green);
    myPort.write(blue);

    break;

  case 's': 
    SoundDraw();
    break;

  case 'q':
    DefaultDraw();
    break;

  case 'n':
    SoundDraw();
    break;

  default: 
    // if(defaultScene==0)
    // {
    DefaultDraw();
    // defaultScene++;
    // }

    break;
  }

}

// giris ekran yeri//
void DefaultDraw() {
  
  
  background(255, 120, 0); 


 fill(255, 0, 0);
  textSize(24);
  text("PRESS 'S' FOR MUSIC LIST", width/2, height/2-20);
  textSize(24);
  text("PRESS 'M' FOR MICROPHONE", width/2, height/2+20);
}

// music okuma yeri//
void SoundDraw() {

  background(0); 
  // draw a green rectangle for every detect band
  // that had an onset this frame
  rectW = width / beat.detectSize();
  for (int i = 0; i < beat.detectSize(); ++i)
  {
    // test one frequency band for an onset
    if ( beat.isOnset(i) )
    {
      fill(255, 69, 0);
      rect( i*rectW, 0, rectW, height);
    }
  }

  // draw an orange rectangle over the bands in 
  // the range we are querying
  int lowBand = 5;
  int highBand = 15;
  // at least this many bands must have an onset 
  // for isRange to return true
  int numberOfOnsetsThreshold = 4;
  if ( beat.isRange(lowBand, highBand, numberOfOnsetsThreshold) )
  {
    fill(255, 0, 0, 200);
    rect(rectW*lowBand, 0, (highBand-lowBand)*rectW, height);
  }

  if ( beat.isKick() ) redSize = 48;
  if ( beat.isSnare() ) greenSize = 48;
  if ( beat.isHat() ) blueSize = 48;

  fill(255);

  textSize(redSize);
  text("REDPIN", width/4, height/2);

  textSize(greenSize);
  text("GREENPIN", width/2, height/2);

  textSize(blueSize);
  text("BLUEPIN", 3*width/4, height/2);

  redSize = constrain(redSize * 0.95, 16, 32);
  greenSize = constrain(greenSize * 0.95, 16, 32);
  blueSize = constrain(blueSize * 0.95, 16, 32);

  int redSizeMapped = int(map(redSize, 16, 32, 0, 255));
  int greenMapped = int(map(greenSize, 16, 32, 0, 255));
  int blueSizeMapped = int(map(blueSize, 16, 32, 0, 255));

  myPort.write(redSizeMapped);
  myPort.write(greenMapped);
  myPort.write(blueSizeMapped);
}

int Sound = 0;
int Microfon = 0;
void keyPressed() {  
  switch(key) {
  case 'm':
    Keyboard = key;
    if (Microfon == 0) {
      Microfon++;
      if (Sound != 0)
        song.close();

      Sound = 0;
      Keyboard = 'm';

      MicrofonRunning();
    }
    break;
  case 's':    
    Keyboard = key; 
    Sound++;
    Microfon = 0;
    Keyboard='s'; 
    SoundRunning();
    currentSongId = currentSongId + 1; 
    if (currentSongId > songList.length-1) {
      currentSongId = 1;
    }
    println("Current song : " + songList[currentSongId]); 

    playASong(songList[currentSongId]); 


    break;
  case 'n':
    if (Keyboard != 'm') {
      Keyboard = key;
      currentSongId = currentSongId + 1; 
      if (currentSongId > songList.length-1) {
        currentSongId = 1;
      }
      println("Current song : " + songList[currentSongId]); 

      playASong(songList[currentSongId]);
    }    

    break;
  case 'q':
    song.close();
    Keyboard = key;     
    break;
  default:  
    Keyboard = key;
    song.close();
    if (Keyboard != 'm') {
      println("Tekrar Bir Seçim Yapınız..");
      println("m - Mikrofon");
      println("s - Müzik");
    } else if (Keyboard != '.') {
      println("Tekrar Bir Seçim Yapınız..");
      println("m - Mikrofon");
      println("s - Müzik");
    } else if (Keyboard != 's') {       
      println("Tekrar Bir Seçim Yapınız..");
      println("m - Mikrofon");
      println("s - Müzik");
    }

    break;
  }
} 

void playASong(String songName) {

  if (song != null) {
    song.close();
  }

  song = minim.loadFile(songName, 1024);
  song.play();

  beat = new BeatDetect(song.bufferSize(), song.sampleRate());

  beat.setSensitivity(150);  
  redSize = greenSize = blueSize = 16;
  // make a new beat listener, so that we won't miss any buffers for the analysis
  bl = new BeatListener(beat, song);
}

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

// This function returns all the files in a directory as an array of File objects
// This is useful if you want more info about the file
File[] listFiles(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    // If it's not a directory
    return null;
  }
}


// Function to get a list of all files in a directory and all subdirectories
ArrayList<File> listFilesRecursive(String dir) {
  ArrayList<File> fileList = new ArrayList<File>(); 
  recurseDir(fileList, dir);
  return fileList;
}

// Recursive function to traverse subdirectories
void recurseDir(ArrayList<File> a, String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    // If you want to include directories in the list
    a.add(file);  
    File[] subfiles = file.listFiles();
    for (int i = 0; i < subfiles.length; i++) {
      // Call this function on all files in this directory
      recurseDir(a, subfiles[i].getAbsolutePath());
    }
  } else {
    a.add(file);
  }
}