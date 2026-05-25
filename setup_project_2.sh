#!/bin/bash
set -e
PROJECT_DIR="$HOME/ecommerce_projet_ehei"
cd "$PROJECT_DIR"

# BASE TEMPLATE - Design professionnel moderne
cat > templates/base.html.twig << 'TWIG'
<!DOCTYPE html>
<html lang="fr" data-theme="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{% block title %}EHEI Shop{% endblock %}</title>
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@300;400;500;600;700&family=Inter:wght@400;500&display=swap" rel="stylesheet">
    <style>
        :root {
            --bg: #0a0a0f;
            --bg2: #111118;
            --bg3: #1a1a24;
            --card: #14141e;
            --border: #2a2a3a;
            --accent: #6c63ff;
            --accent2: #ff6584;
            --accent3: #43e97b;
            --text: #f0f0f5;
            --muted: #888899;
            --radius: 16px;
        }
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:var(--bg); color:var(--text); min-height:100vh; }
        a { color:inherit; text-decoration:none; }

        /* NAV */
        nav {
            position:sticky; top:0; z-index:100;
            background:rgba(10,10,15,0.85); backdrop-filter:blur(20px);
            border-bottom:1px solid var(--border);
            padding:0 2rem; height:70px;
            display:flex; align-items:center; gap:2rem;
        }
        .nav-brand {
            font-family:'Space Grotesk',sans-serif;
            font-size:1.4rem; font-weight:700;
            background:linear-gradient(135deg,var(--accent),var(--accent2));
            -webkit-background-clip:text; -webkit-text-fill-color:transparent;
            background-clip:text;
        }
        .nav-links { display:flex; gap:1.5rem; flex:1; }
        .nav-links a {
            color:var(--muted); font-size:.9rem; font-weight:500;
            padding:.4rem .8rem; border-radius:8px;
            transition:all .2s;
        }
        .nav-links a:hover { color:var(--text); background:var(--bg3); }
        .nav-right { display:flex; align-items:center; gap:1rem; margin-left:auto; }
        .cart-btn {
            display:flex; align-items:center; gap:.5rem;
            background:var(--bg3); border:1px solid var(--border);
            padding:.5rem 1rem; border-radius:10px;
            font-size:.9rem; cursor:pointer; transition:all .2s;
        }
        .cart-btn:hover { border-color:var(--accent); color:var(--accent); }
        .cart-count {
            background:var(--accent); color:#fff;
            width:20px; height:20px; border-radius:50%;
            display:flex; align-items:center; justify-content:center;
            font-size:.7rem; font-weight:700;
        }
        .btn-primary {
            background:linear-gradient(135deg,var(--accent),#8b5cf6);
            color:#fff; padding:.5rem 1.2rem; border-radius:10px;
            font-size:.85rem; font-weight:600; border:none; cursor:pointer;
            transition:all .2s; display:inline-flex; align-items:center; gap:.5rem;
        }
        .btn-primary:hover { transform:translateY(-1px); box-shadow:0 8px 25px rgba(108,99,255,.4); }
        .btn-outline {
            background:transparent; color:var(--accent);
            border:1px solid var(--accent); padding:.5rem 1.2rem;
            border-radius:10px; font-size:.85rem; cursor:pointer;
            transition:all .2s; display:inline-flex; align-items:center; gap:.5rem;
        }
        .btn-outline:hover { background:var(--accent); color:#fff; }

        /* FLASH */
        .flash-container { padding:.5rem 2rem; }
        .flash { padding:.8rem 1.2rem; border-radius:10px; margin:.3rem 0; font-size:.9rem; }
        .flash-success { background:rgba(67,233,123,.1); border:1px solid rgba(67,233,123,.3); color:var(--accent3); }
        .flash-danger  { background:rgba(255,101,132,.1); border:1px solid rgba(255,101,132,.3); color:var(--accent2); }
        .flash-info    { background:rgba(108,99,255,.1);  border:1px solid rgba(108,99,255,.3);  color:var(--accent); }

        /* MAIN */
        main { max-width:1400px; margin:0 auto; padding:2rem; }

        /* CARDS */
        .card {
            background:var(--card); border:1px solid var(--border);
            border-radius:var(--radius); overflow:hidden;
            transition:all .3s;
        }
        .card:hover { border-color:var(--accent); transform:translateY(-4px); box-shadow:0 20px 40px rgba(0,0,0,.5); }

        /* PRODUCT CARD */
        .product-card { cursor:pointer; }
        .product-img {
            width:100%; aspect-ratio:1; object-fit:cover;
            background:var(--bg3);
            display:flex; align-items:center; justify-content:center;
            font-size:4rem; color:var(--muted);
        }
        .product-info { padding:1.2rem; }
        .product-name { font-family:'Space Grotesk',sans-serif; font-weight:600; margin-bottom:.3rem; }
        .product-cat  { font-size:.8rem; color:var(--muted); margin-bottom:.8rem; }
        .product-price { font-size:1.3rem; font-weight:700; color:var(--accent); }
        .product-footer { padding:0 1.2rem 1.2rem; display:flex; gap:.5rem; }

        /* GRID */
        .grid-4 { display:grid; grid-template-columns:repeat(auto-fill,minmax(240px,1fr)); gap:1.5rem; }
        .grid-3 { display:grid; grid-template-columns:repeat(auto-fill,minmax(300px,1fr)); gap:1.5rem; }
        .grid-2 { display:grid; grid-template-columns:repeat(2,1fr); gap:1.5rem; }

        /* SECTION HEADER */
        .section-header { margin-bottom:2rem; }
        .section-title {
            font-family:'Space Grotesk',sans-serif;
            font-size:1.8rem; font-weight:700;
            margin-bottom:.5rem;
        }
        .section-subtitle { color:var(--muted); font-size:.95rem; }

        /* FOOTER */
        footer {
            margin-top:4rem; padding:2rem;
            border-top:1px solid var(--border);
            text-align:center; color:var(--muted); font-size:.85rem;
        }

        /* BADGE */
        .badge {
            display:inline-block; padding:.2rem .7rem;
            border-radius:6px; font-size:.75rem; font-weight:600;
        }
        .badge-purple { background:rgba(108,99,255,.2); color:var(--accent); border:1px solid rgba(108,99,255,.3); }
        .badge-green  { background:rgba(67,233,123,.2); color:var(--accent3); border:1px solid rgba(67,233,123,.3); }
        .badge-pink   { background:rgba(255,101,132,.2); color:var(--accent2); border:1px solid rgba(255,101,132,.3); }

        /* FORM */
        .form-group { margin-bottom:1.2rem; }
        .form-group label { display:block; font-size:.85rem; color:var(--muted); margin-bottom:.4rem; }
        .form-group input, .form-group select, .form-group textarea {
            width:100%; background:var(--bg3); border:1px solid var(--border);
            color:var(--text); padding:.8rem 1rem; border-radius:10px;
            font-size:.9rem; outline:none; transition:border .2s;
        }
        .form-group input:focus { border-color:var(--accent); }
        .form-error { font-size:.8rem; color:var(--accent2); margin-top:.3rem; }

        /* TABLE */
        table { width:100%; border-collapse:collapse; }
        th { text-align:left; padding:1rem; color:var(--muted); font-size:.85rem; font-weight:500; border-bottom:1px solid var(--border); }
        td { padding:1rem; border-bottom:1px solid rgba(255,255,255,.05); }
        tr:last-child td { border:none; }
    </style>
    {% block stylesheets %}{% endblock %}
</head>
<body>
<nav>
    <a href="{{ path('home') }}" class="nav-brand">⚡ EHEI Shop</a>
    <div class="nav-links">
        <a href="{{ path('home') }}">Accueil</a>
        <a href="{{ path('categories') }}">Catégories</a>
    </div>
    <div class="nav-right">
        <form action="{{ path('product_search') }}" method="GET" style="display:flex;gap:.5rem">
            <input type="text" name="q" placeholder="Rechercher..." style="background:var(--bg3);border:1px solid var(--border);color:var(--text);padding:.5rem 1rem;border-radius:10px;outline:none;font-size:.85rem;width:200px">
        </form>
        <a href="{{ path('cart_show') }}" class="cart-btn">
            🛒 <span class="cart-count">0</span>
        </a>
        {% if app.user %}
            <a href="{{ path('profile') }}" class="btn-outline">👤 {{ app.user.email }}</a>
            <a href="{{ path('app_logout') }}" class="btn-primary">Déconnexion</a>
        {% else %}
            <a href="{{ path('app_login') }}" class="btn-outline">Connexion</a>
            <a href="{{ path('app_register') }}" class="btn-primary">S'inscrire</a>
        {% endif %}
    </div>
</nav>

<div class="flash-container">
    {% for msg in app.flashes('success') %}<div class="flash flash-success">{{ msg }}</div>{% endfor %}
    {% for msg in app.flashes('danger') %}<div class="flash flash-danger">{{ msg }}</div>{% endfor %}
    {% for msg in app.flashes('info') %}<div class="flash flash-info">{{ msg }}</div>{% endfor %}
</div>

<main>{% block body %}{% endblock %}</main>

<footer>
    <p>© 2026 EHEI Shop · Projet Symfony · Architecture SOLID</p>
</footer>
{% block javascripts %}{% endblock %}
</body>
</html>
TWIG

# HOME
cat > templates/home/index.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block body %}
<!-- HERO -->
<div style="text-align:center;padding:4rem 0 3rem;position:relative">
    <div style="position:absolute;top:0;left:50%;transform:translateX(-50%);width:600px;height:300px;background:radial-gradient(ellipse,rgba(108,99,255,.2),transparent 70%);pointer-events:none"></div>
    <span class="badge badge-purple" style="margin-bottom:1rem">🎓 Projet EHEI 2026</span>
    <h1 style="font-family:'Space Grotesk',sans-serif;font-size:3.5rem;font-weight:700;line-height:1.1;margin:1rem 0">
        Découvrez nos<br>
        <span style="background:linear-gradient(135deg,#6c63ff,#ff6584);-webkit-background-clip:text;-webkit-text-fill-color:transparent;background-clip:text">meilleurs produits</span>
    </h1>
    <p style="color:#888899;font-size:1.1rem;max-width:500px;margin:1rem auto 2rem">
        Des milliers de produits, des prix imbattables, une expérience d'achat unique.
    </p>
    <a href="{{ path('categories') }}" class="btn-primary" style="font-size:1rem;padding:.8rem 2rem">
        Explorer les catégories →
    </a>
</div>

<!-- CATEGORIES -->
{% if categories %}
<div style="margin-bottom:3rem">
    <div class="section-header">
        <h2 class="section-title">Catégories</h2>
        <p class="section-subtitle">{{ categories|length }} catégories disponibles</p>
    </div>
    <div class="grid-3">
        {% for cat in categories %}
        <a href="{{ path('category_products', {id: cat.id}) }}" class="card" style="padding:1.5rem;display:flex;align-items:center;gap:1rem">
            <div style="font-size:2.5rem">{{ cat.icon ?? '📦' }}</div>
            <div>
                <div style="font-family:'Space Grotesk',sans-serif;font-weight:600;font-size:1.1rem">{{ cat.name }}</div>
                <div style="color:var(--muted);font-size:.85rem">{{ cat.products|length }} produits</div>
            </div>
        </a>
        {% endfor %}
    </div>
</div>
{% endif %}

<!-- FEATURED PRODUCTS -->
{% if featured_products %}
<div>
    <div class="section-header">
        <h2 class="section-title">Produits en vedette</h2>
        <p class="section-subtitle">Sélection de nos meilleures offres</p>
    </div>
    <div class="grid-4">
        {% for product in featured_products %}
        <div class="card product-card">
            <div class="product-img">
                {% if product.image %}
                    <img src="{{ product.image }}" alt="{{ product.name }}" style="width:100%;height:100%;object-fit:cover">
                {% else %}
                    🛍️
                {% endif %}
            </div>
            <div class="product-info">
                <div class="product-name">{{ product.name }}</div>
                {% if product.category %}<div class="product-cat">{{ product.category.name }}</div>{% endif %}
                <div class="product-price">{{ product.price|number_format(2, '.', ',') }} MAD</div>
            </div>
            <div class="product-footer">
                <a href="{{ path('product_show', {id: product.id}) }}" class="btn-outline" style="flex:1;justify-content:center">Voir</a>
                <form action="{{ path('cart_add', {id: product.id}) }}" method="POST" style="flex:1">
                    <input type="hidden" name="quantity" value="1">
                    <button type="submit" class="btn-primary" style="width:100%;justify-content:center">+ Panier</button>
                </form>
            </div>
        </div>
        {% endfor %}
    </div>
</div>
{% else %}
<div style="text-align:center;padding:4rem;color:var(--muted)">
    <div style="font-size:4rem;margin-bottom:1rem">🏪</div>
    <h3 style="font-family:'Space Grotesk',sans-serif;margin-bottom:.5rem">Aucun produit pour l'instant</h3>
    <p>Lancez les fixtures pour ajouter des données de test.</p>
</div>
{% endif %}
{% endblock %}
TWIG

# PRODUCT SHOW
cat > templates/product/show.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}{{ product.name }}{% endblock %}
{% block body %}
<div style="max-width:900px;margin:0 auto">
    <a href="javascript:history.back()" style="color:var(--muted);font-size:.9rem;display:inline-flex;align-items:center;gap:.3rem;margin-bottom:1.5rem">← Retour</a>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:3rem;align-items:start">
        <div class="card" style="aspect-ratio:1;display:flex;align-items:center;justify-content:center;font-size:8rem">
            {{ product.image ? '<img src="'~product.image~'" style="width:100%;height:100%;object-fit:cover">' : '🛍️' }}
        </div>
        <div>
            {% if product.category %}
            <span class="badge badge-purple" style="margin-bottom:1rem">{{ product.category.name }}</span>
            {% endif %}
            <h1 style="font-family:'Space Grotesk',sans-serif;font-size:2rem;font-weight:700;margin-bottom:1rem">{{ product.name }}</h1>
            <p style="color:var(--muted);line-height:1.7;margin-bottom:2rem">{{ product.description }}</p>
            <div style="font-size:2.5rem;font-weight:700;color:var(--accent);margin-bottom:1.5rem">
                {{ product.price|number_format(2, '.', ',') }} <span style="font-size:1.2rem">MAD</span>
            </div>
            {% if product.stock %}
            <div style="margin-bottom:1.5rem">
                <span class="badge badge-green">✅ En stock ({{ product.stock }})</span>
            </div>
            {% endif %}
            <form action="{{ path('cart_add', {id: product.id}) }}" method="POST" style="display:flex;gap:1rem;align-items:center">
                <input type="number" name="quantity" value="1" min="1" max="{{ product.stock ?? 99 }}"
                    style="width:80px;background:var(--bg3);border:1px solid var(--border);color:var(--text);padding:.8rem;border-radius:10px;text-align:center;font-size:1rem">
                <button type="submit" class="btn-primary" style="flex:1;justify-content:center;padding:.8rem;font-size:1rem">
                    🛒 Ajouter au panier
                </button>
            </form>
        </div>
    </div>
