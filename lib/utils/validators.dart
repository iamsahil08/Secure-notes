class Validators {
  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    
    if (!isValidEmail(value)) {
      return 'Please enter a valid email address';
    }
    
    return null;
  }
  
  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    
    return null;
  }
  
  // Confirm Password validation
  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    
    if (value != password) {
      return 'Passwords do not match';
    }
    
    return null;
  }
  
  // Note title validation
  static String? validateNoteTitle(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter a title';
    }
    
    return null;
  }
  
  // Note content validation
  static String? validateNoteContent(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter some content';
    }
    
    return null;
  }
  
  // Email regex pattern
  static bool isValidEmail(String email) {
    final pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }
}
