import java.util.Iterator;
import java.util.ListIterator;


/**
 * Doubly Linked List Clas
 * @author liuqian-2014011216
 * @param <T> generic programming
 */
public class DoublyLinkedList<T> implements Iterable<T> {
	/**
	 * the size of the list
	 */
    private int size = 0;
    /**
     * the head node of the list
     */
    private Node head;

    /**
     * Innerclass(private)
     * @author 2014011216
     *
     */
    private class Node {
        private T item;
        private Node next;
        private Node prev;
    }

    /**
     * The constructor
     */
    public DoublyLinkedList() {
        head = null;
        size = 0;
    }
    
    /**
     * get to know whether the queue is empty
     * @return true if the queue is empty, false if not
     */
    public boolean isEmpty() {
    	return size == 0;
    }
    
    /**
     * get the number of the elements in the queue
     * @return the size of the queue
     */
    public int size() {
    	return size;
    }

    /**
     * find the respective Node in terms of the index
     * @param index the index of the needed node
     * @return the Node object with the index
     * @throws IndexOutOfBoundsException throw an exception
     * when the index is out of the bounds
     */
    private Node findNode(int index) throws IndexOutOfBoundsException{
    	if (index < 0 || index >= size) {  
    		throw new IndexOutOfBoundsException();  
    	} 
    	if (index == 0)
    		return head;
    	Node newNode = head;
    	for (int i = 0; i < index; i++) {
    		newNode = newNode.next;
    	}
    	return newNode;
    }
    
    /**
     * add an item into the linked list with a specific index
     * @param item the item to be added into the queue
     * @param index the index of the position
     * @throws IndexOutOfBoundsException throw an exception
     * when the index is out of the bounds
     */
    private void add(T item, int index) throws IndexOutOfBoundsException {  
        if (index < 0 || index > size) {  
            throw new IndexOutOfBoundsException();  
        }
        Node newNode = new Node();
        newNode.item = item;
        if(index == 0) {
        	head = newNode;
        } else if(index == size) {
        	Node last = findNode(index - 1);
        	last.next = newNode;
        	newNode.prev = last;
        } else {
        	newNode.next = findNode(index);
        	findNode(index).prev = newNode;
        	findNode(index-1).next = newNode;
        	newNode.prev = findNode(index-1);
        }
        size++;
    }
    
    /**
     * add the item to the end of the list
     * @param item the item to be added
     */
    public void add(T item) {
    	 this.add(item, this.size);
    }
    
    
    /**
     * get the item of the Node
     * @param index the index of the needed node
     * @return the item of the Node
     * @throws IndexOutOfBoundsException throw an exception
     * when the index is out of the bounds
     */
    private T get(int index) throws IndexOutOfBoundsException { 
        return findNode(index).item;
    }
    
    /**
     * set the item value for the Node with specific index
     * @param index the index for the Node
     * @param item the value of the item
     */
    public T set(int index, T item) {  
        if (index < 0 || index >= size) {  
            throw new IndexOutOfBoundsException();  
        }
        T tmp = findNode(index).item;
        findNode(index).item = item;
        return tmp;
    }  
    
    /**
     * Remove a Node with a concrete index
     * @param index the index
     * @return the removed value
     */
    public T remove(int index) {  
        if (index < 0 || index >= size) {  
            throw new IndexOutOfBoundsException();  
        } else if (index == 0) {
        	Node toRemoveNode = head;
        	head.next.prev = null;
        	head = head.next;
        	size--;
        	return toRemoveNode.item;
        } else {
            Node toRemoveNode = findNode(index);
            toRemoveNode.prev.next = toRemoveNode.next;
            toRemoveNode.prev = toRemoveNode.prev;
            size--;
            return toRemoveNode.item;  
        }
    } 

    /**
     * Convert the class to a single string
     */
    public String toString() {
    	String s = new String();
    	for (int i = 0;i < this.size;i++) {
    		s = s + get(i);
    	}
    	return s;
    }
    
    /**
     * The iterator of the class
     */
    public Iterator<T> iterator() {   
        return new DoublyLinkedIterator();  
    }
    
    public ListIterator<T> listIterator() {
    	return new DoublyLinkedListIterator();
    }

    private class DoublyLinkedIterator implements Iterator<T>{

        private int index = 0;

        public boolean hasNext() { 
        	return index < size;
        }

		@Override
        public T next() {
            Node current = findNode(index);
            Node nextNode = current.next;
            index++;
            return nextNode.item;
        }
    	
    }

    private class DoublyLinkedListIterator implements ListIterator<T> {
        private int index = 0;

        public boolean hasNext() { 
        	return index < size;
        }
        public boolean hasPrevious(){
        	return index > 0; 
        }

        public T next() {
            Node current = findNode(index);
            Node nextNode = current.next;
            index++;
            return nextNode.item;
        }

        public T previous() {
            index--;
            Node current = findNode(index);
            return current.item;
        }

        public void set(T item) {
        	Node current = findNode(index);
            current.item = item;
        }

        public void remove() { 
           	Node current = findNode(index); 
            Node x = current.prev;
            Node y = current.next;
            x.next = y;
            y.prev = x;
            size--;
        }

        public void add(T item) {
        	Node current = findNode(index); 
            Node x = current.prev;
            Node y = new Node();
            Node z = current;
            y.item = item;
            x.next = y;
            y.next = z;
            z.prev = y;
            y.prev = x;
            size++;
            index++;
        }
		@Override
		public int nextIndex() {
			// TODO Auto-generated method stub
			return index+1;
		}
		@Override
		public int previousIndex() {
			// TODO Auto-generated method stub
			return index-1;
		}
    }

    /**
     * Unit Test to test all the functions of the class
     * @param args the arguments
     */
    public static void main(String[] args) {
    	DoublyLinkedList<String> doublylist = new DoublyLinkedList<>();
    	System.out.println(doublylist.isEmpty());
    	System.out.println(doublylist.toString());
    	String[] strings = {"a","e","i","o","u"};
    	for (String s:strings) {
    		doublylist.add(s);
    	}
    	System.out.println(doublylist.toString());
    	System.out.println(doublylist.size());
    	System.out.println(doublylist.isEmpty());
    	System.out.println("---------get----------");
    	System.out.println(doublylist.get(1));//e
    	System.out.println("---------set----------");
    	System.out.println(doublylist.set(0,"b"));//a
    	System.out.println(doublylist.toString());
    	doublylist.add("c");
    	System.out.println(doublylist.toString());
    	System.out.println(doublylist.get(5));
    	doublylist.add("e",4);
    	System.out.println(doublylist.toString());

    }
}