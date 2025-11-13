import 'package:flutter/material.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Terms and Conditions',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Last updated: July 10, 2025',
            style: TextStyle(
              fontSize: 14,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Please read these Terms and Conditions ("Terms") carefully before using the LogisticsMasters mobile application operated by LogisticsMasters, Inc.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '1. Acceptance of Terms',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'By accessing or using our Services, you agree to be bound by these Terms. If you do not agree to these Terms, you may not access or use the Services.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '2. Changes to Terms',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We may modify the Terms at any time. If we do this, we will post the modified Terms on this page and update the "Last Updated" date above. It is your responsibility to check our Terms periodically for changes. Your continued use of our Service following the posting of modified Terms means that you accept and agree to the changes.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '3. Creating Accounts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'When you create an account with us, you must provide accurate and complete information. You are solely responsible for the activity that occurs on your account, and you must keep your account password secure. We encourage you to use "strong" passwords (passwords that use a combination of upper and lowercase letters, numbers, and symbols) with your account.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            '4. User Generated Content',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'You are responsible for all content that you contribute to our Services, including ratings, reviews, photos, videos, and comments. You represent that you have all necessary rights to the content you contribute, and you agree to indemnify us for all claims resulting from content you supply.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
