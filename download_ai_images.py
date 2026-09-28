import os
import urllib.request
import urllib.parse
import re
import concurrent.futures

SQL_FILE = 'fashionstore.sql'
TARGET_DIR = r"src\main\webapp\assets\images\products"

with open(SQL_FILE, 'r', encoding='utf-8') as f:
    sql_content = f.read()

pattern = r"\((\d+),\s*'([^']+)',\s*'([^']+)',\s*'([^']+)',\s*([\d.]+),\s*'([^']+)',\s*(TRUE|FALSE)\)"
matches = re.findall(pattern, sql_content)

os.makedirs(TARGET_DIR, exist_ok=True)

downloads = []
for match in matches:
    cat_id = int(match[0])
    product_name = match[1]
    image_url = match[5]
    
    file_name = os.path.basename(image_url)
    target_path = os.path.join(TARGET_DIR, file_name)
    
    # Construct a descriptive prompt for AI image generation
    prompt = f"Clean ecommerce product photography of {product_name}, isolated on a solid white background, highly detailed, professional studio lighting"
    encoded_prompt = urllib.parse.quote(prompt)
    url = f"https://image.pollinations.ai/prompt/{encoded_prompt}?width=400&height=500&nologo=true"
    
    downloads.append((url, target_path))

def download_img(item):
    url, path = item
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=30) as response, open(path, 'wb') as out_file:
            out_file.write(response.read())
        return f"Downloaded: {os.path.basename(path)}"
    except Exception as e:
        return f"Failed {os.path.basename(path)}: {e}"

print(f"Starting {len(downloads)} image generations using Pollinations.ai...")
with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
    results = list(executor.map(download_img, downloads))

print(f"Finished generating {len([r for r in results if 'Downloaded' in r])} images.")
