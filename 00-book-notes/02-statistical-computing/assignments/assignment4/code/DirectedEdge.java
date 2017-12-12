/**
 * DirectedEdge Class represents the directed edges
 * and provides the basic functions
 * @author liuqian-2014011216
 */
public class DirectedEdge { 
	/**
	 * the tail vertex of the directed edge
	 */
    private final int v;
    /**
     * the head vertex of the directed edge
     */
    private final int w;
    /**
     * the weight of the directed edge
     */
    private final double weight;

    /**
     * The constructor of the DirectedEdge Class
     * @param v the tail vertex
     * @param w the head vertex
     * @param weight the weight of the edge
     */
    public DirectedEdge(int v, int w, double weight) {
        this.v = v;
        this.w = w;
        this.weight = weight;
    }

    /**
     * get the tail vertex of the edge
     * @return the tail vertex
     */
    public int from() {
        return v;
    }

    /**
     * get the head vertex of the edge
     * @return the head vertex
     */
    public int to() {
        return w;
    }

    /**
     * get the weight of the edge
     * @return the weight
     */
    public double weight() {
        return weight;
    }

    public String toString() {
        return v + "->" + w + " " + weight;
    }
    
    /**
     * Unit Test of DirectedEdge Class
     * @param args the arguments
     */
    public static void main(String[] args) {
        DirectedEdge e = new DirectedEdge(1, 2, 1);
        System.out.println("This is an example directed edge:");
        System.out.println(e);
    }
}