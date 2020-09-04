# Implementation du protocole AOMDV sous NS2
Installation:

## Exécuter dans le bash

```bash
sudo apt-get install ns2

pip3 install tkinter
```

## Utilisation:

Exécutez tclpy dans un shell Linux pour obtenir la trace, la sortie du fichier de nom et la mesure des métriques de performance.

## Description

De nombreuses mesures de performance ont été développées et adoptées pour mesurer et évaluer les performances des réseaux MANET. Tous les processus de mesure des performances nécessitent l'utilisation d'une modélisation statistique pour estimer ces valeurs de paramètres 12. Dans cet article, six métriques d'évaluation ont été estimées et utilisées pour comparer et évaluer les effets et les comportements des paramètres et des variables MANET liés à la vitesse des nœuds et aux temps de pause des nœuds. Ces indicateurs de performance importants sont:

- Débit:
    Débit = paquets reçus / temps de simulation
- Paquets abandonnés:
    Paquets abandonnés = paquets envoyés(i) - paquets reçus (i)
-  Délai moyen de bout en bout (délai moyen E2E):
    Délai E2E[packet_id] = heure de réception [packet_id] - heure d'envoi [packet_id]
- Charge de routage Normalisée (NRL):
    NRL = nombre de paquets de routage / nombre de paquets reçus
- Pourcentage de livraison de paquets (PDR):
    PDR = (nombre de paquets reçus / nombre de paquets envoyés) * 100

## Environnement de Simulation

| Paramètre                 | Valeur                                    |
| ------------------------- | ----------------------------------------- |
| Nodes number              | 20                                        |
| Propagation Model         | Propagation/TwoRayGround                  |
| Antenna Model             | Antenna/OmniAntenna                       |
| Interface queue type      | Queue/DropTail/PriQueue                   |
| Mac Type                  | Mac/802_11                                |
| Topological Area          | 800 m X 800 m                             |
| Max Connection            | 5                                         |
| Node speed                | 10 m/s                                    |
| Pause Time                | 10 s                                      |
| Simulation Time           | 100 s                                     |
| Routing Protocol          | AOMDV                                     |
| Traffic type              | CBR                                       |
| Transport Protocol        | UDP                                       |
| CBR Traffic Parameters    | Interval: 0.1 s , Packet Size:512 Bytes   |