</div>
{% endblock %}
TWIG

# CATEGORY INDEX
cat > templates/category/index.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}Catégories{% endblock %}
{% block body %}
<div class="section-header">
    <h1 class="section-title">Toutes les catégories</h1>
    <p class="section-subtitle">{{ categories|length }} catégories disponibles</p>
</div>
<div class="grid-3">
    {% for cat in categories %}
    <a href="{{ path('category_products', {id: cat.id}) }}" class="card" style="padding:2rem">
        <div style="font-size:3rem;margin-bottom:1rem">{{ cat.icon ?? '📦' }}</div>
        <h3 style="font-family:'Space Grotesk',sans-serif;font-size:1.2rem;font-weight:600;margin-bottom:.5rem">{{ cat.name }}</h3>
        {% if cat.description %}<p style="color:var(--muted);font-size:.9rem">{{ cat.description }}</p>{% endif %}
        <div style="margin-top:1rem;color:var(--accent);font-size:.85rem;font-weight:500">{{ cat.products|length }} produits →</div>
    </a>
    {% else %}
    <p style="color:var(--muted)">Aucune catégorie.</p>
    {% endfor %}
</div>
{% endblock %}
TWIG

# CATEGORY PRODUCTS
cat > templates/category/products.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}{{ category.name }}{% endblock %}
{% block body %}
<div style="display:flex;align-items:center;gap:1rem;margin-bottom:2rem">
    <a href="{{ path('categories') }}" style="color:var(--muted);font-size:.9rem">← Catégories</a>
    <span style="color:var(--border)">/</span>
    <span style="font-size:.9rem">{{ category.name }}</span>
