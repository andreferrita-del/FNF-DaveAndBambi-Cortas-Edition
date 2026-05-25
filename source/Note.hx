package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

using StringTools;

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

	public static var swagWidth:Float = 160 * 0.7;

	public static inline var PURP_NOTE:Int = 0;
	public static inline var BLUE_NOTE:Int = 1;
	public static inline var GREEN_NOTE:Int = 2;
	public static inline var RED_NOTE:Int = 3;

	private var earlyHitMult:Float = 0.5;

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false)
	{
		super();

		moves = false;
		pixelPerfectRender = false;

		if(prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		this.isSustainNote = sustainNote;

		x += 50;
		y = -2000;

		this.strumTime = strumTime;
		this.noteData = noteData;

		var tex = FlxAtlasFrames.fromSparrow(
			AssetPaths.NOTE_assets__png,
			AssetPaths.NOTE_assets__xml
		);

		frames = tex;

		loadNoteAnims();

		setGraphicSize(Std.int(width * 0.7));
		updateHitbox();

		// Better performance
		antialiasing = !isSustainNote;

		switch(noteData)
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

		if(isSustainNote && prevNote != null)
		{
			alpha = 0.6;

			offset.x += width / 2;

			switch(noteData)
			{
				case PURP_NOTE:
					animation.play('purpleholdend');

				case BLUE_NOTE:
					animation.play('blueholdend');

				case GREEN_NOTE:
					animation.play('greenholdend');

				case RED_NOTE:
					animation.play('redholdend');
			}

			updateHitbox();

			offset.x -= width / 2;

			if(prevNote.isSustainNote)
			{
				switch(prevNote.noteData)
				{
					case PURP_NOTE:
						prevNote.animation.play('purplehold');

					case BLUE_NOTE:
						prevNote.animation.play('bluehold');

					case GREEN_NOTE:
						prevNote.animation.play('greenhold');

					case RED_NOTE:
						prevNote.animation.play('redhold');
				}

				prevNote.scale.y *= 1.8 * PlayState.SONG.speed;
			}
		}
		else
		{
			earlyHitMult = 1;
		}
	}

	function loadNoteAnims()
	{
		animation.addByPrefix('greenScroll', 'green0');
		animation.addByPrefix('redScroll', 'red0');
		animation.addByPrefix('blueScroll', 'blue0');
		animation.addByPrefix('purpleScroll', 'purple0');

		if(isSustainNote)
		{
			animation.addByPrefix('purpleholdend', 'pruple end hold');
			animation.addByPrefix('greenholdend', 'green hold end');
			animation.addByPrefix('redholdend', 'red hold end');
			animation.addByPrefix('blueholdend', 'blue hold end');

			animation.addByPrefix('purplehold', 'purple hold piece');
			animation.addByPrefix('greenhold', 'green hold piece');
			animation.addByPrefix('redhold', 'red hold piece');
			animation.addByPrefix('bluehold', 'blue hold piece');
		}
	}

	override function update(elapsed:Float)
	{
		if(!alive)
			return;

		super.update(elapsed);

		var songPos:Float = Conductor.songPosition;
		var safeZone:Float = Conductor.safeZoneOffset;

		if(mustPress)
		{
			canBeHit = (
				strumTime > songPos - safeZone &&
				strumTime < songPos + (safeZone * earlyHitMult)
			);

			if(strumTime < songPos - safeZone && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if(strumTime < songPos + (safeZone * earlyHitMult))
			{
				if((isSustainNote && prevNote.wasGoodHit) || strumTime <= songPos)
				{
					wasGoodHit = true;

					// Opponent note optimization
					visible = false;
					active = false;
				}
			}
		}

		if(tooLate)
		{
			if(alpha > 0.3)
				alpha = 0.3;
		}

		// Render optimization
		visible = y > -400 && y < FlxG.height + 400;

		// Remove notes far below screen
		if(y > FlxG.height + 600)
		{
			kill();
			active = false;
			visible = false;
		}
	}
}
