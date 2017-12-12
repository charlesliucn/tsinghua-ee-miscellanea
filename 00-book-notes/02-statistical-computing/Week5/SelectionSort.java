
public class SelectionSort {
	public static void sort(Comparable[] a) {
		for(int i = 0; i < a.length - 1; i++) {
			int min = i;
			for(int j = i + 1; j < a.length; j++) {
				if(less(a[j],a[min]))
					min = j;
			}
			exch(a,i,min);
		}
	}
	
	private static boolean less(Comparable v, Comparable w) {
		return v.compareTo(w) < 0;
	}
	
	private static void exch(Comparable[]a, int i, int j) {
		Comparable t = a[i];
		a[i] = a[j];
		a[j] = t;
	}
	
	public static void main(String[] args) {
		System.out.print("------Array Test------\n");
		Comparable[] a = {4,8,2,6,3};
		for (int i = 0; i < a.length; i++)
			System.out.print(a[i]);
		System.out.print("\n");
		sort(a);
		for (int i = 0; i < a.length; i++)
			System.out.print(a[i]);
		System.out.print("\n");
		System.out.print("------String Test------\n");
		Comparable[] s = {"e","b","a","g"};
		for (int i = 0; i < s.length; i++)
			System.out.print(s[i]);
		System.out.print("\n");
		sort(s);
		for (int i = 0; i < s.length; i++)
			System.out.print(s[i]);
	}
}
