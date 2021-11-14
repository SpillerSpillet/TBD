class Entity {
    float x, y;
    Hitbox hitbox;
    
    Entity(float initalX, float initalY, float w, float h, int t) {
        this.x = initalX;
        this.y = initalY;
        this.hitbox = new Hitbox(t, this.x, this.y, w, h);
    }
    
    void updatePos(float x, float y) {
        this.x = x;
        this.y = y;
        this.hitbox.update(x, y);
    }
    
    void updatePosOffset(float dx, float dy) {
        float nx = this.x + dx;
        float ny = this.y + dy;
        
        this.hitbox.update(nx, ny);
        // Hvis denne instance af entity rammer NOGET på banen eller dets vægge
        if (this.hitbox.collideWorld()) {
            // Extra gravity
            if (ny + this.hitbox.h > gameSession.h && this.y + this.hitbox.h < gameSession.h) {
                this.y += 1;
            }
            // Reset pos og IKKE bevæg sig
            this.hitbox.update(this.x, this.y);
        } else {
            // Ellers bevæg sig
            this.updatePos(nx, ny);
        }
    }
}


class Player extends Entity {
    int health = 3; // Start antal liv
    int lastJump = 0, lastMove = 0, lastInAir, lastHit = 2000;
    Animation walk, idle;
    float JUMP_TIME_MS = 500;
    float IDLE_TIME_MS = 500;
    float HIT_TIMER_MS = 1500;
    float speed = 3; // Spillerens fart
    ArrayList<PlayerSkud> skud;
    
    Player() {
        super(width / 4, height - (200 + SPRITE_PlayerWalk[0].height), SPRITE_PlayerWalk[0].width, SPRITE_PlayerWalk[0].height, 0);
        PImage[] idleFrame = { SPRITE_Player[0] };
        walk = new Animation(SPRITE_PlayerWalk, false);;
        idle = new Animation(idleFrame, true);
        skud = new ArrayList<PlayerSkud>();
    }
    
    void draw() {
        if (this.isIdle()) {
            this.idle.draw(this.x, this.y);
        } else {
            this.walk.draw(this.x, this.y);
        }
        
        for (int i = 0; i < skud.size(); i++) {
            skud.get(i).draw();
        }
    }
    
    boolean isIdle() {
        return(millis() - this.lastMove) > IDLE_TIME_MS;
    }
    
    void tick() {
        this.move();
        gameSession.setXOffset(this.x - width / 2);
        
        for (int i = this.skud.size() - 1; i >= 0; i--) {
            skud.get(i).tick();
            
            if (!skud.get(i).isActive) {
                skud.remove(i);
            }   
        }
    }
    
    void move() {  // W = OP ; A = VENSTRE ; S = NED ; D = HØJRE ;
        boolean[] wasd = INP.getWASD();
        
        boolean didMove = false;
        
        // Jump on SPACEBAR
        if (INP.inputMap.get(" ") && (millis() - this.lastJump) > JUMP_TIME_MS && this.y + this.hitbox.h == gameSession.h) {
            this.lastJump = millis();
        }
        // Get jump duration (max of 500ms)
        int jumpApex = millis() - this.lastJump;
        // If player is not in air reset last in air
        if (this.y + this.hitbox.h == gameSession.h) this.lastInAir = 0;
        // If still jumping keep adding upwards gravity (max of 500ms)
        if (jumpApex < JUMP_TIME_MS) this.updatePosOffset(0, -(10 * jumpApex / 1000));
        // If player is in air apply gravity
        if (this.y + this.hitbox.h < gameSession.h) {
            if (this.lastInAir == 0) this.lastInAir = millis();
            this.updatePosOffset(0, 5 * (millis() - this.lastInAir) / 1000);
        } 
        
        // W
        if (wasd[0] && this.lastInAir > 0) {
            this.updatePosOffset(0, -this.speed);
            didMove = true;
        }
        // A
        if (wasd[1]) {
            this.updatePosOffset( -this.speed, 0);
            this.walk.flip(true);
            didMove = true;
        }
        // S
        if (wasd[2] && this.lastInAir > 0) {
            this.updatePosOffset(0, this.speed);
            didMove = true;
        }
        // D
        if (wasd[3]) {
            this.updatePosOffset(this.speed, 0); 
            this.walk.flip(false); 
            didMove = true;
        }
        
        if (didMove) {
            if ((millis() - this.lastMove) > 100) {
                this.walk.nFrame();
                this.lastMove = millis();
            }
        }

        if (INP.mbLpressed()) {
            this.shoot();
        }
    }
    
    void shoot() {
        PVector d = new PVector(mouseX - this.x, mouseY - this.y);
        d.normalize();
        this.skud.add(new PlayerSkud(this.x, this.y, d.x, d.y));
    } 
    
    boolean isDead() {
        return health - 1 < 0;
    }    
    
    void takeDamage() {
        if (isDead() || (millis() - this.lastHit) < HIT_TIMER_MS) {
            return;
        }
        
        lastHit = millis();
        health -= 1;
    }
}

