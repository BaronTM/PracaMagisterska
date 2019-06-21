package apk;

import javafx.beans.property.IntegerProperty;
import javafx.beans.property.SimpleIntegerProperty;
import lombok.Getter;
import lombok.Setter;
import org.apache.commons.lang3.ArrayUtils;
import org.jtransforms.fft.FloatFFT_1D;

import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

public class SamplesSet {

    @Getter
    private int size;
    @Getter
    @Setter
    private Assistant assistant;
    @Getter
    private float[] samples;
    private FloatFFT_1D floatFFT;
    private FloatFFT_1D averageFloatFFT;
    private volatile boolean samplesArrayFlag;
    private volatile int samplesArrayFlagIterator;
    @Getter
    @Setter
    private volatile boolean arw;
    @Getter
    @Setter
    private IntegerProperty arwPxPropertyInt;
    @Getter
    @Setter
    private IntegerProperty followPropertyInt;
    @Getter
    @Setter
    private IntegerProperty maxIdPropertyInt;
    private float maxVal;
    private int maxId;
    private float zoomMaxVal;
    private float maxFullVal;
    private int maxFullId;
    private Map<Integer, double[]> triangularWindows;
    private Map<Integer, double[]> bartlettWindows;
    private Map<Integer, double[]> hanningWindows;
    private Map<Integer, double[]> hannWindows;
    private Map<Integer, double[]> hammingWindows;
    private Map<Integer, double[]> blackmanWindows;


    public SamplesSet(int size) {
        this.size = size;
        floatFFT = new FloatFFT_1D(size);
        averageFloatFFT = new FloatFFT_1D(2048);
        samples = new float[size];
        samplesArrayFlag = false;
        samplesArrayFlagIterator = 0;
        arw = true;
        arwPxPropertyInt = new SimpleIntegerProperty(126);
        followPropertyInt = new SimpleIntegerProperty(200);
        maxIdPropertyInt = new SimpleIntegerProperty(0);

        triangularWindows = new HashMap<>();
        bartlettWindows = new HashMap<>();
        hanningWindows = new HashMap<>();
        hannWindows = new HashMap<>();
        hammingWindows = new HashMap<>();
        blackmanWindows = new HashMap<>();


        initWindows();
    }

    public void setSize(int size) {
        this.size = size;
        floatFFT = new FloatFFT_1D(size);
        samples = new float[size];
        samplesArrayFlag = false;
        samplesArrayFlagIterator = 0;
    }

    synchronized public void addArray(float[] array) {

        if (samplesArrayFlagIterator == 0)
            samples = new float[0];

        if (samplesArrayFlagIterator < ((size / 1024) - 1)) {
            samples = ArrayUtils.addAll(samples, array);
            samplesArrayFlagIterator++;
        } else if (samplesArrayFlagIterator == ((size / 1024) - 1)) {
            samples = ArrayUtils.addAll(samples, array);
            samplesArrayFlagIterator = 0;
            samplesArrayFlag = true;
        }

        if (samplesArrayFlag) {
            prepareToPaint(ArrayUtils.clone(samples));
            samplesArrayFlag = false;
        }
    }

