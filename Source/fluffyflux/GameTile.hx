package fluffyflux;

import flash.display.Sprite;

class GameTile extends Sprite
{
    public var boxSize: Float;
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

    private static var COLOR_SELECT = [
        0x000088,
        0x880088,
        0x004000,
        0x885200,
        0x880000,
        0x888800,
    ];

    private var type: Int;
    private var selected: Bool;

    public function new ()
    {
        super ();

        initialize ();
    }

    public function deselect (): Void
    {
        this.selected = false;

        this.draw ();
    }

    public function draw (): Void
    {
        var tileSize = this.boxSize - 12;
        var tileX    = this.col * this.boxSize + 6;
        var tileY    = this.row * this.boxSize + 6;

        this.graphics.clear ();

        if (this.selected) {
            tileSize = this.boxSize - 4;
            tileX    = this.col * this.boxSize + 2;
            tileY    = this.row * this.boxSize + 2;

            this.graphics.lineStyle(4, COLOR_SELECT[this.type]);
        }

        this.graphics.beginFill (COLOR_TYPES[this.type], 0.8);
        this.graphics.drawRect (tileX, tileY, tileSize, tileSize);
    }

    public function select (): Void
    {
        this.selected = true;

        this.draw ();
    }

    private function initialize (): Void
    {
        this.boxSize  = 0;
        this.col      = 0;
        this.row      = 0;
        this.selected = false;
        this.type     = Math.round (Math.random () * (COLOR_TYPES.length - 1));
    }
}
