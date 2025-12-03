# 📚 Guide des Concepts Flutter - Test Technique AZEOO

## 🎯 Introduction

Ce guide t'explique les concepts clés que tu vas utiliser dans le projet. Prends le temps de bien comprendre, ça va te faire gagner du temps après !

---

## 1️⃣ **State Management : Riverpod** 🔄

### **C'est quoi le problème ?**
Imagine que tu as plusieurs écrans dans ton app. Comment partager les données entre eux ? Comment dire à un écran que les données ont changé ?

### **La solution : Riverpod**
Riverpod est comme un **magasin central** où tu stockes tes données. N'importe quel écran peut :
- Lire les données
- Modifier les données
- Être notifié quand les données changent

### **Analogie simple**
Pense à Riverpod comme un **supermarché** :
- Les **Providers** = les rayons du supermarché
- Les **Widgets** = les clients qui viennent chercher des produits
- Quand un produit change, tous les clients intéressés sont notifiés

### **Exemple concret**
```dart
// Provider = Rayon "Profil Utilisateur"
final userProfileProvider = FutureProvider.autoDispose.family<User, int>((ref, userId) async {
  // Va chercher le profil depuis l'API
  return await getUserFromAPI(userId);
});

// Widget = Client qui utilise le profil
class ProfileScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // "Je veux le profil de l'userId 1"
    final userAsync = ref.watch(userProfileProvider(1));
    
    return userAsync.when(
      data: (user) => Text('Bonjour ${user.firstName}'),
      loading: () => CircularProgressIndicator(),
      error: (err, stack) => Text('Erreur: $err'),
    );
  }
}
```

### **Pourquoi pas setState() ?**
`setState()` c'est comme avoir chaque client qui gère son propre mini-stock. Ça marche pour 1-2 clients, mais imagine avec 50 clients ! C'est le chaos.

Riverpod = un seul magasin central, tout le monde vient au même endroit.

---

## 2️⃣ **Navigation : go_router** 🧭

### **C'est quoi le problème ?**
Comment passer d'un écran à un autre ? Comment gérer les URLs ? Comment revenir en arrière ?

### **La solution : go_router**
go_router gère toute la navigation de façon **propre et scalable**.

### **Analogie simple**
Pense à go_router comme le **GPS de ton app** :
- Tu définis toutes les routes (destinations possibles)
- Tu dis "Je veux aller à /profile/1"
- Il t'y emmène automatiquement

### **Exemple concret**
```dart
// Configuration des routes
final router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => HomeScreen(),
    ),
    GoRoute(
      path: '/profile/:userId',
      builder: (context, state) {
        final userId = state.pathParameters['userId']!;
        return ProfileScreen(userId: int.parse(userId));
      },
    ),
  ],
);

// Navigation
context.go('/profile/1');  // Va au profil de l'userId 1
context.push('/profile/3'); // Empile le profil 3 par-dessus
context.pop();              // Retour en arrière
```

### **Pourquoi pas Navigator.push() ?**
`Navigator.push()` c'est comme dire "tourne à gauche, puis tout droit, puis à droite..." à chaque fois.

go_router c'est comme dire "GPS, emmène-moi à cette adresse" → beaucoup plus simple !

---

## 3️⃣ **Architecture : Clean Architecture** 🏗️

### **C'est quoi le problème ?**
Si tu mets tout le code au même endroit, ça devient vite le bordel. Comment organiser ton code proprement ?

### **La solution : Clean Architecture**
Sépare ton code en 3 couches indépendantes :

```
📁 lib/
├── 📁 presentation/     ← L'interface utilisateur (ce que l'utilisateur voit)
│   ├── screens/         ← Les écrans
│   ├── widgets/         ← Les composants réutilisables
│   └── providers/       ← Les providers Riverpod
│
├── 📁 domain/           ← La logique métier (les règles de ton app)
│   ├── entities/        ← Les objets purs (User, Product, etc.)
│   ├── repositories/    ← Les interfaces (contrats)
│   └── usecases/        ← Les actions métier (GetUserProfile, etc.)
│
└── 📁 data/             ← L'accès aux données (API, cache, BDD)
    ├── models/          ← Les modèles JSON
    ├── repositories/    ← L'implémentation des repositories
    └── datasources/     ← API, cache local, etc.
```

### **Analogie simple**
Pense à un **restaurant** :
- **Presentation** = La salle (ce que le client voit, les serveurs)
- **Domain** = Le menu et les recettes (les règles de cuisine)
- **Data** = La cuisine et les fournisseurs (où on prépare vraiment)

