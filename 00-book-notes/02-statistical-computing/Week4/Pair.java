
public class Pair <T> {
	T first;
	T second;
	
	public Pair (T first, T second) { //Constructor²»ÐèÒª¸ú<>
		this.first = first;
		this.second = second;
	}
	
	public T getFirst() {
		return this.first;
	}
	
	public T getSecond() {
		return this.second;
	}
	
	public String toString() {
		return first.toString() + ", " + second.toString();
	}
	
	public static void main(String[] args) {
		Pair<String> p = new Pair<>("Beijing","China");
		System.out.println(p.toString());
	}

}
