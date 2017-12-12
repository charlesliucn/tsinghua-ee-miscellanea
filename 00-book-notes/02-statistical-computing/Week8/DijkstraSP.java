import java.util.ArrayList;
import java.io.FileNotFoundException;

/**
 * The DijkstraSP is intended to find the shortest path from the source to a vertex
 * @author liuqian-2014011216
 */
public class DijkstraSP {
    /**
     * priority queue of vertices
     */
    private IndexMinPQ<Double> pq;
	/**
	 * the distances of shortest path from source to the vertices
	 */
    private double[] distTo;
    /**
     * the last edge on shortest s->v path
     */
    private DirectedEdge[] edgeTo;

    /**
     * Construct from a digraph and the given source
     * @param G and EddgeWeighted Digraph
     * @param s the source vertex of the digraph
     */
    public DijkstraSP(EdgeWeightedDigraph G, int s) {
    	// initialize the distances and the last edges
        distTo = new double[G.V()];	
        edgeTo = new DirectedEdge[G.V()];
        for (int v = 0; v < G.V(); v++)
            distTo[v] = Double.POSITIVE_INFINITY; //set the default values as positive infinity
        distTo[s] = 0.0;
        // relax vertices in order of distance from s
        pq = new IndexMinPQ<Double>(G.V());
        pq.insert(s, distTo[s]);
        while (!pq.isEmpty()) {
            int v = pq.delMin();
            for (DirectedEdge e : G.adj(v))
                relax(e);
        }
    }

    
    /**
     * relax edge e and update pq if changed
     * @param e the directed edge to be relaxed
     */
    private void relax(DirectedEdge e) {
        int v = e.from(), w = e.to();
        if (distTo[w] > distTo[v] + e.weight()) {
            distTo[w] = distTo[v] + e.weight();
            edgeTo[w] = e;
            if (pq.contains(w)) pq.decreaseKey(w, distTo[w]);
            else                pq.insert(w, distTo[w]);
        }
    }

    /**
     * return the distance from source to vertex v
     * @param v the vertex in a digraph
     * @return the distance from source to the given vertex v
     */
    public double distTo(int v) {
        return distTo[v];
    }

    /**
     * return if there is path from source to vertex v
     * @param v the vertex in a digraph
     * @return whether there is  from source to the given vertex v
     */
    public boolean hasPathTo(int v) {
        return distTo[v] < Double.POSITIVE_INFINITY;
    }

    /**
     * get the vertices as an int array in the path from source to vertex v
     * @param v the given vertex
     * @return the int array of the vertices in the path
     */
    public int[] arrayPathTo(int v) {
        if (!hasPathTo(v)) return null;
        // ArrayList is easy to handle
        ArrayList<Integer> path = new ArrayList<Integer>();
        for (DirectedEdge e = edgeTo[v]; e != null; e = edgeTo[e.from()]) {
            path.add(e.to());
        }
        path.add(0);
        
        // from ArrayList to Integer Array
        Integer [] arrayPath = (Integer [])path.toArray(new Integer[path.size()]);
        
        // from Integer Array to int array int[]
        int[] arrayPathInt = new int[path.size()];
        for(int i = arrayPath.length-1;i >= 0 ;i--){
        	arrayPathInt[arrayPath.length-1-i] = arrayPath[i].intValue();
        }
        // return the int array
        return arrayPathInt;
    }

    /**
     * Unit Test for DijkstraSP Class
     * @param args the arguments
     * @throws FileNotFoundException
     */
    public static void main(String[] args) throws FileNotFoundException {
        EdgeWeightedDigraph G = new EdgeWeightedDigraph("10000EWD.txt");
        DijkstraSP sp = new DijkstraSP(G, 0); // 0 is the source vertex
        
        // print shortest path from 0 to 6 for example
        if (sp.hasPathTo(6)) {
            System.out.printf("0¡ú6 distance:" + sp.distTo(6));
            System.out.println();
            @SuppressWarnings("unused")
			int[] path = sp.arrayPathTo(6);
            System.out.println();
            for(int i = 0; i < path.length;i++) {
            	System.out.print(path[i]+" ");
            }
            System.out.println();
        }
        else {
            System.out.printf("%d to %d  no path\n", 0, 6);
        }
    }
}
