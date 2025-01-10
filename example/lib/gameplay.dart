import 'shape_and_object_creators.dart';
import 'messages.g.dart';

// Define a class to hold both GUID and elapsed time for each segment
class SegmentData {
  String guid;
  double elapsedTime;

  SegmentData(this.guid, this.elapsedTime);
}

// List of segments that are currently in use
List<SegmentData> inUse = [];

// List of segments that are free (available to use)
List<SegmentData> free =
    List.from(radarSegmentPiecesGUIDS.map((guid) => SegmentData(guid, 0.0)));

void vDoOneWaveSegment(FilamentViewApi filamentView) {
  if (free.isNotEmpty) {
    SegmentData segmentData = free.removeAt(0); // Get a free segment
    segmentData.elapsedTime = 0;
    inUse.add(segmentData); // Add to in-use list

    // Set the position and scale for this segment
    vSetPositionAndScale(filamentView, segmentData.guid, 0.0, 0.0);

    // if you want a specific color; note the game models i checked in dont have
    // materials on them.
    // Map<String, dynamic> ourJson = poGetRandomColorMaterialParam().toJson();
    // filamentView.changeMaterialParameter(ourJson, segmentData.guid);

    // Debugging: Print the current state
    //print('vDoOneWaveSegment: Moved GUID to inUse: ${segmentData.guid}');
  } else {
    // print('No free wave segments available.');
  }
}

void vDo3RadarWaveSegments(FilamentViewApi filamentView) {
  for (int i = 0; i < 3; i++) {
    if (free.isNotEmpty) {
      SegmentData segmentData = free.removeAt(0); // Get a free segment
      segmentData.elapsedTime = -i * 0.3; // Set elapsed time for each segment

      inUse.add(segmentData); // Add to in-use list

      // Set the position and scale for this segment
      vSetPositionAndScale(filamentView, segmentData.guid, 0.0, 0.0);

      // Debugging: Print the current state
      //print('vDo3RadarWaveSegments: Moved GUID to inUse: ${segmentData.guid}');
    } else {
      // print('Not enough free segments available.');
      break;
    }
  }
}

void vUpdateGameplay(FilamentViewApi filamentView, double deltaTime) {
  // Process each segment in use
  for (int i = 0; i < inUse.length; i++) {
    SegmentData segment = inUse[i];

    // Update the elapsed time for the segment
    segment.elapsedTime += deltaTime;

    if (segment.elapsedTime > 2.5) {
      resetSegment(filamentView, segment.guid);
      continue;
    }

    // Example logic: scale and move the segment outward
    double scaleFactor = (segment.elapsedTime * 0.6); // Example scale factor

    // If it's < 0, we turn the scale all the way off (set to 0)
    if (segment.elapsedTime < 0) {
      scaleFactor = 0.0;
    }

    double moveDistance = segment.elapsedTime * 12; // Example movement distance

    // Apply the position and scale changes
    vSetPositionAndScale(filamentView, segment.guid, moveDistance, scaleFactor);

    // Debugging: Print the update
    // print('vUpdate: Moving segment ${segment.guid} to positionOffset: $moveDistance, scaleFactor: $scaleFactor');
  }
}

void vSetPositionAndScale(FilamentViewApi filamentView, String guid,
    double positionOffset, double scaleFactor) {
  // Placeholder function to set position and scale based on GUID
  // Add your custom logic for applying position and scale to the model
  //print("vSetPositionAndScale: $guid | positionOffset = $positionOffset, scaleFactor = $scaleFactor");

  filamentView.changeTranslationByGUID(guid, -42.2 - positionOffset, 1, 0);

  filamentView.changeScaleByGUID(
      guid, scaleFactor * 6, scaleFactor, scaleFactor);
}

void resetSegment(FilamentViewApi filamentView, String guid) {
  // Move the segment back to the free list once it's done
  SegmentData? segmentData = inUse.firstWhere((segment) => segment.guid == guid,
      orElse: () =>
          SegmentData(guid, 0.0) // Provide a default object instead of null
      );

  if (segmentData.guid == guid) {
    // Only proceed if we found a matching segment
    inUse.remove(segmentData);
    free.add(segmentData); // Add the segment back to the free list

    vSetPositionAndScale(filamentView, guid, 0, 0);

    //print('resetSegment: Moved $guid back to free list.');
  } else {
    //print('resetSegment: GUID $guid is not currently in use.');
  }
}
