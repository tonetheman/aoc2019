package tone;

class Computer {
	public int[] instructions;
	public int ip;
	public boolean halted;

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

		int ci = instructions[ip];
		if (ci==1) {
			//System.out.println("add");
			int arg1 = instructions[ip+1];
			int arg2 = instructions[ip+2];
			int store = instructions[ip+3];
			instructions[store] = instructions[arg1] + instructions[arg2];
			ip += 4;
			return;
		}
		if (ci==2) {
			//System.out.println("mult");
			int arg1 = instructions[ip+1];
			int arg2 = instructions[ip+2];
			int store = instructions[ip+3];
			instructions[store] = instructions[arg1] * instructions[arg2];
			ip += 4;
			return;
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


	public static void main(String[] args) {
		Main.part1();
	}

}