</div>
<div class="section-header">
    <h1 class="section-title">{{ category.icon ?? '📦' }} {{ category.name }}</h1>
    <p class="section-subtitle">{{ products|length }} produit(s)</p>
</div>
<div class="grid-4">
    {% for product in products %}
    <div class="card product-card">
        <div class="product-img">{{ product.image ? '<img src="'~product.image~'" style="width:100%;height:100%;object-fit:cover">' : '🛍️' }}</div>
        <div class="product-info">
            <div class="product-name">{{ product.name }}</div>
            <div class="product-price">{{ product.price|number_format(2,'.') }} MAD</div>
        </div>
        <div class="product-footer">
            <a href="{{ path('product_show', {id: product.id}) }}" class="btn-outline" style="flex:1;justify-content:center">Voir</a>
            <form action="{{ path('cart_add', {id: product.id}) }}" method="POST" style="flex:1">
                <input type="hidden" name="quantity" value="1">
                <button type="submit" class="btn-primary" style="width:100%;justify-content:center">+ Panier</button>
            </form>
        </div>
    </div>
    {% else %}
    <p style="color:var(--muted)">Aucun produit dans cette catégorie.</p>
    {% endfor %}
</div>
{% endblock %}
TWIG

# CART
cat > templates/cart/show.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}Mon panier{% endblock %}
{% block body %}
<div style="max-width:900px;margin:0 auto">
    <div class="section-header">
        <h1 class="section-title">🛒 Mon panier</h1>
    </div>
    {% if cart.items|length > 0 %}
    <div style="display:grid;grid-template-columns:1fr 350px;gap:2rem;align-items:start">
        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Produit</th>
                        <th>Prix</th>
                        <th>Qté</th>
                        <th>Sous-total</th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>
                {% for item in cart.items %}
                <tr>
                    <td>
                        <div style="display:flex;align-items:center;gap:1rem">
                            <div style="width:50px;height:50px;background:var(--bg3);border-radius:8px;display:flex;align-items:center;justify-content:center;font-size:1.5rem">🛍️</div>
                            <div>
                                <div style="font-weight:500">{{ item.product.name }}</div>
                                {% if item.product.category %}<div style="font-size:.8rem;color:var(--muted)">{{ item.product.category.name }}</div>{% endif %}
                            </div>
                        </div>
                    </td>
                    <td style="color:var(--muted)">{{ item.product.price|number_format(2,'.') }} MAD</td>
                    <td><span class="badge badge-purple">× {{ item.quantity }}</span></td>
                    <td style="font-weight:600;color:var(--accent)">{{ (item.product.price * item.quantity)|number_format(2,'.') }} MAD</td>
                    <td><a href="{{ path('cart_remove', {id: item.product.id}) }}" style="color:var(--accent2);font-size:.85rem">✕</a></td>
                </tr>
                {% endfor %}
                </tbody>
            </table>
        </div>
        <div class="card" style="padding:1.5rem">
            <h3 style="font-family:'Space Grotesk',sans-serif;font-size:1.2rem;margin-bottom:1.5rem">Récapitulatif</h3>
            <div style="display:flex;justify-content:space-between;margin-bottom:.8rem;color:var(--muted)">
                <span>Articles ({{ cart.count }})</span>
                <span>{{ cart.total|number_format(2,'.') }} MAD</span>
            </div>
            <div style="display:flex;justify-content:space-between;margin-bottom:.8rem;color:var(--muted)">
                <span>Livraison</span><span style="color:var(--accent3)">Gratuite</span>
            </div>
            <hr style="border:none;border-top:1px solid var(--border);margin:1rem 0">
            <div style="display:flex;justify-content:space-between;font-size:1.3rem;font-weight:700;margin-bottom:1.5rem">
                <span>Total</span>
                <span style="color:var(--accent)">{{ cart.total|number_format(2,'.') }} MAD</span>
            </div>
            <button class="btn-primary" style="width:100%;justify-content:center;padding:.9rem;font-size:1rem">
                Valider la commande →
            </button>
            <a href="{{ path('cart_clear') }}" style="display:block;text-align:center;color:var(--muted);font-size:.85rem;margin-top:1rem">Vider le panier</a>
        </div>
    </div>
    {% else %}
    <div style="text-align:center;padding:4rem;color:var(--muted)">
        <div style="font-size:5rem;margin-bottom:1rem">🛒</div>
        <h3 style="font-family:'Space Grotesk',sans-serif;margin-bottom:.5rem">Panier vide</h3>
        <p style="margin-bottom:2rem">Découvrez nos produits et ajoutez-les ici.</p>
        <a href="{{ path('home') }}" class="btn-primary">Continuer mes achats</a>
    </div>
    {% endif %}
