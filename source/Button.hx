package ;

import flixel.FlxSprite;
import flixel.FlxG;

class Button extends FlxSprite {

    private var keyBinding:String;
    private var xboxBinding:Null<Int>;
    private var res:String;
    private var callback:Void->Void;

    public function new(_x:Float, _y:Float, _w:Int, _h:Int, _callback:Void->Void, _res:String, ?_xboxBinding:Int, ?_keyBinding:String):Void {
        super(_x,_y);

        makeGraphic(_w, _h, flixel.util.FlxColorUtil.darken(Reg.pColours[0],0.25), true);
        res = _res;
        xboxBinding = _xboxBinding;
        keyBinding = _keyBinding;
        callback = _callback;
    }

    override public function update():Void {

        if(this.overlapsPoint(FlxG.mouse.getWorldPosition())
            && FlxG.mouse.justReleased
            || (xboxBinding != null && FlxG.gamepads.anyJustPressed(xboxBinding))
            || (keyBinding  != null && FlxG.keys.anyJustPressed([keyBinding]))) {
            if(callback != null)
                callback();
        }

        super.update();

    }

}