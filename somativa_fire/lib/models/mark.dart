class Mark {
  final String id;
  final String userEmail;
  final DateTime timestamp;
  final double? latitude; // Novo campo para latitude
  final double? longitude; // Novo campo para longitude

  Mark({
    required this.id,
    required this.userEmail,
    required this.timestamp,
    this.latitude, // Tornei opcional, caso a localização não possa ser obtida
    this.longitude, // Tornei opcional, caso a localização não possa ser obtida
  });

  // Converter objeto em Map para salvar no Firestore
  Map<String, dynamic> toMap() {
    return {
      'userEmail': userEmail,
      'timestamp': timestamp,
      'latitude': latitude, // Adiciona a latitude
      'longitude': longitude, // Adiciona a longitude
    };
  }

  // Converter documento do Firestore em objeto Mark
  factory Mark.fromMap(String id, Map<String, dynamic> map) {
    // Tenta converter o timestamp (usando toDate() se for Timestamp do Firestore)
    DateTime parsedTimestamp;
    try {
      // Para o caso de ser um Timestamp do Firestore
      parsedTimestamp = (map['timestamp'] as dynamic).toDate();
    } catch (e) {
      // Para o caso de ser um DateTime que foi salvo diretamente (menos comum no Firestore)
      parsedTimestamp = map['timestamp'] as DateTime;
    }

    return Mark(
      id: id,
      userEmail: map['userEmail'] ?? '',
      timestamp: parsedTimestamp,
      // Tenta obter a latitude e longitude, usando 'null' se não existirem
      latitude: map['latitude'] as double?,
      longitude: map['longitude'] as double?,
    );
  }
}