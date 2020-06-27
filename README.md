# Hackerrank_vanhack

I've created this repository to save for future use and catalog my solutions for the Vanhack proficiency test @ Hacker rank.

The test has 7 days duration, in which I must solve 4 problems using algorithms.

## 1º test - Race car

### Problem description:
Chris is playing the "Racing Car" arcade game. In this game, Chris is controlling a car which can move sideways
but the car keeps moving forward at all times. Chris can move the car into any lane at any moment. There are some
obstacles on the track and no two obstacles share the same position on the track.
There are lanes in the game and Chris starts the game from the middle lane.

Determine the minimum sideways movement needed in order to complete the game. Note that a movement at one moment, be
it from lane *1 to lane 2* and from lane *1 to lane 3* is counted as a single movement.

### Solution
[Go to solution file clicking her](solution_1_race_car.rb)

I've decided to use an **Dijkstra** like approach, It's almost a perfect fine Dijkstra algorithm with some modifications to fit the proposed problem.
