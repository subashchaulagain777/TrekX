import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/authServiceProvider.dart';
// Import your services, models, and theme

// --- NEW: ROLE SELECTION SCREEN ---
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const NetworkImage('https://images.unsplash.com/photo-1551632811-561732d1e306?q=80&w=2940&auto=format&fit=crop'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Join TREK X',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 10),
                const Text(
                  'How will you be using the app?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 40),
                _buildRoleButton(
                  context: context,
                  icon: Icons.hiking,
                  title: "I'm a Trekker",
                  subtitle: "To discover treks and connect with the community.",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TrekkerSignUpScreen()));
                  },
                ),
                const SizedBox(height: 20),
                _buildRoleButton(
                  context: context,
                  icon: Icons.map_outlined,
                  title: "I'm a Guide",
                  subtitle: "To offer my services and manage my packages.",
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const GuideSignUpScreen()));
                  },
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Already have an account? Login", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleButton({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Colors.white70)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }
}


// --- NEW: TREKKER SIGNUP SCREEN ---
class TrekkerSignUpScreen extends StatefulWidget {
  const TrekkerSignUpScreen({super.key});

  @override
  State<TrekkerSignUpScreen> createState() => _TrekkerSignUpScreenState();
}

class _TrekkerSignUpScreenState extends State<TrekkerSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleTrekkerSignUp() async {
    if (_formKey.currentState!.validate()) {
      final authService = Provider.of<AuthService>(context, listen: false);
      // TODO: Add phone number to the signup process
      bool success = await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
        role: 'Trekker',
      );
      if (success && mounted) {
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(authService.errorMessage ?? "An unknown error occurred."),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Trekker Account")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'Please enter an email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (val) => val!.isEmpty ? 'Please enter a phone number' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                validator: (val) => val != _passwordController.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: authService.isLoading ? null : _handleTrekkerSignUp,
                child: authService.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('CREATE ACCOUNT'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- NEW: GUIDE SIGNUP SCREEN ---
class GuideSignUpScreen extends StatefulWidget {
  const GuideSignUpScreen({super.key});

  @override
  State<GuideSignUpScreen> createState() => _GuideSignUpScreenState();
}

class _GuideSignUpScreenState extends State<GuideSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  File? _documentImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickDocument() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _documentImage = File(pickedFile.path);
      });
    }
  }

  void _handleGuideSignUp() async {
    if (_formKey.currentState!.validate() && _documentImage != null) {
      // In a real app, you would upload the document to Cloudinary first
      // and then save the URL along with the user data.
      // For now, we'll just simulate the creation.

      final authService = Provider.of<AuthService>(context, listen: false);
      // TODO: Add document URL to the signup process
      bool success = await authService.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: _nameController.text.trim(),
        role: 'Guide',
      );
      if (success && mounted) {
        // Show a success message and pop back to the login screen
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Application submitted! Your account is under review.'),
          backgroundColor: Colors.green,
        ));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(authService.errorMessage ?? "An unknown error occurred."),
          backgroundColor: Colors.red,
        ));
      }
    } else if (_documentImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please upload your verification document.'),
        backgroundColor: Colors.orange,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Apply to be a Guide")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Full Name'),
                validator: (val) => val!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email Address'),
                keyboardType: TextInputType.emailAddress,
                validator: (val) => val!.isEmpty ? 'Please enter an email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (val) => val!.length < 6 ? 'Password must be at least 6 characters' : null,
              ),
              const SizedBox(height: 24),
              const Text("Verification Document", style: TextStyle(fontWeight: FontWeight.bold)),
              const Text("Please upload a photo of your guide license.", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDocument,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: _documentImage != null
                      ? Image.file(_documentImage!, fit: BoxFit.contain)
                      : const Center(child: Icon(Icons.upload_file, size: 50, color: Colors.grey)),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: authService.isLoading ? null : _handleGuideSignUp,
                child: authService.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('SUBMIT APPLICATION'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
