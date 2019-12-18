package tone;

public class IOpcode {
	int opcode;
	int p1mode;
	int p2mode;
	int p3mode;
	public IOpcode(int a) {
		opcode = a%100;
		p1mode = (a%1000)/100;
		p2mode = (a%10000)/1000;
		p3mode = (a%100000)/10000;
	}
	public void pmodes() {
		System.out.println("p1 p2 p3 : " + p1mode +  " " + p2mode + " " + p3mode);
	}
}
