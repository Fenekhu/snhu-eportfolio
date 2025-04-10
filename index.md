---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: default
title: "SNHU ePortfolio"
---

# SNHU ePortfolio

> The GitHub repository for this project is at **[Fenekhu/gr-miniplayer](https://github.com/Fenekhu/gr-miniplayer)** if you would like to try the player or view the project.  

For this project, I created a compact desktop player for an internet radio station I listen to often. This was a project I had attempted in the past, but failed for a number of reasons. In this project I was able to complete the project, learn a lot a long the way, and meet both personal and educational goals.

- Personal Goals:
  - Finish a project
  - Develop a cross-platform desktop app
  - Make something useful
  - Have a clean, well-architected, well-organized, well-documented code base
- Educational Goals (Course Outcomes):
  - Employ strategies for building collaborative environments that enable diverse audiences to support organizational decision making in the field of computer science
  - Design, develop, and deliver professional-quality oral, written, and visual communications that are coherent, technically sound, and appropriately adapted to specific audiences and contexts
  - Design and evaluate computing solutions that solve a given problem using algorithmic principles and computer science practices and standards appropriate to its solution, while managing the trade-offs involved in design choices
  - Demonstrate an ability to use well-founded and innovative techniques, skills, and tools in computing practices for the purpose of implementing computer solutions that deliver value and accomplish industry-specific goals
  - Develop a security mindset that anticipates adversarial exploits in software architecture and designs to expose potential vulnerabilities, mitigate design flaws, and ensure privacy and enhanced security of data and resources

\<Professional self-assessment goes here\>

## Background

I often listen to an internet radio station - Gensokyo Radio - through [their website](https://app.gensokyoradio.net). I like my music player to take up as little space on my second screen as possible. As nice as their web app is, it doesn't scale down well, and a lot of extra space is required by the browser window. I wanted to make something more compact that could be used by others on any desktop platform. After researching a variety of options, I settled on Flutter, an app development framework by Google, due to its ability to compile directly to native code, low overhead, thorough documentation, and healthy package ecosystem. I also contacted the station owner to confirm that it would be okay to do this project, which it was (given a few guidelines I was able to easily follow).  

Unfortunately, I didn't get very far. I made a prototype UI with an audio player that would play a default UK-based broadcast, but never connected it to Gensokyo Radio in any way. Although I had spent a fair bit of time learning Dart, Flutter, and a number of libraries I planned to use, I jumped straight into coding. With the project not even half finished, progress became impossible due to high-level disorganization, with no underlying structure, architecture, or patterns. It wasn't something that could be fixed with a few refactorings, I needed to restart from scratch, building structure in from the very beginning.  

<img src="assets/prototype-ui.png" width="246" alt="The prototype UI from the initial project">  

*The prototype UI from the initial project.*

## Week One: Planning

To start planning properly from the beginning, I drafted an initial list of features I wanted in my player app. This initial set of business and technical features would end up changing over the course of the project, such as by adding integration with OS media controls, discord rich presence, and a history list.  

- An audio player and audio player controls.
- Connecting to a websocket to receive live song information.
- Connecting an audio player to a chunked HTTP stream source.
- Use the station's REST API for user login sessions.
  - To submit song ratings and save songs to favorites.
  - For access to the paywalled high-quality audio stream.
- A way to blur a specific album's art now and in the future (some art on the station makes me uncomfortable).
- Cross-platform code, tools, and compilation to be natively usable by Windows, Mac, and Linux users (ie, no wine/emulation necessary).
- Start with architecture and design first, before I begin coding, to prevent running into the same issues.

The first place I went to give my application some structure was the Flutter documentation, which had an architecture guide that I had previously skipped. The guide detailed the Model View ViewModel (MVVM) architecture pattern, which Flutter is particularly well suited to. Though I was aware of Model View Controller (MVC) architecture, I lacked a practical understanding of its implementation. On the other hand, this diagram from the documentation, combined with a number of communication and relationship 'rules' between layers and components, made the idea of MVVM architecture click for me.  

[![An example of the Dart objects that might exist in one feature using the architecture described on page.](assets/flutter-mvvm.png)](https://docs.flutter.dev/app-architecture/guide#mvvm)

With this as a base, I came up with a list of 40-ish elements across the different layers to reach all the features I had planned for the app. I turned this list into a flowchart similar to the one above, illustrating the location of each component within the architecture, as well as the flow of communications between them. I modified the diagram frequently throughout development, so unfortunately I don't have this initial version anymore.

## Week Two: Reviewing My Previous Project

If the embed above doesn't work: [my code review (YouTube)](https://youtu.be/7H-Mbs2Q4rk?si=o7l9j7XTFrZjRMr8). The code files from the initial project are available [here](assets/initial-project-code/).

While what little functionality there was within my previous project was junk, I knew a fair amount of the UI would be salvagable. It would need tweaking to handle the new patterns of communication I planned to handle application state with, such as streams and dependency injection. Some UI components were so intertwined with the functionality and state that they had to becompletely rewritten.  

In addition to salvaging code, I also wanted to identify bad practices, inconsistent style, and other issues within my usage of Dart and Flutter, to avoid similar mistakes and keep my new project clean. For example, there are roughly zero code comments in my original project, but the new project is almost fully documented where the code isn't self-documenting (which I try to do as much as possible).

Another example of something that was cleanly rewritten is in [`stream_endpoint.dart`](assets/initial-project-code/stream_endpoint.dart):

*For background, the radio stream is available at four different qualities, all with different URLs. In the initial project, I was just using test endpoints instead of the actual stream. If I accidentally made a mistake that spammed the url with requests, I wouldn't want to get my IP blacklisted from the station I often listen to.*

```dart
class StreamEndpoint {
  final String name;
  final String url;
  const StreamEndpoint({required this.name, required this.url});

  // toString, equality, and hash operators omitted

  static const List<StreamEndpoint> list = [
    StreamEndpoint(name:   "Mobile (64k Opus)", url: "http://localhost:8000/stream"),
    StreamEndpoint(name: "Standard (128k mp3)", url: "http://localhost:8000/stream"),
    StreamEndpoint(name:     "High (256k mp3)", url: "https://stream-uk1.radioparadise.com/aac-320"),
    StreamEndpoint(name:     "Lossless (FLAC)", url: "https://stream-uk1.radioparadise.com/aac-320"),
  ];
}
```

The class here clearly represents an enumerated set of constant objects, but for some reason I didn't make this an enum. This was easily refactored into a more sensible [Dart enum in the final project](https://github.com/Fenekhu/gr-miniplayer/blob/main/lib/util/enum/stream_endpoint.dart):

```dart
// yes, 2 and 1 are backwards like that, because historically there was only one endpoint (Standard /1/).
enum StreamEndpoint {
    mobile(value: '2', name: 'Mobile',   desc: '64k Opus'),
  standard(value: '1', name: 'Standard', desc: '128k mp3'),
      high(value: '3', name: 'High',     desc: '256k mp3'),
  lossless(value: '4', name: 'Lossless', desc: 'FLAC'    ),
  ;

  final String value;
  final String name;
  final String desc;

  Uri get uri => Uri.parse('https://stream.gensokyoradio.net/$value/');

  const StreamEndpoint({required this.value, required this.name, required this.desc});

  static StreamEndpoint fromValue(String value) => switch (value) {
    '2' => StreamEndpoint.mobile,
    '1' => StreamEndpoint.standard,
    '3' => StreamEndpoint.high,
    '4' => StreamEndpoint.lossless,
     _  => StreamEndpoint.standard,
  };
}
```
