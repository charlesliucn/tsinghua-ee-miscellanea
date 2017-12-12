
public class LinkedListStack<T> {
	private int size;
	private Node top;
	
	private class Node {
		T item;
		Node next;
		
	}
	
	public int size() {
		return this.size;
	}
	
	public boolean isEmpty() {
		return this.size == 0;
	}
	
	public void Push(T item) {
		Node node = new Node();
		node.item = item;
		
		if (this.isEmpty()) {
			top = node;
		} else {
			node.next = top;
			top = node;
		}
		this.size++;
	}
	
	public T pop() {
		if (size == 0) return null;
		Node node = top;
		top = node.next;
		size--;
		return top.item;
	}
	
}
