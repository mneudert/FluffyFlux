package fluffyflux;

import flash.display.Sprite;

class Game extends Sprite
{
    private var background:Sprite;
    private var game:Game;
    private var header:Header;

    public function new ()
    {
        super ();

        initialize ();
        construct ();
    }

    public function resize (newWidth:Int, newHeight:Int):Void
    {
        var sideLength = (newHeight < newWidth) ? newHeight : newWidth;

        this.background.graphics.clear ();
        this.background.graphics.beginFill (0x444444, 0.4);
        this.background.graphics.drawRect (0, 0, sideLength, sideLength);

        this.background.x = newWidth / 2 - sideLength / 2;
    }

    private function construct ():Void
    {
        addChild (this.background);
    }

    private function initialize ():Void
    {
        this.background = new Sprite();
    }
}
