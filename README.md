# Town_sim
This is a geography project. It's a simulation of life in an entire city district: cars will be driving around, and people will be commuting to work. Just like in real life!
/
Это проект по географии. Симуляция жизни большого города! Здесь будут ездить машины, и ходить пешеходы на работу в определенное время!

# How to use

If you are interested in my graph tool, here is a detailed guide:
  1. Add a 'RoadNetworkManager' node to the scene tree.
  2. **IMPORTANT**: IF YOU WANT VEHICLES TO SEE THE 'RoadNetworkManager', **CREATE A GROUP CALLED** 'RoadManager' AND ADD IT TO THE 'RoadNetworkManager'.
  3. Please do not create a Travel Point manually; **use the 'Create new point' button instead. You can delete them using the button to the right of the resource**.
  4. The 'TravelPoint' resource has another array of Next 'Points', so that the car can move along the edges between them, it is worth adding 'TravelPoint' INDICES to this array.

**PLEASE NOTE:** The visual representation of created 'TravelPoints' only updates when they are moved!
