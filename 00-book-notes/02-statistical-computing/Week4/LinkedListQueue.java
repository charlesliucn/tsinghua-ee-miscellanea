
public class LinkedListQueue<T> {
	private int size;
	private Node first;
	private Node last;
	
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
	
	public void enQueue(T item) {
		Node node = new Node();
		node.item = item;
		if (size == 0) {
			
		}
	}
	
	public T deQueue() {
		if (size == 0) return null;
		Node node = first;
		first = first.next;
		size--;
		if(size == 0) {
			first = null;
			last = null;
		}
		return node.item;
	}
}
