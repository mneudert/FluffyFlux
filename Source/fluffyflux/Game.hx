package fluffyflux;

import flash.display.Sprite;
import flash.events.MouseEvent;

class Game extends Sprite
{
    private static var NUM_COLS = 9;
    private static var NUM_ROWS = 9;

    private var background: Sprite;
    private var game: Game;
    private var header: Header;
    private var tileBox: Sprite;

    private var tiles: Array <Array < GameTile>>;

    private var boxSize: Float;

    public function new ()
    {
        super ();

        initialize ();
        construct ();

        this.tileBox.addEventListener(MouseEvent.CLICK, tilebox_onClick);
    }

    public function resize (newWidth: Int, newHeight: Int): Void
    {
        var sideLength = (newHeight < newWidth) ? newHeight : newWidth;

        this.boxSize = sideLength / NUM_COLS;

        this.background.graphics.clear ();
        this.background.x = newWidth / 2 - sideLength / 2;

        this.tileBox.x = this.background.x;
        this.tileBox.y = this.background.y;

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                drawBox (col, row, boxSize);

                this.tiles[col][row].boxSize = boxSize;

                this.tiles[col][row].draw ();
            }
        }
    }

    private function construct (): Void
    {
        addChild (this.background);
        addChild (this.tileBox);

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                var tile = new GameTile();

                tile.col = col;
                tile.row = row;

                this.tiles[col][row] = tile;

                this.tileBox.addChild (tile);
            }
        }
    }

    private function drawBox (col: Int, row: Int, boxSize: Float): Void
    {
        this.background.graphics.lineStyle (2, 0x444444);
        this.background.graphics.beginFill (0xFFFFFF, 0.4);
        this.background.graphics.drawRect (col * boxSize, row * boxSize, boxSize, boxSize);
    }

    private function initialize (): Void
    {
        this.background = new Sprite();
        this.tileBox    = new Sprite();
        this.tiles      = new Array <Array <GameTile>> ();

        this.boxSize            = 0;
        this.tileBox.buttonMode = true;

        for (col in 0...NUM_COLS) {
            this.tiles[col] = new Array <GameTile> ();

            for (row in 0...NUM_ROWS) {
                this.tiles[col][row] = null;
            }
        }
    }

    private function tilebox_onClick (event: MouseEvent): Void
    {
        var selectCol = Math.floor( event.localX / this.boxSize );
        var selectRow = Math.floor( event.localY / this.boxSize );

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                this.tiles[col][row].deselect();
            }
        }

        this.tiles[selectCol][selectRow].select();
    }
}