    public void prepareToPaint(float[] fftSamples) {
        // Do badan
        Random random = new Random();
//        for (int i = 0; i < fftSamples.length; i++) {
//            float f = (float) (1240 * Math.sin((Math.PI * 2 * (3125000) * i / 400000)));
//            fftSamples[i] = fftSamples[i] + f;
//        }
        for (int i = 0; i < fftSamples.length; i++) {
            float f = (float) ((random.nextFloat() * 2048) - 1024);
            fftSamples[i] = fftSamples[i] + f;
        }


        maxId = 0;
        maxFullId = 0;
        maxVal = 0;
        maxFullVal = 0;
        zoomMaxVal = 0;
        int[] prepareInt = new int[1024];
        int[] prepareZoomInt = new int[180];
        float[] calculatedSamples = new float[size / 2];

        if (fftSamples.length == size) {

            if (assistant.getOsciloscopeMode().get()) {
                if (assistant.getWindowStr() != ServicePanel.getAvailableWindowsStr()[0]) {
                    timeWindow(fftSamples);
                }
                if (!arw) {
                    for (int i = 0; i < 1024; i++) {
                        float f = fftSamples[i] * 180;
                        fftSamples[i] = f / 4096;
                    }
                }

                for (int i = 0; i < 1024; i++) {
                    if (fftSamples[i] > maxVal) {
                        maxVal = fftSamples[i];
                        maxId = i;
                    }
                }
                if (arw) {
                    for (int i = 0; i < 1024; i++) {
                        prepareInt[i] = (int) (arwPxPropertyInt.get() * fftSamples[i] / maxVal);
                    }
                } else {
                    for (int i = 0; i < 1024; i++) {
                        prepareInt[i] = (int) (fftSamples[i]);
                    }
                }
                maxIdPropertyInt.set(0);
                assistant.getFigure().setValues(prepareInt);
                assistant.getZoomFigure().setValues(prepareZoomInt);

                assistant.getGreenFreq().setText("F [Hz]: ");
                assistant.getGreenSpeed().setText("V [m/s]:");
                assistant.getYellowFreq().setText("F [Hz]: ");
                assistant.getYellowSpeed().setText("V [m/s]:");
                assistant.getGrayFreq().setText("ΔF [Hz]: ");
                assistant.getGraySpeed().setText("ΔV [Hz]: ");

            } else if (!assistant.getOsciloscopeMode().get()) {

                if (assistant.getMethodStr() == ServicePanel.getAvailableMethodsStr()[0]) {
                    if (assistant.getWindowStr() != ServicePanel.getAvailableWindowsStr()[0]) {
                        timeWindow(fftSamples);
                    }
                    floatFFT.realForward(fftSamples);

                    if (assistant.isLogarithmicScale()) {
                        for (int i = 0; i < size / 2; i++) {
                            calculatedSamples[i] = (float) (20 * Math.log10(Math.sqrt((Math.pow(fftSamples[(2 * i)], 2)) + (Math.pow(fftSamples[(2 * i) + 1], 2)))));
                        }
                    } else {
                        for (int i = 0; i < size / 2; i++) {
                            calculatedSamples[i] = (float) Math.sqrt((Math.pow(fftSamples[(2 * i)], 2)) + (Math.pow(fftSamples[(2 * i) + 1], 2)));
                        }
                    }

                    for (int d = 0; d < assistant.getDullStripeAmount(); d++) {
                        calculatedSamples[d] = 0;
                    }
                    if (size == 1024) {
                        for (int i = 0; i < 512; i++) {
                            int len = (int) calculatedSamples[i];
                            prepareInt[2 * i] = len;
                            prepareInt[2 * i + 1] = len;
                            if (len > maxVal) {
                                maxVal = len;
                                maxFullVal = len;
                                maxFullId = i;
                                maxId = 2 * i;
                            }
                        }
                    } else {
                        int merge = size / 2048;
                        for (int i = 0; i < 1024; i++) {
                            int len = 0;
                            for (int j = 0; j < merge; j++) {
                                int temp = (int) calculatedSamples[((merge * i) + j)];
                                if (temp > maxFullVal) {
                                    maxFullVal = temp;
                                    maxFullId = (merge * i) + j;
                                }
                                len += temp;
                            }
                            prepareInt[i] = len / merge;
                            if (prepareInt[i] > maxVal) {
                                maxVal = prepareInt[i];
                                maxId = i;
                            }
                        }
                    }
                } else if (assistant.getMethodStr() == ServicePanel.getAvailableMethodsStr()[1]) {
                    if (size == 1024) {
                        if (assistant.getWindowStr() != ServicePanel.getAvailableWindowsStr()[0]) {
                            timeWindow(fftSamples);
                        }
                        floatFFT.realForward(fftSamples);

                        if (assistant.isLogarithmicScale()) {
                            for (int i = 0; i < size / 2; i++) {
                                calculatedSamples[i] = (float) (20 * Math.log10(Math.sqrt((Math.pow(fftSamples[(2 * i)], 2)) + (Math.pow(fftSamples[(2 * i) + 1], 2)))));
                            }
                        } else {
                            for (int i = 0; i < size / 2; i++) {
                                calculatedSamples[i] = (float) Math.sqrt((Math.pow(fftSamples[(2 * i)], 2)) + (Math.pow(fftSamples[(2 * i) + 1], 2)));
                            }
                        }
                        for (int d = 0; d < assistant.getDullStripeAmount(); d++) {
                            calculatedSamples[d] = 0;
                        }
                        for (int i = 0; i < 512; i++) {
                            int len = (int) calculatedSamples[i];
                            prepareInt[2 * i] = len;
                            prepareInt[2 * i + 1] = len;
                            if (len > maxVal) {
                                maxVal = len;
                                maxFullVal = len;
                                maxFullId = i;
                                maxId = i * 2;
                            }
                        }
                    } else {
                        int amount = size / 2048;
                        float[][] arrays = new float[amount][2048];
                        for (int i = 0; i < amount; i++) {
                            arrays[i] = ArrayUtils.subarray(fftSamples, (i * 2048), ((i + 1) * 2048));
                            if (assistant.getWindowStr() != ServicePanel.getAvailableWindowsStr()[0]) {
                                timeWindow(arrays[i]);
                            }
                            averageFloatFFT.realForward(arrays[i]);
                            for (int d = 0; d < assistant.getDullStripeAmount(); d++) {
                                arrays[i][2 * d] = 0;
                                arrays[i][(2 * d) + 1] = 0;
                            }
                        }

                        for (int i = 0; i < 1024; i++) {
                            float len = 0;
                            for (int j = 0; j < amount; j++) {
                                len += (Math.sqrt((Math.pow(arrays[j][(2 * i)], 2)) + (Math.pow(arrays[j][(2 * i) + 1], 2))));
                            }
                            len = len / amount;
                            if (assistant.isLogarithmicScale()) {
                                calculatedSamples[i] = (float) (20 * Math.log10(Math.sqrt(len)));
                            } else {
                                calculatedSamples[i] = len;
                            }
                            prepareInt[i] = (int) calculatedSamples[i];
                            if (prepareInt[i] > maxVal) {
                                maxFullVal = prepareInt[i];
                                maxFullId = i;
                                maxVal = prepareInt[i];
                                maxId = i;
                            }
                        }
                    }
                }
                maxIdPropertyInt.set(maxId);

                {
                    int spectrumSize = size;
                    int zoom = assistant.getWnZoom();
                    if (size == 1024 && (zoom == 20 || zoom == 60)) {
                        String defaultZoom = zoom == 20 ? ServicePanel.getAvailableZoomStr()[3] : ServicePanel.getAvailableZoomStr()[5];
                        assistant.getServicePanel().getZoomCombo().setSelectedItem(defaultZoom);
                        assistant.setZoomStr(defaultZoom);
                        int newZ = Integer.parseInt(defaultZoom.substring(1));
                        assistant.setWnZoom(newZ);
                        zoom = newZ;
                    }
                    if (assistant.getMethodStr() == ServicePanel.getAvailableMethodsStr()[1] || size == 1024)
                        spectrumSize = 2048;
                    int inter = followPropertyInt.get() * spectrumSize / 2048;
                    if (size > 2048 && assistant.isAccurateArw() && assistant.getAccurateFollowing().get()) {
                        inter = maxFullId;
                    }
                    int start = inter - (89 / zoom);
                    int meta = inter + (90 / zoom);
                    if (start < 0) {
                        start = 0;
                        meta = (179 / zoom);
                        inter = (start + meta) / 2;
                    } else if (meta > ((spectrumSize / 2) - 1)) {
                        meta = (spectrumSize / 2) - 1;
                        start = meta - (179 / zoom);
                        inter = (start + meta) / 2;
                    }
                    int div = meta - start;
                    int stripeWidth = 180 / (div + 1);

                    double greFreq;
                    double grayFreq;
                    if (assistant.getMethodStr() == ServicePanel.getAvailableMethodsStr()[1] || size == 1024) {
                        for (int i = 0; i <= div; i++) {
                            for (int k = 0; k < stripeWidth; k++) {
                                prepareZoomInt[i * stripeWidth + k] = prepareInt[start + i];
                                if (prepareZoomInt[i * stripeWidth + k] > zoomMaxVal)
                                    zoomMaxVal = prepareZoomInt[i * stripeWidth + k];
                            }
                        }
                        if (size == 1024) {
                            greFreq = (((assistant.getConstants().get(4) * (spectrumSize / 1024) - (inter)) * assistant.getFrequencyDivs().get(size)) / 2);
                            grayFreq = (assistant.getFrequencyDivs().get(size));
                        } else {
                            greFreq = (((assistant.getConstants().get(4) * (spectrumSize / 1024) - (inter)) * assistant.getFrequencyDivs().get(spectrumSize)));
                            grayFreq = (assistant.getFrequencyDivs().get(spectrumSize));
                        }
                    } else {
                        for (int i = 0; i <= div; i++) {
                            for (int k = 0; k < stripeWidth; k++) {
                                int len = (int) calculatedSamples[(i + start)];
                                prepareZoomInt[i * stripeWidth + k] = len;
                                if (len > zoomMaxVal) zoomMaxVal = len;
                            }
                        }
                        greFreq = (((assistant.getConstants().get(4) * (spectrumSize / 1024) - (inter)) * assistant.getFrequencyDivs().get(size)));
                        grayFreq = (assistant.getFrequencyDivs().get(size));
                    }


                    for (int i = 0; i < 180; i++) {
                        prepareZoomInt[i] = (int) (120 * prepareZoomInt[i] / zoomMaxVal);
                    }
                    assistant.getGrayFreq().setText("ΔF [Hz]: " + (grayFreq));
                    assistant.getGreenFreq().setText("F [Hz]: " + (greFreq));


                    double greV = (greFreq * assistant.getConstants().get(5));
                    double grayV = (grayFreq * assistant.getConstants().get(5));

                    assistant.getGreenSpeed().setText("V [m/s]:" + greV);
                    assistant.getGraySpeed().setText("ΔV [m/s]:" + grayV);

                    assistant.getZoomFigure().setValues(prepareZoomInt);
                }

                if (arw) {
                    for (int i = 0; i < prepareInt.length; i++) {
                        prepareInt[i] = (int) (arwPxPropertyInt.get() * prepareInt[i] / maxVal);
                    }
                }

                double yelFreq = (((assistant.getConstants().get(4) * 2) - maxIdPropertyInt.get()) * assistant.getFrequencyDivs().get(1024)) / 2;
                assistant.getYellowFreq().setText("F [Hz]: " + ((int) yelFreq));

                int yelV = (int) (yelFreq * assistant.getConstants().get(5));
                assistant.getYellowSpeed().setText("V [m/s]:" + yelV);
                assistant.getFigure().setValues(prepareInt);
            }
        }
    }

