class StreamEndpoint {
  final String name;
  final String url;
  const StreamEndpoint({required this.name, required this.url});

  @override
  String toString() {
    return "{name: $name, url: $url}";
  }

  @override
  bool operator ==(Object other) {
    return other is StreamEndpoint && name == other.name && url == other.url;
  }
  
  @override
  int get hashCode => Object.hash(name, url);

  static const List<StreamEndpoint> list = [
    StreamEndpoint(name:   "Mobile (64k Opus)", url: "http://localhost:8000/stream"),
    StreamEndpoint(name: "Standard (128k mp3)", url: "http://localhost:8000/stream"),
    StreamEndpoint(name:     "High (256k mp3)", url: "https://stream-uk1.radioparadise.com/aac-320"),
    StreamEndpoint(name:     "Lossless (FLAC)", url: "https://stream-uk1.radioparadise.com/aac-320"),
  ];
  
}
