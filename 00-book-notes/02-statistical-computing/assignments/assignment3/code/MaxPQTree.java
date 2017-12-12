/**
 * A class using a heap-ordered binary tree to develop a priority queue
 * The class includes insert, remove, max, delMax functions.
 * @author liuqian-2014011216
 * @param <T> implement Generic Programming
 */
public class MaxPQTree<T extends Comparable<T>> {
	/**
	 * A reference to root node
	 */
	private Node root;
	/**
	 * the number of the nodes in the tree
	 */
	private int size;
	
	/**
	 * Node Class, intended to implement linked nodes
	 * @author liuqian-2014011216
	 * Node includes four fields
	 */
	private class Node{
		/**
		 * data field: the item(data) in the Node
		 */
		private T item;
		/**
		 * the parent node of current node
		 */
		private Node parent;
		/**
		 * the left child node of current node
		 */
		private Node left;
		/**
		 * the right child node of current node
		 */
		private Node right;
		
		/**
		 * Constructor to create a new Node instance
		 * @param item the item/data of the new node
		 * @param parent the parent node of the new node
		 * @param left the left node of the new node
		 * @param right the right node of the new node
		 */
		private Node(T item, Node parent, Node left, Node right) {  
            this.item = item;  
            this.parent = parent;  
            this.left = left;  
            this.right = right;  
        }
	}
	
	/**
	 * The default constructor of MaxPQTree class (without an existing T array)
	 * initialize the tree parameter
	 */
	public MaxPQTree(){
		this.size=0;
		this.root = null;
	}
	
	/**
	 * The constructor of MaxPQTree class with an existing T array
	 * @param items an array of T datatype, which is used to create a MaxPQTree
	 */
	public MaxPQTree(T[] items) {
		this.size = 0;
		this.root = null;
		// element-wisely insert the tree
		for(int i = 0;i < items.length;i++) {
			this.insert(items[i]);
		}
	}
	
	/**
	 * whether the tree is empty or not
	 * @return if there is no node(empty), then return true; otherwise, return false
	 */
	public boolean isEmpty(){
		return this.size == 0;
	}
	
	/**
	 * the size of the tree
	 * @return the size of the tree/ the number of the nodes
	 */
	public int size(){
		return this.size;
	}
	
	/**
	 * compare two nodes in terms of their items
	 * @param node1 the first node
	 * @param node2 the second node
	 * @return if the item of the first node is less than the item of the second node
	 * then return true. (use compareTo function)
	 */
	public boolean less(Node node1, Node node2) {
		return node1.item.compareTo(node2.item) < 0;
	}
	
	/**
	 * a helper funtion to locate the 
	 * @param k the index of the needed node 
	 * @return the node of index k
	 */
	private Node findNode(int k) {
		Node current = root; 	// start from the root node
		if (k == 0) 
			return null; 		// the index 0 is set as null
		else if (k == 1)
			return root;  		// the index 1 is root node
		else {
			while (k > 1) {
				if(k%2 == 0) 
					current = current.left;
				else current = current.right;
				k = k/2;
			}
			return current;
		}
	}
	
	/**
	 * exchange the Node with its parent, left child or right child node.
	 * @param node the current node
	 * @param type exchange with type 1: parent, type 2: left child or type 3: right child.
	 * @return the exchanged node
	 */
	public Node exch(Node node, int type) {
		if (type == 1) { 		// parent
			T tmp = node.item;
			node.item = node.parent.item;
			node.parent.item = tmp;
			node = node.parent;
		} else if(type == 2) { 	// left child
			T tmp = node.item;
			node.item = node.left.item;
			node.left.item = tmp;
			node = node.left;
		} else if(type == 3) { 	// right child
			T tmp = node.item;
			node.item = node.right.item;
			node.right.item = tmp;
			node = node.right;
		} else {
			System.err.println("Wrong Type!");	// error
		}
		return node;
	}
	
	/**
	 * insert function: insert a new node with T item
	 * @param item the data field of the new node
	 */
	public void insert(T item){
		if (isEmpty()) { 	// empty tree, set the new node as root
			root = new Node(item, null, null, null);
			size++;
			return;
		}
		Node current = findNode((size+1)/2); //locate the middle node (the leaf node)
		Node newNode = new Node(item, current, null, null); //start from the leaf node
		// first, insert the node to the tree
		if (size%2 > 0) 
			current.left = newNode;
		else current.right = newNode; 
		// then, adjust the tree using bottom-up method
		while (newNode.parent != null) {
			// when the item of new node is bigger than its parent, then exchange the positions.
			if (less(newNode.parent,newNode)) {
				newNode = exch(newNode,1);
			} else break;
		}
		size++;
	}
	
	/**
	 * get the maximum item of the tree(the item of the root)
	 * @return the maximum item of the tree
	 */
	public T max(){
		return root.item;
	}
	
	/**
	 * return and delete the maximum item(the item of the root) of the tree
	 * @return the maximum item of the tree
	 */
	public T delMax() {
		if (isEmpty()) //Empty tree
			return null;
		T maxItem = this.max();
		// root is the only node
		if (size == 1) {
			size--;
			root = null;
			return maxItem;
		}
		//find the middle node(the leaf node)
		Node current = findNode(size/2);
		if (size%2 > 0) {
			root.item = current.right.item;
			current.right=null;
		} else {
			root.item = current.left.item;
			current.left = null;
		}
		// adjust the tree after deleting the root
		Node pos = root;
		while(true) {
			// current node is less than its left node
			if(pos.left != null && less(pos, pos.left)) {
				if(pos.right == null) {
					// exchange the position of this node and its left child node
					pos = exch(pos,2);
					continue;
				} 
				// compare the right node with the left child node
				else if(less(pos.right, pos.left)){
					pos = exch(pos,2);
					continue;
				}
			}
			// exchange the position of this node and its rchild node
			if(pos.right != null && less(pos, pos.right)){
				pos = exch(pos,3);
				continue;
			}
			break;
		}
		size--;
		return maxItem;
	}
	
	/**
	 * Unit Test: test all the functions of MaxPQTree Class
	 * @param args the arguments
	 */
	public static void main(String args[]){
		System.out.println("------constructor 1-----");
		MaxPQTree<Integer> test = new MaxPQTree<Integer>();
		System.out.println("isEmpty: " + test.isEmpty());
		System.out.println("size: " + test.size());
		System.out.println("------insert test------");
		test.insert(3);
		test.insert(34);
		test.insert(13);
		test.insert(2010);
		test.insert(3204);
		test.insert(142);
		test.insert(40);
		test.insert(774);
		test.insert(41);
		System.out.println("isEmpty: " + test.isEmpty());
		System.out.println("size: " + test.size());
		System.out.println("max: " + test.max());
		System.out.println("------remove test------");
		for (int i = 0; i < test.size();i++)
			System.out.println(test.delMax());
		
		System.out.println("------constructor 2-----");
		Integer items[]={2,4,51,51,21025,148452,848,548};
		MaxPQTree<Integer> test2 = new MaxPQTree<Integer>(items);
		System.out.println("isEmpty: " + test2.isEmpty());
		System.out.println("size: " + test2.size());
		System.out.println("max: " + test2.max());
		System.out.println("------remove test------");
		for (int i = 0; i < test2.size();i++)
			System.out.println(test2.delMax());
		
	}
}