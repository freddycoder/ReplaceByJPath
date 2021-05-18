# ReplaceByJPathFunction

Script permetant de modifier les valeurs d'un json à l'intérieur d'un fichier.

# Utilisation

1. Dans le script, a la section suivante, adapteur la logique pour votre scénario de remplacement.

```
# Modifier certaines valeurs
foreach ($tag in $json.Tags) {
    $tag.Confidence = 1.0
}
```

2. Lancer le script

```
.\replaceByJPathFunction.ps1 .\exemple1-input.json .\exemple1-output.json
```

3. (Optionel) Comparer les résultats

Dans VSCode ou un autre outils, comparer les résultats.

# Notes :

Ici Write-Output n'a pas été utiliser car un saut de ligne s'ajoutait à la fin
ce qui créait des différences à la comparaison entre le fichier input et output

Dans le cas ou un saut de ligne serait désiré, le script pourrait être modifier
Write-Output $outputContent
et lors de l'appel au script au lieu d'avoir deux argument, on pourrait utiliser
l'operateur de redirection de la sortie standard >
```
.\replaceByJPathFunction.ps1 .\exemple1-input.json > .\exemple1-output.json
```

# Todo

- Ajouter une liste de JPath en paramètre
- Ajouter une liste de valeur pour chaque JPath en paramètre
- Ajouter un menu et de l'aide

# Powershell version

```
>>> $PSVersionTable.PSVersion

Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      19041  906
```