import os
import urllib.request
from duckduckgo_search import DDGS
import time

TARGET_DIR = r"c:\Users\veena\Downloads\fashionStore\src\main\webapp\assets\images\products"

# Define the exact images we need to replace
images_to_fetch = {
    "women-dress.jpg": "premium women fashion dress catalog myntra",
    "kids-shirt.jpg": "premium kids clothing catalog myntra",
    "acc-belt.jpg": "premium leather belt accessories catalog myntra",
    "shoes-running.jpg": "premium running shoes catalog myntra",
    "prod_1_formalwhiteshirt.jpg": "premium men formal white shirt isolated myntra",
    "prod_1_urbanstreethoodie.jpg": "premium men urban street hoodie isolated myntra",
    "prod_1_blueslimfitjeans.jpg": "premium men blue slim fit jeans isolated myntra"
}

def download_image(url, save_path):
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})
        with urllib.request.urlopen(req, timeout=15) as response, open(save_path, 'wb') as f:
            f.write(response.read())
        return True
    except Exception as e:
        print(f"Failed to download {url}: {e}")
        return False

with DDGS() as ddgs:
    for filename, query in images_to_fetch.items():
        print(f"Searching for: {query}")
        # Search DuckDuckGo Images
        results = list(ddgs.images(query, max_results=5))
        
        target_path = os.path.join(TARGET_DIR, filename)
        
        for res in results:
            url = res['image']
            print(f"  Attempting download: {url}")
            if download_image(url, target_path):
                print(f"  Success: {filename}")
                break
        
        time.sleep(2) # Prevent rate limiting

print("Finished downloading specific images.")
