
class GameSession {
    Player player1;
    Boss boss1;
    int w, h;
    float x_offset; // Dimensions of the game
    ArrayList<WorldPart> world;

    GameSession (int w, int h) {
        this.w = w; 
        this.h = h;
        this.x_offset = 0;

        world = new ArrayList<WorldPart>();
        
        player1 = new Player();
        boss1 = new Boss(this.w/2, this.h/2);

        WorldPart map = new WorldPart(0, 0 + (this.h / 2), IMG_mapbg.width, this.h / 2, false);
        map.addTexture(IMG_mapbg);
        world.add(map);
    }

    // Restart game session (Load UI etc.)
    void gameOver(){

    }

    void setXOffset(float x){
        this.x_offset = x;
    }



    ArrayList<WorldPart> getWorld() {
        return this.world;
    }

    void tick() {
        if (player1.isDead()) {
            gameOver();
        }

        for (WorldPart part : world) {
            part.tick();
        }

        player1.tick();
        boss1.tick();

        // Single game tick over.
    }

    void draw() {
        rectMode(CORNER);

        // Draw background / UI
        pushMatrix();
        fill(0);
        rect(0, this.h, this.w, height);
        if (!player1.isDead()) image(SPRITE_HP[player1.health - 1], 200, this.h + 50);
        popMatrix();

        for (WorldPart part : world) {
            part.draw();
        }

        player1.draw();
        boss1.draw();
    }

}