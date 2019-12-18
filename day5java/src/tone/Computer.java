package tone;

class Computer {
	public int[] instructions;
	public int ip;
	public boolean halted;
	private int input;
	public int output;
	public boolean debug = true;

	public void set_input(int input) {
		if (debug) {
			System.out.println("dbg: input is set to: " + input);
		}
		this.input = input;
	}

	public int get_input() {
		return this.input;
	}

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
