package apk;

import lombok.Getter;
import lombok.Setter;

import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

public class ServicePanel extends JPanel {


    @Getter
    private static String[] availableSamplesStr;
    @Getter
    private static String[] availableWindowsStr;
    @Getter
    private static String[] availableMethodsStr;
    @Getter
    private static String[] availableZoomStr;
    @Getter
    private static byte[] mesage;


    private JRadioButton oscBut;
    private JRadioButton specBut;
    private JLabel modeLabel;
    private ButtonGroup radioGroup;
    private Assistant assistant;
    private Color background;
    @Getter @Setter
    private JLabel freqLabel;
    private JPanel spectrumOptionPanel;
    private JButton refreshBut;
    private JButton button;

    private JPanel gridLayoutSpectrum;
    private JLabel samplesLabel;
    private JLabel methodLabel;
    private JLabel windowLabel;
    private JLabel dullLab;
    private JLabel dcComponentLab;
    private JLabel zoomLab;
    private JLabel accurateFollowingLab;
    private JLabel logarithmicScaleLab;
    @Getter @Setter
    private JComboBox<String> samplesCombo;
    @Getter @Setter
    private JComboBox<String> methodCombo;
    @Getter @Setter
    private JComboBox<String> windowCombo;
    @Getter @Setter
    private JComboBox<String> zoomCombo;
    private JSpinner dullStripe;
    private JSpinner dcComponentValue;
    @Getter @Setter
    private SwitchBox accurateFollowingSwitch;
    @Getter @Setter
    private SwitchBox logarithmicScale;

    private Color fontColor;

    static {
        availableSamplesStr = new String[] {"1024", "2048", "4096", "8192", "16384"};
        availableWindowsStr = new String[] {"Prostokątne", "Trójkątne", "Bartletta", "Hanninga", "Hanna", "Hamminga", "Blackmana"};
        availableMethodsStr = new String[] {"Brak", "Uśrednianie"};
        availableZoomStr = new String[] {"x1", "x2", "x5", "x10", "x20", "x30", "x60"};
        mesage = new byte[1];
    }

