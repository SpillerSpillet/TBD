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
            sliderX = mouseX - width/2;
            if (barX <= -barW / 2) {
                sliderX = -barW / 2;
            } else if (barX >= barW / 2) {
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
        return (int) (sliderX - barX);
    }

    void setValue(int value) {
        sliderX = barX + value;
    }
}

class cButton {
    cButton() {
        
    }
}

class cTextureButton extends cButton {
    PImage texture;
    
    cTextureButton(PImage texture) {
        this.texture = texture;
    }
}

class GameMenu {
    boolean menuPressed = false;
    float eBX, eBY, eBW, eBH, rBX, rBY, rBW, rBH;
    float soundDb;
    int barW = 200, barH = 20;
    cSlider sSound, sMusic;
    float soundX, musicX, soundY, musicY;

    GameMenu() {
        sSound = new cSlider(0, 0, 0, 0, "Sound");
        sMusic = new cSlider(0, 60, 0, 60, "Music");
    }
    
    void draw() {
        // Menuknappen i opper højre hjørne
        rect(1890, 30, 50, 50);

        if (menuPressed == true) {
            fill(60, 60, 60, 20);
            rect(width / 2, height / 2, width, height);
            
            pushMatrix();
            translate(width / 2, height / 2);
            
            // Sound baren og dens skyder
            sSound.draw();
            // Musik baren og dens skyder
            sMusic.draw();

            sSound.marker();
            sMusic.marker();
            restart();
            popMatrix();
            resume();
            
            leave();
        }
    }
    

    void menu() {
        pushMatrix();
        rectMode(CENTER);
        if (mouseX >= 1890 - 25 && mouseX <= 1890 + 25 && mouseY >= 30 - 25 && mouseY <= 30 + 25) {
            fill(69, 69, 69);
        } else {
            fill(255, 255, 255);
        }
        if (INP.mbLpressed() && mouseX >= 1890 - 25 && mouseX <= 1890 + 25 && mouseY >= 30 - 25 && mouseY <= 30 + 25) {
            menuPressed = true;
            gamePause = true;
        }
        this.draw();
        popMatrix();
    }
    
    void resume() {
        textAlign(CENTER);
        textSize(64);
        rBX = width / 2;
        rBY = width / 3 - 200;
        rBW = 250;
        rBH = 100;
        if (mouseX >= rBX - eBW / 2 && mouseX <= rBX + rBW / 2 && mouseY >= rBY - 50 && mouseY <= rBY + 50) {
            fill(69, 69, 69);
            rect(rBX, rBY, rBW, rBH);
            if (INP.mbLpressed()) {
                menuPressed = false;
                gamePause = false;
            }
        } else {
            fill(255);
            rect(rBX, rBY, rBW, rBH);
        }
        fill(0);
        text("RESUME", rBX, rBY + rBH / 3 - 10);
    }
    
    void restart() {
        rect(rBX, rBY + 200, eBW, eBH);   
        if (mouseX >= rBX - eBW / 2 && mouseX <= rBX + eBW / 2 && mouseY >= rBY + 200 - eBH / 2 && mouseY <= rBY + 200 + eBH / 2) {
            fill(69, 69, 100);
            sSound = new cSlider(0, 0, 0, 0, "Sound");
            sMusic = new cSlider(0, 60, 0, 60, "Music");

        } else {
            fill(69, 69, 69);
        }
        
    }
    
    void leave() {
        textSize(80);
        eBX = width / 2;
        eBY = width / 3 + 200;
        eBW = 250;
        eBH = 100;
        if (mouseX >= eBX - eBW / 2 && mouseX <=  eBX + eBW / 2 && mouseY >= eBY - 50 && mouseY <= eBY + 50) {
            fill(69, 69, 69);
            rect(eBX, eBY, eBW, eBH);
            if (INP.mbLpressed()) {
                exit();
            }
        } else {
            fill(255);
            rect(eBX, eBY, eBW, eBH);
        }
        fill(0);
        text("EXIT", eBX, eBY + eBH / 3 - 5);
    }
    
    void startMenu() {
        int SGButtonX = width / 2, SGButtonY = height / 2, SGButtonW = 300, SGButtonH = 75;
        
        // start knappen
        rectMode(CENTER);
        textAlign(CENTER);
        if (mouseX >= SGButtonX - SGButtonW / 2 && mouseX <=  SGButtonX + SGButtonW / 2 && mouseY >= SGButtonY - SGButtonH / 2 && mouseY <= SGButtonY + SGButtonH / 2) {
            fill(69,69, 69);
            rect(SGButtonX, SGButtonY, SGButtonW, SGButtonH);
            if (INP.mbLpressed()) {
                startGame = true;
            }
        } else{
            fill(255);
            rect(SGButtonX, SGButtonY + 300, SGButtonW, SGButtonH);
        }
        fill(0);
        textSize(32);
        text("PRESS TO START", SGButtonX, SGButtonY + 10);
        
        // Exit Knappen
        if (mouseX >= SGButtonX - SGButtonW / 2 && mouseX <=  SGButtonX + SGButtonW / 2 && mouseY >= SGButtonY + 300 - SGButtonH / 2 && mouseY <= SGButtonY + 300 + SGButtonH / 2) {
            
            fill(69,69, 69);
            rect(SGButtonX, SGButtonY + 300, SGButtonW, SGButtonH);
            if (INP.mbLpressed()) {
                exit();
            }
        } else{
            fill(255);
            rect(SGButtonX, SGButtonY + 300, SGButtonW, SGButtonH);
        }
        fill(0);
        textSize(48);
        text("Exit", SGButtonX, SGButtonY + 315);
    }
}
