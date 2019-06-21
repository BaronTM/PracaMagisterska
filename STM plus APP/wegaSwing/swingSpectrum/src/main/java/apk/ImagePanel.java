package apk;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionAdapter;

class ImagePanel extends JPanel {

    private Image img;
    private int xx;
    private int yy;

    public ImagePanel(String img) {
        this(new ImageIcon(img).getImage());
    }

    public ImagePanel(Image img) {

        this.img = img;

    }

    public void paintComponent(Graphics g) {
        g.drawImage(img, 0, 0, null);
    }

}