    public ServicePanel(Assistant assistant) {
        super();
        this.assistant = assistant;
        this.setLayout(null);
        background = assistant.getBackgroundColor();
        this.setBackground(background);
        this.setBounds(30,130, 200, 600);

        fontColor = new Color(217, 217, 208);
        modeLabel = new JLabel("Tryb");
        modeLabel.setForeground(fontColor);
        modeLabel.setBackground(background);
        modeLabel.setBounds(10, 10, 150, 20);
        oscBut = new JRadioButton("Sygnal");
        oscBut.setForeground(fontColor);
        oscBut.setBounds(20, 30, 150, 20);
        oscBut.setBackground(background);
        specBut = new JRadioButton("Widmo");
        specBut.setForeground(fontColor);
        specBut.setBounds(20, 50, 150, 20);
        specBut.setBackground(background);
        specBut.setSelected(true);
        freqLabel = new JLabel("Opcje");
        freqLabel.setForeground(fontColor);
        freqLabel.setBounds(10,370, 200, 30);
        refreshBut = new JButton("Odśwież");
        refreshBut.setBounds(40, 530, 120, 40);
        button = new JButton("STM MODE");
        button.setBounds(40, 480, 120, 40);

        gridLayoutSpectrum =  new JPanel(new GridLayout(8, 2));
        gridLayoutSpectrum.setBackground(background);
        gridLayoutSpectrum.setBounds(0, 10, 200, 100);
        samplesLabel = new JLabel("Liczba próbek");
        samplesLabel.setForeground(fontColor);
        methodLabel = new JLabel("Metoda");
        methodLabel.setForeground(fontColor);
        windowLabel = new JLabel("Okno");
        windowLabel.setForeground(fontColor);
        samplesCombo = new JComboBox<>(availableSamplesStr);
        methodCombo = new JComboBox<>(availableMethodsStr);
        windowCombo = new JComboBox<>(availableWindowsStr);
        zoomCombo = new JComboBox<>(availableZoomStr);
        dullLab = new JLabel("Wytłum");
        dullLab.setForeground(fontColor);
        dcComponentLab = new JLabel("Składowa stała");
        dcComponentLab.setForeground(fontColor);
        zoomLab = new JLabel("WN zoom");
        zoomLab.setForeground(fontColor);
        accurateFollowingLab = new JLabel("Precyzyjny zoom");
        accurateFollowingLab.setForeground(fontColor);
        logarithmicScaleLab = new JLabel("Skala log");
        logarithmicScaleLab.setForeground(fontColor);
        dullStripe = new JSpinner(new SpinnerNumberModel(1, 0, 100, 1));
        dullStripe.setEditor(new JSpinner.NumberEditor(dullStripe, "###"));
        dullStripe.setValue(assistant.getDullStripeAmount());
        ((JSpinner.DefaultEditor) dullStripe.getEditor()).getTextField().setEditable(false);
        dcComponentValue = new JSpinner(new SpinnerNumberModel(1, 0, 4095, 1));
        dcComponentValue.setEditor(new JSpinner.NumberEditor(dcComponentValue, "####"));
        dcComponentValue.setValue(assistant.getDcComponent());
        accurateFollowingSwitch = new SwitchBox("ON", "OFF");
        accurateFollowingSwitch.setSelected(false);
        logarithmicScale = new SwitchBox("ON", "OFF");
        logarithmicScale.setSelected(false);

        gridLayoutSpectrum.add(samplesLabel);
        gridLayoutSpectrum.add(samplesCombo);
        gridLayoutSpectrum.add(methodLabel);
        gridLayoutSpectrum.add(methodCombo);
        gridLayoutSpectrum.add(windowLabel);
        gridLayoutSpectrum.add(windowCombo);
        gridLayoutSpectrum.add(dullLab);
        gridLayoutSpectrum.add(dullStripe);
        gridLayoutSpectrum.add(dcComponentLab);
        gridLayoutSpectrum.add(dcComponentValue);
        gridLayoutSpectrum.add(zoomLab);
        gridLayoutSpectrum.add(zoomCombo);
        gridLayoutSpectrum.add(accurateFollowingLab);
        gridLayoutSpectrum.add(accurateFollowingSwitch);
        gridLayoutSpectrum.add(logarithmicScaleLab);
        gridLayoutSpectrum.add(logarithmicScale);

        spectrumOptionPanel = new JPanel();
        spectrumOptionPanel.setBackground(background);
        spectrumOptionPanel.setBounds(0,100, 200, 300);
        spectrumOptionPanel.add(freqLabel);
        spectrumOptionPanel.add(gridLayoutSpectrum);
        spectrumOptionPanel.setVisible(true);

        radioGroup = new ButtonGroup();
        radioGroup.add(oscBut);
        radioGroup.add(specBut);

        samplesCombo.setSelectedItem(availableSamplesStr[0]);
        methodCombo.setSelectedItem(availableMethodsStr[0]);
        windowCombo.setSelectedItem(availableWindowsStr[0]);
        zoomCombo.setSelectedItem(availableZoomStr[0]);

        // oscyloskop
        oscBut.addActionListener(l -> {
            if (oscBut.isSelected()) {
                assistant.setOsciloscopeMode(true);
                assistant.setSampleStr(availableSamplesStr[0]);
                samplesCombo.setSelectedItem(getAvailableSamplesStr()[0]);
                mesage[0] = (byte) 11;
                assistant.getEthServer().sendMessage(mesage);
            }
        });

        // widmo
        specBut.addActionListener(l -> {
            if (specBut.isSelected()) {
                assistant.setOsciloscopeMode(false);
                samplesCombo.setSelectedItem(assistant.getSampleStr());
                methodCombo.setSelectedItem(assistant.getMethodStr());
                windowCombo.setSelectedItem(assistant.getWindowStr());
            }
        });

        samplesCombo.addActionListener(l -> {
            assistant.setSampleStr((String) samplesCombo.getSelectedItem());
            switch (samplesCombo.getSelectedIndex()) {
                case 0: mesage[0] = (byte) 11; break;
                case 1: mesage[0] = (byte) 12; break;
                case 2: mesage[0] = (byte) 13; break;
                case 3: mesage[0] = (byte) 14; break;
                case 4: mesage[0] = (byte) 15; break;
            }
            assistant.getEthServer().sendMessage(mesage);
        });
        methodCombo.addActionListener(l -> {
            assistant.setMethodStr((String) methodCombo.getSelectedItem());
        });
        windowCombo.addActionListener(l -> {assistant.setWindowStr((String) windowCombo.getSelectedItem());});

        zoomCombo.addActionListener(l -> {
            String s = (String) zoomCombo.getSelectedItem();
            assistant.setZoomStr(s);
            int z = Integer.parseInt(s.substring(1));
            assistant.setWnZoom(z);
        });

        dullStripe.addChangeListener(l -> {
            assistant.setDullStripeAmount((int)(dullStripe.getValue()));
        });

        dcComponentValue.addChangeListener(l -> {
            assistant.setDcComponent((Integer) dcComponentValue.getValue());
        });

        refreshBut.addActionListener( l -> {
            assistant.getEthServer().sendMessage(mesage);
        });

        button.addActionListener( l -> {
            assistant.getEthServer().sendMessage(new byte[] {(byte) 33, (byte) 44});
        });

        accurateFollowingSwitch.addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                if (!accurateFollowingSwitch.isSelected() && assistant.getAccurateFollowing().get()){
                    assistant.setAccurateArw(true);
                    accurateFollowingSwitch.setSelected(false);
                } else {
                    assistant.setAccurateArw(false);
                    accurateFollowingSwitch.setSelected(true);
                }
            }
        });

        logarithmicScale.addMouseListener(new MouseAdapter() {
            @Override
            public void mousePressed(MouseEvent e) {
                if (!logarithmicScale.isSelected()){
                    assistant.setLogarithmicScale(true);
                } else {
                    assistant.setLogarithmicScale(false);
                }
            }
        });


        this.add(modeLabel);
        this.add(oscBut);
        this.add(specBut);
        this.add(spectrumOptionPanel);
        this.add(refreshBut);
        this.add(button);

    }

}
