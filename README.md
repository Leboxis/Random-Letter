# Random Letter

Application iPhone (SwiftUI) pour tirer au sort une lettre du jeu du **petit bac** (baccalauréat).

- Appuie sur le bouton pour faire tourner la roulette et obtenir une lettre.
- Une lettre déjà tirée ne peut plus réapparaître.
- Utilise le bouton rond avec l’icône de chronomètre, en haut à gauche, pour choisir la durée de la manche.
- La roue de sélection du temps fournit un retour haptique léger ; le compte à rebours commence lorsque la lettre apparaît.
- Bouton **Réinitialiser** pour recommencer une nouvelle partie.
- Onglet **Lettres** : toutes les lettres déjà apparues et celles restantes.
- Onglet **À propos** : auteur et numéro de version.
- Design sobre mais fun, avec dégradés et animations.

## Fonctionnement

Le projet est compilé **uniquement via GitHub Actions** (pas besoin de Mac ni de Xcode) : chaque push sur `main` lance le workflow qui génère un projet Xcode avec XcodeGen, le compile en non signé et publie un fichier **.ipa** en artifact.

## Installer sur l'iPhone (PC Windows)

1. Sur GitHub, ouvre l'onglet **Actions** du dépôt.
2. Ouvre le run **Build iOS** le plus récent (déclenché par le push ou en cliquant sur *Run workflow*).
3. En bas, section **Artifacts** → télécharge `RandomLetter-ipa`.
4. Extrais le fichier `RandomLetter.ipa` (l'artifact est livré compressé en .zip).
5. Installe **Sideloadly** sur ton PC : https://sideloadly.io/
6. Branche ton iPhone, lance Sideloadly, glisse le `.ipa`, renseigne ton **Apple ID gratuit**.
7. Clique sur *Start* : l'app est installée sur l'iPhone.
   - L'app reste valable **7 jours** ; réinstalle-la ensuite (Sideloadly garde tes réglages).

> Apple ID obligatoire : sans compte développeur payant, un certificat gratuit expire au bout de 7 jours. C'est le fonctionnement normal du sideloading.

## Développement local

Le fichier `project.yml` permet de générer le projet Xcode avec XcodeGen :

```sh
xcodegen generate
open RandomLetter.xcodeproj
```

Structure :

```
RandomLetter/
├── RandomLetterApp.swift   # entrée de l'app
├── GameViewModel.swift     # logique (tirage, chrono, reset)
├── ContentView.swift       # barre d'onglets
├── RouletteView.swift      # roulette + boutons
├── TimerPickerView.swift   # roue de sélection du chrono
├── LettersView.swift       # lettres tirées / restantes
└── .github/workflows/build.yml  # build GitHub Actions
```
