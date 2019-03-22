PImage img;
PImage smaller;
PImage[] allImages;
float[] colorDiff;
int[] theRecords;


int scl = 8;
int w, h;

void setup()
{
  noStroke();
  //pixelDensity(2);
  size(100, 100);
  img = loadImage("image.jpg");
  img.resize(img.width*2, img.height*2);
  surface.setSize(img.width, img.height);
  surface.setResizable(true);
  println(img.width + "   " + img.height);

  File[] files = listFiles(sketchPath("images"));
  allImages = new PImage[files.length-1];
  colorDiff = new float[allImages.length];

  for (int i = 0; i < allImages.length; i++) {
    String filename = files[i].toString();  
    allImages[i] = loadImage(filename);
    allImages[i].loadPixels();
    float avg = 0;
    for (int j = 0; j < allImages[i].pixels.length; j++) {
      float b = red(allImages[i].pixels[j]) + green(allImages[i].pixels[j])*100 + blue(allImages[i].pixels[j])*200;
      //float b = brightness(allImages[i].pixels[j]);
      avg += b;
    }
    avg /= allImages[i].pixels.length;
    colorDiff[i] = avg;
  }


  w = img.width/scl;
  h = img.height/scl;

  smaller = createImage(w, h, RGB);
  smaller.copy(img, 0, 0, img.width, img.height, 0, 0, w, h);

  theRecords = new int[w*h];
}


void draw()
{
  println(w + "    " + h);
  smaller.loadPixels();
  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      int recordIndex = 0;
      float record = 26000;
      int index = x + y * w;
      color c = smaller.pixels[index];
      int imageIndex = int(red(c)+green(c)*100+blue(c)*200);
      for (int z = 0; z < colorDiff.length; z++) {

        float diff = abs(imageIndex - colorDiff[z]);
        if (diff < record) {
          record = diff;
          recordIndex = z;
        }
      }
      theRecords[index] = recordIndex;
      image(allImages[recordIndex], x*scl, y*scl, scl, scl);
    }
  }
 // saveFrame();
  //noLoop();

  if (mousePressed) {
    int index = (mouseY/scl)*(img.width/scl) + mouseX/scl;  
    println(index);
    PImage display;
    display = allImages[theRecords[index]];
    image(display, img.width/2-display.width/2, height/2-display.height/2);
  }
}


// Loading all image files from a directory
File[] listFiles(String dir)
{
  File file = new File(dir);
  if (file.isDirectory()) {
    File[] files = file.listFiles();
    return files;
  } else {
    return null;
  }
}
