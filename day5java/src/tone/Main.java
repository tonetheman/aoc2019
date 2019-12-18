package tone;

class IOpcode {
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

class Computer {
	public int[] instructions;
	public int ip;
	public boolean halted;
	public int input;
	public int output;
	public boolean debug = true;

	public void print_instructions() {
		System.out.println("hlt: "+ halted);
		System.out.println("ip: " + ip);
		for(int i=0;i<instructions.length;i++) {
			System.out.print(instructions[i] +", ");
		}
		System.out.println();
	}

	public void cycle() {
		if (halted) {
			return;
		}

		IOpcode iop = new IOpcode(instructions[ip]);
		int ci = iop.opcode;
		if (ci==1) {
			int arg1 = instructions[ip+1];
			int p1 = -1;
			if (iop.p1mode==1) {
				// immediate
				p1 = arg1;
			} else {
				// position
				p1 = instructions[arg1];
			}
			int arg2 = instructions[ip+2];
			int p2 = -1;
			if (iop.p2mode==1) {
				p2 = arg2;
			} else {
				p2 = instructions[arg2];
			}
			int store = instructions[ip+3];
			instructions[store] = p1 + p2;
			ip += 4;
			return;
		}
		if (ci==2) {
			int arg1 = instructions[ip+1];
			int p1 = -1;
			if (iop.p1mode==1) {
				// immediate
				p1 = arg1;
			} else {
				// position
				p1 = instructions[arg1];
			}
			int arg2 = instructions[ip+2];
			int p2 = -1;
			if (iop.p2mode==1) {
				p2 = arg2;
			} else {
				p2 = instructions[arg2];
			}

			int store = instructions[ip+3];
			instructions[store] = p1 * p2;
			ip += 4;
			return;
		}
		if (ci==3) {
			int arg1 = instructions[ip+1];
			instructions[arg1] = input;
			if (debug) {
				System.out.println("input read and stored at " + arg1);
				iop.pmodes();
			}
			ip += 2;
		}
		if (ci==4) {
			int arg1 = instructions[ip+1];
			if (debug) {
				System.out.println("4 - output");
			}
			if (iop.p1mode==1) {
				output = arg1;
			} else {
				output = instructions[arg1];
			}
			
			ip += 2;
			//System.out.println("output called!");
			//iop.pmodes();
			//System.exit(0);
		}
		if ((ci==5)||(ci==6)) { // jmp if true and jmp if false
			int arg1 = instructions[ip+1];
			int p1 = 0;
			if (iop.p1mode==1) {
				p1 = arg1;
			} else {
				p1 = instructions[arg1];
			}

			int arg2 = instructions[ip+2];
			int p2;
			if (iop.p2mode==1) {
				p2 = arg2;
			} else {
				p2 = instructions[arg2];
			}
			
			if (ci==5) { // jmp if true
				// arg1 is non-zero then adjust ip to p2
				if (p1!=0) {
					ip = p2;
				} else {
					ip += 3;
				}
			} else {
				// jmp if false
				if (p1==0) {
					ip = p2;
				} else {
					ip += 3;
				}
			}
		}
		if (ci==7) { // less than
			int arg1 = instructions[ip+1];
			int p1 = 0;
			if (iop.p1mode==1) {
				p1 = arg1;
			} else {
				p1 = instructions[arg1];
			}

			int arg2 = instructions[ip+2];
			int p2;
			if (iop.p2mode==1) {
				p2 = arg2;
			} else {
				p2 = instructions[arg2];
			}
			int arg3 = instructions[ip+3];
			if (p1<p2) {
				instructions[arg3] = 1;
			} else {
				instructions[arg3] = 0;
			}
			ip += 4;
		}
		if (ci==8) {
			if (debug) {
				System.out.println("8 - equals");
				iop.pmodes();
			}
			
			int arg1 = instructions[ip+1];
			int p1 = 0;
			if (iop.p1mode==1) {
				p1 = arg1;
			} else {
				p1 = instructions[arg1];
			}

			int arg2 = instructions[ip+2];
			int p2;
			if (iop.p2mode==1) {
				p2 = arg2;
			} else {
				p2 = instructions[arg2];
			}
			int arg3 = instructions[ip+3];
			if (debug) {
				System.out.println("eq p1 p2 arg3 " + p1 + " " + p2 + " " + arg3);
			}
			if (p1==p2) {
				if (debug) {
					System.out.println("eq setting 1 in arg3 " + arg3);
				}
				instructions[arg3] = 1;
			} else {
				instructions[arg3] = 0;
			}
			ip += 4;
		}
		if (ci==99) {
			System.out.println("system halting");
			halted = true;
			return;
		}
		
	}

	public Computer(int[] instructions) {
		this.instructions = instructions;
		this.ip = 0;
		this.halted = false;
	}
}

public class Main {

	public static void test1() {
		//int[] instructions = {1,0,0,3,99};
		int[] instructions = {1,9,10,3,2,3,11,0,99,30,40,50};
		Computer computer = new Computer(instructions);
		int counter = 0;
		while (!computer.halted) {
			computer.print_instructions();
			computer.cycle();
			counter++;
			
			if (counter>10) {
				break;
			}
		}
	}


