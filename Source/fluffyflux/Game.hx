package fluffyflux;

import flash.display.Sprite;
import flash.events.MouseEvent;

import fluffyflux.util.RevIntIterator;

class Game extends Sprite
{
    private static var NUM_COLS = 9;
    private static var NUM_ROWS = 9;

    private var debug: Debug;

    private var background: Sprite;
    private var tileBox: Sprite;

    private var tiles: Array <Array < GameTile>>;

    private var boxSize: Float;
    private var selectedCol: Int;
    private var selectedRow: Int;

    public function new ()
    {
        super ();

        this.initialize ();
        this.construct ();

        this.tileBox.addEventListener (MouseEvent.CLICK, tileBox_onClick);
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
                this.drawBox (col, row, boxSize);

                this.tiles[col][row].boxSize = boxSize;

                this.tiles[col][row].draw ();
            }
        }
    }

    private function construct (): Void
    {
        addChild (this.debug);

        addChild (this.background);
        addChild (this.tileBox);

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                var tile = new GameTile ();

                tile.col = col;
                tile.row = row;

                this.tiles[col][row] = tile;

                do {
                    tile.resetType ();
                } while (hasMatches (tile.type, col, row));

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
        this.debug      = new Debug ();

        this.background = new Sprite ();
        this.tileBox    = new Sprite ();
        this.tiles      = new Array <Array <GameTile>> ();

        this.boxSize     = 0;
        this.selectedCol = -1;
        this.selectedRow = -1;

        this.tileBox.buttonMode = true;

        for (col in 0...NUM_COLS) {
            this.tiles[col] = new Array <GameTile> ();

            for (row in 0...NUM_ROWS) {
                this.tiles[col][row] = null;
            }
        }
    }

    private function hasMatches (tileType: Int, targetCol: Int, targetRow: Int): Bool
    {
        var hMatchLeft   = 0;
        var hMatchRight  = 0;
        var vMatchBottom = 0;
        var vMatchTop    = 0;

        if (1 < targetCol) {
            for (col in new RevIntIterator(targetCol, 0)) {
                if ((null == this.tiles[col - 1][targetRow])
                        || (tileType != this.tiles[col - 1][targetRow].type)) {
                    break;
                }

                hMatchLeft++;
            }
        }

        if (NUM_COLS > targetCol + 1) {
            for (col in new IntIterator(targetCol + 1, NUM_COLS)) {
                if ((null == this.tiles[col][targetRow])
                        || (tileType != this.tiles[col][targetRow].type)) {
                    break;
                }

                hMatchRight++;
            }
        }

        if (1 < targetRow) {
            for (row in new RevIntIterator(targetRow, 0)) {
                if ((null == this.tiles[targetCol][row - 1])
                        || (tileType != this.tiles[targetCol][row - 1].type)) {
                    break;
                }

                vMatchTop++;
            }
        }

        if (NUM_ROWS > targetRow + 1) {
            for (row in new IntIterator(targetRow + 1, NUM_ROWS)) {
                if ((null == this.tiles[targetCol][row])
                        || (tileType != this.tiles[targetCol][row].type)) {
                    break;
                }

                vMatchBottom++;
            }
        }

        return (2 <= hMatchLeft + hMatchRight) || (2 <= vMatchBottom + vMatchTop);
    }

    private function isSwitchable (targetCol: Int, targetRow: Int): Bool
    {
        if (0 > this.selectedCol || 0 > this.selectedRow) {
            return false;
        }

        if (targetCol == this.selectedCol) {
            if (targetRow == this.selectedRow - 1 || targetRow == this.selectedRow + 1) {
                return true;
            }
        }

        if (targetRow == this.selectedRow) {
            if (targetCol == this.selectedCol - 1 || targetCol == this.selectedCol + 1) {
                return true;
            }
        }

        return false;
    }

    private function switchTile (fromCol: Int, fromRow: Int, toCol: Int, toRow: Int): Void
    {
        var fromTile = this.tiles[fromCol][fromRow];
        var toTile   = this.tiles[toCol][toRow];

        fromTile.col = toCol;
        fromTile.row = toRow;
        toTile.col   = fromCol;
        toTile.row   = fromRow;

        this.tiles[fromCol][fromRow] = toTile;
        this.tiles[toCol][toRow]     = fromTile;

        fromTile.draw ();
        toTile.draw ();
    }

    private function tileBox_onClick (event: MouseEvent): Void
    {
        var clickedCol = Math.floor (event.localX / this.boxSize);
        var clickedRow = Math.floor (event.localY / this.boxSize);

        this.debug.text = "BoxClick: " + clickedCol + "x" + clickedRow;

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                this.tiles[col][row].deselect ();
            }
        }

        if (this.isSwitchable (clickedCol, clickedRow)) {
            var selectedType = this.tiles[this.selectedCol][this.selectedRow].type;
            var clickedType  = this.tiles[clickedCol][clickedRow].type;

            this.switchTile (this.selectedCol, this.selectedRow, clickedCol, clickedRow);

            if (!hasMatches (selectedType, clickedCol, clickedRow)
                    && !hasMatches (clickedType, this.selectedCol, this.selectedRow)) {
                this.switchTile (this.selectedCol, this.selectedRow, clickedCol, clickedRow);

                this.selectedCol = -1;
                this.selectedRow = -1;

                return;
            }
        }

        this.tiles[clickedCol][clickedRow].select ();

        this.selectedCol = clickedCol;
        this.selectedRow = clickedRow;
    }
}