</div>
{% endblock %}
TWIG

# LOGIN
cat > templates/security/login.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}Connexion{% endblock %}
{% block body %}
<div style="max-width:420px;margin:3rem auto">
    <div class="card" style="padding:2rem">
        <h1 style="font-family:'Space Grotesk',sans-serif;font-size:1.8rem;font-weight:700;margin-bottom:.5rem;text-align:center">Bienvenue</h1>
        <p style="color:var(--muted);text-align:center;margin-bottom:2rem">Connectez-vous pour continuer</p>
        
        {% if error %}
            <div class="flash flash-danger" style="margin-bottom:1.5rem">{{ error.messageKey|trans(error.messageData, 'security') }}</div>
        {% endif %}

        <form method="post">
            <div class="form-group">
                <label for="username">Email</label>
                <input type="email" value="{{ last_username }}" name="_username" id="username" required autofocus placeholder="email@example.com">
            </div>
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" name="_password" id="password" required placeholder="••••••••">
            </div>

            <input type="hidden" name="_csrf_token" value="{{ csrf_token('authenticate') }}">

            <button class="btn-primary" type="submit" style="width:100%;justify-content:center;padding:.8rem;font-size:1rem;margin-top:1rem">
                Se connecter
            </button>
        </form>
        <div style="text-align:center;margin-top:1.5rem;font-size:.9rem;color:var(--muted)">
            Pas encore de compte ? <a href="{{ path('app_register') }}" style="color:var(--accent)">S'inscrire</a>
        </div>
    </div>
