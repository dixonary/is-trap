package ;

import flixel.util.FlxSpriteUtil;
import flixel.util.FlxColorUtil;
import flixel.FlxSprite;
import flixel.FlxG;

class Cell extends FlxSprite {

    private var colours = [ 0xffaaaaaa //default
                          , FlxColorUtil.darken(Reg.pColours[0],0.25) //red
                          , FlxColorUtil.darken(Reg.pColours[1],0.25) //blue
                          , FlxG.cameras.bgColor //disappeared
                          , FlxColorUtil.brighten(Reg.pColours[0],0.25) //lred
                          , FlxColorUtil.brighten(Reg.pColours[1],0.25) //lblue
                          ];

    public var tx:Int;
    public var ty:Int;
    private var size:Int;
    private var grid:Grid;
    private var value:Int;

    function new(_x:Int, _y:Int, _size:Int, _grid:Grid, ?_value:Int):Void {
        
        super();

        tx = _x;
        ty = _y;
        size = _size;
        grid = _grid;

        value = _value == null ? 0 : _value;

        makeGraphic(size*2 + 2, size*2 + 2, 0x000000ff, true);

        FlxSpriteUtil.drawCircle(this, size+1, size+1, size, colours[value], {pixelHinting:true});

        x = grid.getX(tx)-size;
        y = grid.getY(ty)-size;
        
    }


    public function getValue():Int {
        return value;
    }

    public function setValue(_value:Int):Void {
        value = _value;

        var newCell = new Cell(tx, ty, size, grid, _value);
        newCell.scale.x = newCell.scale.y = 0;
        grid.newCells.add(newCell);

        flixel.tweens.FlxTween.tween(newCell.scale, {x:1,y:1},0.5,{complete:function(_){
            grid.replaceCell(tx, ty, newCell);
        }});

    }

    override public function update():Void {

        super.update();

    }

    override public function toString():String {
        return "{"+tx+","+ty+"}";
    }

}