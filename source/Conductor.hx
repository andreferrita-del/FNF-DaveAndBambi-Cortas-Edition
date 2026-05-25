package;

class Conductor
{
	public static var bpm:Float = 100;

	// Beat duration
	public static var crochet:Float = 0;

	// Step duration
	public static var stepCrochet:Float = 0;

	// Current song position
	public static var songPosition:Float = 0;

	// Last song position
	public static var lastSongPos:Float = 0;

	// Audio offset
	public static var offset:Float = 0;

	// Scroll speed
	public static var songSpeed:Float = 1;

	// Safe frames
	public static var safeFrames:Int = 10;

	// Hit window
	public static var safeZoneOffset:Float = 0;

	// BPM change map
	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	public function new() {}

	public static function init()
	{
		recalculateTimings();
	}

	public static function changeBPM(newBpm:Float)
	{
		bpm = newBpm;
		recalculateTimings();
	}

	public static function recalculateTimings()
	{
		crochet = (60 / bpm) * 1000;
		stepCrochet = crochet / 4;
		safeZoneOffset = (safeFrames / 60) * 1000;
	}

	// FIX
	public static function mapBPMChanges(song:Dynamic)
	{
		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;

		// Array FIX
		var notes:Array<Dynamic> = cast song.notes;

		for (section in notes)
		{
			if (section.changeBPM && section.bpm != curBPM)
			{
				curBPM = section.bpm;

				var event:BPMChangeEvent =
				{
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};

				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = section.lengthInSteps;

			totalSteps += deltaSteps;

			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
	}
}

typedef BPMChangeEvent =
{
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}
