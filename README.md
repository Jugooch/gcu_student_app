# Grand Canyon University Student App

## Justice Gooch - Senior Capstone

This Application is a redesign of Grand Canyon University's (GCU's) mobile student application. The point of this redesign was to condense the amount of applications that GCU students have to download. As of right now, students download upwards of 8 to 9 applications to do various GCU-related tasks; this app shrinks that down to 1. It utilizes Flutter as a frontend framework to support use across different platforms and is designed based on an entire UI/UX case study done on current GCU students.

## UI/UX CASE STUDY

A full view of the UI/UX case study can be found at this Behance link.

[Behance - UI/UX Case Study](https://www.behance.net/gallery/185136569/University-Student-Application-Redesign)

## FLUTTER WIDGET DESIGN

This link takes you to a Figma file where you can find all of the pseudo-code for the different widgets that are planned to be designed in the application.

[Figma - Flutter Widget Design](https://www.figma.com/embed?embed_host=share&url=https%3A%2F%2Fwww.figma.com%2Ffile%2FZX7LZ0xPp1psXrG9TccpJt%2FCapstone-Design%3Ftype%3Ddesign%26node-id%3D611%253A7212%26mode%3Ddesign%26t%3DkjKhB2gBMqDKY7rw-1)

## SITEMAP

![image](https://github.com/Jugooch/gcu_student_app/assets/97257742/04be9dac-7bf1-412b-9641-77da1245849c)

## LOGICAL SOLUTION DIAGRAM

The logical solution design depicts the high-level software architecture and interactions in the Flutter application, which relies on frontend Flutter code in pages, services to connect the pages to the data, and mock data. Arrows denote the interaction between the User Interface which speak to the related service to access the Local Data, highlighting that the app's frontend interacts with the mock data. This design provides an abstract overview of the software components and their interactions within the Flutter app, emphasizing its self-contained nature without the need for an outside API or true backend.

![image](https://github.com/Jugooch/gcu_student_app/assets/97257742/11305c49-720b-4340-b786-f2b7f1d8861d)

## PHYSICAL SOLUTION DIAGRAM

The physical solution design illustrates the practical setup for developing and running a Flutter application on your laptop. In the diagram is your "Local Development Environment," representing your laptop. On the laptop's screen, you have an "Android Emulator," symbolizing the virtual Android device in which your Flutter app will run as well as the recommended hardware specifications. The "Flutter SDK and IDE" and “Android Studio” components are crucial for app development as they are how the app is being built and shown on the emulator. To provide clarity, arrows indicate the flow of code from the IDE and Android Studio to the emulator. This design emphasizes the physical components required for local development and testing.

![image](https://github.com/Jugooch/gcu_student_app/assets/97257742/edfcf0c5-3f21-425b-a88b-18eaa5493f3c)

## GENERAL TECHNICAL APPROACH

### Design Approach:
I used a design process for this project that is very similar to the waterfall model. The project's strict deadlines and the requirement to fulfill particular criteria in a constrained amount of time were the main factors that influenced the decision to choose a sequential and structured approach. The waterfall model's distinct and sequential phases made it possible for me to work my way through the project. Every stage of the project — from requirements analysis to implementation and testing — was carried out to guarantee that the goals would be achieved on schedule. Although agile approaches are flexible and adaptive, the particulars of this project made the waterfall approach more appropriate. This allowed me to effectively prioritize and meet the project's requirements.

### Analyzing the Problem:
The issue I set out to solve was one that all GCU students encountered on a daily basis. It is common for students to have to download and use several applications, each of which is designed to support a particular feature or service offered by the university. In addition to being inconvenient, this disjointed method of obtaining different services results in lower usage rates for the features offered by GCU's official app. 

My objective was to improve each student's experience with their student app by combining different services and functionalities into one all-inclusive application. By doing this, I hoped to make it easier for students to manage their academic and campus lives by streamlining access to important information and services. The project also aimed to increase the usage rates of these features on the official GCU app, transforming it into a one-stop shop for all of their requirements. The goal of this strategy was to improve the general standard of living for students while offering an effective, user-friendly, and all-inclusive resource that satisfies the various needs of the university's student body.

### UX-focused design:
I was really focused on developing a user-centered design when I started this project. Applications should, in my opinion, be fun and simple to use, especially those that people must use on a daily basis. Why would someone find a dislike for an app that is so necessary to their everyday existence on campus? In order to solve this, improving the application's everyday usability and user experience for its users informed a lot of my design choices.

The following important ideas were given top priority in keeping with this mindset:
* Easy Navigation: I made the app's navigation structure as user-friendly and intuitive as possible. It should be simple for users to access the features and services they require. This comprised uncomplicated menus, uncomplicated paths, and a well-organized layout.
* Consistency: To make the app feel familiar and cozy to use, I kept the user interface consistent throughout. Students could anticipate a unified and unified design whether they were using social features, campus news, or academic resources.
*	User input: I took into account user input at every stage of the design process, making adjustments to the interface in response to their recommendations and preferences. In order to tailor the design to the unique requirements and expectations of the GCU student body, user input was extremely important.
*	Efficiency: In order to save users time and effort, I concentrated on optimizing the app's internal processes. The app's design sought to improve students' daily experiences by removing pointless steps and lowering friction when gaining access to features.
*	Engagement and Pleasure: The application's design incorporated components that aimed to enhance users' engagement and pleasure. To create a positive and enjoyable user experience, features like interactive elements, personalized content, and an aesthetically pleasing interface were combined.

## HARDWARE AND SOFTWARE TECHNOLOGIES
1. Flutter (v. 1.12)
2. Figma (v. 107.0.0)
3. Visual Studio Code (v. 1.80.1)
4. Android Studio (v. 2022.3.1)
5. Dart (v. 3.1)

## LOCALIZATION

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.
