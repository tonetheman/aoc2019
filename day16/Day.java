import java.util.*;
import java.io.*;

public class Day {

    public String readfromfile(String filename) {
        StringBuffer sb = new StringBuffer();
        try {
            BufferedReader inf = new BufferedReader(new FileReader(filename));
            String currentLine;
            while((currentLine = inf.readLine()) != null) {
                sb.append(currentLine);
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        return sb.toString();
    }

    public ArrayList<Integer> buildpat(int n) {
        ArrayList<Integer> al = new ArrayList<Integer>();
        for (int i=0;i<n;i++) {
            al.add(0);
        }
        for(int i=0;i<n;i++) {
            al.add(1);
        }
        for(int i=0;i<n;i++) {
            al.add(0);
        }
        for(int i=0;i<n;i++) {
            al.add(-1);
        }
        return al;
    }
    public ArrayList<Integer> buildshiftpat(ArrayList<Integer> input) {
        ArrayList<Integer> al = new ArrayList<Integer>();
        for (int i=1;i<input.size();i++) {
            al.add(input.get(i));
        }
        return al;
    }

    public int crazy(int i, ArrayList<Integer> pat, ArrayList<Integer> shpat) {
        int cl = pat.size();
        System.out.println("\tcrazy: cl: " + cl + " i: "+i);
        if (i<(cl-1)) {
            if (i==0) {
                return shpat.get(0);
            }
            return shpat.get(cl%i);
        } else {
            int tmp = i-(cl-1);
            if (tmp==0) {
                return pat.get(0);
            }
            return pat.get(cl%tmp);
        }    
    }
    
    public ArrayList<Integer> parseInput(String inp) {
        ArrayList<Integer> al = new ArrayList<Integer>();
        for(int i=0;i<inp.length();i++) {
            char c = inp.charAt(i);
            int v = (int)c-(int)'0';
            al.add(v);
        }
        return al;
    }

    public int testcase(ArrayList<Integer> input, int cp) {
        ArrayList<Integer> pat = buildpat(cp);
        ArrayList<Integer> shpat = buildshiftpat(pat);
        int res = 0;
        for(int i=0;i<input.size();i++) {
            int index = crazy(i,pat,shpat);
            res += input.get(i) * index;
        }

        return res;
    }

    public ArrayList<Integer> runone(ArrayList<Integer> input) {
        ArrayList<Integer> al = new ArrayList<Integer>();

        for(int i=1;i<input.size();i++) {
            al.add(testcase(input,i));
        }
        return al;
    }

    public void example1() {
        String inp = "12345678";
        ArrayList<Integer> al_input = parseInput(inp);
        System.out.println(al_input);
        for(int i=0;i<4;i++) {
            ArrayList<Integer> res = runone(al_input);
            System.out.println(res);
            for (int j=0;j<res.size();j++) {
                al_input.set(j, res.get(j));
            }
        }
    }

    public void part1() {
        String inp = readfromfile("data.txt");
        ArrayList<Integer> al_input = parseInput(inp);
        System.out.println(al_input);
        for(int i=0;i<100;i++) {
            ArrayList<Integer> res = runone(al_input);
            System.out.println(res);
            for (int j=0;j<res.size();j++) {
                al_input.set(j, res.get(j));
            }
        }

    }

    public static void main(String[] args) {
        Day app = new Day();
        app.example1();
        //app.part1();
        
    }
}