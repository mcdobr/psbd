INSERT INTO category VALUES(1, 'bucătărie');
INSERT INTO category VALUES(2, 'baie');
INSERT INTO category VALUES(3, 'mobilă');
INSERT INTO category VALUES(4, 'electrocasnice');
INSERT INTO category VALUES(5, 'scule și unelte');
INSERT INTO category VALUES(6, 'grădină');
INSERT INTO category VALUES(7, 'auto');
INSERT INTO category VALUES(8, 'decorațiuni');
INSERT INTO category VALUES(9, 'amenajări interioare');
INSERT INTO category VALUES(10, 'gresie si fainață');
INSERT INTO category VALUES(11, 'construcții');
INSERT INTO category VALUES(12, 'termice');
INSERT INTO category VALUES(13, 'electrice');
INSERT INTO category VALUES(14, 'sanitare');
INSERT INTO category VALUES(15, 'dormitoare');

COMMIT;

-- Categoria bucatarie
INSERT INTO product(id, name, unit, price, category_id) VALUES(1, 'frigider', 'buc', 2099.99, 1);
INSERT INTO product(id, name, unit, price, category_id) VALUES(2, 'aragaz', 'buc', 999.99, 1);
INSERT INTO product(id, name, unit, price, category_id) VALUES(3, 'hotă', 'buc', 499.99, 1);
INSERT INTO product(id, name, unit, price, category_id) VALUES(4, 'oală', 'buc', 99.99, 1);
INSERT INTO product(id, name, unit, price, category_id) VALUES(5, 'tigaie', 'buc', 49.99, 1);

-- Categoria baie
INSERT INTO product(id, name, unit, price, category_id) VALUES(6, 'bideu', 'buc', 100.00, 2);
INSERT INTO product(id, name, unit, price, category_id) VALUES(7, 'cabina duș', 'buc', 1600.00, 2);
INSERT INTO product(id, name, unit, price, category_id) VALUES(8, 'oglindă', 'buc', 159.00, 2);
INSERT INTO product(id, name, unit, price, category_id) VALUES(9, 'dulap suspendat', 'buc', 350.00, 2);
INSERT INTO product(id, name, unit, price, category_id) VALUES(10, 'capac wc', 'buc', 60.00, 2);

-- Categoria mobila
INSERT INTO product(id, name, unit, price, category_id) VALUES(11, 'dulap', 'buc', 200.00, 3);
INSERT INTO product(id, name, unit, price, category_id) VALUES(12, 'birou', 'buc', 790.00, 3);
INSERT INTO product(id, name, unit, price, category_id) VALUES(13, 'scaun', 'buc', 300.00, 3);
INSERT INTO product(id, name, unit, price, category_id) VALUES(14, 'fotoliu', 'buc', 600.00, 3);
INSERT INTO product(id, name, unit, price, category_id) VALUES(15, 'bibliotecă', 'buc', 1000.00, 3);

-- Categoria electrocasnice
INSERT INTO product(id, name, unit, price, category_id) VALUES(16, 'televizor', 'buc', 2500.00, 4);
INSERT INTO product(id, name, unit, price, category_id) VALUES(17, 'laptop', 'buc', 3000.00, 4);
INSERT INTO product(id, name, unit, price, category_id) VALUES(18, 'monitor', 'buc', 500.00, 4);
INSERT INTO product(id, name, unit, price, category_id) VALUES(19, 'telefon mobil', 'buc', 2500.00, 4);
INSERT INTO product(id, name, unit, price, category_id) VALUES(20, 'masina spalat rufe', 'buc', 1000.00, 4);

-- Categoria scule si unelte
INSERT INTO product(id, name, unit, price, category_id) VALUES(21, 'bormașină', 'buc', 100.00, 5);
INSERT INTO product(id, name, unit, price, category_id) VALUES(22, 'ferăstrău', 'buc', 260.00, 5);
INSERT INTO product(id, name, unit, price, category_id) VALUES(23, 'rotopercutor', 'buc', 399.99, 5);
INSERT INTO product(id, name, unit, price, category_id) VALUES(24, 'polizor unghiular', 'buc', 201.82, 5);
INSERT INTO product(id, name, unit, price, category_id) VALUES(25, 'șlefuitor tencuială', 'buc', 666.40, 5);

-- Categoria gradina
INSERT INTO product(id, name, unit, price, category_id) VALUES(26, 'masina tuns iarba', 'buc', 179.00, 6);
INSERT INTO product(id, name, unit, price, category_id) VALUES(27, 'motocoasă', 'buc', 400.00, 6);
INSERT INTO product(id, name, unit, price, category_id) VALUES(28, 'drujbă', 'buc', 500.00, 6);
INSERT INTO product(id, name, unit, price, category_id) VALUES(29, 'motosapă', 'buc', 300.10, 6);
INSERT INTO product(id, name, unit, price, category_id) VALUES(30, 'pulverizator', 'buc', 49.99, 6);

-- Categoria auto
INSERT INTO product(id, name, unit, price, category_id) VALUES(31, 'baterie auto', 'buc', 340.00, 7);
INSERT INTO product(id, name, unit, price, category_id) VALUES(32, 'radio auto', 'buc', 240.00, 7);
INSERT INTO product(id, name, unit, price, category_id) VALUES(33, 'cauciuc r14', 'buc', 400.00, 7);
INSERT INTO product(id, name, unit, price, category_id) VALUES(34, 'ulei 10w40 1L', 'buc', 30.00, 7);
INSERT INTO product(id, name, unit, price, category_id) VALUES(35, 'covoraș', 'buc', 100.00, 7);

