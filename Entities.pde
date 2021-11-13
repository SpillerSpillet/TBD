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
    
    void gravity(float t) {

    }
}


class Player extends Entity {
    int health = 3; // Start antal liv
    int lastJump = 0, lastMove = 0, lastInAir;
    Animation walk, idle;
    float JUMP_TIME_MS = 500;
    float IDLE_TIME_MS = 500;
    float speed = 2; // Spillerens fart
    
    Player() {
        super(width / 2, height - (200 + SPRITE_Player[0].height), 50, SPRITE_Player[0].height, 0);
        PImage[] idleFrame = { SPRITE_Player[0] };
        PImage[] walkFrames = { SPRITE_Player[1], SPRITE_Player[2], SPRITE_Player[3] };
        walk = new Animation(walkFrames, false);
        idle = new Animation(idleFrame, true);
    }
    
    void draw() {
        if (this.isIdle()) {
            this.idle.draw(width / 2, this.y);
        } else {
            this.walk.draw(width / 2, this.y);
        }
    }

    boolean isIdle() {
        return (millis() - this.lastMove) > IDLE_TIME_MS;
    }
    
    void tick() {
        this.move();
        gameSession.setXOffset(this.x - width / 2);
        println(gameSession.x_offset);
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
            this.updatePosOffset(-this.speed, 0);
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
            this.lastMove = millis();
            // Don't change frame mid air
            if (!(this.lastInAir > 0)) this.walk.nFrame();
        }
    }
    
    void shoot() {
        
    } 
    
    boolean isDead() {
        return health <= 0;
    }
    

    void damageTaken() {
        if (isDead()) {
            return;
        }
        health -= 1;
    }
}

class BossSkud extends Entity {
    float x, y, dx, dy;
    boolean isActive = true;
    float speed = 5;
    float damage = 1;


    BossSkud(float x, float y, float dx, float dy) {
        super(x, y, 10, 10, 1);
        this.dx = dx;
        this.dy = dy;
    }

    void draw() {
        fill(255, 0, 0);
        ellipse(this.x, this.y, 10, 10);
    }

    void tick() {
        this.move();
    }

    void move() {
        this.updatePosOffset(this.dx, this.dy);
        int[] bounce = this.hitbox.bounceScreen();
        
        if (bounce[0] < 0 || bounce[1] < 0) {
            this.isActive = false;
        }
    }
}

class Boss extends Entity {
    float dx = 1, dy = 1;
    float initialTime;
    int timeCount;
    int atkITNVms = 3000;
    float antalSkud = 0, skudX = 0, skudY = 0;
    Animation idle;
    ArrayList<BossSkud> skud;

    Boss(float x, float y) {
        super(x, y, 44, 60, 1);
        this.initialTime = millis();
        this.timeCount = 0;
        this.idle = new Animation(SPRITE_Boss, true);
        skud = new ArrayList<BossSkud>();
    }

    void draw() {
        this.idle.draw(this.x, this.y);
        
        for (int i = 0; i < skud.size(); i++) {
            skud.get(i).draw();
        }
    }

    void tick() {
        this.updatePos(this.x + this.dx, this.y + this.dy);
        int[] bounce = this.hitbox.bounceScreen();
        this.dx = bounce[0] * this.dx;
        this.dy = bounce[1] * this.dy;
        this.idle.flip(this.dy > 0 ? true : false);

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
        for (int i = 0; i < this.antalSkud; ++i) {
            float t = (i * PI / 4);
            this.skud.add(new BossSkud(this.x + this.skudX, this.y + this.skudY, sin(t), cos(t)));
        }
    }
}

class WorldPart extends Entity {
    PImage texture;
    boolean collision = true;

    WorldPart(float x, float y, float w, float h, boolean collision) {
        super(x, y, w, h, 1);
        this.collision = collision;
    }

    void addTexture(PImage img) {
        img.resize((int)this.hitbox.w,(int)this.hitbox.h);
        this.texture = img;
    }

    void draw() {
        fill(255, 100, 0);
        rect(this.x, this.y, this.hitbox.w, this.hitbox.h);
        if (this.texture != null) {
            image(this.texture, (this.x - gameSession.x_offset) % this.texture.width, this.y);
        }
    }

    void tick() {
        this.updatePos(this.x, this.y);
    }
}