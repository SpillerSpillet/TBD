import processing.sound.*;

class MusicTrack extends SoundFile {
    float lastPlayedAt;
    boolean reset;
    boolean loop;
    String name;

    MusicTrack(String name, PApplet parent, String path, boolean loop) {
        super(parent, path);
        this.name = name;
        this.reset = true;
        this.loop = loop;
        this.setVolume(0.1f); // Default 10%
    }

    void reset() {
        this.reset = true;
    }

    void playOnce() {
        this.lastPlayedAt = millis(); 
        this.play();
    }

    void tick() {
        if (!this.loop) return;

        if (this.reset) {
            this.playOnce();
            this.reset = false;
            this.lastPlayedAt = millis();
        }

        if (millis() - this.lastPlayedAt > this.duration() * 1000) {
            this.playOnce();
        }
    }

    void setVolume(float volume) {
        this.amp(volume);
    }

    void restart() {
        this.reset = true;
    }

    void start() {
        this.loop = true;
    }

    void stop() {
        this.loop = false;
        super.stop();
    }
}


class Music {
    ArrayList<MusicTrack> tracks;

    public Music() {
        tracks = new ArrayList<MusicTrack>();
        tracks.add(MT_1boss);
        tracks.add(MT_2boss);
        tracks.add(MT_intro);
        tracks.add(MT_main);
    }
    
    void addTrack(String name, PApplet parent, String path) {
        tracks.add(new MusicTrack(name, parent, path, false));
    }

    void tick() {
        for (MusicTrack t : this.tracks) {
            t.tick();
        }
    }

    void stopTrack(String name) {
        for (MusicTrack t : this.tracks) {
            if (t.name.equals(name)) {
                t.stop();
            }
        }
    }

    void startTrack(String name) {
        for (MusicTrack t : this.tracks) {
            if (t.name.equals(name)) {
                t.start();
            }
        }
    }
}
