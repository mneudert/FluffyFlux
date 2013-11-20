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
    private var points: GamePoints;
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
        var gameHeight = Std.int (newHeight - this.points.height - 50);
        var sideLength = (gameHeight < newWidth) ? gameHeight : newWidth;

        this.boxSize = sideLength / NUM_COLS;

        this.background.graphics.clear ();
        this.background.x = newWidth / 2 - sideLength / 2;

        this.points.x = newWidth / 2 - this.points.width / 2;
        this.points.y = gameHeight + 25;

        this.tileBox.x = this.background.x;
        this.tileBox.y = this.background.y;

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                this.drawBox (col, row, this.boxSize);

                this.tiles[col][row].boxSize = this.boxSize;

                this.tiles[col][row].draw ();
            }
        }
    }

    private function addTile (col: Int, row: Int): Void
    {
        var tile = new GameTile ();

        tile.boxSize = this.boxSize;
        tile.col     = col;
        tile.row     = row;

        this.tiles[col][row] = tile;

        this.tileBox.addChild (tile);

        tile.resetType ();
        tile.draw ();
    }

    private function clearMatches (clearCol: Int, clearRow: Int): Void
    {
        var tileType = this.tiles[clearCol][clearRow].type;
        var matches  = this.findMatches (tileType, clearCol, clearRow);

        if (0 < matches.hAsc) {
            for (col in new IntIterator (clearCol + 1, clearCol + matches.hAsc + 1)) {
                this.tileBox.removeChild (this.tiles[col][clearRow]);

                this.tiles[col][clearRow] = null;
            }
        }

        if (0 < matches.hDesc) {
            for (col in new RevIntIterator (clearCol - 1, clearCol - matches.hDesc - 1)) {
                this.tileBox.removeChild (this.tiles[col][clearRow]);

                this.tiles[col][clearRow] = null;
            }
        }

        if (0 < matches.vAsc) {
            for (row in new IntIterator (clearRow + 1, clearRow + matches.vAsc + 1)) {
                this.tileBox.removeChild (this.tiles[clearCol][row]);

                this.tiles[clearCol][row] = null;
            }
        }

        if (0 < matches.vDesc) {
            for (row in new RevIntIterator (clearRow - 1, clearRow - matches.vDesc - 1)) {
                this.tileBox.removeChild (this.tiles[clearCol][row]);

                this.tiles[clearCol][row] = null;
            }
        }

        this.tileBox.removeChild (this.tiles[clearCol][clearRow]);

        this.tiles[clearCol][clearRow] = null;
    }

    private function construct (): Void
    {
        addChild (this.debug);

        addChild (this.background);
        addChild (this.tileBox);
        addChild (this.points);

        for (col in 0...NUM_COLS) {
            for (row in 0...NUM_ROWS) {
                this.addTile (col, row);

                while (hasMatches (col, row)) {
                    this.tiles[col][row].resetType ();
                    this.tiles[col][row].draw ();
                }
            }
        }
    }

    private function drawBox (col: Int, row: Int, boxSize: Float): Void
    {
        this.background.graphics.lineStyle (2, 0x444444);
        this.background.graphics.beginFill (0xFFFFFF, 0.4);
        this.background.graphics.drawRect (col * boxSize, row * boxSize, boxSize, boxSize);
    }

    private function findMatches (tileType: Int, targetCol: Int, targetRow: Int)
    {
        var hMatchLeft   = 0;
        var hMatchRight  = 0;
        var vMatchBottom = 0;
        var vMatchTop    = 0;

        if (1 < targetCol) {
            for (col in new RevIntIterator (targetCol - 1, -1)) {
                if ((null == this.tiles[col][targetRow])
                        || (tileType != this.tiles[col][targetRow].type)) {
                    break;
                }

                hMatchLeft++;
            }
        }

        if (NUM_COLS > targetCol + 1) {
            for (col in new IntIterator (targetCol + 1, NUM_COLS)) {
                if ((null == this.tiles[col][targetRow])
                        || (tileType != this.tiles[col][targetRow].type)) {
                    break;
                }

                hMatchRight++;
            }
        }

        if (1 < targetRow) {
            for (row in new RevIntIterator (targetRow - 1, -1)) {
                if ((null == this.tiles[targetCol][row])
                        || (tileType != this.tiles[targetCol][row].type)) {
                    break;
                }

                vMatchTop++;
            }
        }

        if (NUM_ROWS > targetRow + 1) {
            for (row in new IntIterator (targetRow + 1, NUM_ROWS)) {
                if ((null == this.tiles[targetCol][row])
                        || (tileType != this.tiles[targetCol][row].type)) {
                    break;
                }

                vMatchBottom++;
            }
        }

        return { hAsc: hMatchRight, hDesc: hMatchLeft, vAsc: vMatchBottom, vDesc: vMatchTop };
    }

    private function hasMatches (targetCol: Int, targetRow: Int): Bool
    {
        var tileType = this.tiles[targetCol][targetRow].type;
        var matches  = this.findMatches (tileType, targetCol, targetRow);

        return (2 <= matches.hAsc + matches.hDesc) || (2 <= matches.vAsc + matches.vDesc);
    }

    private function initialize (): Void
    {
        this.debug      = new Debug ();

        this.background = new Sprite ();
        this.points     = new GamePoints ();
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

    private function refillCleared (): Int
    {
        var amount = 0;

        for (col in 0...NUM_COLS) {
            for (row in new RevIntIterator (NUM_ROWS - 1, -1)) {
                if (null != this.tiles[col][row]) {
                    continue;
                }

                amount += refillClearedPart (col, row);
                break;
            }
        }

        return amount;
    }

    private function refillClearedPart (refillCol: Int, refillRow: Int): Int
    {
        var amount = 0;

        for (row in new RevIntIterator (refillRow, -1)) {
            if (null != this.tiles[refillCol][row]) {
                break;
            }

            amount++;
        }

        if (amount <= refillRow) { // full clear at "amount == refillRow + 1"
            for (row in new RevIntIterator (refillRow - amount, -1)) {
                var tile = this.tiles[refillCol][row];

                tile.row = row + amount;

                this.tiles[refillCol][row]          = null;
                this.tiles[refillCol][row + amount] = tile;

                tile.draw ();
            }
        }

        for (row in 0...amount) {
            this.addTile (refillCol, row);
        }

        return amount;
    }

    private function refillMatches (): Void
    {
        var cleared: Int;
        var redo: Bool;

        var multiplier = 0;

        do {
            multiplier++;

            redo    = false;
            cleared = this.refillCleared ();

            this.points.addPoints ( cleared * (20 * multiplier));

            for (col in 0...NUM_COLS) {
                for (row in 0...NUM_ROWS) {
                    if (hasMatches (col, row)) {
                        this.clearMatches (col, row);

                        redo = true;
                        break;
                    }
                }

                if (redo) {
                    break;
                }
            }
        } while (redo);
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
                if (null == this.tiles[col][row]) {
                    continue;
                }

                this.tiles[col][row].deselect ();
            }
        }

        if (this.isSwitchable (clickedCol, clickedRow)) {
            this.switchTile (this.selectedCol, this.selectedRow, clickedCol, clickedRow);

            var hasClickedMatches  = hasMatches (clickedCol, clickedRow);
            var hasSelectedMatches = hasMatches (this.selectedCol, this.selectedRow);

            if (!hasClickedMatches && !hasSelectedMatches) {
                this.switchTile (this.selectedCol, this.selectedRow, clickedCol, clickedRow);
            }

            if (hasClickedMatches) {
                this.clearMatches (clickedCol, clickedRow);
            }

            if (hasSelectedMatches) {
                this.clearMatches (this.selectedCol, this.selectedRow);
            }

            this.refillMatches ();

            this.selectedCol = -1;
            this.selectedRow = -1;

            return;
        }

        this.tiles[clickedCol][clickedRow].select ();

        this.selectedCol = clickedCol;
        this.selectedRow = clickedRow;
    }
}
