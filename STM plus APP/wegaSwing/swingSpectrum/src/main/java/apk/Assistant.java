package apk;


import javafx.beans.property.BooleanProperty;
import javafx.beans.property.SimpleBooleanProperty;
import javafx.beans.value.ChangeListener;
import javafx.beans.value.ObservableValue;
import lombok.Getter;
import lombok.Setter;

import javax.swing.*;
import java.awt.*;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicBoolean;

public class Assistant {

    @Getter
    private static Map<String, Integer> availableSize;
    @Getter
    private Main main;
    @Getter
    private volatile int actualSize;
    @Getter @Setter
    private SamplesSet samplesSet;
    @Getter @Setter
    private Figure figure;
    @Getter @Setter
    private ZoomFigure zoomFigure;
    @Getter
    private AtomicBoolean osciloscopeMode;
    @Getter @Setter
    private ServicePanel servicePanel;
    @Getter @Setter
    private ETHServerUDP ethServer;
    @Getter @Setter
    private Color backgroundColor;
    @Getter @Setter
    private volatile int dcComponent;

    @Getter
    private String sampleStr;
    @Getter @Setter
    private String windowStr;
    @Getter @Setter
    private String methodStr;
    @Getter @Setter
    private String zoomStr;

    @Getter
    private double samplingFrequency;
    @Getter @Setter
    private int dullStripeAmount;
    @Getter @Setter
    private int wnZoom;
    @Getter @Setter
    private Map<Integer, Double> frequencyDivs;
    @Getter @Setter
    private Map<Integer, Double> constants;
    @Getter @Setter
    private BooleanProperty accurateFollowing;
    @Getter @Setter
    private volatile boolean accurateArw;
    @Getter @Setter
    private volatile boolean logarithmicScale;

    @Getter @Setter
    private JLabel yellowFreq;
    @Getter @Setter
    private JLabel greenFreq;
    @Getter @Setter
    private JLabel yellowSpeed;
    @Getter @Setter
    private JLabel greenSpeed;
    @Getter @Setter
    private JLabel graySpeed;
    @Getter @Setter
    private JLabel grayFreq;
    private Color myYellow;
    private Color myGreen;
    private Color myGray;
    private Font font;



    static {
        availableSize = new HashMap<>();
        availableSize.put("1024", 1024);
        availableSize.put("2048", 2048);
        availableSize.put("4096", 4096);
        availableSize.put("8192", 8192);
        availableSize.put("16384", 16384);
    }

    public Assistant(Main main) {
        this.main = main;
        samplingFrequency = 400000;
        backgroundColor = new Color(109, 109, 109);
        actualSize = availableSize.get("1024");
        dullStripeAmount = 0;
        wnZoom = 1;
        logarithmicScale = false;
        samplesSet = new SamplesSet(actualSize);
        samplesSet.setAssistant(this);
        figure = new Figure(1024, this);
        figure.setSamplesSet(samplesSet);
        zoomFigure = new ZoomFigure(180);
        zoomFigure.setSamplesSet(samplesSet);
        osciloscopeMode = new AtomicBoolean(false);
        servicePanel = new ServicePanel(this);
        dcComponent = 0;
        accurateFollowing = new SimpleBooleanProperty(false);
        accurateFollowing.addListener(new ChangeListener<Boolean>() {
            @Override
            public void changed(ObservableValue<? extends Boolean> observable, Boolean oldValue, Boolean newValue) {
                if (!newValue) {
                    getAccurateFollowing().setValue(false);
                    accurateArw = false;
                    servicePanel.getAccurateFollowingSwitch().setSelected(false);
                }
            }
        });

        myYellow = new Color(255, 255, 0);
        myGreen = new Color(0, 168, 0);
        myGray = new Color(179, 179, 179);
        font =  new Font("TimesRoman", Font.PLAIN, 14);
        yellowFreq = new JLabel("F [Hz]: ");
        yellowFreq.setForeground(myYellow);
        greenFreq = new JLabel("F [Hz]: ");
        greenFreq.setForeground(myGreen);
        grayFreq = new JLabel("ΔF [Hz]: ");
        grayFreq.setForeground(myGray);
        yellowSpeed = new JLabel("V [m/s]:");
        yellowSpeed.setForeground(myYellow);
        greenSpeed = new JLabel("V [m/s]:");
        greenSpeed.setForeground(myGreen);
        graySpeed = new JLabel("ΔV [m/s]:");
        graySpeed.setForeground(myGray);
        yellowFreq.setBounds(10, 810, 100, 30);
        greenFreq.setBounds(505, 810, 200, 30);
        grayFreq.setBounds(780, 810, 150, 30);
        graySpeed.setBounds(910, 810, 200, 30);
        yellowSpeed.setBounds(105, 810, 100, 30);
        greenSpeed.setBounds(220, 810, 200, 30);
        yellowFreq.setFont(font);
        greenFreq.setFont(font);
        yellowSpeed.setFont(font);
        greenSpeed.setFont(font);
        graySpeed.setFont(font);
        grayFreq.setFont(font);


        main.getMainPanel().add(figure);
        main.getMainPanel().add(zoomFigure);
        main.getMainPanel().add(yellowFreq);
        main.getMainPanel().add(greenFreq);
        main.getMainPanel().add(yellowSpeed);
        main.getMainPanel().add(greenSpeed);
        main.getMainPanel().add(grayFreq);
        main.getMainPanel().add(graySpeed);
        main.getAdditionalPanel().add(servicePanel);

        sampleStr = ServicePanel.getAvailableSamplesStr()[0];
        windowStr = ServicePanel.getAvailableWindowsStr()[0];
        methodStr = ServicePanel.getAvailableMethodsStr()[0];
        zoomStr = ServicePanel.getAvailableZoomStr()[0];


        frequencyDivs = new HashMap<>();
        constants = new HashMap<>();
        initFreq();
        initConstants();
    }

    public void setOsciloscopeMode(boolean b) {
        osciloscopeMode.set(b);
    }

    public void setSampleStr(String sampleStr) {
        this.sampleStr = sampleStr;
        actualSize = availableSize.get(sampleStr);
        samplesSet.setSize(actualSize);
    }

    private void initFreq() {
        int[] sizes = new int[]{1024, 2048, 4096, 8192, 16384};
        for (int s : sizes) {
            double div = samplingFrequency / s;
            frequencyDivs.put(s, div);
        }
    }

    private void initConstants() {
        double f_wid_max = samplingFrequency * 8;
        double f_wid_min = samplingFrequency * 7 + (samplingFrequency / 2);
        double fo = 3135000;
        double prazek_zero = ((f_wid_max - fo) / samplingFrequency) * 1024;
        double wsp = 0.023060958308;
        constants.put(1, f_wid_max);
        constants.put(2, f_wid_min);
        constants.put(3, fo);
        constants.put(4, prazek_zero);
        constants.put(5, wsp);

    }
}
