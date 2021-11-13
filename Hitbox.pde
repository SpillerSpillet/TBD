class Hitbox {
    int type; // 0 = ellipse, 1 = rectangle
    float x, y, w, h;

    Hitbox(int type, float x, float y, float w, float h) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h;
        this.type = type;
    }

    void update (float x, float y) {
        this.x = x;
        this.y = y;
    }

    int[] bounceScreen() {
        int[] bounceM = new int[3]; // Consists of -1 and +1 for each axis then a final boolean value indicating if the hitbox has collided with the world
        bounceM[0] = this.x > gameSession.w - this.w || this.x < 0 ? -1 : 1; // Bounce X
        bounceM[1] = this.y > gameSession.h - this.h || this.y < 0 ? -1 : 1; // Bounce Y
        bounceM[2] = bounceM[0] + bounceM[1] < 2 ? 0 : 1;

        // Bounce all entities on the map
        for (WorldPart b : gameSession.world) {
            if (!b.collision) continue;
            int[] bounce = this.bounceHitbox(b.hitbox);
            if (bounce[2] == 1) {
                bounceM[0] *= bounce[0];
                bounceM[1] *= bounce[1];
                bounceM[2] = bounce[2];
            }
        }

        return bounceM;
    }

    int[] bounceHitbox(Hitbox other) {
        int[] bounceM = new int[3]; // Consists of -1 and +1 for each axis then a final boolean value indicating if the hitbox has collided with the world
        boolean collide = this.doesCollideRR(this.x, this.y, this.w, this.h, other.x, other.y, other.w, other.h);
        bounceM[0] = collide ? -1 : 1;
        bounceM[1] = collide ? -1 : 1;
        bounceM[2] = collide ? 1 : 0;
        return bounceM;
    }

    boolean collideWorld() {
        if (this.x + this.w > gameSession.w + gameSession.world.get(0).texture.width || this.x < 0 || this.y + this.h > gameSession.h || this.y < 0) {
            return true;
        }

        // Collide with everything
        for (WorldPart b : gameSession.world) {
            if (!b.collision) continue;
            if (this.doesCollideRR(this.x, this.y, this.w, this.h, b.hitbox.x, b.hitbox.y, b.hitbox.w, b.hitbox.h)) {
                return true;
            }
        }

        return false;
    }

    // For ellipses use smallest radius
    boolean doesCollideCR (float cx, float cy, float radius, float rx, float ry, float rw, float rh) {
        // Get distance from closest edges
        float distX = cx - ( cx < rx ? rx : (cx > rx + rw) ? rx + rw : cx );
        float distY = cy- ( cy < ry ? ry : (cy > ry + rh) ? ry + rh : cy );
        // if the distance is less than the radius, collision!
        return sqrt( (distX*distX) + (distY*distY) ) <= radius;
    }

    boolean doesCollideRR (float ax, float ay, float aw, float ah, float bx, float by, float bw, float bh) {
        return !(ax + aw < bx || bx + bw < ax || ay + ah < by || by + bh < ay);
    }

    boolean doesCollideCC (float ax, float ay, float ar, float bx, float by, float br) {
        // Check if two circles collide
        float dx = ax - bx;
        float dy = ay - by;
        return sqrt(dx*dx + dy*dy) < ar + br;
    }

    boolean doesCollide (Hitbox other) {
        if (this.type != 1) {
            if (other.type != 1) {
                return doesCollideCC(this.x, this.y, (this.w < this.h ? this.w : this.h), other.x, other.y, (other.w > other.h ? other.w : other.h));
            } else {
                return doesCollideCR(this.x, this.y, (this.w < this.h ? this.w : this.h), other.x, other.y, other.w, other.h);
            }
        } else {
            if (other.type != 1) {
                return doesCollideCR(other.x, other.y, (other.w < other.h ? other.w : other.h), this.x, this.y, this.w, this.h);
            } else {
                return doesCollideRR(this.x, this.y, this.w, this.h, other.x, other.y, other.w, other.h);
            }
        }
    }
}