class PlayerSkud extends Entity {
    float dx, dy;
    boolean isActive = true;
    Animation spyt;
    float speed = 10;
    float damage = 1;
    
    
    PlayerSkud(float x, float y, float dx, float dy) {
        super(x, y, SKUD_spyt.width, SKUD_spyt.height, 1);
        this.dx = dx;
        this.dy = dy;
        PImage[] dsbFrames = { SKUD_spyt };
        this.spyt = new Animation(dsbFrames, false);
    }
    
    void draw() {
        this.spyt.draw(this.x, this.y);
    }
    
    void tick() {
        this.move();
    }
    
    void move() {
        this.updatePos(this.x + this.speed * this.dx, this.y + this.speed * this.dy);
        int[] bounce = this.hitbox.bounceScreen();
        if (bounce[0] < 0 || bounce[1] < 0) {
            this.isActive = false;
        }
    }
}

class BossSkud extends Entity {
    float dx, dy;
    boolean isActive = true;
    Animation dsb;
    float speed = 5;
    float damage = 1;
    
    
    BossSkud(float x, float y, float dx, float dy) {
        super(x, y, SKUD_dsb.width, SKUD_dsb.height, 1);
        this.dx = dx;
        this.dy = dy;
        PImage[] dsbFrames = { SKUD_dsb };
        this.dsb = new Animation(dsbFrames, false);
    }
    
    void draw() {
        this.dsb.draw(this.x, this.y);
    }
    
    void tick() {
        this.move();
    }
    
    void move() {
        this.updatePos(this.x + this.speed * this.dx, this.y + this.speed * this.dy);
        int[] bounce = this.hitbox.bounceScreen();
        if (bounce[0] < 0 || bounce[1] < 0) {
            this.isActive = false;
        }
    }
}

class Boss extends Entity {
    int health = 100;
    float dx = 2, dy = 4;
    float initialTime;
    int timeCount, lastHit;
    int atkITNVms = 3000;
    float antalSkud = 5, skudX = SPRITE_Boss[0].width / 2, skudY = SPRITE_Boss[0].height / 2;
    Animation boss;
    ArrayList<BossSkud> skud;
    
    Boss() {
        super(width - (width / 4), height - (200 + random(50, 75) + SPRITE_Boss[0].height), SPRITE_Boss[0].height, SPRITE_Boss[0].width, 1);
        this.initialTime = millis();
        this.timeCount = 0;
        this.boss = new Animation(SPRITE_Boss, false);
        skud = new ArrayList<BossSkud>();
    }
    
    void draw() {
        this.boss.draw(this.x, this.y);
        
        for (int i = 0; i < skud.size(); i++) {
            skud.get(i).draw();
        }
    }

    boolean isDead() {
        return health - 1 < 0;
    }

    void takeDamage() {
        if (isDead() || (millis() - this.lastHit) < 200) {
            return;
        }
        
        lastHit = millis();
        health -= 2;
    }
    
    void tick() {
        if (this.isDead()) return;
        if (this.health < 50) { 
            this.boss.setFrame(1); 
            atkITNVms = 2000;
            antalSkud = 10;
        }

        this.updatePos(this.x + this.dx, this.y + this.dy);
        int[] bounce = this.hitbox.bounceScreen();
        this.dx = bounce[0] * this.dx;
        this.dy = bounce[1] * this.dy;
        this.boss.flip(this.dy > 0 ? true : false);
        
        if (int((millis() - this.initialTime) / atkITNVms) > this.timeCount) {
            this.timeCount++;
            attack();
        }
        
        for (int i = this.skud.size() - 1; i >= 0; i--) {
            skud.get(i).tick();
            
            if (!skud.get(i).isActive) {
                skud.remove(i);
            }   
        }
    }
    void attack() {
        if (this.skud.size() > this.antalSkud * 2) {
            this.skud.clear();
        }

        for (int i = 0; i < this.antalSkud; ++i) {
            float t = (((i + 1)) * PI / (this.antalSkud > 7 ? 4 : 2));
            this.skud.add(new BossSkud(this.x + this.skudX, this.y + this.skudY, sin(t), cos(t)));
        }
    }
}

class WorldPart extends Entity {
    PImage texture;
    boolean collision = true;
    boolean relative = false;
    int min_offset = 0;
    int max_offset = 0;
    
    WorldPart(float x, float y, float w, float h, boolean collision, boolean relative) {
        super(x, y, w, h, 1);
        this.collision = collision;
        this.relative = relative;
    }
    
    void addTexture(PImage img) {
        img.resize((int)this.hitbox.w,(int)this.hitbox.h);
        this.texture = img;
    }
    
    void draw() {
        // if (!this.relative && (this.max_offset < gameSession.x_offset || this.min_offset > gameSession.x_offset)) return;
        
        float x = this.relative ? this.x - gameSession.x_offset : this.x;
        
        if (this.texture != null) {
            imageMode(CORNER);
            image(this.texture, x, this.y);
        } else {
            fill(255, 100, 0);
            rect(x, this.y, this.hitbox.w, this.hitbox.h);
        }
    }
    
    void tick() {
        this.updatePos(this.x, this.y);
    }
}