	public static void part1() {
		int[] instructions = {1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,10,19,1,19,5,23,2,23,6,27,1,27,5,31,2,6,31,35,1,5,35,39,2,39,9,43,1,43,5,47,1,10,47,51,1,51,6,55,1,55,10,59,1,59,6,63,2,13,63,67,1,9,67,71,2,6,71,75,1,5,75,79,1,9,79,83,2,6,83,87,1,5,87,91,2,6,91,95,2,95,9,99,1,99,6,103,1,103,13,107,2,13,107,111,2,111,10,115,1,115,6,119,1,6,119,123,2,6,123,127,1,127,5,131,2,131,6,135,1,135,2,139,1,139,9,0,99,2,14,0,0};
		
		instructions[1] = 12;
		instructions[2] = 2;

		Computer computer = new Computer(instructions);
		int counter = 0;
		while (!computer.halted) {
			computer.print_instructions();
			computer.cycle();
			counter++;			
		}
	
	}

	public static void part2() {
		int [] instructions = {3,225,1,225,6,6,1100,1,238,225,104,0,101,14,135,224,101,-69,224,224,4,224,1002,223,8,223,101,3,224,224,1,224,223,223,102,90,169,224,1001,224,-4590,224,4,224,1002,223,8,223,1001,224,1,224,1,224,223,223,1102,90,45,224,1001,224,-4050,224,4,224,102,8,223,223,101,5,224,224,1,224,223,223,1001,144,32,224,101,-72,224,224,4,224,102,8,223,223,101,3,224,224,1,223,224,223,1102,36,93,225,1101,88,52,225,1002,102,38,224,101,-3534,224,224,4,224,102,8,223,223,101,4,224,224,1,223,224,223,1102,15,57,225,1102,55,49,225,1102,11,33,225,1101,56,40,225,1,131,105,224,101,-103,224,224,4,224,102,8,223,223,1001,224,2,224,1,224,223,223,1102,51,39,225,1101,45,90,225,2,173,139,224,101,-495,224,224,4,224,1002,223,8,223,1001,224,5,224,1,223,224,223,1101,68,86,224,1001,224,-154,224,4,224,102,8,223,223,1001,224,1,224,1,224,223,223,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,108,226,677,224,1002,223,2,223,1006,224,329,1001,223,1,223,1007,226,226,224,1002,223,2,223,1006,224,344,101,1,223,223,1008,226,226,224,102,2,223,223,1006,224,359,1001,223,1,223,107,226,677,224,1002,223,2,223,1005,224,374,101,1,223,223,1107,677,226,224,102,2,223,223,1006,224,389,101,1,223,223,108,677,677,224,102,2,223,223,1006,224,404,1001,223,1,223,1108,677,226,224,102,2,223,223,1005,224,419,101,1,223,223,1007,677,226,224,1002,223,2,223,1006,224,434,101,1,223,223,1107,226,226,224,1002,223,2,223,1006,224,449,101,1,223,223,8,677,226,224,102,2,223,223,1006,224,464,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,479,1001,223,1,223,1007,677,677,224,102,2,223,223,1005,224,494,1001,223,1,223,1108,677,677,224,102,2,223,223,1006,224,509,101,1,223,223,1008,677,677,224,102,2,223,223,1005,224,524,1001,223,1,223,107,226,226,224,1002,223,2,223,1005,224,539,101,1,223,223,7,226,226,224,102,2,223,223,1005,224,554,101,1,223,223,1108,226,677,224,1002,223,2,223,1006,224,569,1001,223,1,223,107,677,677,224,102,2,223,223,1005,224,584,101,1,223,223,7,677,226,224,1002,223,2,223,1005,224,599,101,1,223,223,108,226,226,224,1002,223,2,223,1005,224,614,101,1,223,223,1008,677,226,224,1002,223,2,223,1005,224,629,1001,223,1,223,7,226,677,224,102,2,223,223,1005,224,644,101,1,223,223,8,677,677,224,102,2,223,223,1005,224,659,1001,223,1,223,8,226,677,224,102,2,223,223,1006,224,674,1001,223,1,223,4,223,99,226};
		Computer computer = new Computer(instructions);
		computer.input = 1;
		int counter = 0;
		while (!computer.halted) {
			//computer.print_instructions();
			computer.cycle();
			counter++;			
		}
		System.out.println("output is: " + computer.output);

	}

	public static void p2test1() {
		int [] instructions = {3,9,8,9,10,9,4,9,99,-1,8};
		Computer computer = new Computer(instructions);
		computer.input = 8;
		int counter = 0;
		while (!computer.halted) {
			computer.print_instructions();
			computer.cycle();
			counter++;			
		}

		System.out.println("output is: " + computer.output);
	}

	public static void p2test3() {
		int [] instructions = {3,3,1108,-1,8,3,4,3,99};
		Computer computer = new Computer(instructions);
		computer.input = 7;
		int counter = 0;
		while (!computer.halted) {
			computer.print_instructions();
			computer.cycle();
			counter++;			
		}

		System.out.println("output is: " + computer.output);
	}

	

	public static void digitTest() {
		int a = 12345;
		int opcode = a%100;
		int param1mode = (a%1000)/100;
		int param2mode = (a%10000)/1000;
		int param3mode = (a%100000)/10000;
		System.out.println("opcode: " + opcode);
		System.out.println("p1: " + param1mode);
		System.out.println("p2: " + param2mode);
		System.out.println("p3: " + param3mode);

	}

	public static void main(String[] args) {
		//Main.part1();
		//digitTest();
		//Main.part2();
		Main.p2test3();
	}

}
