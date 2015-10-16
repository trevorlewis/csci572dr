import java.net.*;
import java.io.*;
import java.util.*;

public class lidHttpClient {

    public static void main(String[] args) {
        String url = "http://127.0.0.1:8000/";
        int total = 0, count = 0;

        try {
            BufferedReader br = new BufferedReader(new FileReader("data/test.tsv"));
            String line;
            while ((line = br.readLine()) != null) {
                String test_string = line.split("\\t")[1];
                String test_truth = line.split("\\t")[0];

                System.out.println("Test: " + test_string);
                System.out.println("Test Truth: " + test_truth);

                String base64encodedString = Base64.getEncoder().encodeToString(test_string.getBytes("UTF-8"));
                String urlEncodedString = URLEncoder.encode(base64encodedString, "UTF-8");

                URL lidurl = new URL(url + urlEncodedString);
                URLConnection lid = lidurl.openConnection();
                BufferedReader in = new BufferedReader(new InputStreamReader(lid.getInputStream()));
                String test_result = in.readLine();
                in.close();

                System.out.println("Test Result: " + test_result);
                System.out.println("Equals: " + test_truth.equals(test_result));

                total++;
                if(test_truth.equals(test_result)){
                    count++;
                }

                System.out.println();
            }
            br.close();
        } catch (Exception e){
            e.printStackTrace();
        }
        System.out.println("Total Test: " + total);
        System.out.println("Correct: " + count);
        System.out.println("Incorrect: " + (total-count));
    }

}
