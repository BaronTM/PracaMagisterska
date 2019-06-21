package apk;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.net.Socket;
import java.nio.ByteBuffer;

public class STMService implements Runnable {

    private Socket socket;
    private BufferedInputStream bufferedInputStream;
    private byte bytes[];
    private int len;
    private Assistant assistant;

    public STMService(Socket socket) {
        this.socket = socket;
        assistant = Main.getMain().getAssistant();
        bytes = new byte[2048];
        try {
            bufferedInputStream = new BufferedInputStream(socket.getInputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
        System.out.println("Uruchomiono STMService");
    }
    @Override
    public void run() {
        try {
            while ((len = bufferedInputStream.read(bytes)) > 0) {

            }
        } catch (IOException e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }

    private class TransformBytes implements Runnable {

        private byte bytesTB[];
        private byte bytesTempTB[];
        private float[] varsTB;

        public TransformBytes(byte[] bytesIn) {
            this.bytesTB = bytesIn;
            bytesTempTB = new byte[2];
            varsTB = new float[1024];
        }

        @Override
        public void run() {
            for (int i = 0; i < 1024; i++) {
                bytesTempTB[1] = bytesTB[2 * i];
                bytesTempTB[0] = bytesTB[2 * i + 1];
                varsTB[i] = ByteBuffer.wrap(bytesTempTB).getShort();
            }
            assistant.getSamplesSet().addArray(varsTB);
        }
    }
}
