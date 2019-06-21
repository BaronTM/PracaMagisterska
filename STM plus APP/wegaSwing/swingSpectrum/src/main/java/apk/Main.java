package apk;

import lombok.Getter;

import javax.swing.*;
import java.awt.event.KeyEvent;
import java.awt.event.KeyListener;

public class Main {

    @Getter
    public static Main main;

    private JFrame ramka;
    private JPanel backgroundPanel;
    @Getter
    private JPanel mainPanel;
    @Getter
    private JPanel additionalPanel;
    @Getter
    private static Assistant assistant;
    @Getter
    private Thread thread;
    @Getter
    private int frameWidth;
    @Getter
    private int frameHeight;

    private volatile boolean isShown;
    private ImageIcon showRightIconR;
    private ImageIcon showRightIconL;

    private JButton showRight;
    private JButton exitBut;
    private MySlider sliderRed;
    private MySlider sliderGreen;
    private MySlider sliderYellow;
    private MySlider pointerGreen;

    private MovePanel movePanel;



    public void start() {
        frameWidth = 1136;
        frameHeight = 851;
        ramka = new JFrame("WEGA Spectrum");
        ramka.setUndecorated(true);
        ramka.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        ramka.setSize(frameWidth, frameHeight);
        ramka.getContentPane().setLayout(null);

        backgroundPanel = new JPanel();
        backgroundPanel.setLayout(null);
        backgroundPanel.setBounds(0, 0, 1500, ramka.getHeight());

        mainPanel = new ImagePanel(new ImageIcon(Main.class.getResource("/view/wega_pulpit.png")).getImage());
        mainPanel.setLayout(null);
        mainPanel.setBounds(0, 0, 1136, ramka.getHeight());

        additionalPanel = new JPanel();
        additionalPanel.setLayout(null);
        additionalPanel.setBounds(mainPanel.getWidth(), 0, 350, mainPanel.getHeight());
        isShown = false;

        movePanel = new MovePanel(ramka);
        movePanel.setBounds(0, 0, frameWidth, 300);

        assistant = new Assistant(this);
        ETHServerUDP ethServer = new ETHServerUDP();
        assistant.setEthServer(ethServer);

        showRight = new JButton();
        showRightIconR = new ImageIcon(Main.class.getResource("/view/but1.png"));
        showRightIconL = new ImageIcon(Main.class.getResource("/view/but2.png"));
        showRight.setIcon(showRightIconR);
        showRight.setBorderPainted(false);
        showRight.setBounds(1100, 400, showRight.getIcon().getIconWidth(), showRight.getIcon().getIconHeight());

        exitBut = new JButton();
        exitBut.setIcon(new ImageIcon(Main.class.getResource("/view/exit.png")));
        exitBut.setBackground(assistant.getBackgroundColor());
        exitBut.setBorderPainted(false);
        exitBut.setBounds(additionalPanel.getWidth() - 82, 10, exitBut.getIcon().getIconWidth(), exitBut.getIcon().getIconHeight());

        sliderRed = new MySlider(new ImageIcon(Main.class.getResource("/view/sliderRed.png")),
                assistant.getBackgroundColor(), 72, 524 + 190, 72, 524);
        sliderRed.setAutimaticVBinding(assistant.getSamplesSet().getArwPxPropertyInt());

        sliderGreen = new MySlider(new ImageIcon(Main.class.getResource("/view/sliderGreen.png")),
                assistant.getBackgroundColor(), 1100, 724, 76, 724);
        sliderGreen.setAutimaticHBinding(assistant.getSamplesSet().getFollowPropertyInt());
        sliderGreen.getBProperty().bindBidirectional(assistant.getAccurateFollowing());

        pointerGreen = new MySlider(new ImageIcon(Main.class.getResource("/view/wsk.png")),
                assistant.getBackgroundColor(), 1092, 523, 68, 523);
        pointerGreen.setAutimaticHBinding(assistant.getSamplesSet().getFollowPropertyInt());
        pointerGreen.enableMovingListener(false);

        sliderYellow = new MySlider(new ImageIcon(Main.class.getResource("/view/sliderYellow.png")),
                assistant.getBackgroundColor(), 1092, 778, 68, 778);
        sliderYellow.enableMovingListener(false);
        sliderYellow.setAutimaticHBinding(assistant.getSamplesSet().getMaxIdPropertyInt());

        showRight.addActionListener(l -> {
            if (!isShown) {
                isShown = true;
                ramka.setSize(ramka.getWidth() + 350, ramka.getHeight());
                showRight.setIcon(showRightIconL);
            } else {
                isShown = false;
                ramka.setSize(ramka.getWidth() - 350, ramka.getHeight());
                showRight.setIcon(showRightIconR);
            }
        });

        exitBut.addActionListener(l -> {
            thread.stop();
            System.exit(0);
        });


        sliderRed.addKeyListener(new KeyListener() {
            @Override
            public void keyTyped(KeyEvent e) {

            }

            @Override
            public void keyPressed(KeyEvent e) {
                int code = e.getKeyCode();
                if (code == 38) {
                    sliderRed.moveV(-10);
                } else if (code == 40) {
                    sliderRed.moveV(10);
                } else if (code == 39) {
                    assistant.getSamplesSet().getFollowPropertyInt().unbind();
                    sliderGreen.moveH(10);
                    assistant.getAccurateFollowing().setValue(false);
                } else if (code == 37) {
                    assistant.getSamplesSet().getFollowPropertyInt().unbind();
                    sliderGreen.moveH(-10);
                    assistant.getAccurateFollowing().setValue(false);
                } else if (code == 32) {
                    assistant.getSamplesSet().getFollowPropertyInt().bind(assistant.getSamplesSet().getMaxIdPropertyInt());
                    assistant.getAccurateFollowing().setValue(true);
                } else if (code == 10) {
                    assistant.getSamplesSet().setArw(!assistant.getSamplesSet().isArw());
                }
            }

            @Override
            public void keyReleased(KeyEvent e) {

            }
        });
        sliderGreen.addKeyListener(sliderRed.getKeyListeners()[0]);





        backgroundPanel.add(mainPanel);
        backgroundPanel.add(movePanel);
        backgroundPanel.add(additionalPanel);
        mainPanel.add(showRight);
        mainPanel.add(sliderRed);
        mainPanel.add(sliderGreen);
        mainPanel.add(pointerGreen);
        mainPanel.add(sliderYellow);
        additionalPanel.add(exitBut);

        backgroundPanel.setBackground(assistant.getBackgroundColor());
        additionalPanel.setBackground(assistant.getBackgroundColor());
        mainPanel.setBackground(assistant.getBackgroundColor());
        ramka.setBackground(assistant.getBackgroundColor());
        ramka.getContentPane().add(backgroundPanel);
        ramka.setResizable(false);
        ramka.setLocationRelativeTo(null);
        ramka.setVisible(true);

        thread = new Thread(ethServer);
        thread.setPriority(Thread.MAX_PRIORITY);
        thread.start();
    }

    private void initSpeed() {
        
    }

    public static void main(String[] args) {
        main = new Main();
        main.start();
    }

    private Main() {}

}