    private synchronized void initWindows() {

        int[] sizes = new int[]{1024, 2048, 4096, 8192, 16384};

        for (int s : sizes) {
            double[] triangular = new double[s];
            for (int i = 0; i < s; i++) {
                if (i <= s / 2) {
                    triangular[i] = 2 * i;
                    triangular[i] = triangular[i] / s;
                } else {
                    triangular[i] = 2 * i;
                    triangular[i] = 2 - (triangular[i] / s);
                }
            }
            triangularWindows.put(s, triangular);

            double[] bartlett = new double[s];
            for (int i = 0; i < s; i++) {
                if (i <= s / 2) {
                    bartlett[i] = 2 * i;
                    bartlett[i] = bartlett[i] / (s - 1);
                } else {
                    bartlett[i] = 2 * i;
                    bartlett[i] = 2 - (bartlett[i] / (s - 1));
                }
            }
            bartlettWindows.put(s, bartlett);

            double[] hanning = new double[s];
            for (int i = 0; i < s; i++) {
                hanning[i] = (0.5 - (0.5 * Math.cos((2 * Math.PI * i) / s)));
            }
            hanningWindows.put(s, hanning);

            double[] hann = new double[s];
            for (int i = 0; i < s; i++) {
                hann[i] = (0.5 - (0.5 * Math.cos((2 * Math.PI * i) / (s - 1))));
            }
            hannWindows.put(s, hann);

            double[] hamming = new double[s];
            for (int i = 0; i < s; i++) {
                hamming[i] = (0.42 - (0.5 * Math.cos((2 * Math.PI * i) / (s - 1))) + (0.08 * Math.cos((4 * Math.PI * i) / (s - 1))));
            }
            hammingWindows.put(s, hamming);

            double[] blackman = new double[s];
            for (int i = 0; i < s; i++) {
                blackman[i] = (0.54 - (0.46 * Math.cos((2 * Math.PI * i) / (s - 1))));
            }
            blackmanWindows.put(s, blackman);
        }

    }