</div>
{% endblock %}
TWIG

# REGISTER
cat > templates/security/register.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}Inscription{% endblock %}
{% block body %}
<div style="max-width:420px;margin:3rem auto">
    <div class="card" style="padding:2rem">
        <h1 style="font-family:'Space Grotesk',sans-serif;font-size:1.8rem;font-weight:700;margin-bottom:.5rem;text-align:center">Créer un compte</h1>
        <p style="color:var(--muted);text-align:center;margin-bottom:2rem">Rejoignez-nous aujourd'hui</p>

        {{ form_start(form) }}
        <div class="form-group">
            {{ form_label(form.fullName) }}
            {{ form_widget(form.fullName) }}
            <div class="form-error">{{ form_errors(form.fullName) }}</div>
        </div>
        <div class="form-group">
            {{ form_label(form.email) }}
            {{ form_widget(form.email) }}
            <div class="form-error">{{ form_errors(form.email) }}</div>
        </div>
        <div class="form-group">
            {{ form_label(form.plainPassword.first) }}
            {{ form_widget(form.plainPassword.first) }}
            <div class="form-error">{{ form_errors(form.plainPassword.first) }}</div>
        </div>
        <div class="form-group">
            {{ form_label(form.plainPassword.second) }}
            {{ form_widget(form.plainPassword.second) }}
            <div class="form-error">{{ form_errors(form.plainPassword.second) }}</div>
        </div>

        <button class="btn-primary" type="submit" style="width:100%;justify-content:center;padding:.8rem;font-size:1rem;margin-top:1rem">
            S'inscrire
        </button>
        {{ form_end(form) }}
        
        <div style="text-align:center;margin-top:1.5rem;font-size:.9rem;color:var(--muted)">
            Déjà inscrit ? <a href="{{ path('app_login') }}" style="color:var(--accent)">Se connecter</a>
        </div>
    </div>