### **Pourquoi cette séparation ?**
- **Testable** : Tu peux tester chaque couche séparément
- **Réutilisable** : Tu peux changer l'UI sans toucher à la logique
- **Maintenable** : Facile de trouver où est le code
- **Scalable** : Tu peux ajouter des features sans tout casser

### **Exemple concret : Récupérer un profil utilisateur**

**1. Entity (Domain)** - L'objet pur
```dart
class User {
  final int id;
  final String firstName;
  final String lastName;
  final String avatarUrl;
  
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarUrl,
  });
}
```

**2. Repository Interface (Domain)** - Le contrat
```dart
abstract class UserRepository {
  Future<User> getUserProfile(int userId);
}
```

**3. Model (Data)** - Le JSON
```dart
class UserModel {
  final int id;
  final String first_name;  // Format API
  final String last_name;
  final List<Picture> picture;
  
  // Conversion JSON → UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      picture: (json['picture'] as List).map((p) => Picture.fromJson(p)).toList(),
    );
  }
  
  // Conversion UserModel → User (Entity)
  User toEntity() {
    return User(
      id: id,
      firstName: first_name,
      lastName: last_name,
      avatarUrl: picture.firstWhere((p) => p.label == 'large').url,
    );
  }
}
```

**4. Repository Implementation (Data)** - La vraie logique
```dart
class UserRepositoryImpl implements UserRepository {
  final ApiService apiService;
  final CacheService cacheService;
  
  @override
  Future<User> getUserProfile(int userId) async {
    // 1. Vérifie le cache
    final cached = await cacheService.getUser(userId);
    if (cached != null) return cached.toEntity();
    
    // 2. Si pas de cache, appelle l'API
    final json = await apiService.get('/users/me', headers: {'X-User-Id': '$userId'});
    final model = UserModel.fromJson(json);
    
    // 3. Sauvegarde en cache
    await cacheService.saveUser(model);
    
    // 4. Retourne l'entity
    return model.toEntity();
  }
}
```

**5. UseCase (Domain)** - L'action métier
```dart
class GetUserProfile {
  final UserRepository repository;
  
  GetUserProfile(this.repository);
  
  Future<User> call(int userId) {
    return repository.getUserProfile(userId);
  }
}
```

**6. Provider (Presentation)** - Exposé à l'UI
```dart
final userProfileProvider = FutureProvider.family<User, int>((ref, userId) async {
  final repository = ref.read(userRepositoryProvider);
  final useCase = GetUserProfile(repository);
  return await useCase(userId);
});
```

**7. Widget (Presentation)** - L'affichage
```dart
class ProfileScreen extends ConsumerWidget {
  final int userId;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProfileProvider(userId));
    
    return userAsync.when(
      data: (user) => Column(
        children: [
          Image.network(user.avatarUrl),
          Text('${user.firstName} ${user.lastName}'),
        ],
      ),
      loading: () => CircularProgressIndicator(),
      error: (e, s) => Text('Erreur: $e'),
    );
  }
}
```

**Flux de données :**
```
Widget demande données
    ↓
Provider
    ↓
UseCase
    ↓
Repository Interface
    ↓
Repository Implementation
    ↓
Cache → pas de données ? → API
    ↓
Model (JSON)
    ↓
Entity (objet propre)
    ↓
Widget affiche
```

---

## 4️⃣ **API Client : Dio** 🌐

### **C'est quoi ?**
Dio est une bibliothèque pour faire des appels HTTP (GET, POST, etc.) de façon propre.

### **Pourquoi Dio et pas http ?**
- ✅ Intercepteurs (pour logger, ajouter des headers automatiquement)
- ✅ Gestion d'erreurs avancée
- ✅ Retry automatique
- ✅ Timeout configurable
- ✅ Upload/Download avec progression

### **Exemple concret**
```dart
final dio = Dio(BaseOptions(
  baseUrl: 'https://api.azeoo.dev/v1',
  connectTimeout: Duration(seconds: 5),
  receiveTimeout: Duration(seconds: 3),
));

// Intercepteur pour ajouter l'auth automatiquement
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    options.headers['Authorization'] = 'Bearer $token';
    return handler.next(options);
  },
  onError: (error, handler) {
    if (error.response?.statusCode == 401) {
      // Token expiré, refresh
    }
    return handler.next(error);
  },
));

// Appel API
final response = await dio.get('/users/me', 
  headers: {'X-User-Id': '1'}
);
```

---

## 5️⃣ **Cache Local : Hive** 💾

### **C'est quoi le problème ?**
Chaque fois que l'app démarre, tu ne veux pas recharger toutes les données depuis l'API. C'est lent et ça bouffe de la data.

