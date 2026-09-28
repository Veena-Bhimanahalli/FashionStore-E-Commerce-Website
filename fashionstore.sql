-- MySQL Database Schema for Fashion Store
DROP DATABASE IF EXISTS fashionstore;
CREATE DATABASE fashionstore;
USE fashionstore;

-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(15),
    address_line1 VARCHAR(255),
    address_line2 VARCHAR(255),
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(20),
    country VARCHAR(100) DEFAULT 'India',
    role ENUM('customer', 'admin') DEFAULT 'customer',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT
);

-- 3. Products Table
CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    brand VARCHAR(100),
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE RESTRICT
);

-- 4. Product Variants Table
CREATE TABLE product_variants (
    variant_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size VARCHAR(20),
    color VARCHAR(50),
    price DECIMAL(10, 2) NOT NULL,
    stock INT DEFAULT 0,
    sku VARCHAR(100) UNIQUE,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 5. Cart Table
CREATE TABLE cart (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 6. Cart Items Table
CREATE TABLE cart_items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    variant_id INT NOT NULL,
    quantity INT DEFAULT 1,
    FOREIGN KEY (cart_id) REFERENCES cart(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE CASCADE,
    UNIQUE KEY cart_variant_unique (cart_id, variant_id)
);

-- 7. Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status ENUM('PENDING', 'PROCESSING', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    shipping_address TEXT NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'COD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE RESTRICT
);

-- 8. Order Items Table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    variant_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES product_variants(variant_id) ON DELETE RESTRICT
);

-- ==========================================
-- SEED DATA
-- ==========================================

-- Seed Users
INSERT INTO users (full_name, email, password, phone, city, role) VALUES 
('Veena User', 'veena@gmail.com', 'veena123', '9876543210', 'Bangalore', 'customer'),
('Admin User', 'admin@gmail.com', 'admin123', '9999999999', 'Bangalore', 'admin');

-- Seed Categories
INSERT INTO categories (name, description) VALUES 
('Men', 'Men clothing and fashion'),
('Women', 'Women clothing and fashion'),
('Kids', 'Kids clothing and accessories'),
('Accessories', 'Bags, belts, wallets, etc.'),
('Footwear', 'Shoes, sandals, and sneakers');

-- Seed Products (100 products)
-- Category 1: Men
INSERT INTO products (category_id, name, brand, description, base_price, image_url, is_active) VALUES 
(1, 'Classic Black Casual Shirt', 'Levis', 'Premium cotton black casual shirt for men.', 1299.00, 'assets/images/products/prod_1_classicblackcasualshirt.jpg', TRUE),
(1, 'Blue Slim Fit Jeans', 'Wrangler', 'Stretchable slim fit blue jeans.', 1999.00, 'assets/images/products/prod_1_blueslimfitjeans.jpg', TRUE),
(1, 'Urban Street Hoodie', 'H&M', 'Comfortable oversized hoodie for street style.', 1599.00, 'assets/images/products/prod_1_urbanstreethoodie.jpg', TRUE),
(1, 'Formal White Shirt', 'Allen Solly', 'Pure white formal shirt for office wear.', 1499.00, 'assets/images/products/prod_1_formalwhiteshirt.jpg', TRUE),
(1, 'Denim Jacket', 'Levis', 'Classic blue denim jacket with pockets.', 2999.00, 'assets/images/products/prod_1_denimjacket.jpg', TRUE),
(1, 'Graphic Print T-Shirt', 'Adidas', 'Cotton t-shirt with modern graphic print.', 799.00, 'assets/images/products/prod_1_graphicprinttshirt.jpg', TRUE),
(1, 'Chino Trousers', 'Zara', 'Slim fit beige chinos for semi-formal look.', 1799.00, 'assets/images/products/prod_1_chinotrousers.jpg', TRUE),
(1, 'Striped Polo Shirt', 'Puma', 'Breathable polo shirt with horizontal stripes.', 1199.00, 'assets/images/products/prod_1_stripedpoloshirt.jpg', TRUE),
(1, 'Leather Biker Jacket', 'H&M', 'Tough black leather jacket for a cool look.', 4999.00, 'assets/images/products/prod_1_leatherbikerjacket.jpg', TRUE),
(1, 'Linen Summer Shirt', 'Zara', 'Lightweight linen shirt for hot days.', 2299.00, 'assets/images/products/prod_1_linensummershirt.jpg', TRUE),
(1, 'Cargo Pants', 'Wrangler', 'Multi-pocket cargo pants for outdoor adventure.', 2499.00, 'assets/images/products/prod_1_cargopants.jpg', TRUE),
(1, 'V-Neck Sweater', 'Tommy Hilfiger', 'Soft wool v-neck sweater for winters.', 3499.00, 'assets/images/products/prod_1_vnecksweater.jpg', TRUE),
(1, 'Checked Flannel Shirt', 'Levis', 'Warm checked flannel shirt in red and black.', 1899.00, 'assets/images/products/prod_1_checkedflannelshirt.jpg', TRUE),
(1, 'Sports Track Pants', 'Nike', 'Flexible track pants for workout and gym.', 1499.00, 'assets/images/products/prod_1_sportstrackpants.jpg', TRUE),
(1, 'Puffer Vest', 'Adidas', 'Insulated puffer vest for layering.', 2599.00, 'assets/images/products/prod_1_puffervest.jpg', TRUE),
(1, 'Slim Fit Chinos', 'H&M', 'Classic navy blue slim fit chinos.', 1699.00, 'assets/images/products/prod_1_slimfitchinos.jpg', TRUE),
(1, 'Printed Hawaiian Shirt', 'Zara', 'Tropical print shirt for beach vacations.', 1999.00, 'assets/images/products/prod_1_printedhawaiianshirt.jpg', TRUE),
(1, 'Oversized Tee', 'Puma', 'Trendy oversized t-shirt in pastel colors.', 999.00, 'assets/images/products/prod_1_oversizedtee.jpg', TRUE),
(1, 'Distressed Jeans', 'Levis', 'Stylish distressed blue jeans with rips.', 2799.00, 'assets/images/products/prod_1_distressedjeans.jpg', TRUE),
(1, 'Formal Blazer', 'Allen Solly', 'Sharp grey formal blazer for special events.', 5999.00, 'assets/images/products/prod_1_formalblazer.jpg', TRUE);

-- Category 2: Women
INSERT INTO products (category_id, name, brand, description, base_price, image_url, is_active) VALUES 
(2, 'Floral Summer Dress', 'Zara', 'Beautiful floral printed dress perfect for summer.', 2499.00, 'assets/images/products/prod_2_floralsummerdress.jpg', TRUE),
(2, 'Pink Straight Kurti', 'Biba', 'Elegant pink straight kurti for everyday wear.', 1499.00, 'assets/images/products/prod_2_pinkstraightkurti.jpg', TRUE),
(2, 'Skinny Fit Blue Jeans', 'Levis', 'High-waisted skinny fit blue jeans.', 2299.00, 'assets/images/products/prod_2_skinnyfitbluejeans.jpg', TRUE),
(2, 'Silk Evening Gown', 'H&M', 'Stunning black silk gown for parties.', 4499.00, 'assets/images/products/prod_2_silkeveninggown.jpg', TRUE),
(2, 'Embroidered Salwar Suit', 'Biba', 'Traditional embroidered suit set with dupatta.', 3999.00, 'assets/images/products/prod_2_embroideredsalwarsuit.jpg', TRUE),
(2, 'Crop Top with Frills', 'Zara', 'Cute white crop top with frill details.', 1299.00, 'assets/images/products/prod_2_croptopwithfrills.jpg', TRUE),
(2, 'Denim Skirt', 'Levis', 'Classic mini denim skirt with raw edge.', 1799.00, 'assets/images/products/prod_2_denimskirt.jpg', TRUE),
(2, 'Cotton Anarkali Kurta', 'Biba', 'Flowy cotton anarkali kurta in blue.', 2799.00, 'assets/images/products/prod_2_cottonanarkalikurta.jpg', TRUE),
(2, 'Satin Slip Dress', 'H&M', 'Sleek satin slip dress in champagne color.', 1999.00, 'assets/images/products/prod_2_satinslipdress.jpg', TRUE),
(2, 'Off-Shoulder Top', 'Zara', 'Stylish off-shoulder top with floral pattern.', 1599.00, 'assets/images/products/prod_2_offshouldertop.jpg', TRUE),
(2, 'Palazzo Pants', 'Biba', 'Wide-leg comfortable palazzo pants.', 1199.00, 'assets/images/products/prod_2_palazzopants.jpg', TRUE),
(2, 'Knitted Cardigan', 'H&M', 'Soft knitted cardigan for light winters.', 1899.00, 'assets/images/products/prod_2_knittedcardigan.jpg', TRUE),
(2, 'Midi Pleated Skirt', 'Zara', 'Elegant pleated midi skirt in emerald green.', 2199.00, 'assets/images/products/prod_2_midipleatedskirt.jpg', TRUE),
(2, 'Chiffon Blouse', 'H&M', 'Lightweight chiffon blouse for office wear.', 1699.00, 'assets/images/products/prod_2_chiffonblouse.jpg', TRUE),
(2, 'Leather Trousers', 'Zara', 'Edgy black faux leather trousers.', 2999.00, 'assets/images/products/prod_2_leathertrousers.jpg', TRUE),
(2, 'Boho Maxi Dress', 'H&M', 'Long flowy boho style maxi dress.', 3299.00, 'assets/images/products/prod_2_bohomaxidress.jpg', TRUE),
(2, 'Velvet Wrap Top', 'Zara', 'Luxurious velvet top with wrap design.', 2499.00, 'assets/images/products/prod_2_velvetwraptop.jpg', TRUE),
(2, 'High-Rise Shorts', 'Levis', 'Classic denim shorts for summer days.', 1499.00, 'assets/images/products/prod_2_highriseshorts.jpg', TRUE),
(2, 'Turtleneck Sweater', 'Uniqlo', 'Warm wool turtleneck sweater.', 2599.00, 'assets/images/products/prod_2_turtlenecksweater.jpg', TRUE),
(2, 'Lehenga Choli Set', 'Biba', 'Beautiful ethnic lehenga set for weddings.', 8999.00, 'assets/images/products/prod_2_lehengacholiset.jpg', TRUE);

-- Category 3: Kids
INSERT INTO products (category_id, name, brand, description, base_price, image_url, is_active) VALUES 
(3, 'Boys Checked Shirt', 'Allen Solly', 'Casual checked shirt for boys.', 899.00, 'assets/images/products/prod_3_boyscheckedshirt.jpg', TRUE),
(3, 'Girls Frozen Frock', 'Disney', 'Beautiful blue frock with Frozen print.', 1299.00, 'assets/images/products/prod_3_girlsfrozenfrock.jpg', TRUE),
(3, 'Kids Denim Shorts', 'Levis', 'Durable denim shorts for active kids.', 999.00, 'assets/images/products/prod_3_kidsdenimshorts.jpg', TRUE),
(3, 'Superhero T-Shirt', 'Marvel', 'Cotton t-shirt with Spider-Man print.', 699.00, 'assets/images/products/prod_3_superherotshirt.jpg', TRUE),
(3, 'Girls Floral Jumpsuit', 'Zara Kids', 'Trendy floral jumpsuit for girls.', 1499.00, 'assets/images/products/prod_3_girlsfloraljumpsuit.jpg', TRUE),
(3, 'Boys Cargo Pants', 'Wrangler', 'Tough cargo pants for little explorers.', 1199.00, 'assets/images/products/prod_3_boyscargopants.jpg', TRUE),
(3, 'Kids Hooded Sweatshirt', 'H&M', 'Warm and cozy hoodie for kids.', 1099.00, 'assets/images/products/prod_3_kidshoodedsweatshirt.jpg', TRUE),
(3, 'Girls Glitter Leggings', 'H&M', 'Sparkly leggings for parties.', 799.00, 'assets/images/products/prod_3_girlsglitterleggings.jpg', TRUE),
(3, 'Boys Polo T-Shirt', 'Puma Kids', 'Classic polo t-shirt for boys.', 899.00, 'assets/images/products/prod_3_boyspolotshirt.jpg', TRUE),
(3, 'Girls Tutu Skirt', 'Zara Kids', 'Fun pink tutu skirt for dancing.', 1299.00, 'assets/images/products/prod_3_girlstutuskirt.jpg', TRUE),
(3, 'Kids Rain Jacket', 'Columbia', 'Waterproof jacket for rainy days.', 1899.00, 'assets/images/products/prod_3_kidsrainjacket.jpg', TRUE),
(3, 'Boys Bow Tie Set', 'Allen Solly', 'Formal shirt with matching bow tie.', 1599.00, 'assets/images/products/prod_3_boysbowtieset.jpg', TRUE),
(3, 'Girls Cotton Nightsuit', 'H&M', 'Soft cotton nightsuit with cute prints.', 999.00, 'assets/images/products/prod_3_girlscottonnightsuit.jpg', TRUE),
(3, 'Boys Swim Trunks', 'Speedo', 'Comfortable swim trunks for the pool.', 799.00, 'assets/images/products/prod_3_boysswimtrunks.jpg', TRUE),
(3, 'Girls Denim Jacket', 'Levis', 'Mini denim jacket for girls.', 1999.00, 'assets/images/products/prod_3_girlsdenimjacket.jpg', TRUE),
(3, 'Kids Winter Gloves', 'North Face', 'Warm insulated gloves for kids.', 599.00, 'assets/images/products/prod_3_kidswintergloves.jpg', TRUE),
(3, 'Boys Linen Trousers', 'Zara Kids', 'Lightweight linen trousers for summer.', 1399.00, 'assets/images/products/prod_3_boyslinentrousers.jpg', TRUE),
(3, 'Girls Party Dress', 'Biba Kids', 'Elegant ethnic dress for girls.', 2499.00, 'assets/images/products/prod_3_girlspartydress.jpg', TRUE),
(3, 'Kids Woolen Cap', 'Adidas', 'Cute woolen beanie for winters.', 499.00, 'assets/images/products/prod_3_kidswoolencap.jpg', TRUE),
(3, 'Boys Graphic Tee', 'Nike Kids', 'Cool graphic tee for everyday wear.', 799.00, 'assets/images/products/prod_3_boysgraphictee.jpg', TRUE);

-- Category 4: Accessories
INSERT INTO products (category_id, name, brand, description, base_price, image_url, is_active) VALUES 
(4, 'Premium Leather Belt', 'Tommy Hilfiger', 'Brown genuine leather belt.', 799.00, 'assets/images/products/prod_4_premiumleatherbelt.jpg', TRUE),
(4, 'Classic Aviator Sunglasses', 'Ray-Ban', 'Timeless aviator style sunglasses.', 4999.00, 'assets/images/products/prod_4_classicaviatorsunglasses.jpg', TRUE),
(4, 'Leather Wallet', 'Fossil', 'Minimalist bifold leather wallet.', 1499.00, 'assets/images/products/prod_4_leatherwallet.jpg', TRUE),
(4, 'Designer Handbag', 'Michael Kors', 'Elegant leather handbag for women.', 12999.00, 'assets/images/products/prod_4_designerhandbag.jpg', TRUE),
(4, 'Analog Watch', 'Fossil', 'Classic analog watch with leather strap.', 5999.00, 'assets/images/products/prod_4_analogwatch.jpg', TRUE),
(4, 'Digital Sports Watch', 'Casio', 'Durable digital watch with stopwatch.', 2999.00, 'assets/images/products/prod_4_digitalsportswatch.jpg', TRUE),
(4, 'Silk Scarf', 'H&M', 'Soft silk scarf with artistic print.', 999.00, 'assets/images/products/prod_4_silkscarf.jpg', TRUE),
(4, 'Canvas Backpack', 'Nike', 'Spacious backpack for school and travel.', 2499.00, 'assets/images/products/prod_4_canvasbackpack.jpg', TRUE),
(4, 'Woolen Muffler', 'Zara', 'Warm woolen muffler for winters.', 1299.00, 'assets/images/products/prod_4_woolenmuffler.jpg', TRUE),
(4, 'Beanie Cap', 'Adidas', 'Stylish knitted beanie cap.', 699.00, 'assets/images/products/prod_4_beaniecap.jpg', TRUE),
(4, 'Ties and Cufflinks Set', 'Allen Solly', 'Elegant set for formal occasions.', 1999.00, 'assets/images/products/prod_4_tiesandcufflinksset.jpg', TRUE),
(4, 'Silver Bracelet', 'Tanishq', 'Beautiful silver bracelet for women.', 3499.00, 'assets/images/products/prod_4_silverbracelet.jpg', TRUE),
(4, 'Laptop Sleeve', 'HP', 'Protective padded sleeve for 15-inch laptop.', 1199.00, 'assets/images/products/prod_4_laptopsleeve.jpg', TRUE),
(4, 'Umbrella', 'Totes', 'Sturdy windproof foldable umbrella.', 899.00, 'assets/images/products/prod_4_umbrella.jpg', TRUE),
(4, 'Leather Keychain', 'Fossil', 'Small leather keychain with ring.', 399.00, 'assets/images/products/prod_4_leatherkeychain.jpg', TRUE),
(4, 'Hat', 'H&M', 'Classic straw hat for beach days.', 799.00, 'assets/images/products/prod_4_hat.jpg', TRUE),
(4, 'Gloves', 'Uniqlo', 'Touchscreen compatible winter gloves.', 1299.00, 'assets/images/products/prod_4_gloves.jpg', TRUE),
(4, 'Socks Pack of 3', 'Puma', 'Cotton ankle-length socks.', 499.00, 'assets/images/products/prod_4_sockspackof3.jpg', TRUE),
(4, 'Brooch', 'Zara', 'Decorative brooch for blazers and coats.', 599.00, 'assets/images/products/prod_4_brooch.jpg', TRUE),
(4, 'Passport Holder', 'Tommy Hilfiger', 'Leather holder for travel documents.', 1799.00, 'assets/images/products/prod_4_passportholder.jpg', TRUE);

-- Category 5: Footwear
INSERT INTO products (category_id, name, brand, description, base_price, image_url, is_active) VALUES 
(5, 'Running Sports Shoes', 'Nike', 'Comfortable lightweight running shoes.', 2999.00, 'assets/images/products/prod_5_runningsportsshoes.jpg', TRUE),
(5, 'Casual Sneakers', 'Adidas', 'White canvas sneakers for daily wear.', 2499.00, 'assets/images/products/prod_5_casualsneakers.jpg', TRUE),
(5, 'Leather Formal Shoes', 'Bata', 'Classic black leather oxfords.', 3499.00, 'assets/images/products/prod_5_leatherformalshoes.jpg', TRUE),
(5, 'Heeled Sandals', 'Zara', 'High heel sandals for evening parties.', 3999.00, 'assets/images/products/prod_5_heeledsandals.jpg', TRUE),
(5, 'Running Shoes', 'Puma', 'High performance running shoes.', 4499.00, 'assets/images/products/prod_5_runningshoes.jpg', TRUE),
(5, 'Flip Flops', 'Nike', 'Comfortable flip flops for beach.', 999.00, 'assets/images/products/prod_5_flipflops.jpg', TRUE),
(5, 'Loafers', 'H&M', 'Stylish suede loafers for men.', 2799.00, 'assets/images/products/prod_5_loafers.jpg', TRUE),
(5, 'Ankle Boots', 'Zara', 'Fashionable leather ankle boots.', 4999.00, 'assets/images/products/prod_5_ankleboots.jpg', TRUE),
(5, 'Ballet Flats', 'H&M', 'Simple and comfortable ballet flats.', 1499.00, 'assets/images/products/prod_5_balletflats.jpg', TRUE),
(5, 'Hiking Boots', 'Timberland', 'Rugged boots for mountain trails.', 6999.00, 'assets/images/products/prod_5_hikingboots.jpg', TRUE),
(5, 'Canvas Shoes', 'Converse', 'Classic high-top canvas shoes.', 3299.00, 'assets/images/products/prod_5_canvasshoes.jpg', TRUE),
(5, 'Platform Sneakers', 'Puma', 'Trendy platform sole sneakers.', 3799.00, 'assets/images/products/prod_5_platformsneakers.jpg', TRUE),
(5, 'Wedge Sandals', 'Bata', 'Comfortable wedge sandals for women.', 1999.00, 'assets/images/products/prod_5_wedgesandals.jpg', TRUE),
(5, 'Chelsea Boots', 'H&M', 'Classic suede chelsea boots.', 4599.00, 'assets/images/products/prod_5_chelseaboots.jpg', TRUE),
(5, 'Running Spikes', 'Adidas', 'Professional spikes for track and field.', 5999.00, 'assets/images/products/prod_5_runningspikes.jpg', TRUE),
(5, 'Slide Sandals', 'Adidas', 'Sporty slides for post-workout.', 1299.00, 'assets/images/products/prod_5_slidesandals.jpg', TRUE),
(5, 'Moccasins', 'Zara', 'Soft leather moccasins for men.', 2999.00, 'assets/images/products/prod_5_moccasins.jpg', TRUE),
(5, 'Stilettos', 'Zara', 'Elegant high stilettos for formal events.', 5499.00, 'assets/images/products/prod_5_stilettos.jpg', TRUE),
(5, 'Espadrilles', 'H&M', 'Lightweight canvas espadrilles.', 1799.00, 'assets/images/products/prod_5_espadrilles.jpg', TRUE),
(5, 'Safety Boots', 'Cat', 'Durable safety boots for construction.', 5999.00, 'assets/images/products/prod_5_safetyboots.jpg', TRUE);

-- Seed Product Variants (1-2 per product)
-- This is simplified for the example, typically you'd add variants for all 100 products.
INSERT INTO product_variants (product_id, size, color, price, stock, sku) VALUES 
(1, 'M', 'Black', 1299.00, 20, 'SHIRT-BLK-M'),
(1, 'L', 'Black', 1299.00, 15, 'SHIRT-BLK-L'),
(2, '32', 'Blue', 1999.00, 10, 'JEANS-BLU-32'),
(2, '34', 'Blue', 1999.00, 12, 'JEANS-BLU-34'),
(21, 'S', 'Floral', 2499.00, 8, 'DRESS-FLO-S'),
(22, 'M', 'Pink', 1499.00, 15, 'KURTI-PNK-M'),
(41, 'S', 'Blue', 899.00, 20, 'KIDS-SHRT-BLU-S'),
(61, 'Standard', 'Brown', 799.00, 30, 'BELT-BRN-STD'),
(81, '8', 'White', 2999.00, 15, 'SHOE-WHT-8'),
(81, '9', 'White', 2999.00, 10, 'SHOE-WHT-9');

-- Add variants for more products to ensure search/category filter works with details
INSERT INTO product_variants (product_id, size, color, price, stock, sku)
SELECT product_id, 'Free Size', 'Default', base_price, 50, CONCAT('SKU-', product_id)
FROM products WHERE product_id NOT IN (1, 2, 21, 22, 41, 61, 81);

-- Seed Cart (for Veena User, user_id=1)
INSERT INTO cart (user_id) VALUES (1);

-- Seed Cart Items
INSERT INTO cart_items (cart_id, variant_id, quantity) VALUES 
(1, 1, 1),
(1, 3, 2);
