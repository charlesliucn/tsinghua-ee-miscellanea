
public class Welcome {
	public static void main(String[] args) {
		if (args.length == 0) {
			System.out.println("Welcome to Statistical Computing!");
		}
		else if (args.length == 1) {
			System.out.println("Welcome to Statistical Computing, " + args[0] + "!");
		}
		else {
			System.out.print("Welcome to Statistical Computing");
			for(int i=0; i<args.length - 1;i++) {
				System.out.print(", " + args[i]);
			}
			System.out.println(" and " + args[args.length - 1] + "!");
		}
	}
}
