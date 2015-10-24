import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

public class lidHttpClient {

    public static void main(String[] args) {

        String inputFile = null;
        for(int i=0; i<args.length-1; i++){
            if(args[i].equals("-i")){
                inputFile = args[i+1];
            }
        }
        if(inputFile == null){
            System.out.println("Usage: java lidHttpClient -i inputFile");
            System.exit(0);
        }

        BufferedReader br = null;
        String line;
        try {
            br = new BufferedReader(new FileReader(inputFile));
            while ((line = br.readLine()) != null) {
                String test_string = line.split("\\t")[1];
                String test_truth = line.split("\\t")[0];

                System.out.println("Test: " + test_string);
                System.out.println("Truth: " + test_truth);

                String result = getLanguageFromString(test_string);
                System.out.println("Result: " + result);

                System.out.println();
            }
        } catch (Exception e){
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    static String getLanguageFromString(String s){
        String lang = "error";

        URL url = null;
        try {
            url = new URL("http://127.0.0.1:8000");
        } catch (MalformedURLException e) {
            e.printStackTrace();
        }

        HttpURLConnection con = null;
        OutputStreamWriter out = null;
        InputStreamReader in = null;
        try {
            con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("PUT");
            con.setDoOutput(true);

            out = new OutputStreamWriter(con.getOutputStream());
            out.write(s);
            out.close();

            in = new InputStreamReader(con.getInputStream());
            lang = getStringFromInputStreamReader(in);
            in.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return lang;
    }

    // convert InputStreamReader to String
    static String getStringFromInputStreamReader(InputStreamReader in) {
        BufferedReader br = null;
        StringBuilder sb = new StringBuilder();
        String line;
        try {
            br = new BufferedReader(in);
            while ((line = br.readLine()) != null) {
                sb.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            if (br != null) {
                try {
                    br.close();
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        return sb.toString();
    }

}

