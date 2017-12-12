
public class MyInvestment {
	public static void main(String[] args) {
		Security s = new Security("Bob",12,SecurityType.FUND);
		System.out.println(s.getId());
		System.out.println(s.getName());
	}
}
