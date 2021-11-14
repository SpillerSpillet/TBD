import java.util.Map;
import processing.sound.*;
import processing.video.*;

boolean gamePause = false;
boolean startGame = false;

InputHandler INP = new InputHandler();

Music music;
GameMenu gameMenu;
GameSession gameSession;

void setup() {
    fullScreen();
    VIDEO_BG = new Movie(this, "c1.mp4");
    VIDEO_BG.loop();
    frameRate(100000);
    smooth(0);
    loadAssets();
    music = new Music();
    gameMenu = new GameMenu();
    gameSession = new GameSession(width, height - 200);
}

float tickrate = 256;
float frameDelta = 1e3f / tickrate;
float now = millis();
float lastFrame = millis();

void draw() {
    float timeDelta = millis() - lastFrame;
    lastFrame = now;
    
    background(255);
    
    // Menu (Settings, Map Selector) ELLER Game Session (i et map)
    if (!startGame) {
        imageMode(CORNER);
        image(VIDEO_BG, 0, 0);
        gameMenu.startMenu();
        music.startTrack("menu");
    } else {
        if (startGame) {
            if (!gamePause) {
                music.stopTrack("menu");
            } else {
                music.stopTrack("2boss");
                music.stopTrack("1boss");
                music.startTrack("menu");
            }
            gameSession.draw();
            gameMenu.draw();
        }
    }
    
    // Always ensure music is playing
    music.tick();
    
    if (timeDelta < frameDelta) return;
    if (startGame && !gamePause) gameSession.tick();
    now = millis();
}

void movieEvent(Movie m) {
    m.read();
}

void keyPressed() { INP.keyPressed(); }
void keyReleased() { INP.keyReleased(); }
void mousePressed() { INP.mousePressed(); }
void mouseReleased() { INP.mouseReleased(); }
