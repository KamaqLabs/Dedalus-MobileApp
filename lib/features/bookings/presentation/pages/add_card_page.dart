import 'package:dedalus/core/theme/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddCardPage extends StatefulWidget {
  const AddCardPage({super.key});

  @override
  State<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends State<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Card'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card number field
              const Text(
                'Card Number',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberFormatter(),
                ],
                decoration: InputDecoration(
                  hintText: 'XXXX XXXX XXXX XXXX',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: ColorPalette.primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  if (value.replaceAll(' ', '').length < 16) {
                    return 'Please enter a valid card number';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Card holder name field
              const Text(
                'Card Holder Name',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardHolderController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Name on card',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: ColorPalette.primaryColor),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card holder name';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Expiry date and CVV fields in a row
              Row(
                children: [
                  // Expiry Date field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Expiry Date',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _expiryDateController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                            _ExpiryDateFormatter(),
                          ],
                          decoration: InputDecoration(
                            hintText: 'MM/YY',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: ColorPalette.primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 5) {
                              return 'Invalid date';
                            }
                            
                            // Check if the date is valid (MM/YY)
                            final parts = value.split('/');
                            if (parts.length != 2) {
                              return 'Invalid format';
                            }
                            
                            final month = int.tryParse(parts[0]);
                            if (month == null || month < 1 || month > 12) {
                              return 'Invalid month';
                            }
                            
                            final year = int.tryParse('20${parts[1]}');
                            final currentYear = DateTime.now().year;
                            if (year == null || year < currentYear) {
                              return 'Expired';
                            }
                            
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // CVV field
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CVV',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _cvvController,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                          decoration: InputDecoration(
                            hintText: '•••',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(color: ColorPalette.primaryColor),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Required';
                            }
                            if (value.length < 3) {
                              return 'Invalid CVV';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
              
              // Add Card button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorPalette.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: _saveCard,
                  child: const Text(
                    'Add Card',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveCard() {
    if (_formKey.currentState?.validate() ?? false) {
      // En una app real, aquí se guardaría la tarjeta en un lugar seguro
      // y se manejaría el procesamiento del pago
      
      // Volvemos a la pantalla anterior con los datos de la tarjeta
      Navigator.pop(context, {
        'cardNumber': _cardNumberController.text,
        'cardHolder': _cardHolderController.text,
        'expiryDate': _expiryDateController.text,
        'cardType': _getCardType(_cardNumberController.text),
      });
    }
  }

  String _getCardType(String cardNumber) {
    // Simplificado para fines de demostración
    final cleanedNumber = cardNumber.replaceAll(' ', '');
    
    if (cleanedNumber.startsWith('4')) {
      return 'visa';
    } else if (cleanedNumber.startsWith('5')) {
      return 'mastercard';
    } else if (cleanedNumber.startsWith('3')) {
      return 'amex';
    } else {
      return 'generic';
    }
  }
}

// Formateador para números de tarjeta (XXXX XXXX XXXX XXXX)
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Eliminar espacios para facilitar el formato
    final trimmed = newValue.text.replaceAll(' ', '');
    
    // Formatear con espacios cada 4 dígitos
    final buffer = StringBuffer();
    for (int i = 0; i < trimmed.length; i++) {
      buffer.write(trimmed[i]);
      if ((i + 1) % 4 == 0 && i != trimmed.length - 1) {
        buffer.write(' ');
      }
    }
    
    final formatted = buffer.toString();
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

// Formateador para fechas de expiración (MM/YY)
class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    
    // Eliminar "/" para facilitar el formato
    final trimmed = newValue.text.replaceAll('/', '');
    
    // Si tiene más de 2 caracteres, formato MM/YY
    final buffer = StringBuffer();
    for (int i = 0; i < trimmed.length; i++) {
      buffer.write(trimmed[i]);
      if (i == 1 && i < trimmed.length - 1) {
        buffer.write('/');
      }
    }
    
    final formatted = buffer.toString();
    
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
