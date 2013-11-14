package fluffyflux;

import flash.display.Sprite;

class GameTile extends Sprite
{
    public var col: Int;
    public var row: Int;

    private static var COLOR_TYPES = [
        0x0000FF, // blue
        0xFF00FF, // fuchsia
        0x008000, // green
        0xFFA500, // orange
        0xFF0000, // red
        0xFFFF00, // yellow
    ];

    private var type: Int;

    public function new ()
    {
        super ();

        initialize ();
    }

    private function initialize (): Void
    {
        this.col  = 0;
        this.row  = 0;
        this.type = Math.round (Math.random () * (COLOR_TYPES.length - 1));
    }

    public function draw (boxSize: Float): Void
    {
        var tileX = this.col * boxSize + 6;
        var tileY = this.row * boxSize + 6;

        this.graphics.clear ();
        this.graphics.beginFill (COLOR_TYPES[this.type], 0.8);
        this.graphics.drawRect (tileX, tileY, boxSize - 12, boxSize - 12);
    }
}
