# Grand Canyon University Student App

## Justice Gooch - Senior Capstone

This Application is a redesign of Grand Canyon University's (GCU's) mobile student application. The point of this redesign was to condense the amount of applications that GCU students have to download. As of right now, students download upwards of 8 to 9 applications to do various GCU-related tasks; this app shrinks that down to 1. The problem's students had with downloading so many apps is the amount of space it took up on their device, and the poor user experience that was related to moving between multiple applications just to do small everyday tasks. This app reduces the amount of space taken up, and also improves that user experience by keeping everything important for every-day life in one location. It utilizes Flutter as a frontend framework to support use across different platforms and is designed based on an entire UI/UX case study done on current GCU students.

## UI/UX CASE STUDY

A full view of the UI/UX case study can be found at this Behance link.

[Behance - UI/UX Case Study](https://www.behance.net/gallery/185136569/University-Student-Application-Redesign)

## Functional and non-Functional Requirements
<details open>
  <summary>Functional Requirements</summary>


  <ul>
    <li><details>
    <summary>Home Page Requirements</summary>
      <ul>
        <li>As a user, I would like to see my student ID first when opening the app so my app's usability is improved.</li>
        <li>As a user, I would like to customize what's on my home page so my most used features are available right away.</li>
      </ul>
    </details></li></ul>
   <ul>
    <li><details>
    <summary>Events Page Requirements</summary>
    <ul>
      <li>As a user, I would like to be able to view campus news so that I can keep up to date with campus news.</li>
      <li>As a user, I would like to view campus events so that I can keep up to date with events.</li>
      <li>As a user, I would like to see a full calender of things happening on campus so that i can look and plan ahead.</li>
      <li>As a user, I would like to to be able to get student tickets so I don't have to download another application.</li>  
      <li>As an admin, I would like to update the news section so that everythng is up to date.</li>
      <li>As an admin, I would like to add events to the page and calender so I can get more people to attend.</li>
      <li>As an admin, I would like to remove an event so that unneeded events are not shown.</li>
    </ul>
  </details></li></ul>
 <ul>
    <li><details>
  <summary>Community Page Requirements</summary>
  <ul>
    <li>As a User, I would like to access and manage intramural teams so that I do not have to download multiple apps.</li>
    <li>As a User, I would like to leave an intramural team so that I can join a different team.</li>
    <li>As a User, I would like to join an intramural team so that I can participate in games.</li>
    <li>As a User, I would like to see my next Intramural game details so that I can be on time for my game.</li>
    <li>As a User, I would like to see a market for student businesses so that I can easily market my business and buy from others.</li>
    <li>As a User, I would like to access clubs/groups on campus so that I can get involved on campus more easily.</li>
    <li>As an Admin, I would like to change featured businesses in the market so that users can be introduced to more businesses.</li>
    <li>As a System, I would like to be able to filter clubs/market posts so that all content aligns with university guidelines.</li>
    <li>As a User, I would like to be able to add my own student business so that I can sell stuff on the student market.</li>
    <li>As a User, I would like to be able to delete my student business so that my inactive business doesn't stay up.</li>
    <li>As a User, I would like to be able to create a product to display on my business so that I can get more products on my page.</li>
    <li>As a User, I would like to be able to remove a product from my page so that sold objects don't stay on my page.</li>
    <li>As a System, I would like to filter out submissions for businesses/products/clubs that go against university policy so that less manual approvals have to happen.</li>
    <li>As a System, I would like to validate user entries in the submission forms so that users can only input valid data.</li>
    <li>As a User, I would like to join a club so that I can get involved on campus.</li>
    <li>As a User, I would like to leave a club so that I can not be a part of a club I don't want to.</li>
    <li>As a User, I would like to create a club so that I can get more members to join.</li>
    <li>As a User, I would like to delete my club so that the club can be shut down.</li>
  </ul>
</details></li></ul>
 <ul>
    <li><details>
  <summary>Profile Page Requirements</summary>
  <ul>
    <li>As a User, I would like to access student info (ID #, Counselor, etc…) so that I can access this info when needed.</li>
    <li>As a User, I would like to access all elements not in my home menu so that I can still use features that I don't need all the time.</li>
  </ul>
</details></li></ul>
 <ul>
    <li><details>
  <summary>Shared Page Requirements</summary>
  <ul>
    <li>As a User, I would like to see all the scheduled chapels and the ones I checked into so that I can track my chapel attendance.</li>
    <li>As a User, I would like a link to my student portal so that I can save time accessing it.</li>
    <li>As a User, I would like to see all my campus budgeting (Dining dollars, etc…) so that I can track my budget.</li>
    <li>As a User, I would like to see my class schedule so that I can see my current class times and places.</li>
    <li>As a User, I would like to be able to check into events with a QR scanner so that I don't have to download another app.</li>
    <li>As a User, I want to access hours of when places on campus are open/closed so that I can know whether a place is open/closed.</li>
    <li>As a User, I want to access settings like theming so that I can personalize my application.</li>
    <li>As a User, I want to access a campus map so I can find my classes and other buildings.</li>
  </ul>
</details></li></ul>

</details>

<details>
  <summary>Non-Functional Requirements</summary>
<ul>
    <li>
  <details>
    <summary>Usability Enhancement</summary>
    <ul>
      <li>As a user, I would like the app to have an intuitive user interface with clear navigation and ease of use of different platforms so that I can easily find and use the features I need on all my mobile devices.</li>
    </ul>
  </details></li></ul>
</details>

## OUT OF SCOPE FEATURES
1. Integration with Halo - GCU Learning Management System
2. Admin Website for updating/adding News Articles
3. Admin Website for editing Intramurals information (scores, brackets, etc...)
4. Admin website for featuring specific businesses on the student market

## HARDWARE AND SOFTWARE TECHNOLOGIES
1. Flutter (v. 1.12) - Flutter was chosen because it allows for efficient cross-platform development. This allows me to develop the app to work on as many devices as possible, which is important since this app is created to be used by university students.
2. Figma (v. 107.0.0) - Figma was chosen because it is the industry standard for UI/UX design and has any features that allow for a clean transition from design to development (like dev-mode and variables!).
3. Visual Studio Code (v. 1.80.1) - Vidual Studio Code was the chosen IDE because its extensions feature gives access to an in-depth integration with Flutter. This extension allows development to be done all from one place, streamlining the process.
4. Android Studio (v. 2022.3.1) - Android Studio allows the use of emulators on my laptop. This is important to development because it gives a proper simulation of using the app on a real device, and gives access to native features that would otherwise be unaccessible.
5. Dart (v. 3.1) - Dart is the underlying language that Flutter relies on. Because of this, Dart was used to leverage the features that Flutter provides.

## LEARNING TECHNOLOGIES
In the process of developing the Grand Canyon University mobile application redesign, I chose to delve into new technologies that were very important in completing this project. Flutter and Dart were the cornerstones of my development process, and I had never touched these before working on this project. Learning these technologies not only enhanced my skill set but also significantly contributed to the app's performance, design flexibility, and cross-platform compatibility. Below, I detail my experience and insights into working with Flutter and Dart.

### Flutter:
Flutter is Google's UI toolkit for crafting natively compiled applications for mobile, web, and desktop from a single codebase. My decision to learn and use Flutter for this project was driven by its ability to deliver efficient cross-platform applications. Flutter's set of pre-designed widgets and its reactive framework simplified the process of creating a visually appealing and responsive user interface for the GCU app. Moreover, the ability to customize and extend these widgets allowed me to tailor the app's design to meet the specific needs and preferences identified in the UI/UX case study. Flutter's hot reload feature also enabled rapid iteration and instant feedback during development, which significantly sped up the app's build and test cycles.

### Dart:
Dart is a client-optimized language for fast apps on any platform, serving as the programming language for Flutter. Learning Dart was instrumental in understanding how to architect and implement the functionality of the GCU app efficiently because Flutter is built on it. Its features, such as providers/notifiers, rich core libraries, and a strong typing system, provided a strong foundation for building such a complex application. Dart's syntax and language features, including futures and streams for handling asynchronous tasks, were critical in developing a seamless and interactive user experience. Working with Dart not only improved my programming skills but also my understanding of functional and reactive programming.

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

## LOCALIZATION

This project generates localized messages based on arb files found in
the `lib/src/localization` directory.
