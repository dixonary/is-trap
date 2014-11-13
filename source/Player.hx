package ;

import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.input.gamepad.XboxButtonID;
import flixel.input.gamepad.FlxGamepad;
import flixel.util.FlxTimer;

class Player extends FlxSprite {

    private static inline var THRESHOLD:Float = 0.5; //For xbox stick pressure
    private var size:Int;
    private var grid:Grid;
    private var moving:Bool = false;
    private var validMoves:Moves;
    public  var tx:Int;
    public  var ty:Int;
    private var id:Int;

    private var gamepad:FlxGamepad;
    
    function new(_id:Int, _x:Int, _y:Int, _size:Int, _grid:Grid):Void {

        super();

        size = _size;

        id = _id;
        tx = _x;
        ty = _y;
        size = _size;
        grid = _grid;

        x = grid.getX(tx) - size;
        y = grid.getY(ty) - size;

        makeGraphic(size*2+2, size*2+2, 0x00ffffff, true);
        FlxSpriteUtil.drawCircle(this, size+1, size+1, size, Reg.pColours[_id], {pixelHinting:true}); 

    }

    override public function update():Void {

        super.update();

        validMoves = {
            up   :ty > 0                  && grid.openCell(tx, ty-1),
            down :ty < Reg.boardSize - 1  && grid.openCell(tx, ty+1),
            left :tx > 0                  && grid.openCell(tx-1, ty),
            right:tx < Reg.boardSize - 1  && grid.openCell(tx+1, ty)
        };

        if(!(validMoves.up || validMoves.down || validMoves.left || validMoves.right)) {
            //trace("player "+id+" ded");
        }


        gamepad = FlxG.gamepads.getByID(id);
        if(gamepad != null && !moving) {

            if(gamepad.pressed(XboxButtonID.A) && grid.openCell(tx, ty))
                dig();

            else if(gamepad.getYAxis(1) >  THRESHOLD)
                move(0, 1);
            else if(gamepad.getYAxis(1) < -THRESHOLD)
                move(0,-1);
            else if(gamepad.getXAxis(0) >  THRESHOLD)
                move(1, 0);
            else if(gamepad.getXAxis(0) < -THRESHOLD)
                move(-1,0);


            if(gamepad.justPressed(XboxButtonID.BACK))
                FlxG.resetGame();
            if(gamepad.justPressed(XboxButtonID.START))
                 Sys.exit(0);
        }
        // case 1:
        //     if(!moving) {

        //         if(FlxG.keys.pressed.SPACE && grid.openCell(tx, ty))
        //             dig();

        //         else if(FlxG.keys.pressed.DOWN)
        //             move(0, 1);
        //         else if(FlxG.keys.pressed.UP)
        //             move(0,-1);
        //         else if(FlxG.keys.pressed.RIGHT)
        //             move(1, 0);
        //         else if(FlxG.keys.pressed.LEFT)
        //             move(-1,0);


        //         if(FlxG.keys.justPressed.ENTER)
        //             FlxG.resetGame();
        //         if(FlxG.keys.justPressed.BACKSPACE)
        //             Sys.exit(0);
        //     }

        // }

    }

    public function dig():Void {
        moving = true;

        grid.setCell(tx, ty, id+1);

        new FlxTimer(0.25,function(_){moving = false;});
    }

    public function move(_x:Int, _y:Int):Void {

        if(_y < 0 && !validMoves.up   ) return;
        if(_y > 0 && !validMoves.down ) return;
        if(_x < 0 && !validMoves.left ) return;
        if(_x > 0 && !validMoves.right) return;

        moving = true;
        tx += _x;
        ty += _y;

        flixel.tweens.FlxTween.tween(this, {x:grid.getX(tx) - size, y:grid.getY(ty) - size}, 0.25, {complete:function(_) {
            moving = false;
        }, ease:flixel.tweens.FlxEase.quadInOut});

    }

}

typedef Moves = {
    up   :Bool,
    down :Bool,
    left :Bool,
    right:Bool
}