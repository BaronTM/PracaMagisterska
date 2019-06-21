package apk;

import javafx.beans.property.BooleanProperty;
import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleBooleanProperty;
import lombok.Getter;
import lombok.Setter;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseEvent;
import java.awt.event.MouseListener;
import java.awt.event.MouseMotionAdapter;
import java.util.Arrays;
import java.util.concurrent.atomic.AtomicInteger;

public class MySlider extends JButton {

    private ImageIcon imageIcon;
    private int maxX;
    private int maxY;
    private int minX;
    private int minY;
    private int xx;
    private int yy;
    private IntegerProperty hProperty;
    private IntegerProperty vProperty;
    @Getter @Setter
    private BooleanProperty bProperty;


    public MySlider(ImageIcon img, Color backCol, int maxXX, int maxYY, int minXX, int minYY) {
        super();
        this.imageIcon = img;
        this.maxX = maxXX;
        this.maxY = maxYY;
        this.minX = minXX;
        this.minY = minYY;
        this.setIcon(imageIcon);
        this.setBackground(backCol);
        this.setBorderPainted(false);
        this.setBounds(maxX , maxY, imageIcon.getIconWidth(), imageIcon.getIconHeight());
        enableMovingListener(true);
        bProperty = new SimpleBooleanProperty(false);
    }

    public void moveV(int i) {
        int y = this.getY() + i;
        setSliderPositionY(y);
        if (vProperty != null) {
            vProperty.set(maxY - this.getY());
        }
    }

    public void moveH(int i) {
        int x = this.getX() + i;
        setSliderPositionX(x);
        if (hProperty != null) {
            hProperty.set(this.getX() - minX);
        }
    }

    private void sliderMousePressed(java.awt.event.MouseEvent evt) {
        if (hProperty != null) {
            hProperty.unbind();
        }
        if (vProperty != null) {
            vProperty.unbind();
        }
        if (bProperty != null) {
            bProperty.setValue(false);
        }
        xx=evt.getX();
        yy=evt.getY();
    }

    private void sliderMouseDragged(java.awt.event.MouseEvent evt) {
        int x=evt.getX();
        int y=evt.getY();
        moveV(y - yy);
        moveH(x - xx);
    }

    public void enableMovingListener(boolean b) {
        if (b) {
            this.addMouseListener(new MouseListener() {
                @Override
                public void mouseClicked(MouseEvent e) {

                }

                @Override
                public void mousePressed(MouseEvent e) {
                    sliderMousePressed(e);
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
                    sliderMouseDragged(e);
                }
            });
        } else {
            Arrays.stream(this.getMouseListeners()).forEach(e -> this.removeMouseListener(e));
            Arrays.stream(this.getMouseMotionListeners()).forEach(e -> this.removeMouseMotionListener(e));
        }
    }

    public void setAutimaticHBinding(IntegerProperty integerProperty) {
        this.hProperty = integerProperty;
        int xPos = minX + integerProperty.get();
        setSliderPositionX(xPos);
        hProperty.addListener((observable, oldValue, newValue) -> {
            int x = minX + newValue.intValue();
            setSliderPositionX(x);
        });
    }

    public void setAutimaticVBinding(IntegerProperty integerProperty) {
        this.vProperty = integerProperty;
        int yPos = maxY - integerProperty.get();
        setSliderPositionY(yPos);
        vProperty.addListener((observable, oldValue, newValue) -> {
            int y = maxY - newValue.intValue();
            setSliderPositionY(y);
        });
    }

    private void setSliderPositionX(int x) {
        if (x < minX) {
            this.setLocation(minX, this.getY());
        } else if (x > maxX) {
            this.setLocation(maxX, this.getY());
        } else {
            this.setLocation(x, this.getY());
        }
    }

    private void setSliderPositionY(int y) {
        if (y < minY) {
            this.setLocation(this.getX(), minY);
        } else if (y > maxY) {
            this.setLocation(this.getX(), maxY);
        } else {
            this.setLocation(this.getX(), y);
        }
    }

}
