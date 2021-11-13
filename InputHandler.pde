import java.util.Map;

class InputHandler {
    HashMap<String,Boolean> inputMap = new HashMap<String,Boolean>();

    InputHandler() {
        String[] k = new String[]{"MOUSE1", "MOUSE2", "w", "W", "a", "A", "s", "S", "d", "D", " "};
        for (String s : k) {
            inputMap.put(s, false);
        }
    }

    void mousePressed() {
        if (mouseButton == LEFT) {
            inputMap.put("MOUSE1", true);
        } 

        if (mouseButton == RIGHT) {
            inputMap.put("MOUSE2", true);
        }
    }

    void mouseReleased() {
        if (mouseButton == LEFT) {
            inputMap.put("MOUSE1", false);
        } 

        if (mouseButton == RIGHT) {
            inputMap.put("MOUSE2", false);
        }
    }

    void keyPressed() {
        inputMap.put(Character.toString(key), true);
    }

    void keyReleased() {
        inputMap.put(Character.toString(key), false);
    }

    boolean[] getWASD() {
        boolean[] wasd = new boolean[4];  // W = OP ; A = VENSTRE ; S = NED ; D = HØJRE ;
        wasd[0] = inputMap.get("w") || inputMap.get("W");
        wasd[1] = inputMap.get("a") || inputMap.get("A");
        wasd[2] = inputMap.get("s") || inputMap.get("S");
        wasd[3] = inputMap.get("d") || inputMap.get("D");
        return wasd;
    }

    boolean mbLpressed() {
        return inputMap.get("MOUSE1");
    }

    boolean mbRpressed() {
        return inputMap.get("MOUSE2");
    }

    boolean mbPressed() {
        return mbLpressed() || mbRpressed();
    }
}