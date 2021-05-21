# ReplaceByJPath

Script permettant de modifier les valeurs d'un JSON ou d'un XML à l'intérieur d'un fichier.

## Utilisation

### Exemple 1

1. Préparer un JSON de replacement

Un JSON de replacement indiquera le chemin des valeurs à remplacer ainsi que les valeurs même.

Les clés seront le path et la valeur, la valeur à remplacer.

```
'{"Tags.Confidence":1.0,"RequestId":"0000-0000-0000"}'
```

2. Lancer le script

Les arguments dans l'ordre sont :
1. le chemin du fichier contenant le JSON
2. le JSON de remplacement
3. le fichier de sortie ou sera sauvegardé le résultat.

```
.\replaceByJPath.ps1 .\exemples\input1.json '{"Tags.Confidence":1.0,"RequestId":"0000-0000-0000"}' .\exemples\output1.json
```

3. (Optionel) Comparer les résultats

Dans VSCode ou un autre outil, comparer les résultats.

### Exemple 2

Json avec un tableau à la racine

1. Préparer et lancer la commande

```
.\replaceByJPath.ps1 .\exemples\input2.json '{"donnees.d": "2021"}' .\exemples\output2.json
```

2. (optionnel) Comparer les résultats

### Exemple 3

Modifier les id d'un tableau a plusieurs dimensions.

1. Préparer et lancer la commande

```
.\replaceByJPath.ps1 .\exemples\input3.json "{'capteurs.donnees.id': '000-000-000' }" .\exemples\output3.json
```

2. (optionnel) Comparer les résultats

### Exemple 4 et 5

Modifier un fichier XML.

L'exemple 4 n'utilise pas les namespaces, alors que l'exemple 5 utilise un namespace par défaut.

1. Préparer et lancer la commande
```
.\replaceByJPath.ps1 .\exemples\input4.xml "{'/submission/group/@attr1': 'some other text', '/submission/group/item': 'z'}" .\exemples\output4.xml
```

2. (optionnel) Comparer les résultats

## Obtenir de l'aide

```
Get-Help -detailed .\replaceByJPath.ps1
```

## Ne pas journaliser en console

Utiliser la fonction Out-Null de powershell

Exemple :
```
.\replaceByJPath.ps1 .\exemples\input1.json '{"Tags.Confidence":1.0,"RequestId":"0000-0000-0000"}' .\exemples\output1.json | Out-Null
```

## Executer les tests

Pour lancer les tests, se positionner à la racine du repo et exécuter :

```
.\tests\replaceByJPathTest.ps1
```

## Ajouter un test

Pour ajouter un test, il faut :
1. Ajouter le fichier input dans le dossier exemple et le résultat attendu en remplaçant le préfix input par output.
2. Modifier l'expression switch dans la fonction JsonReplacement du fichier .\tests\replaceByJPath.Test.ps1

## Todo

- Améliorer les validations des paramètres d'entrées
- Améliorer le menu et d'aide

## Powershell version

```
>>> $PSVersionTable.PSVersion

Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      19041  906
```
