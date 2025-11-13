import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          Text(
            'Privacy Policy',
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
            'This Privacy Policy describes how LogisticsMasters ("we", "us", or "our") collects, uses, and shares your information when you use our mobile application and related services (collectively, the "Services").',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Information We Collect',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We collect information that you provide directly to us, such as when you create an account, update your profile, use the interactive features of our Services, participate in contests, promotions, or surveys, request customer support or otherwise communicate with us.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'How We Use Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We use the information we collect to provide, maintain, and improve our Services, such as to process transactions, send you related information, and provide customer support.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Sharing of Information',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We do not share your personal information with third parties without your consent, except in the following circumstances: (a) with third-party vendors and service providers who need access to such information to carry out work on our behalf; (b) in response to a request for information if we believe disclosure is in accordance with any applicable law, regulation, or legal process; (c) if we believe your actions are inconsistent with our user agreements or policies, or to protect the rights, property, and safety of us or any third party.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 16),
          Text(
            'Security',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'We take reasonable measures to help protect information about you from loss, theft, misuse and unauthorized access, disclosure, alteration and destruction.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
