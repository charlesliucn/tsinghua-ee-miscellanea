
public class ResizingArrayStack<T>{
	private T[] items;
	private int size;
	
	public ResizingArrayStack() {
		this.size = 0;
		this.items = (T[]) new Object[8];
	}
	
	public void push(T item) {
		if(this.size < items.length) {
			items[size] = item;
		} else {
			T[] oldArray = this.items;
			items = (T[]) new Object[size*2];
			for (int i = 0; i < this.size; i++) {
				items[i] = oldArray[i];
			}
			items[size] = item;
 		}
		size++;
	}
	
	public T pop() {
		if (size == 0) return null;
		size--;
		T output = items[size];
		items[size] = null;
		if (this.size < items.length/4) {
			T[] oldArray = items;
			items = (T[]) new Object[oldArray.length/2];
			for (int i = 0; i < size; i++) {
				items[i] = oldArray[i];
			}
		}
		return output;
	}
	
}
