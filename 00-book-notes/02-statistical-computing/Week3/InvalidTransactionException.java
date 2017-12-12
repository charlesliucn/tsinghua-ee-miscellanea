import java.time.LocalDate;

/**
 * An InvalidTransactionException object should be thrown 
 * when there is an invalid input such as a negative price.
 */

public class InvalidTransactionException extends Exception{
	TransactionType type;
	String price;
	String quantity;
	LocalDate date;
	
	public InvalidTransactionException(TransactionType type, String price,
			String quantity, LocalDate date, String errorMessage) {
		super(errorMessage);
		this.type = type;
		this.price = price;
		this.quantity = quantity;
		this.date = date;
	}
	
}