</div>
{% endblock %}
TWIG

# PROFILE
cat > templates/profile/index.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}Mon Profil{% endblock %}
{% block body %}
<div style="max-width:800px;margin:0 auto">
    <div class="section-header">
        <h1 class="section-title">Mon Profil</h1>
    </div>
    <div class="card" style="padding:2rem;display:flex;align-items:center;gap:2rem">
        <div style="width:100px;height:100px;background:var(--accent);color:#fff;border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:2.5rem;font-weight:700">
            {{ user.fullName|default(user.email)|slice(0,1)|upper }}
        </div>
        <div>
            <h2 style="font-family:'Space Grotesk',sans-serif;font-size:1.5rem;margin-bottom:.5rem">{{ user.fullName|default('Utilisateur') }}</h2>
            <p style="color:var(--muted);margin-bottom:.5rem">{{ user.email }}</p>
            <span class="badge badge-purple">Membre</span>
        </div>
    </div>
</div>
{% endblock %}
TWIG

# SEARCH
cat > templates/product/search.html.twig << 'TWIG'
{% extends 'base.html.twig' %}
{% block title %}Recherche{% endblock %}
{% block body %}
<div class="section-header">
    <h1 class="section-title">Résultats pour "{{ query }}"</h1>
    <p class="section-subtitle">{{ products|length }} produit(s) trouvé(s)</p>
