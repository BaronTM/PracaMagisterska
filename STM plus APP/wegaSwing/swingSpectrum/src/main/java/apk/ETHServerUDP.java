package apk;

import org.apache.commons.lang3.ArrayUtils;

import java.io.IOException;
import java.net.*;
import java.nio.ByteBuffer;
import java.util.Random;

public class ETHServerUDP implements Runnable {
    private DatagramSocket datagramSocket;
    private InetSocketAddress address;
    private DatagramPacket packet;
    private DatagramPacket response;
    private Assistant assistant;
    private InetAddress stmAddress;
    private int stmPort;
    private byte[] bytes;
    private byte[] bytesTemp;
    private float[] vars;
    private float[] samples;
    private volatile int iter;
    private volatile int allIter;
    private Random random;

    private static byte[] com32;
    private static byte[] com80;
    private static byte[] com100;
    private static byte[] com101;
    private static byte[] com102;
    private static byte mask;

    static {
        com32 = new byte[] {((byte) 32)}; // start
        com80 = new byte[] {((byte) 80)}; // czekam
        com100 = new byte[] {((byte) 100)}; // potwierdzenie
        com101 = new byte[] {((byte) 101)}; // pierwszy odebrany
        com102 = new byte[] {((byte) 102)}; // drugi odebrany
        mask = 15;
    }


    @Override
    public void run() {
        try {
            assistant = Main.getAssistant();
            address = new InetSocketAddress("192.168.0.85", 5678);
            stmAddress = InetAddress.getByName("192.168.0.55");
            stmPort = 65100;
            datagramSocket = new DatagramSocket(address);
            datagramSocket.setBroadcast(true);
            random = new Random();
            bytes = new byte[1024];
            bytesTemp = new byte[2];
            vars = new float[512];
            samples = new float[1024];
            response = new DatagramPacket(com32, com32.length, stmAddress, stmPort);
            packet = new DatagramPacket(bytes,0, bytes.length);
            datagramSocket.setReceiveBufferSize(1024);
            datagramSocket.send(response);
            while (true) {
                datagramSocket.receive(packet);
                packet.getData();
                sendMessage(com100);
                if (packet.getLength() == 10) {
                    iter = 0;
                    allIter = assistant.getActualSize() / 512;
                    samples = new float[0];
                }
                else {
                    try {
                        for (int i = 0; i < 512; i++) {
                            bytesTemp[1] = bytes[2 * i];
                            bytesTemp[0] = bytes[2 * i + 1];
                            vars[i] = (float) ((ByteBuffer.wrap(bytesTemp).getShort() - assistant.getDcComponent()));
//                            vars[i] = (float) ((ByteBuffer.wrap(bytesTemp).getShort() - assistant.getDcComponent()) * (3.3 / 4095));
                        }
                        samples = ArrayUtils.addAll(samples, vars);
                        iter++;
                        if (iter >= allIter) {
                            if (iter == allIter)
                            assistant.getSamplesSet().prepareToPaint(samples);
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            datagramSocket.close();
        }

    }

    public void sendMessage(byte[] mesBytes) {
        try {
            response.setData(mesBytes);
            datagramSocket.send(response);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }


}
