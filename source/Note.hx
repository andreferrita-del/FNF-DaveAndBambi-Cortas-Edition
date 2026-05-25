package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public var noteScore:Float = 1;

	public static var swagWidth:Float = 160 * 0.7;

	public static inline var PURP_NOTE:Int = 0;
	public static inline var BLUE_NOTE:Int = 1;
	public static inline var GREEN_NOTE:Int = 2;
	public static inline var RED_NOTE:Int = 3;

	// Texture cache
	public static var NOTE_TEX:FlxAtlasFrames;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		if (NOTE_TEX == null)
		{
			NOTE_TEX = FlxAtlasFrames.fromSparrow(
				AssetPaths.NOTE_assets__png,
				AssetPaths.NOTE_assets__xml
			);
		}

		frames = NOTE_TEX;

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		this.isSustainNote = sustainNote;
		this.strumTime = strumTime;
		this.noteData = noteData;

		x += 50;
		y = -2000;

		setupAnimations();

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		// Better performance on mobile/low-end devices
		antialiasing = false;

		switch (noteData)
		{
			case PURP_NOTE:
				x += swagWidth * 0;
				animation.play('purpleScroll');

			case BLUE_NOTE:
				x += swagWidth * 1;
				animation.play('blueScroll');

			case GREEN_NOTE:
				x += swagWidth * 2;
				animation.play('greenScroll');

			case RED_NOTE:
				x += swagWidth * 3;
				animation.play('redScroll');
		}

		if (isSustainNote)
			setupSustain();
	}

	function setupAnimations()
	{
		if (animation.getByName('greenScroll') != null)
			return;

		animation.addByPrefix('greenScroll', 'green0');
		animation.addByPrefix('redScroll', 'red0');
		animation.addByPrefix('blueScroll', 'blue0');
		animation.addByPrefix('purpleScroll', 'purple0');

		animation.addByPrefix('purpleholdend', 'pruple end hold');
		animation.addByPrefix('greenholdend', 'green hold end');
		animation.addByPrefix('redholdend', 'red hold end');
		animation.addByPrefix('blueholdend', 'blue hold end');

		animation.addByPrefix('purplehold', 'purple hold piece');
		animation.addByPrefix('greenhold', 'green hold piece');
		animation.addByPrefix('redhold', 'red hold piece');
		animation.addByPrefix('bluehold', 'blue hold piece');
	}

	function setupSustain()
	{
		noteScore *= 0.2;
		alpha = 0.6;

		x += width / 2;

		switch (noteData)
		{
			case GREEN_NOTE:
				animation.play('greenholdend');

			case RED_NOTE:
				animation.play('redholdend');

			case BLUE_NOTE:
				animation.play('blueholdend');

			case PURP_NOTE:
				animation.play('purpleholdend');
		}

		updateHitbox();

		x -= width / 2;

		if (prevNote != null && prevNote.isSustainNote)
		{
			switch (prevNote.noteData)
			{
				case GREEN_NOTE:
					prevNote.animation.play('greenhold');

				case RED_NOTE:
					prevNote.animation.play('redhold');

				case BLUE_NOTE:
					prevNote.animation.play('bluehold');

				case PURP_NOTE:
					prevNote.animation.play('purplehold');
			}

			prevNote.offset.y = -19;

			// Reduced scaling for better performance
			prevNote.scale.y *= 1.8 * PlayState.SONG.speed;
		}
	}

	override function update(elapsed:Float)
{
	if (!alive)
		return;

	super.update(elapsed);

	var songPos = Conductor.songPosition;
	var safeZone = Conductor.safeZoneOffset;

	if (mustPress)
	{
		canBeHit = (
			strumTime > songPos - safeZone &&
			strumTime < songPos + safeZone
		);

		tooLate = strumTime < songPos - safeZone;

		if (tooLate)
			alpha = 0.3;
	}
	else
	{
		canBeHit = false;

		if (strumTime <= songPos + 50)
		{
			wasGoodHit = true;

			// Remove opponent notes instantly
			visible = false;
			kill();
		}
	}

	// Render optimization
	visible = y > -200 && y < FlxG.height + 200;

	// Remove notes far below screen
	if (y > FlxG.height + 400)
	{
		kill();
	}
}
}
