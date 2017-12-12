
public class MergeSort {
	private static Comparable[] aux;
	public static void sort(Comparable[] a) {
		aux = new Comparable[a.length];
		sort(a, 0, a.length-1);
	}
	
	private static void sort(Comparable[] a, int low, int high) {
		if (high <= low) return;
		int mid = low + (high - low) / 2;
		sort(a, low, mid);
		sort(a, mid+1, high);
		merge(a, low, mid, high);
	}
	
	private static void merge(Comparable[] a, int low, int mid, int high) {
		int i = low, j = mid + 1;
		for (int k = low; k <= high; k++)
			aux[k] = a[k];
		for (int k = low; k <= high; k++) {
			if (i > mid) {
				a[k] = aux[j];
				j++;
			} else if (j > high) {
				a[k] = aux[i];
				i++;
			} else if (less(aux[j], aux[i])) {
				a[k] = aux[j];
				j++;
			} else {
				a[k] = aux[i];
				i++;
			}
		}
	}
	
	private static boolean less(Comparable v, Comparable w) {
		return v.compareTo(w) < 0;
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
