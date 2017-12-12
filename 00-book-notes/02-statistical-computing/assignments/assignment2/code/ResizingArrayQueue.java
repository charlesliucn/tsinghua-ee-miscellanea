import java.util.Iterator;

/**
 * A class of resizing array queue, and use the queue in a circular way
 * @author liuqian-2014011216
 * @param <T> generic programming
 */
public class ResizingArrayQueue<T> implements Iterable<T> {
	/**
	 * the array of items
	 */
    private T[] items;
    /**
     * the size of the array, the number of elements in the array items
     */
    private int size;
    /**
     * the first index of the queue
     */
    private int front;
    /**
     * the last index of the queue
     */
    private int rear;

    @SuppressWarnings("unchecked")
    /**
     * The constructor of the class
     */
	public ResizingArrayQueue() {
        items = (T[]) new Object[1];
        size = 0;
        front = 0;
        rear = 0;
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
     * Resize the array of the queue(in a circular way)
     * @param cap the capacity of the resizing array
     */
    private void resize(int cap) {
        @SuppressWarnings("unchecked")
		T[] tmp = (T[]) new Object[cap];
        for (int i = 0; i < size; i++) {
            tmp[i] = items[(front + i) % items.length];
        }
        items = tmp;
        front = 0;
        rear  = size;
    }

    /**
     * add an item into the end of the queue
     * @param item the item needed to be added into queue
     */
    public void enqueue(T item) {
    	if (size == items.length) 
        	resize(2*size);
        items[rear] = item;
        rear++;
        if (rear == items.length) 
        	rear = 0;
        size++;
    }

    /**
     * extract an item from the front of the queue
     * @return the extracted item of the queue
     */
    public T dequeue() {
        if (isEmpty()) 
        	return null;
        size--;
        T item = items[front];
        items[front] = null;
        front++;
        if (front == items.length) 
        	front = 0;
        if (size <= items.length/4) //
        	resize(items.length/2); 
        return item;
    }
    
    /**
     * get the length of the items array
     * @return the length of the items array
     */
    public int getItemsLength() {
    	return items.length;
    }

    /**
     * The Iterator of the class
     * @return an Iterator
     */
    public Iterator<T> iterator() {
        return new ArrayIterator();
    }
    
    /**
     * Innerclass of the class, which also implements an iterator
     * @author Charles Liu
     *
     */
    private class ArrayIterator implements Iterator<T> {
        private int i = 0;
        
        /**
         * @return whether it has the next item
         */
        @Override
        public boolean hasNext() { 
        	return i < size;
        }
        
        /**
         * @return the next item
         */
        @Override
        public T next() {
            T item = items[(front + i) % items.length];
            i++;
            return item;
        }
    }
    
    /**
     * Unit Test of Resizing Array Queue Class
     * @param args the input arguments
     */
    public static void main(String[] args) {
    	ResizingArrayQueue<String> queue = new ResizingArrayQueue<>();
    	String[] test = {"to","be","or","-","not","to","-","be","-","-","-"};
    	System.out.println("---------Dequeue Test---------");
    	// To observe the change of the length of the items in the class object
    	for (String item: test) {
    		if(item.equals("-")) {
    			String dq = queue.dequeue(); //dequeue
    			System.out.println("Dequeue--->Items Length: " + queue.getItemsLength()); // change of the length
    			System.out.println(dq); // print the item
    		} else {
    			queue.enqueue(item);
    			System.out.println("Enqueue--->Items Length: " + queue.getItemsLength());
    		}
    	}
    	System.out.println("------String after dequeue-----");    	
    	for(String q: queue) {
    		System.out.println(q);
    	}
    }
}