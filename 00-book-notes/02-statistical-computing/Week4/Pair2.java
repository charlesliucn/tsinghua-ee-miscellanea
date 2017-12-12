
public class Pair2 <T, U> {
	T first;
	U second;
	
	public Pair2 (T first, U second) { //Constructor²»ÐèÒª¸ú<>
		this.first = first;
		this.second = second;
	}
	
	public T getFirst() {
		return this.first;
	}
	
	public U getSecond() {
		return this.second;
	}
	
	public String toString() {
		return first.toString() + ", " + second.toString();
	}
	
	public static void main(String[] args) {
		//Pair2<String, String> p = new Pair2<>("Beijing","China");
		Pair2<String, Integer> p = new Pair2<>("China", 86);
		System.out.println(p.toString());
	}

}
