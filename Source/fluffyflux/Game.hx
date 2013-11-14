package fluffyflux;

import flash.display.Sprite;

class Game extends Sprite
{
    private static var NUM_COLS = 9;
    private static var NUM_ROWS = 9;

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
        var boxSize    = sideLength / NUM_COLS;

        this.background.graphics.clear ();
        this.background.x = newWidth / 2 - sideLength / 2;

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                drawBox(col, row, boxSize);
            }
        }
    }

    private function construct ():Void
    {
        addChild (this.background);
    }

    private function drawBox (col:Int, row:Int, boxSize:Float):Void
    {
        this.background.graphics.lineStyle (2, 0x444444);
        this.background.graphics.beginFill (0xFFFFFF, 0.4);
        this.background.graphics.drawRect (col * boxSize, row * boxSize, boxSize, boxSize);
    }

    private function initialize ():Void
    {
        this.background = new Sprite();
    }
}