    private void timeWindow(float[] samplesToAddingWindow) {
        int samlesSize = samplesToAddingWindow.length;
        double[] window;
        if (assistant.getWindowStr() == ServicePanel.getAvailableWindowsStr()[1]) {
            window = triangularWindows.get(samlesSize);
        } else if (assistant.getWindowStr() == ServicePanel.getAvailableWindowsStr()[2]) {
            window = bartlettWindows.get(samlesSize);
        } else if (assistant.getWindowStr() == ServicePanel.getAvailableWindowsStr()[3]) {
            window = hanningWindows.get(samlesSize);
        } else if (assistant.getWindowStr() == ServicePanel.getAvailableWindowsStr()[4]) {
            window = hannWindows.get(samlesSize);
        } else if (assistant.getWindowStr() == ServicePanel.getAvailableWindowsStr()[5]) {
            window = hammingWindows.get(samlesSize);
        } else if (assistant.getWindowStr() == ServicePanel.getAvailableWindowsStr()[6]) {
            window = blackmanWindows.get(samlesSize);
        } else {
            window = new double[samlesSize];
            for (int i = 0; i < samlesSize; i++) {
                window[i] = i;
            }
        }
        for (int i = 0; i < samlesSize; i++) {
            samplesToAddingWindow[i] = (float) (samplesToAddingWindow[i] * window[i]);
        }
    }

}
