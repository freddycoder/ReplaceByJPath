# ReplaceByJPathFunction

Script permetant de modifier les valeurs d'un json à l'intérieur d'un fichier.

# Utilisation

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

# Obtenir de l'aide

```
Get-Help -detailed .\replaceByJPathFunction.ps1
```

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

- Rendre la solution plus générique, supporte seulement les tableaus a une dimession
- Améliorer les validations des paramètres d'entrés
- Améliorer le menu et d'aide

# Powershell version

```
>>> $PSVersionTable.PSVersion

Major  Minor  Build  Revision
-----  -----  -----  --------
5      1      19041  906
```