Movie VIDEO_BG;

MusicTrack MT_1boss;
MusicTrack MT_2boss;
MusicTrack MT_intro;
MusicTrack MT_main;

String[] lines;

PImage IMG_bg;
PImage IMG_bg2;
PImage IMG_mapbg;
PImage IMG_Win;
PImage IMG_Loss;
PImage[] SPRITE_HP = new PImage[3];
PImage[] SPRITE_Player = new PImage[4];
PImage[] SPRITE_PlayerWalk = new PImage[6];
PImage[] SPRITE_Boss = new PImage[2];
PImage BUTTON_ExitBright;
PImage BUTTON_ExitDark;
PImage BUTTON_RestartBright;
PImage BUTTON_RestartDark;
PImage BUTTON_ResumeBright;
PImage BUTTON_ResumeDark;
PImage BUTTON_StartBright;
PImage BUTTON_StartDark;
PImage SKUD_dsb;
PImage SKUD_spyt;
PImage IMG_logo;

PImage resizeByFactor(PImage img, float factor) {
    img.resize((int)(img.width * factor),(int)(img.height * factor));
    return img;
}

void loadMusic() {
    MT_1boss = new MusicTrack("1boss", this, "assets/1halvdelBoss.wav", false);
    MT_2boss = new MusicTrack("2boss", this, "assets/2halvdelBoss.wav", false);
    MT_intro = new MusicTrack("intro", this, "assets/IntroBossMusic.wav", false);
    MT_main = new MusicTrack("menu", this, "assets/MainMenuMusic.wav", false);
}

void loadImages() {
    SPRITE_HP[0] = resizeByFactor(loadImage("assets/Hp01.png"), 2);
    SPRITE_HP[1] = resizeByFactor(loadImage("assets/Hp02.png"), 2);
    SPRITE_HP[2] = resizeByFactor(loadImage("assets/Hp03.png"), 2);
    
    SPRITE_Player[0] = resizeByFactor(loadImage("assets/sprites/player/idle.png"), 2); // Idle
    SPRITE_Player[1] = resizeByFactor(loadImage("assets/sprites/player/1.png"), 2); // Walk no movement
    SPRITE_Player[2] = resizeByFactor(loadImage("assets/sprites/player/2-1.png"), 2); // Walk 1
    SPRITE_Player[3] = resizeByFactor(loadImage("assets/sprites/player/2-2.png"), 2); // Walk 2
    
    SPRITE_PlayerWalk[0] = resizeByFactor(loadImage("assets/sprites/player/walk0001.png"), 2); // Walk 1
    SPRITE_PlayerWalk[1] = resizeByFactor(loadImage("assets/sprites/player/walk0002.png"), 2); // Walk 2
    SPRITE_PlayerWalk[2] = resizeByFactor(loadImage("assets/sprites/player/walk0003.png"), 2); // Walk 3
    SPRITE_PlayerWalk[3] = resizeByFactor(loadImage("assets/sprites/player/walk0004.png"), 2); // Walk 4
    SPRITE_PlayerWalk[4] = resizeByFactor(loadImage("assets/sprites/player/walk0005.png"), 2); // Walk 5
    SPRITE_PlayerWalk[5] = resizeByFactor(loadImage("assets/sprites/player/walk0006.png"), 2); // Walk 6
    
    SPRITE_Boss[0] = resizeByFactor(loadImage("assets/sprites/characters/MikkeBoss.png"), 4);
    SPRITE_Boss[1] = resizeByFactor(loadImage("assets/sprites/characters/MikkeDevil.png"), 4);
    
    IMG_Win = loadImage("assets/YouWIn.png");
    IMG_Loss = loadImage("assets/GameOver.png");

    IMG_bg = loadImage("assets/bg.png");
    IMG_bg.resize(width, height);
    
    IMG_bg2 = loadImage("assets/bg2.png");
    IMG_bg2.resize(width, height);
    
    IMG_mapbg = loadImage("assets/map_bg.png");
    
    IMG_logo = loadImage("assets/logo.png");
    
    SKUD_spyt = loadImage("assets/spitball.png");
    SKUD_dsb = resizeByFactor(loadImage("assets/dsb.png"), 0.1);
    
    BUTTON_ExitBright = loadImage("assets/sprites/buttons/Exit-Bright.png");
    BUTTON_ExitDark = loadImage("assets/sprites/buttons/Exit-Dark.png");
    BUTTON_RestartBright = loadImage("assets/sprites/buttons/Restart-Bright.png");
    BUTTON_RestartDark = loadImage("assets/sprites/buttons/Restart-Dark.png");
    BUTTON_ResumeBright = loadImage("assets/sprites/buttons/Resume-Bright.png");
    BUTTON_ResumeDark = loadImage("assets/sprites/buttons/Resume-Dark.png");
    BUTTON_StartBright = loadImage("assets/sprites/buttons/Start-Bright.png");
    BUTTON_StartDark = loadImage("assets/sprites/buttons/Start-Dark.png");
}
void loadAssets() {
    loadMusic();
    loadImages();
    lines = loadStrings("assets/lines.txt");
}
