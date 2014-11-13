package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{

	private var grid:Grid;
	private var player1:Player;
	private var endText:FlxText;
	public var running:Bool = true;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		FlxG.mouse.visible = false;
		FlxG.cameras.bgColor = 0xff000000;

		var t = new FlxText(0,20,FlxG.width,"is trap",100);
		t.alignment = "center";
		t.color = 0xffffffff;
		add(t);
		
		FlxG.fixedTimestep = false;

		FlxG.camera.antialiasing = true;
		FlxG.stage.quality = flash.display.StageQuality.HIGH;

		grid = new Grid();
		add(grid);
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justPressed.Q) {
			FlxG.switchState(new MenuState());
		}

	}	
}