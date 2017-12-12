import java.util.Iterator;

public class FixedCapacityStack<T> {
	private T[] items;
	private int size;
	
	public FixedCapacityStack(int cap) {
		this.size = 0;
		this.items = (T[]) new Object[cap];
	}
	
	public int size() {
		return this.size;
	}
	
	public boolean isEmpty() {
		return this.size == 0;
	}
	
	public void push(T item) {
		if (size == items.length) return;
		items[size] = item;
		this.size++;
	}
	
	public T pop() {
		if (size == 0) return null;
		this.size--;
		return this.items[size];
	}
	
	public Iterator<T> iterator(){
		return new InnerIterator();
	}
	private class InnerIterator implements Iterator<T> {
		
		private int index = size;
		
		@Override
		public boolean hasNext() {
			// TODO Auto-generated method stub
			return index > 0;
		}

		@Override
		public T next() {
			// TODO Auto-generated method stub
			return items[index];
		}
		
	}
	public static void main(String[] args) {
		FixedCapacityStack<String> stack = new FixedCapacityStack<>(100);
		
		for(String s: args) {
			if (s == "-")
				stack.pop();
			else
				stack.push(s);
		}
//		while(!stack.isEmpty()) {
//			System.out.println(stack.pop());
//		}
//		for (String s: stack) {
//			System.out.println(s);
//		}
//		System.out.println(stack.size());
	}
	
}
