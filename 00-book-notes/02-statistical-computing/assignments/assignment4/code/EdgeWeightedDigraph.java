import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Scanner;
import java.io.BufferedInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;

/**
 * EdgeWeightedDigraph represents a digraph with weighted edges
 * @author liuqian-2014011216
 * the class mainly wants to read in the vertices and weights from the file(using filename)
 * and construct the Digraph according to the information
 */
public class EdgeWeightedDigraph {
	/**
	 * the number of the vertices
	 */
    private final int V;
    /**
     * the number of the edges
     */
    private int E;
    /**
     * store the adjacent vertices to a vertex, using bag
     */
    private Bag<DirectedEdge>[] adj;
    
    /**
     * The constructor of the EdgeWeightedDigraph Class
     * @param s the filename of the file to be read in
     * @throws FileNotFoundException throw an exception when filename s does not exist.
     */
    @SuppressWarnings("unchecked")
	public EdgeWeightedDigraph(String s) throws FileNotFoundException {
    	In in = new In(s);	 	// read the file using filename s
    	int V = in.readInt();	// read the number of vertices
    	this.V = V;
    	
    	// initialize the adjacent arrays for V vertices
        adj = (Bag<DirectedEdge>[]) new Bag[V];	
        for (int v = 0; v < V; v++)
            adj[v] = new Bag<DirectedEdge>();
        
        int E = in.readInt();	// read the number of edges

        // add the edges to the Digraph one by one, using the constructor of DirectedEdge Class
        for (int i = 0; i < E; i++) {
            int v = in.readInt();
            int w = in.readInt();
            double weight = in.readDouble();
            addEdge(new DirectedEdge(v, w, weight));
        }
    }

    /**
     * return the number of the vertices
     * @return the number of the vertices
     */
    public int V() {
        return V;
    }
    
    /**
     * return the number of the edges
     * @return the number of the edges
     */
    public int E() {
        return E;
    }

    /**
     * add an edge to the DirectedEdge
     * @param e the directed edge to be added
     */
    public void addEdge(DirectedEdge e) {
        int v = e.from();
        @SuppressWarnings("unused")
		int w = e.to();
        adj[v].add(e);
        E++;
    }

    /**
     * The Iterable method of the adjacent vertices to a vertex v
     * @param v a vertex
     * @return Iterable method
     */
    public Iterable<DirectedEdge> adj(int v) {
        return adj[v];
    }

    /**
     * The Iterable method of the adjacent vertices to all the vertices
     * @return Iterable method
     */
    public Iterable<DirectedEdge> edges() {
        Bag<DirectedEdge> list = new Bag<DirectedEdge>();
        for (int v = 0; v < V; v++) {
            for (DirectedEdge e : adj(v)) {
                list.add(e);
            }
        }
        return list;
    } 

    /**
     * A helper class to store the information of the adjacent vertices
     * @author liuqian-2014011216
     * @param <Item> Generic Programming
     */
    public class Bag<Item> implements Iterable<Item> {
        private Node<Item> first;    // represents the beginning of bag
        private int n;               // the current number of elements in bag

        /**
         * A help class of Node
         * @author 2014011216
         * @param <Item> generic programming
         */
        @SuppressWarnings("hiding")
		private class Node<Item> {
            private Item item; 		// the item of the node
            private Node<Item> next;// the next node
        }
        
        /**
         * Default constructor
         */
        public Bag() {
            first = null;
            n = 0;
        }

        /**
         * whether the bag is empty or not
         * @return the state of bag (empty or not)
         */
        public boolean isEmpty() {
            return first == null;
        }

        /**
         * return the size of the bag
         * @return the size
         */
        public int size() {
            return n;
        }

        /**
         * add an item to current bag
         * @param item the item to be added
         */
        public void add(Item item) {
            Node<Item> oldfirst = first;
            first = new Node<Item>();
            first.item = item;
            first.next = oldfirst;
            n++;
        }

        /**
         * The Iterator
         */
        public Iterator<Item> iterator()  {
            return new ListIterator<Item>(first);  
        }

        /**
         * ListIterator
         * @param <Item>
         */
        @SuppressWarnings("hiding")
    	private class ListIterator<Item> implements Iterator<Item> {
            private Node<Item> current;
            public ListIterator(Node<Item> first) {
                current = first;
            }
            public boolean hasNext()  { return current != null;                     }
            public void remove()      { throw new UnsupportedOperationException();  }
            public Item next() {
                if (!hasNext()) throw new NoSuchElementException();
                Item item = current.item;
                current = current.next; 
                return item;
            }
        }
    }
    
    /**
     * A helper class to read in the data from the file
     * @author liuqian-2014011216
     */
    public final class In {
        private Scanner scanner;
        public In(String name) throws FileNotFoundException {
            File file = new File(name);
            if (file.exists()) {
                FileInputStream fis = new FileInputStream(file);
                scanner = new Scanner(new BufferedInputStream(fis));
                return;
            }
        }

        /**
         * @return whether the filename exists
         */
        public boolean exists()  {
            return scanner != null;
        }
        /**
         * read and return an Integer 
         * @return the integer just read in
         */
        public int readInt() {
        	return scanner.nextInt();
        }
        /**
         * read and return an double 
         * @return the double number just read in
         */
        public double readDouble() {
         	return scanner.nextDouble();
        }
    }
    
    public static void main(String[] args) throws FileNotFoundException {
//        EdgeWeightedDigraph G = new EdgeWeightedDigraph("10000EWD.txt"); // the file may not be open from eclipse
//        System.out.println(G);
    }
}