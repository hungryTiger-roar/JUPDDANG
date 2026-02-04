
import os
import re

def audit_imports(root_dir):
    invalid_patterns = [
        r'package:jupddang/screens/',
        r'package:jupddang/models/',
        r'\.\./screens/',
        r'\.\./models/',
        r'auth_provider.dart' 
    ]
    
    errors = []
    
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        lines = f.readlines()
                        for i, line in enumerate(lines):
                            if line.strip().startswith('import '):
                                for pattern in invalid_patterns:
                                    if re.search(pattern, line):
                                        errors.append(f"{filepath}:{i+1} -> {line.strip()}")
                except Exception as e:
                    print(f"Error reading {filepath}: {e}")

    if errors:
        print("Found invalid imports:")
        for error in errors:
            print(error)
    else:
        print("No invalid imports found matching patterns.")

if __name__ == "__main__":
    audit_imports(r'c:\Users\SSAFY\Desktop\dev\S14P11D208\Frontend\jupddang\lib')
