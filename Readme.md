# ReplaceByJPathFunction

Script permetant de modifier les valeurs d'un json à l'intérieur d'un fichier.

## Utilisation

### Exemple 1

1. Préparer un json de replacement

Un json de replacement indiquera le chemin des valeurs a remplacer ainsi que les valeurs même.

Les clés seront le path et la valeur, la valeur à remplacer.

```
'{"Tags.Confidence":1.0,"RequestId":"0000-0000-0000"}'
```

2. Lancer le script

Les arguments dans l'ordre sont :
1. le chemin du fichier contenant le json
2. le json de remplacement
3. le fichier de sortie ou sera sauvegarder le résultat.

```
.\replaceByJPathFunction.ps1 .\exemple1-input.json '{"Tags.Confidence":1.0,"RequestId":"0000-0000-0000"}' .\exemple1-output.json
```

3. (Optionel) Comparer les résultats

Dans VSCode ou un autre outils, comparer les résultats.

### Exemple 2

Json avec un tableau à la racine

1. Préparer et lancer la commande

```
.\replaceByJPathFunction.ps1 .\exemple2-input.json '{"donnees.d": "2021"}' .\exemple2-output.json
```

2. (optionnel) Comparer les résultat

### Exemple 3

Modifier les id d'un tableau a plusieurs dimmesion.

1. Préparer et lancer la commande

```
.\replaceByJPathFunction.ps1 .\exemple3-input.json "{'capteurs.donnees.id': '000-000-000' }" .\exemple3-output.json
```

2. (optionnel) Comparer les résultat

## Obtenir de l'aide

```
Get-Help -detailed .\replaceByJPathFunction.ps1
```

## Ne pas journaliser en console

Utiliser la fonction Out-Null de powershell

Exemple :
```
.\replaceByJPathFunction.ps1 .\fichier-input.json '{"propriete": 123}' .\fichier-output.json | Out-Null
```

## Notes :

Ici Write-Output n'a pas été utiliser car un saut de ligne s'ajoutait à la fin
ce qui créait des différences à la comparaison entre le fichier input et output

Dans le cas ou un saut de ligne serait désiré, le script pourrait être modifier
Write-Output $outputContent
et lors de l'appel au script au lieu d'avoir deux argument, on pourrait utiliser
l'operateur de redirection de la sortie standard >
```
.\replaceByJPathFunction.ps1 .\exemple1-input.json > .\exemple1-output.json
```

## Todo

- Améliorer les validations des paramètres d'entrés
- Améliorer le menu et d'aide
- Ajout de test automatisé à partire des exemples dans le repo

## Powershell version

```
>>> $PSVersionTable.PSVersion

Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      19041  906
```
