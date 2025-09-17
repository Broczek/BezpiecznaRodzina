import 'package:dio/dio.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

const String GOOGLE_MAPS_API_KEY = 'GOOGLE_MAPS_API_KEY';

// A simple model for place suggestions from the Google Places Autocomplete API.
class PlaceSuggestion {
  final String description;
  final String placeId;

  PlaceSuggestion(this.description, this.placeId);
}

// This service provides methods to interact with Google Maps APIs,
// specifically for place autocomplete, place details (to get coordinates),
// and reverse geocoding (to get an address from coordinates).
class PlacesService {
  final Dio _dio = Dio();

  PlacesService() {
    _dio.options.responseType = ResponseType.json;
  }

  // Fetches address suggestions based on user input.
  Future<List<PlaceSuggestion>> getAutocomplete(String input, String sessionToken) async {
    if (input.isEmpty || GOOGLE_MAPS_API_KEY.contains('YOUR_API_KEY')) {
      return [];
    }

    final url =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&key=$GOOGLE_MAPS_API_KEY&sessiontoken=$sessionToken&language=pl&components=country:pl';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        final predictions = response.data['predictions'] as List;
        return predictions
            .map((p) => PlaceSuggestion(p['description'], p['place_id']))
            .toList();
      }
      return [];
    } catch (e) {
      print('Place Autocomplete Error: $e');
      return [];
    }
  }

  // Fetches the geographic coordinates (LatLng) for a given place ID.
  Future<LatLng?> getPlaceDetails(String placeId, String sessionToken) async {
     if (GOOGLE_MAPS_API_KEY.contains('YOUR_API_KEY')) return null;

    final url =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$GOOGLE_MAPS_API_KEY&sessiontoken=$sessionToken&fields=geometry';
    
    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data['result'] != null) {
        final location = response.data['result']['geometry']['location'];
        return LatLng(location['lat'], location['lng']);
      }
      return null;
    } catch (e) {
      print('Get Place Details Error: $e');
      return null;
    }
  }

  // Converts geographic coordinates (LatLng) into a human-readable address.
  Future<String> getReverseGeocode(LatLng location) async {
    if (GOOGLE_MAPS_API_KEY.contains('YOUR_API_KEY')) {
       return 'Coords: ${location.latitude.toStringAsFixed(4)}, ${location.longitude.toStringAsFixed(4)}';
    }

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${location.latitude},${location.longitude}&key=$GOOGLE_MAPS_API_KEY&language=pl';
    
     try {
      final response = await _dio.get(url);
      if (response.statusCode == 200 && response.data['results'].isNotEmpty) {
        return response.data['results'][0]['formatted_address'];
      }
      return 'Address not found';
    } catch (e) {
      print('Reverse Geocoding Error: $e');
      return 'Error fetching address';
    }
  }
}