-- Categoria decoratiuni
INSERT INTO product(id, name, unit, price, category_id) VALUES(36, 'perdea', 'buc', 100.00, 8);
INSERT INTO product(id, name, unit, price, category_id) VALUES(37, 'draperie', 'buc', 200.00, 8);
INSERT INTO product(id, name, unit, price, category_id) VALUES(38, 'cearceaf', 'buc', 100.00, 8);
INSERT INTO product(id, name, unit, price, category_id) VALUES(39, 'rolă tapet', 'buc', 25.40, 8);
INSERT INTO product(id, name, unit, price, category_id) VALUES(40, 'prosop', 'buc', 6.00, 8);

-- Categoria amenajari interioare
INSERT INTO product(id, name, unit, price, category_id) VALUES(41, 'parchet 13mm', 'm2', 82.89, 9);
INSERT INTO product(id, name, unit, price, category_id) VALUES(42, 'mochetă', 'm2', 30.00, 9);
INSERT INTO product(id, name, unit, price, category_id) VALUES(43, 'fereastră termopan', 'buc', 159.00, 9);
INSERT INTO product(id, name, unit, price, category_id) VALUES(44, 'covor', 'buc', 200.49, 9);
INSERT INTO product(id, name, unit, price, category_id) VALUES(45, 'ușă', 'buc', 500.00, 9);

-- Categoria gresie si fainata
INSERT INTO product(id, name, unit, price, category_id) VALUES(46, 'gresie exterior', 'm2', 25.00, 10);
INSERT INTO product(id, name, unit, price, category_id) VALUES(47, 'gresie interior', 'm2', 999.99, 10);
INSERT INTO product(id, name, unit, price, category_id) VALUES(48, 'marmură', 'm2', 130.00, 10);
INSERT INTO product(id, name, unit, price, category_id) VALUES(49, 'granit', 'm2', 100, 10);
INSERT INTO product(id, name, unit, price, category_id) VALUES(50, 'cărămidă sticlă', 'buc', 7.18, 10);

-- Categoria constructii
INSERT INTO product(id, name, unit, price, category_id) VALUES(51, 'beton', 'm3', 200.00, 11);
INSERT INTO product(id, name, unit, price, category_id) VALUES(52, 'ciment 40kg', 'buc', 19.85, 11);
INSERT INTO product(id, name, unit, price, category_id) VALUES(53, 'glet 20kg', 'buc', 15.00, 11);
INSERT INTO product(id, name, unit, price, category_id) VALUES(54, 'ipsos 25kg', 'buc', 16.49, 11);
INSERT INTO product(id, name, unit, price, category_id) VALUES(55, 'liant', 'buc', 20.50, 11);

-- Categoria termice
INSERT INTO product(id, name, unit, price, category_id) VALUES(56, 'bideu', 'buc', 100.00, 12);
INSERT INTO product(id, name, unit, price, category_id) VALUES(57, 'aragaz', 'buc', 999.99, 12);
INSERT INTO product(id, name, unit, price, category_id) VALUES(58, 'hotă', 'buc', 499.99, 12);
INSERT INTO product(id, name, unit, price, category_id) VALUES(59, 'oală', 'buc', 99.99, 12);
INSERT INTO product(id, name, unit, price, category_id) VALUES(60, 'tigaie', 'buc', 49.99, 12);

-- Categoria electrice
INSERT INTO product(id, name, unit, price, category_id) VALUES(61, 'aer condiționat', 'buc', 750.00, 13);
INSERT INTO product(id, name, unit, price, category_id) VALUES(62, 'centrală gaz', 'buc', 5000.00, 13);
INSERT INTO product(id, name, unit, price, category_id) VALUES(63, 'centrală lemne', 'buc', 3500.00, 13);
INSERT INTO product(id, name, unit, price, category_id) VALUES(64, 'generator', 'buc', 1000.00, 13);
INSERT INTO product(id, name, unit, price, category_id) VALUES(65, 'sobă', 'buc', 500.00, 13);

-- Categoria sanitare
INSERT INTO product(id, name, unit, price, category_id) VALUES(66, 'suport prosop', 'buc', 90.00, 14);
INSERT INTO product(id, name, unit, price, category_id) VALUES(67, 'perie', 'buc', 20.55, 14);
INSERT INTO product(id, name, unit, price, category_id) VALUES(68, 'baterie', 'buc', 75.00, 14);
INSERT INTO product(id, name, unit, price, category_id) VALUES(69, 'piedestal', 'buc', 40.00, 14);
INSERT INTO product(id, name, unit, price, category_id) VALUES(70, 'burete', 'buc', 1.99, 14);

-- Categoria dormitoare
INSERT INTO product(id, name, unit, price, category_id) VALUES(71, 'pat', 'buc', 1000.00, 15);
INSERT INTO product(id, name, unit, price, category_id) VALUES(72, 'noptieră', 'buc', 450.00, 15);
INSERT INTO product(id, name, unit, price, category_id) VALUES(73, 'saltea', 'buc', 700.00, 15);
INSERT INTO product(id, name, unit, price, category_id) VALUES(74, 'șifonier', 'buc', 600.99, 15);
INSERT INTO product(id, name, unit, price, category_id) VALUES(75, 'comodă', 'buc', 170.99, 15);

COMMIT;