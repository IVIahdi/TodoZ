import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:listify/src/application/Theme_Provider.dart';
import 'package:listify/src/data/projects.dart';

void main() {
  group('Project and Task Tests', () {
    test('Creating a new Task', () {
      var task = Task(creatorName: 'Test User', taskName: 'Test Task');
      expect(task.creatorName, 'Test User');
      expect(task.taskName, 'Test Task');
    });

    test('Creating a new Project', () {
      var task = Task(creatorName: 'Test User', taskName: 'Test Task');
      var project = Project(projectName: 'Test Project', tasksList: [task]);
      expect(project.projectName, 'Test Project');
      expect(project.tasksList.length, 1);
    });
  });

  group('ThemeProvider Tests', () {
    test('Initial theme is light', () {
      ThemeProvider themeProvider = ThemeProvider();
      expect(themeProvider.isDarkMode, isFalse);
      expect(themeProvider.themeData, ThemeData.light());
    });

    test('Toggle theme changes to dark', () {
      ThemeProvider themeProvider = ThemeProvider();
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, isTrue);
      expect(themeProvider.themeData, ThemeData.dark());
    });

    test('Toggle theme twice reverts to light', () {
      ThemeProvider themeProvider = ThemeProvider();
      themeProvider.toggleTheme(); // First toggle to dark
      themeProvider.toggleTheme(); // Second toggle back to light
      expect(themeProvider.isDarkMode, isFalse);
      expect(themeProvider.themeData, ThemeData.light());
    });
  });
}
