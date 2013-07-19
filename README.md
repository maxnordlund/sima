## Description
A queuing application for the [Computer Science and Communications][1]
collage at the [Royal Institute of Technology][2] in [Stockholm, Sweden][3].

TaskIG stands for Tasks In Groups, here tasks are grouped by course.

### Ideas
Use courses as rooms from socket.io. Join course/room and receive events about that task list. Join multiple rooms no problem.
On desktop show top task for all joined courses, or all task for selected course only. Single click to join course, double click to select only that course.

On mobile show all task for selected course only.

```desktop
+--------+--------+
| DD1391 | Task 1 |
|        | Task 2 |
|        +--------+
| DD1341 | Task 3 |
|        | Task 4 |
| ...    |        |
+--------+--------+
```

```mobile
+--------+    +--------+
| DD1391 | -> | Task 1 |
| DD1341 |    | Task 2 |
| ...    |    |        |
+--------+    +--------+

+--------+    +--------+
| DD1391 |    | Task 3 |
| DD1341 | -> | Task 4 |
| ...    |    |        |
+--------+    +--------+
```

[1]: http://www.kth.se/csc/
[2]: http://www.kth.se/
[3]: http://maps.google.se/?q=Stockholm+Sweden
