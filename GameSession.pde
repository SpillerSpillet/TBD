class GameSession {
    Player player1;
    Boss boss1;
    int w, h;
    int lc, lcTime;
    float x_offset; // Dimensions of the game
    ArrayList<WorldPart> world;
    boolean spawn_boss;

    GameSession (int w, int h) {
        this.w = w; 
        this.h = h;
        this.spawn_boss = true;
        this.x_offset = 0;
        this.lc = 0;
        this.lcTime = 0;

        world = new ArrayList<WorldPart>();
        
        player1 = new Player();
        boss1 = new Boss();

        /*WorldPart hall = new WorldPart(0 - width / 2, 0 + (this.h / 2), IMG_mapbg.width - (width / 2), this.h / 2, false, false);
        hall.addTexture(IMG_mapbg);
        hall.max_offset = 4750;
        hall.min_offset = 0;
        // world.add(hall);*/

        WorldPart bossroom = new WorldPart(0, 0, width, this.h, false, false);
        bossroom.addTexture(IMG_bg);
        bossroom.min_offset = 0;
        bossroom.max_offset = bossroom.min_offset + width;
        world.add(bossroom);
    }

    // Restart game session (Load UI etc.)
    void gameOver(boolean win){
        music.stopTrack("2boss");
        music.stopTrack("1boss");
        gameMenu.gameOver(win);
    }

    void setXOffset(float x){
        this.x_offset = x;
    }



    ArrayList<WorldPart> getWorld() {
        return this.world;
    }

    void tick() {
        if (player1.isDead()) {
            gameOver(false);
            return;
        } else if (boss1.isDead()) {
            gameOver(true);
            return;
        }

        // WorldPart hall = gameSession.world.get(0);
        WorldPart bossroom = gameSession.world.get(0);

        // hall.tick();
        bossroom.tick();

        player1.tick();

        /*if (bossroom.min_offset <= player1.x && player1.x <= bossroom.max_offset) {
            spawn_boss = true;
        }*/

        if (spawn_boss && !boss1.isDead()) {
           //  if (player1.x < hall.max_offset) player1.updatePos(hall.max_offset + 1, player1.y);
            boss1.tick();
            if (boss1.health < 50) {
                bossroom.addTexture(IMG_bg2);
                gameSession.world.set(0, bossroom);
                music.startTrack("2boss");
                music.stopTrack("1boss");
            } else {
                music.startTrack("1boss");
                music.stopTrack("2boss");
            }
        }

        // Collision detection
        if (player1.hitbox.doesCollide(boss1.hitbox)) {
            player1.takeDamage();
        }

        for (BossSkud s : boss1.skud) {
            if (player1.hitbox.doesCollide(s.hitbox)) {
                player1.takeDamage();
            }
        }

        for (PlayerSkud s : player1.skud) {
            if (boss1.hitbox.doesCollide(s.hitbox)) {
                boss1.takeDamage();
            }
        }
       /* if (gameSession.x_offset > hall.max_offset) {
            this.spawn_boss = true;
        }*/

        // Single game tick over.
    }

    void draw() {
        rectMode(CORNER);

        // Draw background / UI
        for (WorldPart part : world) {
            part.draw();
        }
        fill(0);
        rect(0, this.h, this.w, height);
        if (!player1.isDead()) image(SPRITE_HP[player1.health - 1], 200, this.h + 50);
        
        // Draw boss hp bar

        if (boss1.health < 25)
        {
            fill(255, 0, 0);
        }  
        else if (boss1.health < 50)
        {
            fill(255, 200, 0);
        }
        else
        {
            fill(0, 255, 0);
        }

        float drawWidth = ((float)boss1.health / 100f) * 400f;
        rect(width - 500, this.h + 75, drawWidth, 25);
        // Outline
        stroke(255);
        noFill();
        rect(width - 500, this.h + 75, 400, 25);

        textMode(CENTER);
        text(lines[lc], width / 2, this.h + 100);

        if (millis() - lcTime > 5000) {
            lc = (lc + 1) % (lines.length - 1);
            lcTime = millis();
        }

        if (!player1.isDead()) player1.draw();

        if (spawn_boss && !boss1.isDead()) {
            boss1.draw();
        }
    }
}
