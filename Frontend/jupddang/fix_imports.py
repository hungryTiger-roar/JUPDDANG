import os
import re

def fix_imports(root_dir):
    # Map of filename to correct package path
    # We found these files exist in features/*/models/
    model_paths = {
        'party_models.dart': 'package:jupddang/features/party/models/party_models.dart',
        'plogging_models.dart': 'package:jupddang/features/plogging/models/plogging_models.dart',
        'hexagon.dart': 'package:jupddang/features/plogging/models/hexagon.dart', # Assuming strict location
        'raid_models.dart': 'package:jupddang/features/raid/models/raid_models.dart',
        'ranking_model.dart': 'package:jupddang/features/ranking/models/ranking_model.dart',
        'community_models.dart': 'package:jupddang/features/social/models/community_models.dart',
        'follow_model.dart': 'package:jupddang/features/social/models/follow_model.dart',
        'trashcan_model.dart': 'package:jupddang/features/trashcan/models/trashcan_model.dart',
    }

    count = 0
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        content = f.read()
                    
                    original_content = content
                    
                    # Regex to find imports like import '../models/party_models.dart';
                    # or import '../../models/party_models.dart';
                    
                    for model_file, package_path in model_paths.items():
                        # Pattern: import '.../models/filename.dart';
                        # Capture the quote type too
                        regex = r"(import\s+)(['\"])(?:\.\./)+models/" + re.escape(model_file) + r"(['\"];?)"
                        
                        def replace_func(match):
                            return f"{match.group(1)}{match.group(2)}{package_path}{match.group(3)}"
                            
                        content = re.sub(regex, replace_func, content)
                        
                        # Also handle case where it might be package:jupddang/models/ (if that was the bad pattern)
                        regex_pkg = r"(import\s+)(['\"])package:jupddang/models/" + re.escape(model_file) + r"(['\"];?)"
                        content = re.sub(regex_pkg, replace_func, content)

                    if content != original_content:
                        with open(filepath, 'w', encoding='utf-8') as f:
                            f.write(content)
                        print(f"Fixed imports in: {filepath}")
                        count += 1
                        
                except Exception as e:
                    print(f"Error processing {filepath}: {e}")
    
    print(f"Total files updated: {count}")

if __name__ == "__main__":
    fix_imports(r'c:\Users\SSAFY\Desktop\dev\S14P11D208\Frontend\jupddang\lib')
