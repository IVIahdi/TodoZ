# Todoz App

Todoz is a task management app that allows users to organize their tasks and collaborate on projects
efficiently.

## Table of Contents

1. [Introduction](#introduction)
2. [Features](#features)
3. [Project Structure](#project-structure)
4. [Getting Started](#getting-started)
5. [Sensitive data](#sensitive-data)
6. [Test Files](#Tests)
7. [Contributing](#contributing)

## Introduction

Todoz is a Flutter-based task management app developed as part of the SWE 463 Term Project at King
KFUPM.
This app helps users manage their tasks within specific projects, and facilitating collaboration.

## Features

- Create and manage projects
- Add tasks to projects
- Collaborate with team members on tasks
- Dark mode support

## Project Structure

The project follows a clean architecture,
with features organized under the `lib/features` directory.

The codebase includes widget tests.

## Getting Started

Follow these steps to get Todoz up and running on your local machine.

1. **Clone the repository:**
   ```
   bash
   
   git clone https://github.com/IVIahdi/TodoZ
   cd TodoZ
   ```
2. **Get dependencies**

```
   flutter pub get
```

3. **Run the App**

```
   flutter run
```

## sensitive-data

Todoz works on macos, ios, web, and android.

All sensitive data and configuration for the above platforms are stored inside firebase_options.dart
file

Mahdi Alabbadi -> Owner of the firebase credentials
Asem Kharma -> Main editor

## Tests
In test folder, a series of test cases and imports for our Todoz. It includes tests for various widgets, as well as integration tests for the complete app flow and user authentication. Additionally, the code contains mock classes for simulating user authentication and data.

## contributing

Mahdi Alabbadi significantly contributed to the Todoz project by designing a clean and organized project
architecture, integrating Firebase for user authentication and data storage, and developing a user-friendly
interface for task management. Asem was evident in implementing features such as project and task creation,
dynamic theme switching, and seamless navigation.
Mahdi also played a crucial role in collaborating with team members, addressing bug fixes, and ensuring a
smooth testing process. Asem greatly enhanced the overall functionality and user experience of the
Todoz app.

