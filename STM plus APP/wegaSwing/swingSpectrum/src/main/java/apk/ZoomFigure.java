package apk;

import lombok.Getter;
import lombok.Setter;

import javax.swing.*;
import java.awt.*;

public class ZoomFigure extends JPanel {

    private int[] lines;
    private int length;
    @Getter @Setter
    private int yellowStripeWidth;
    @Setter @Getter
    private SamplesSet samplesSet;
    private Color backColor;

    public ZoomFigure(int length) {
        super();
        this.setLayout(null);
        backColor = new Color(0, 100, 0);
//        backColor = new Color(100, 100, 255);
        this.setBackground(backColor);
        this.setBounds(914,308, 180, 180);
        this.length = length;
        yellowStripeWidth = 9;
        lines = new int[length];
    }

    synchronized public void setValues(int[] samples) {
        if (length == samples.length) {
                lines = samples;
                this.repaint();
        } this.repaint();
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;
        g2d.setColor(backColor);
        g2d.drawRect(0, 0, this.getWidth(), this.getHeight());

        int h = this.getHeight();

        g2d.setColor(new Color(178,178,178));
        g2d.drawLine(90, 0, 90, 15);

        g2d.setColor(new Color(255,255,0));

        for (int i = 0; i < lines.length; i++) {
            g2d.drawLine(i, h, i, (h - lines[i]));
        }
    }




}
