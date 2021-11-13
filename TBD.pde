boolean gamePause = false; boolean startGame = false;
InputHandler INP = new InputHandler();
GameMenu gameMenu = new GameMenu();
GameSession gameSession;
Music music;

void setup() {
    fullScreen();
    frameRate(100000);
    loadAssets();
    music = new Music();
    gameSession = new GameSession(width, height - 200);
}

float fps = 256;
float frameDelta = 1e3f/fps;
float now = millis();
float lastFrame = millis();

void draw() {
    float timeDelta = millis() - lastFrame;
    lastFrame = now;
    if (timeDelta < frameDelta) return;

    // Blank canvas
    background(IMG_bg);
    
    // Menu (Settings, Map Selector) ELLER Game Session (i et map)
    if (!startGame) {
        gameMenu.startMenu();
        music.startTrack("menu");
    }

    if (startGame) {
        if (!gamePause) {
            music.stopTrack("menu");
            gameSession.tick();
        } else {
            music.startTrack("menu");
        }
        gameSession.draw();
        gameMenu.menu();
    }

    // Always ensure music is playing
    music.tick();

    now = millis();
}

void keyPressed() { INP.keyPressed(); }
void keyReleased() { INP.keyReleased(); }
void mousePressed() { INP.mousePressed(); }
void mouseReleased() { INP.mouseReleased(); }
