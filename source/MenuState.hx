package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.input.gamepad.XboxButtonID;



/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{

	private var lButton:Button;
	private var rButton:Button;

	private var sizeCounter:FlxText;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		FlxG.cameras.bgColor = 0xff000000;
		FlxG.mouse.visible = true;
		FlxG.mouse.useSystemCursor = true;

		var tColour:Int = 0xffffffff;

		var title = new FlxText(0,20,FlxG.width,"is trap",100);
		title.alignment = "center";
		title.color = tColour;
		add(title);

		var label = new FlxText(0,220, FlxG.width, "board size", 40);
		label.alignment = "center";
		label.color = tColour;
		add(label);

		sizeCounter = new FlxText(0, 300, FlxG.width, ""+Reg.boardSize, 100);
		sizeCounter.alignment = "center";
		sizeCounter.color = tColour;
		add(sizeCounter);

		var lbutton = new Button(40, 310, 100, 100, decSize, null, XboxButtonID.LB, "LEFT");
		add(lbutton);
		var lbuttonText = new FlxText(40, 307, 100, "LB\n<", 40);
		lbuttonText.color = tColour;
		lbuttonText.alignment = "center";
		add(lbuttonText);

		var rbutton = new Button(FlxG.width-140, 310, 100, 100, incSize, null, XboxButtonID.RB, "RIGHT");
		add(rbutton);
		var rbuttonText = new FlxText(FlxG.width-140, 307, 100, "RB\n>", 40);
		rbuttonText.color = tColour;
		rbuttonText.alignment = "center";
		add(rbuttonText);

		var desc = new FlxText(0,FlxG.height-120,FlxG.width,"trap other player\nbut dont get trap!",40);
		desc.alignment = "center";
		desc.color = tColour;
		add(desc);

		var startButton = new Button(120, 700, FlxG.width-240, 100, startGame, null, XboxButtonID.START, "ENTER");
		add(startButton);
		var startButtonText = new FlxText(120, 700, FlxG.width-240, "start", 80);
		startButtonText.color = tColour;
		startButtonText.alignment = "center";
		add(startButtonText);



	}

	function incSize():Void {
		Reg.boardSize = Math.round(Math.min(Reg.boardSize+1, 21));
	}
	function decSize():Void {
		Reg.boardSize = Math.round(Math.max(Reg.boardSize-1, 3));
	}
	function startGame():Void {
		FlxG.switchState(new PlayState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

		if (FlxG.keys.justPressed.Q) {
			Sys.exit(0);
		}

		sizeCounter.text = ""+Reg.boardSize;
	}	
}