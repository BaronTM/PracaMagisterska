package apk;

import lombok.Getter;
import lombok.Setter;

import javax.swing.*;
import java.awt.*;
import java.awt.geom.Rectangle2D;

public class Figure extends JPanel {

    private Assistant assistant;
    private int[] lines;
    private int length;
    @Getter @Setter
    private int yellowStripeWidth;
    @Setter @Getter
    private SamplesSet samplesSet;


    public Figure(int length, Assistant assistant) {
        super();
        this.assistant = assistant;
        this.setLayout(null);
        this.setBackground(Color.WHITE);
        this.setBounds(84,532, 1024, 190);
        this.length = length;
        yellowStripeWidth = 9;
        lines = new int[length];
    }

    synchronized public void setValues(int[] samples) {
        if (length == samples.length) {
                lines = samples;
                this.repaint();
        }
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        Graphics2D g2d = (Graphics2D) g;
        g2d.clearRect(0, 0, this.getWidth(), this.getHeight());

        int yelPos = samplesSet.getMaxIdPropertyInt().get();
        int h = this.getHeight();

        if (!assistant.getOsciloscopeMode().get()) {
            g2d.setColor(new Color(178,178,178));
            g2d.drawLine(333, h, 333, 0);
            for (int i = 1; i < 15; i++) {
                g2d.drawLine(333 - i, h, 333 - i, 0);
                g2d.drawLine(333 + i, h, 333 + i, 0);
            }
        }

        g2d.setColor(new Color(255,255,0));
        g2d.drawLine(yelPos, h, yelPos, 0);
        for (int i = 1; i < yellowStripeWidth / 2; i++) {
            g2d.drawLine(yelPos - i, h, yelPos - i, 0);
            g2d.drawLine(yelPos + i, h, yelPos + i, 0);
        }

        g2d.setColor(new Color(33,130,55));

        for (int i = 0; i < lines.length; i++) {
            g2d.drawLine(i, h, i, (h - lines[i]));
        }
    }




}
