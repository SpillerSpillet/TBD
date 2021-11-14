class Animation {
  PImage[] images;
  int imageCount, iterations, frame;
  boolean isIdle, flipped;

  Animation (PImage[] images, boolean isIdle) {
    this.images = images;
    imageCount = images.length;
    iterations = 1;
    frame = 0;
    this.isIdle = isIdle;
    flipped = false;
  }
  
  Animation(String imagePrefix, int count) {
    this.imageCount = count;
    this.flipped = false;
    this.images = new PImage[imageCount];
    this.iterations = 0;

    if (count <= 1) {
        this.isIdle = true;
        this.images[0] = loadImage(imagePrefix + ".png");
    } else {
        // Start filenames from 0001 not 0000
        for (int i = 1; i <= this.imageCount; i++) {
            // Offset images by -1 so that they start at 0
            this.images[i-1] = loadImage(imagePrefix + nf(i, 4) + ".png");
        }
    }
  }

  void draw(float xpos, float ypos) {
    pushMatrix();
    imageMode(CORNER);
    image(flipped ? this.flip(images[frame]) : images[frame], xpos, ypos);
    popMatrix();
  }

  // Overrides er det eneste gode ved Java men det er stadig dårligt.

  // Kunne optimeres ved at cache resultater men det koster mere RAM end processing power
  PImage flip(PImage img) {
    PImage newImage = createImage(img.width, img.height, ARGB);
    newImage.loadPixels();
    for (int i = 0; i < img.pixels.length; i++) {
        newImage.pixels[i] = img.pixels[i - 2 * (i % img.width) + img.width - 1];
    }
    newImage.updatePixels();
    return newImage;
  }

  void flip(boolean flipped) { 
      this.flipped = flipped;
  }

  void nFrame() {
      this.iterations += (this.frame == (this.imageCount - 1) ? 1 : 0);
      // Progress to the next frame (but cap at framecount)
      this.frame = (this.frame+1) % this.imageCount;
  }

  //  when frame is imageCount return true
  boolean isDone() {
      return this.iterations > 0 ? true : false;
  }

  void setFrame(int frame) {
      this.frame = frame;
  }
  
  PImage getFrame() {
    return images[frame];
  }
}