</div>
{% if products %}
<div class="grid-4">
    {% for product in products %}
    <div class="card product-card">
        <div class="product-img">{{ product.image ? '<img src="'~product.image~'" style="width:100%;height:100%;object-fit:cover">' : '🛍️' }}</div>
        <div class="product-info">
            <div class="product-name">{{ product.name }}</div>
            <div class="product-price">{{ product.price|number_format(2,'.') }} MAD</div>
        </div>
        <div class="product-footer">
            <a href="{{ path('product_show', {id: product.id}) }}" class="btn-outline" style="flex:1;justify-content:center">Voir</a>
            <form action="{{ path('cart_add', {id: product.id}) }}" method="POST" style="flex:1">
                <input type="hidden" name="quantity" value="1">
                <button type="submit" class="btn-primary" style="width:100%;justify-content:center">+ Panier</button>
            </form>
        </div>
    </div>
    {% endfor %}
</div>
{% else %}
<p style="color:var(--muted)">Aucun produit trouvé pour "{{ query }}".</p>
{% endif %}
{% endblock %}
TWIG

# Fixtures (to be loaded in Step 2)
mkdir -p src/DataFixtures
cat > src/DataFixtures/AppFixtures.php << 'EOF'
<?php
namespace App\DataFixtures;
use App\Entity\Category;
use App\Entity\Product;
use Doctrine\Bundle\FixturesBundle\Fixture;
use Doctrine\Persistence\ObjectManager;