### **La solution : Hive**
Hive est une base de données **ultra-rapide** qui stocke les données localement sur le téléphone.

### **Stratégie Cache-First**
```
1. L'app demande les données
2. On vérifie le cache
   - Si données présentes → Affiche immédiatement
   - En parallèle, rafraîchit depuis l'API
3. Si pas de cache → Affiche loading, puis charge depuis l'API
```

### **Exemple concret**
```dart
// Ouvre la box Hive
final box = await Hive.openBox<UserModel>('users');

// Sauvegarde
await box.put(userId, userModel);

// Récupère
final cached = box.get(userId);

// Supprime
await box.delete(userId);

// Efface tout
await box.clear();
```

### **Pourquoi Hive et pas SharedPreferences ?**
- ✅ Plus rapide (10x plus rapide)
- ✅ Peut stocker des objets complexes
- ✅ Pas de limite de taille (SharedPrefs = 2MB max)
- ✅ Type-safe

---

## 6️⃣ **Dependency Injection : get_it** 💉

### **C'est quoi le problème ?**
Comment créer et partager des instances de services (API, cache, etc.) dans toute l'app ?

### **La solution : get_it**
get_it est un **service locator** qui gère toutes tes dépendances.

### **Analogie simple**
Pense à get_it comme un **annuaire téléphonique** :
- Tu enregistres tous tes services une seule fois
- N'importe qui peut appeler le service quand il en a besoin

### **Exemple concret**
```dart
final getIt = GetIt.instance;

// Setup (au démarrage de l'app)
void setupDependencies() {
  // Singletons (une seule instance pour toute l'app)
  getIt.registerSingleton<Dio>(Dio());
  getIt.registerSingleton<HiveInterface>(Hive);
  
  // Lazy singletons (créé seulement quand nécessaire)
  getIt.registerLazySingleton<ApiService>(() => ApiService(getIt<Dio>()));
  getIt.registerLazySingleton<CacheService>(() => CacheService(getIt<HiveInterface>()));
  
  // Factories (nouvelle instance à chaque fois)
  getIt.registerFactory<UserRepository>(() => UserRepositoryImpl(
    apiService: getIt<ApiService>(),
    cacheService: getIt<CacheService>(),
  ));
}

// Utilisation
final apiService = getIt<ApiService>();
final userRepo = getIt<UserRepository>();
```

### **Avantages**
- ✅ **Testable** : Tu peux remplacer les vrais services par des mocks pour les tests
- ✅ **Découplé** : Aucun widget ne connaît l'implémentation réelle
- ✅ **Flexible** : Tu peux changer l'implémentation sans toucher au code qui l'utilise

---

## 🎯 **Résumé : Comment tout ça marche ensemble**

Imagine que l'utilisateur ouvre l'écran de profil :

```
1. Widget demande le profil userId=1
   ↓
2. Riverpod (Provider) active le GetUserProfile UseCase
   ↓
3. UseCase appelle le UserRepository
   ↓
4. Repository vérifie le cache (Hive)
   - Cache existe ? → Retourne immédiatement
   - Pas de cache ? → Continue
   ↓
5. Repository appelle l'API (Dio)
   ↓
6. Dio fait la requête HTTP à https://api.azeoo.dev/v1/users/me
   ↓
7. API retourne le JSON
   ↓
8. Repository convertit JSON → UserModel → User (Entity)
   ↓
9. Repository sauvegarde en cache (Hive)
   ↓
10. Riverpod notifie le Widget que les données sont prêtes
   ↓
11. Widget affiche le profil avec go_router pour la navigation
```

---

## 📝 **Checklist de compréhension**

Avant de passer à la suite, assure-toi de comprendre :

- [ ] **Riverpod** : Pourquoi on l'utilise ? (Partager l'état entre widgets)
- [ ] **go_router** : Comment on navigue ? (context.go('/profile/1'))
- [ ] **Clean Architecture** : Les 3 couches ? (Presentation / Domain / Data)
- [ ] **Dio** : Pourquoi pas http ? (Intercepteurs, retry, etc.)
- [ ] **Hive** : Stratégie cache-first ? (Cache d'abord, puis API)
- [ ] **get_it** : À quoi ça sert ? (Service locator pour DI)

---

## 🚀 **Prochaine étape**

Maintenant qu'on a compris les concepts, on passe à la pratique :
- **SDK-1** : Créer le projet Flutter Module
- **SDK-2** : Mettre en place l'architecture

**Prêt à coder ? On y va ! 💪**
