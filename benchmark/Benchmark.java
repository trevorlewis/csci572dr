import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;

import org.apache.tika.exception.TikaException;
import org.apache.tika.language.LanguageIdentifier;
import org.xml.sax.SAXException;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

public class Benchmark {

    public static void main(String[] args) {
        String inputFile = args[0];

        JSONParser parser = new JSONParser();

        BufferedReader br = null;
        String line;
        try {
            br = new BufferedReader(new FileReader(inputFile));
            while ((line = br.readLine()) != null) {
                String[] lineArray = line.split("\\t");
                String truth = lineArray[0];
                String id = lineArray[1];
                String url = lineArray[2];
                String title = lineArray[3];
                String string = lineArray[4];
                String resultTika, resultText;
                long startTime, endTime, durationTika, durationText;

                startTime = System.nanoTime();
                resultTika = getLanguageFromStringUsingTika(string);
                endTime = System.nanoTime();
                durationTika = (endTime - startTime);
                
                startTime = System.nanoTime();
                resultText = getLanguageFromStringUsingText(string);
                endTime = System.nanoTime();
                durationText = (endTime - startTime);
                JSONObject obj = (JSONObject) parser.parse(resultText);
                resultText = (String) obj.get("lang");

                String[] words = string.split("\\s+");
                
                System.out.println(id + "\t" + truth + "\t" + resultTika + "\t" + durationTika + "\t" + resultText + "\t" + durationText + "\t" + words.length + "\t" + string.length());
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

    static String getLanguageFromStringUsingTika(String s){
        LanguageIdentifier identifier = new LanguageIdentifier(s);
        String language = identifier.getLanguage();
        return language;
    }

    static String getLanguageFromStringUsingText(String s){
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
