import java.time.LocalDate;

public class Transaction {
	private static int nextId = 0;
	private int id;
	private TransactionType type;
	private double price;
	private double quantity;
	private LocalDate date;
	
	public Transaction(TransactionType type, double price,
			double quantity, LocalDate date) {
		this.id = nextId;
		nextId++;
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.date = date;
	}
	
	public Transaction(int id, TransactionType type, double price,
			double quantity, LocalDate date) {
		this.id = id;
		if(id >= nextId)
			nextId = id + 1;
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.date = date;
	}
	
	public int getId() { 
		return this.id;
	}
	
	public void setId(int id) {
		this.id = id;
	}
	
	public TransactionType getType() {
		return this.type;
	}
	
	public double getPrice() {
		return this.price;
	}
	
	public double getQuantity() {
		return this.quantity;
	}
	
	public LocalDate getDate() {
		return this.date;
	}
	

}

enum TransactionType {BUY, SELL, BONUS, INC_SHARE}