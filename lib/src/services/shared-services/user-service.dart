class UserService {
  // Example method, modify according to your actual implementation
  List<CardAccount> getUserCardAccounts() {
    // Fetch user card accounts from somewhere
    // This might be from an API, local storage, or any other source
    return [
      CardAccount(name: 'Card 1', balance: 100.0),
      CardAccount(name: 'Card 2', balance: 200.0),
      CardAccount(name: 'Card 3', balance: 300.0),
    ];
  }
}

class CardAccount {
  final String name;
  final double balance;

  CardAccount({required this.name, required this.balance});
}