import java.util.*;
import java.io.*;

public class Day {

    HashMap hmpat = new HashMap<Integer,int[]>();
    HashMap hmshpat = new HashMap<Integer,int[]>();

    public int[] cvtALtoA(ArrayList<Integer> al) {
        int[] tmp = new int[al.size()];
        for(int i=0;i<al.size();i++) {
            tmp[i] = al.get(i);
        }
        return tmp;
    }

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

    public int[] buildpat(int n) {
        if (hmpat.containsKey(n)) {
            return (int[])hmpat.get(n);
        }
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
        hmpat.put(n,cvtALtoA(al));
        return (int[])hmpat.get(n);
    }

    public int[] buildshiftpat(int n, int[] input) {
        if (hmshpat.containsKey(n)) {
            return (int[])hmshpat.get(n);
        }
        ArrayList<Integer> al = new ArrayList<Integer>();
        for (int i=1;i<input.length;i++) {
            al.add(input[i]);
        }
        hmshpat.put(n, cvtALtoA(al));
        return (int[])hmshpat.get(n);
    }

    public int crazy(int i, ArrayList<Integer> pat, int patsize,
        ArrayList<Integer> shpat, int shpatsize) {
        int cl = shpatsize;
        if (i<cl) {
            return shpat.get(i);
        } else {
            i -= cl;
            return pat.get(i%patsize);
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

    public int testcase(int[] input, int cp) {
        //System.out.println("testcase starts to build pat...");
        int[] pat = buildpat(cp+1);
        int[] shpat = buildshiftpat(cp+1,pat);
        int patsize = pat.length;
        int shpatsize = shpat.length;

        //System.out.println("testcase finishes building pat");
        //System.out.println("pat : " + pat);
        //System.out.println("shpat : " + shpat);
        //System.out.println("test starting to iterate...");
        int res = 0;
        for(int i=0;i<input.length;i++) {
            //int index = crazy(i,pat,patsize,shpat,shpatsize);
            int index;
            if (i<shpatsize) {
                index = shpat[i];
            } else {
                index = pat[(i-shpatsize)%patsize];
            }
            //System.out.println("\t i : " + i + " index: " + index);
            int tmp = input[i] * index;
            //System.out.println("\t" + input.get(i) + " " + tmp);
            res += tmp;
        }
        //System.out.println("testcase returning");
        //System.out.println("res: " + res);
        if (res<0) {
            res *= -1;
        }
        return res % 10;
    }

    /*
    public int testcase(ArrayList<Integer> input, int cp) {
        //System.out.println("testcase called cp: " + cp);
        ArrayList<Integer> pat = buildpat(cp+1);
        ArrayList<Integer> shpat = buildshiftpat(pat);
        //System.out.println("pat : " + pat);
        //System.out.println("shpat : " + shpat);
        int res = 0;
        for(int i=0;i<input.size();i++) {
            int index = crazy(i,pat,shpat);
            //System.out.println("\t i : " + i + " index: " + index);
            int tmp = input.get(i) * index;
            //System.out.println("\t" + input.get(i) + " " + tmp);
            res += tmp;
        }
        //System.out.println("res: " + res);
        return Math.abs(res) % 10;
    }
    */

    public int[] runone(int[] input) {
        System.out.println("runone starting allocating al...");
        int[] al = new int[input.length];
        System.out.println("starting runone testcases...");
        for(int i=0;i<input.length;i++) {
            al[i] = testcase(input,i);
            if ((i%100)==0) {
                System.out.print("*");
            }
        }
        System.out.println("runone returning al");
        return al;
    }

    /*
    public ArrayList<Integer> runone(ArrayList<Integer> input) {
        ArrayList<Integer> al = new ArrayList<Integer>(input.size());

        for(int i=0;i<input.size();i++) {
            al.add(testcase(input,i));
        }
        return al;
    }
    */

    /*
    public void example2() {
        String inp = "80871224585914546619083218645595";
        ArrayList<Integer> al_input = parseInput(inp);
        for(int i=0;i<100;i++) {
            ArrayList<Integer> res = runone(al_input);
            System.out.println(res);
            for (int j=0;j<res.size();j++) {
                al_input.set(j, res.get(j));
            }
        }
    }
    */
    /*
    void example3() {
        String inp = "19617804207202209144916044189917";
        ArrayList<Integer> al_input = parseInput(inp);
        for(int i=0;i<100;i++) {
            ArrayList<Integer> res = runone(al_input);
            System.out.println(res);
            for (int j=0;j<res.size();j++) {
                al_input.set(j, res.get(j));
            }
        }
    }
    */
    /*
    public void example1() {
        String inp = "12345678";
        ArrayList<Integer> al_input = parseInput(inp);
        System.out.println(al_input);
        //ArrayList<Integer> res = runone(al_input);
        //System.out.println(res);
        
        for(int i=0;i<4;i++) {
            ArrayList<Integer> res = runone(al_input);
            System.out.println(res);
            for (int j=0;j<res.size();j++) {
                al_input.set(j, res.get(j));
            }
        }        
    }
    */
    /*
    public void example4() {
        String inp = "69317163492948606335995924319873";
        ArrayList<Integer> al_input = parseInput(inp);
        System.out.println(al_input);
        //ArrayList<Integer> res = runone(al_input);
        //System.out.println(res);
        
        for(int i=0;i<100;i++) {
            ArrayList<Integer> res = runone(al_input);
            System.out.println(res);
            for (int j=0;j<res.size();j++) {
                al_input.set(j, res.get(j));
            }
        }
    }
    */
    /*
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
    */
    public void part2() {
        String inp = readfromfile("data.txt");
        ArrayList<Integer> al_input = parseInput(inp);
        System.out.println("creating big array...");
        //ArrayList<Integer> big = new ArrayList<>(al_input.size() * 10000);
        int[] big = new int[al_input.size() * 10000];

        System.out.println("filling big array...");
        for(int i=0;i<10000;i++) {
            for (int j=0;j<al_input.size();j++) {
                big[i] = al_input.get(j);
                //big.add(al_input.get(j));
            }
        }
        //System.out.println("size of big array: " + big.size());

        System.out.println("running algo now...");
        for(int i=0;i<100;i++) {
            System.out.println("starting round: " + i);
            int[] res = runone(big);
            //System.out.println(res);
            System.out.println("copying over res for round: " + i);
            for (int j=0;j<res.length;j++) {
                big[j] = res[j];
                //big.set(j, res.get(j));
            }
            res = null; // trying to help GC
        }

        System.out.println("printing first seven digits...");
        for(int i=0;i<7;i++) {
            System.out.print(big[i]);
        }
        System.out.println();


    }

    public void part2_example1() {
        String inp = "03036732577212944063491565474664";
        ArrayList<Integer> al_input = parseInput(inp);
        System.out.println(al_input);
        //ArrayList<Integer> res = runone(al_input);
        //System.out.println(res);
        int[] big = new int[al_input.size() * 10000];

        System.out.println("filling big array...");
        for(int i=0;i<10000;i++) {
            for (int j=0;j<al_input.size();j++) {
                big[i] = al_input.get(j);
                //big.add(al_input.get(j));
            }
        }

        for(int i=0;i<100;i++) {
            int[] res = runone(big);
            System.out.println(res);
            for (int j=0;j<res.length;j++) {
                //al_input.set(j, res.get(j));
                big[j] = res[j];
            }
        }

    }

    public static void main(String[] args) {
        Day app = new Day();
        //app.example1();
        //app.part1();
        //app.example2();
        //app.example3();
        //app.example4();
        //app.part2();
        app.part2_example1();
    }
}