/*
Load / Serve fra disk til memory on-demand
*/

MusicTrack MT_1boss;
MusicTrack MT_2boss;
MusicTrack MT_intro;
MusicTrack MT_main;

PImage IMG_bg;
PImage IMG_mapbg;
PImage[] SPRITE_HP = new PImage[3];
PImage[] SPRITE_Player = new PImage[4];
PImage[] SPRITE_Boss = new PImage[1];

void loadMusic() {
    MT_1boss = new MusicTrack("1boss", this, "assets/1halvdelBoss.wav", false);
    MT_2boss = new MusicTrack("2boss", this, "assets/2halvdelBoss.wav", false);
    MT_intro = new MusicTrack("intro", this, "assets/IntroBossMusic.wav", false);
    MT_main = new MusicTrack("menu", this, "assets/MainMenuMusic.wav", false);
}

void loadImages() {
    SPRITE_HP[0] = loadImage("assets/Hp01.png");
    SPRITE_HP[1] = loadImage("assets/Hp02.png");
    SPRITE_HP[2] = loadImage("assets/Hp03.png");

    SPRITE_Player[0] = loadImage("assets/sprites/player/idle.png"); // Idle
    SPRITE_Player[1] = loadImage("assets/sprites/player/1.png"); // Walk no movement
    SPRITE_Player[2] = loadImage("assets/sprites/player/2-1.png"); // Walk 1
    SPRITE_Player[3] = loadImage("assets/sprites/player/2-2.png"); // Walk 2

    SPRITE_Boss[0] = loadImage("assets/sprites/characters/MikkeBoss.png");

    IMG_bg = loadImage("assets/bg.png");
    IMG_bg.resize(width, height);

    IMG_mapbg = loadImage("assets/map_bg.png");
}


void loadAssets() {
    loadMusic();
    loadImages();
}