import java.time.LocalDate;
//import java.time.format.DateTimeFormatter;
//import java.util.Collections;
//import java.util.LinkedList;
import java.math.BigDecimal;

public class Transaction implements Comparable<Transaction> {
	private int id;
	private int nextId = 0;
	private TransactionType type;
	private BigDecimal price;
	private BigDecimal quantity;
	private LocalDate date;
	
	public Transaction(TransactionType type, String price, 
		String quantity, LocalDate date) throws InvalidTransactionException {
		this.id = nextId;
		nextId++;
		this.type = type;
		this.price = new BigDecimal(price);
		this.quantity = new BigDecimal(quantity);
		if (this.quantity.signum() < 0) {
			throw new InvalidTransactionException(type,
					price, quantity, date, "negative quantity");
		}
		this.date = date;

	}
	
	public Transaction(int id,TransactionType type, String price,
			String quantity, LocalDate date) {
		this.id = id;
		this.type = type;
		this.price = new BigDecimal(price);
		this.quantity = new BigDecimal(quantity);
		this.date = date;
	}
	
	public int getID() {
		return this.id;
	}
	
	public TransactionType getType() {
		return this.type;
	}
	
	public BigDecimal getPrice() {
		return this.price;
	}
	
	public BigDecimal getQuantity() {
		return this.quantity;
	}
	
	public BigDecimal getTotal() {
		return this.price.multiply(this.quantity);
	}
	
	public LocalDate getDate() {
		return this.date;
	}
	
	public String toString() {
		StringBuilder strbld = new StringBuilder();
		strbld.append("date: ");		
		strbld.append(this.getDate());
		strbld.append(" type: ");
		strbld.append(this.getType());
		strbld.append(" price: ");
		strbld.append(this.getPrice());
		strbld.append(" quantity: ");
		strbld.append(this.getQuantity());
		strbld.append(" total: ");
		strbld.append(this.getTotal().doubleValue());
		return strbld.toString();
	}
	
	//LocalDate×Ô´øÁËcompareTo
	public int compareTo(Transaction t) {
		return date.compareTo(t.date);
	}
}


enum TransactionType {BUY, SELL, BONUS, INC_SHARE};
