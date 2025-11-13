import 'package:flutter/material.dart';
import 'package:dedalus/core/theme/color_palette.dart';

class PaymentMethodsPage extends StatelessWidget {
  const PaymentMethodsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildPaymentCard(
            context,
            cardType: 'Visa',
            cardNumber: '**** **** **** 1234',
            expiryDate: '12/25',
            isDefault: true,
          ),
          const SizedBox(height: 12),
          _buildPaymentCard(
            context,
            cardType: 'Mastercard',
            cardNumber: '**** **** **** 5678',
            expiryDate: '09/24',
            isDefault: false,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navegación a la página para añadir una nueva tarjeta
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Add new card feature coming soon')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorPalette.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Add New Card',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentCard(
    BuildContext context, {
    required String cardType,
    required String cardNumber,
    required String expiryDate,
    required bool isDefault,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(
              cardType == 'Visa' ? Icons.credit_card : Icons.credit_card,
              size: 40,
              color: cardType == 'Visa' ? Colors.blue : Colors.red,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cardType,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    cardNumber,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  Text(
                    'Expires: $expiryDate',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
            ),
            if (isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorPalette.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Default',
                  style: TextStyle(
                    color: ColorPalette.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