class AppFixtures extends Fixture
{
    public function load(ObjectManager $manager): void
    {
        $categoriesData = [
            ['name' => 'Électronique', 'icon' => '💻', 'description' => 'Gadgets et appareils électroniques'],
            ['name' => 'Vêtements', 'icon' => '👕', 'description' => 'Mode pour hommes et femmes'],
            ['name' => 'Maison', 'icon' => '🏠', 'description' => 'Décoration et ameublement'],
            ['name' => 'Livres', 'icon' => '📚', 'description' => 'Romans, essais, et plus'],
            ['name' => 'Sport', 'icon' => '⚽', 'description' => 'Équipements sportifs'],
        ];

        $categories = [];
        foreach ($categoriesData as $data) {
            $category = new Category();
            $category->setName($data['name']);
            $category->setIcon($data['icon']);
            $category->setDescription($data['description']);
            $manager->persist($category);
            $categories[] = $category;
        }

        $productsData = [
            ['name' => 'PC Portable Gamer', 'price' => 12000, 'stock' => 5, 'desc' => 'PC ultra performant.', 'cat_idx' => 0],
            ['name' => 'Smartphone 5G', 'price' => 5000, 'stock' => 15, 'desc' => 'Dernier smartphone.', 'cat_idx' => 0],
            ['name' => 'Casque Sans Fil', 'price' => 800, 'stock' => 20, 'desc' => 'Son HD et réduction de bruit.', 'cat_idx' => 0],
            ['name' => 'T-shirt Basique', 'price' => 150, 'stock' => 50, 'desc' => 'T-shirt en coton bio.', 'cat_idx' => 1],
            ['name' => 'Veste en Cuir', 'price' => 1200, 'stock' => 10, 'desc' => 'Veste élégante.', 'cat_idx' => 1],
            ['name' => 'Lampe de Bureau', 'price' => 300, 'stock' => 30, 'desc' => 'Lampe LED moderne.', 'cat_idx' => 2],
            ['name' => 'Canapé 3 Places', 'price' => 4500, 'stock' => 3, 'desc' => 'Canapé confortable.', 'cat_idx' => 2],
            ['name' => 'Roman Science-Fiction', 'price' => 120, 'stock' => 100, 'desc' => 'Bestseller de l\'année.', 'cat_idx' => 3],
            ['name' => 'Livre de Recettes', 'price' => 200, 'stock' => 40, 'desc' => 'Cuisiner comme un chef.', 'cat_idx' => 3],
            ['name' => 'Ballon de Football', 'price' => 250, 'stock' => 25, 'desc' => 'Ballon officiel.', 'cat_idx' => 4],
            ['name' => 'Tapis de Yoga', 'price' => 180, 'stock' => 60, 'desc' => 'Tapis antidérapant.', 'cat_idx' => 4],
            ['name' => 'Haltères 5kg', 'price' => 400, 'stock' => 15, 'desc' => 'Paire d\'haltères.', 'cat_idx' => 4],
        ];

        foreach ($productsData as $data) {
            $product = new Product();
            $product->setName($data['name']);
            $product->setPrice($data['price']);
            $product->setStock($data['stock']);
            $product->setDescription($data['desc']);
            $product->setCategory($categories[$data['cat_idx']]);
            $manager->persist($product);
        }

        $manager->flush();
    }
}
EOF

echo "✅ All files and templates created."
