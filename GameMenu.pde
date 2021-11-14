class cSlider {
    float barX, barY, barW, barH;
    float sliderX;
    String text;
    
    cSlider(float x, float y, float w, float h, String text) {
        this.barX = x;
        this.barY = y;
        this.barW = w;
        this.barH = h;
        this.text = text;
        this.sliderX = x;
    }
    
    void marker() {
        if (INP.mbLpressed() && mouseX >= sliderX + 960 - 15 && mouseX <= sliderX + 960 + 15 && mouseY >= barY + 540 - 15 && mouseY <= barY + 540 + 15) {
            sliderX = mouseX - width / 2;
            if (sliderX <= -barW / 2) {
                sliderX = -barW / 2;
            } else if (sliderX >= barW / 2) {
                sliderX = barW / 2;
            }
        }
    }
    
    void draw() {
        textSize(24); // giver skriftstørrelsen til musik og sound barene.
        fill(255);
        rect(barX, barY, barW, barH);
        
        fill(66);
        text(this.text, barX, barY + 9);
        
        fill(255, 0, 0);
        ellipse(sliderX, barY, 30, 30);
    }
    
    int getValue() {
        return(int)(sliderX - barX);
    }
    
    void setValue(int value) {
        sliderX = barX + value;
    }
}

class cButton {
    float x, y, w, h;
    String text;
    PImage texture;
    PImage onhover;

    cButton(float x, float y, float w, float h, String text) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.text = text;
    }

    cButton(float x, float y, float w, float h, PImage texture) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.text = "";
        this.addTexture(texture);
    }

    cButton(float x, float y, float w, float h, PImage texture, PImage onhover) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.text = "";
        this.addTexture(texture, onhover);
    }

    void draw() {
        pushMatrix();
        if (this.isPressed()) {
            fill(69, 69, 69);
        } else {
            fill(255);
        }
        rectMode(CENTER);
        imageMode(CENTER);
        rect(x, y, w, h);
        if (this.texture != null) {
            noSmooth();
            image(this.onhover != null && this.isPressed() ? this.onhover : this.texture, x, y, w, h);
        } else {
            fill(0);
            textAlign(CENTER);
            textSize(24);
            text(this.text, x, y + h / 3 - 10);
        }

        popMatrix();
    }
    
    void addTexture(PImage texture) {
        texture.resize((int)w, (int)h);
        this.texture = texture;
    }

    void addTexture(PImage texture, PImage onhover) {
        texture.resize((int)w, (int)h);
        this.texture = texture;
        onhover.resize((int)w, (int)h);
        this.onhover = onhover;
    }

    boolean isPressed() {
        return mouseX >= x - this.w / 2 && mouseX <= x + w / 2 && mouseY >= y - this.h / 2 && mouseY <= y + h / 2;
    }
}

class GameMenu {
    boolean menuPressed = false;
    float eBX, eBY, eBW, eBH, rBX, rBY, rBW, rBH;
    cSlider sSound, sMusic;
    cButton bMenu, bResume, bExit, bStart;
    
    GameMenu() {
        sSound = new cSlider(0, 0, 200, 20, "Sound");
        sMusic = new cSlider(0, 60, 200, 20, "Music");
        bMenu = new cButton(1890, 30, 50, 50, "||");
        bResume = new cButton(width / 2, height / 3, 200, 50, BUTTON_ResumeBright, BUTTON_ResumeDark);
        bExit = new cButton(width / 2, height / 3 + 400, 200, 50, BUTTON_ExitBright, BUTTON_ExitDark);
        bStart = new cButton(width / 2, height / 2, 300, 75, BUTTON_StartBright, BUTTON_StartDark);
    }
    
    void draw() {
        pushMatrix();
        rectMode(CENTER);
        // Menuknappen i opper højre hjørne
        bMenu.draw();
        
        if (INP.mbLpressed() && bMenu.isPressed() || gamePause) {
            gamePause = true;
            fill(60, 60, 60, 20);
            rect(width / 2, height / 2, width, height);
            
            pushMatrix();
            translate(width / 2, height / 2);
            
            // Sound baren og dens skyder
            sSound.draw();
            // Musik baren og dens skyder
            sMusic.draw();
            
            sSound.marker();
            sMusic.marker();;
            popMatrix();

            bResume.draw();
            bExit.draw();

            if (INP.mbLpressed() && bResume.isPressed()) {
                gamePause = false;
            }

            if (INP.mbLpressed() && bExit.isPressed()) {
                exit();
            }
        }
        popMatrix();
    }
    
    void startMenu() {
        bStart.draw();

        imageMode(CENTER);
        image(IMG_logo, width / 2 - 100, height / 2 - IMG_logo.height);
        imageMode(CORNER);

        if (INP.mbLpressed() && bStart.isPressed()) {
            startGame = true;
        }
        
        bExit.draw();

        if (INP.mbLpressed() && bExit.isPressed()) {
            exit();
        }
    }

    void gameOver(boolean win) {
        music.startTrack("intro");
        imageMode(CENTER);
        image(win ? IMG_Win : IMG_Loss, width / 2, height / 2);

        bExit.draw();

        if (INP.mbLpressed() && bExit.isPressed()) {
            exit();
        }
    }
}