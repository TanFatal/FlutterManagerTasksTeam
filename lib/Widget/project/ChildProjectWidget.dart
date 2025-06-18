// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:testflutter/models/ProjectModel.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/models/user.dart';
import 'package:testflutter/screen/ProjectScreen/DetailProjectScreen.dart';
import 'package:testflutter/services/projectService.dart';

class ChildProjectWidget extends StatelessWidget {
  final ProjectModel project;
  
  const ChildProjectWidget({super.key, required this.project});
  
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => DetailProjectScreen(project: project),
            ),
          );
        },
        child: Container(
          height: 110,
          width: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.blue, width: 1),
          
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 140,
                      child: Text(
                        project.projectName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    Text(
                      '${project.taskCount} Tasks',
                      style: const TextStyle(
                        color: Colors.grey, // Set the text color to grey
                        fontSize: 16, // Set text size
                      ),
                    )
                  ],
                ),
                if (UserSession.currentUser?.id == project.ownerId)
                  const Positioned(
                      top: 0,
                      right: 0,
                      child: Icon(Icons.star, size: 20, color: Colors.amber))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
