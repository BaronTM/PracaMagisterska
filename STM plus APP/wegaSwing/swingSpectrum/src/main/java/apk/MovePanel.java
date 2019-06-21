package apk;

import javax.swing.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionAdapter;

public class MovePanel extends JPanel {

    private int xx;
    private int yy;
    private JFrame frame;

    public MovePanel(JFrame frame) {
        super();
        this.frame =frame;
        xx = 0;
        yy = 0;

        this.addMouseListener(new MouseListener() {
            @Override
            public void mouseClicked(MouseEvent e) {

            }

            @Override
            public void mousePressed(MouseEvent e) {
                jPanel1MousePressed(e);
            }

            @Override
            public void mouseReleased(MouseEvent e) {

            }

            @Override
            public void mouseEntered(MouseEvent e) {

            }

            @Override
            public void mouseExited(MouseEvent e) {

            }
        });

        this.addMouseMotionListener(new MouseMotionAdapter() {
            @Override
            public void mouseDragged(MouseEvent e) {
                super.mouseDragged(e);
                jPanel1MouseDragged(e);
            }
        });

    }

    private void jPanel1MousePressed(java.awt.event.MouseEvent evt) {
        xx=evt.getX();
        yy=evt.getY();
    }

    private void jPanel1MouseDragged(java.awt.event.MouseEvent evt) {
        int x=evt.getXOnScreen();
        int y=evt.getYOnScreen();
        frame.setLocation(x-xx, y-yy);
    }

}
