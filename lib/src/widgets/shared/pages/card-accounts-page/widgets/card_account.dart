import 'package:flutter/material.dart';

class CardAccountCard extends StatelessWidget {
  
  final String name;
  final double balance;

  const CardAccountCard({required this.name, required this.balance, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160.0,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/card_background.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.green, width: 4.0),
                      ),
                      child: const Center(
                        child: Text(
                          '100%',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    const Text(
                      'Daily Budget',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                    const Text(
                      '\$17.28',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Balance',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white),
                    ),
                    Text(
                      '\$$balance',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}