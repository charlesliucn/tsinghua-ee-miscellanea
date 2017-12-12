import java.util.Iterator;  

/**
 * Linked List Class
 * @author liuqian-2014011216
 * @param <T> generic programming
 */
public class LinkedList<T> implements Iterable<T> {  
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
    	/**
    	 * the item of the Node
    	 */
    	private T item;
    	/**
    	 * pointer to the next Node
    	 */
    	private Node next;
    }
    
    /**
     * Constructor of the class
     */
    public LinkedList() {
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
        return this.size;  
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
    	Node node = head;
    	for (int i = 0; i < index; i++) {
    		node = node.next;
    	}
    	return node;
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
        Node node = new Node();
        node.item = item;
        if(index == 0) {
        	node.next = head;
        	head = node;
        } else if(index == size) {
        	Node last = findNode(index - 1);
        	last.next = node;
        } else {
        	node.next = findNode(index);
        	findNode(index - 1).next = node;
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
        	head = head.next;
        	size--;
        	return toRemoveNode.item;
        } else {
            Node toRemoveNode = findNode(index);
            Node preNode = findNode(index-1);
            preNode.next = toRemoveNode.next;
            toRemoveNode.next = null;
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
    @Override  
    public Iterator<T> iterator() {   
        return new LinkedListIterator();  
    }  
  
    /**
     * The inner class intended for the iterator
     */
    private class LinkedListIterator implements Iterator<T> {
        private int currentIndex = 0;
        @Override  
        public boolean hasNext() {  
            // TODO Auto-generated method stub  
            return (currentIndex < size);
        }
  
        @Override  
        public T next() {  
            // TODO Auto-generated method stub 
        	Node nextNode = findNode(currentIndex).next;
        	currentIndex++;
            return nextNode.item; 
        }
    }
    
    /**
     * Unit Test to test all the functions of the class
     * @param args the arguments
     */
    public static void main(String[] args) {
    	LinkedList<String> list = new LinkedList<>();
    	System.out.println(list.isEmpty());
    	System.out.println(list.toString());
    	String[] strings = {"a","e","i","o","u"};
    	System.out.println("---------add into the list---------");
    	for (String s:strings) {
    		list.add(s);
    	}
    	System.out.println(list.toString());
    	System.out.println(list.size());
    	System.out.println(list.isEmpty());
    	System.out.println("---------get----------");
    	System.out.println(list.get(1));
    	System.out.println("---------set----------");
    	System.out.println(list.set(0,"b"));
    	System.out.println(list.toString());
    	list.add("c");
    	System.out.println(list.toString());
    	System.out.println(list.get(5));
    	list.add("e",4);
    	System.out.println(list.toString());

    }
    
  
} 