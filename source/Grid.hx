package ;

import flixel.util.FlxSpriteUtil;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.group.FlxGroup;
import flixel.FlxG;

class Grid extends FlxGroup {

    private var size:Int;

    private var width:Int  = 600;
    private var height:Int = 600;
    public var x:Int = 20;
    public var y:Int = 20;

    private var players:Array<Player>;
    private var cells:Array<Array<Cell>>;

    public var playersG:FlxGroup;
    public var newCells:FlxGroup;
    public var oldCells:FlxGroup;

    private var countQueues:Array<Queue<Cell>>;
    public var  countChecks:Array<Array<Array<Bool>>>;
    
    function new():Void {
        
        super();

        playersG = new FlxGroup();
        add(playersG);
        oldCells = new FlxGroup();
        add(oldCells);
        newCells = new FlxGroup();
        add(newCells);

        size = Std.int(width / (Reg.boardSize+1) / 3);

        //Set up players and add to players group
        players = [];
        for (i in 0 ... 2) {
            players[i] = new Player(i, i*(Reg.boardSize-1), i*(Reg.boardSize-1), Math.round(size*1.5), this);
            playersG.add(players[i]);
        }

        //Set up cells and add to cells group
        cells = [];
        for(i in 0 ... Reg.boardSize) {
            cells[i] = [];
            for(j in 0 ... Reg.boardSize) {
                cells[i][j] = new Cell(i, j, size, this);
                oldCells.add(cells[i][j]);
            }
        }

    }

    override public function update():Void {
        super.update();

        if(cast(FlxG.state,PlayState).running) {
            //Game ends when the parts are disconnected
            if(!checkConnected()) {
                cast(FlxG.state, PlayState).running = false;
                beginCount();
            }

            //Disappearing holes
            if(Math.random()<Reg.boardSize*Reg.boardSize/40000)
                setCell(Math.floor(Math.random()*Reg.boardSize), Math.floor(Math.random()*Reg.boardSize), 3);
        }
    }

    //Initialises the "hole counting" flood fill
    public function beginCount():Void {

        countQueues = [];
        countChecks = [];

        for (i in 0 ... 2) {
            var startCell = cells[players[i].tx][players[i].ty];
            countQueues[i] = new Queue<Cell>();
            countQueues[i].enqueue(startCell);

            countChecks[i] = [];
            for (j in 0 ... Reg.boardSize) {
                countChecks[i][j] = [];
                for (k in 0 ... Reg.boardSize) {
                    countChecks[i][j][k] = !openCell(j, k);
                }
            }
        }

        countStep();

    }

    //Iterative step of the "hole counting" flood fill
    public function countStep():Void {
        var cont:Bool = false;
        for(i in 0 ... 2) {
            if(countQueues[i].empty()) {
                continue;
            }
            else {
                cont = true;
                var n = countQueues[i].dequeue();

                n.setValue(4+i);

                //Add neighbours to queue
                if(n.tx > 0 && !countChecks[i][n.tx-1][n.ty]) { 
                    countQueues[i].enqueue(cells[n.tx-1][n.ty]);
                    countChecks[i][n.tx-1][n.ty] = true;
                }
                if(n.tx < Reg.boardSize-1 && !countChecks[i][n.tx+1][n.ty]) {
                    countQueues[i].enqueue(cells[n.tx+1][n.ty]);
                    countChecks[i][n.tx+1][n.ty] = true;
                }
                if(n.ty > 0 && !countChecks[i][n.tx][n.ty-1]) {
                    countQueues[i].enqueue(cells[n.tx][n.ty-1]);
                    countChecks[i][n.tx][n.ty-1] = true;
                }
                if(n.ty < Reg.boardSize-1 && !countChecks[i][n.tx][n.ty+1]) {
                    countQueues[i].enqueue(cells[n.tx][n.ty+1]);
                    countChecks[i][n.tx][n.ty+1] = true;
                }
            }
        }
        if(cont) {
            new FlxTimer((1/Math.pow(Reg.boardSize, 1.5)), function(_){countStep();});
        }
    }

    //Swap cell out for new valued version
    public function replaceCell(_x:Int, _y:Int, _cell:Cell):Void {
        oldCells.remove(cells[_x][_y]);
        cells[_x][_y] = _cell;
        newCells.remove(_cell);
        oldCells.add(_cell);
    }

    //
    public function openCell(_x:Int, _y:Int):Bool {
        return cells[_x][_y].getValue() == 0;
    }


    public function setCell(_x:Int, _y:Int, _value:Int):Void {
        cells[_x][_y].setValue(_value);
    }

    public function getX(_x:Int):Int {
        return Math.round(600 * (_x+0.5) / (Reg.boardSize)) + x;
    }

    public function getY(_y:Int):Int {
        return Math.round(600 * (_y+0.5) / (Reg.boardSize)) + FlxG.height - y - height;
    }

    //Checks if the two players are connected in grid space.
    public function checkConnected():Bool {

        var checked:Array<Array<Bool>> = [];
        for (i in 0 ... Reg.boardSize) {
            checked[i] = [];
            for(j in 0 ... Reg.boardSize) {
                checked[i][j] = false;
            }
        }

        var nodes = new Queue();
        nodes.enqueue(cells[players[0].tx][players[0].ty]);

        while(!nodes.empty()) {
            var n = nodes.dequeue();
            if(players[1].tx == n.tx && players[1].ty == n.ty) {
                return true;
            }
            //Add neighbours to queue
            if(n.tx > 0 && openCell(n.tx-1,n.ty) && !checked[n.tx-1][n.ty]
                || (players[1].tx == n.tx-1 && players[1].ty == n.ty)) { 
                nodes.enqueue(cells[n.tx-1][n.ty]);
                checked[n.tx-1][n.ty] = true;
            }
            if(n.tx < Reg.boardSize-1 && openCell(n.tx+1,n.ty) && !checked[n.tx+1][n.ty]
                || (players[1].tx == n.tx+1 && players[1].ty == n.ty)){
                nodes.enqueue(cells[n.tx+1][n.ty]);
                checked[n.tx+1][n.ty] = true;
            }
            if(n.ty > 0 && openCell(n.tx,n.ty-1) && !checked[n.tx][n.ty-1]
                || (players[1].tx == n.tx && players[1].ty == n.ty-1)){
                nodes.enqueue(cells[n.tx][n.ty-1]);
                checked[n.tx][n.ty-1] = true;
            }
            if(n.ty < Reg.boardSize-1 && openCell(n.tx,n.ty+1) && !checked[n.tx][n.ty+1]
                || (players[1].tx == n.tx && players[1].ty == n.ty+1)){
                nodes.enqueue(cells[n.tx][n.ty+1]);
                checked[n.tx][n.ty+1] = true;
            }
        }

        return false;

    }

}

class Queue<T> {

    var head:QueueElem<T>;
    var tail:QueueElem<T>;

    public function new():Void {}

    public function enqueue(_e:T) {
        var e = new QueueElem(_e);
        if(head == null) head = e;
        if(tail == null) 
            tail = e;
        else {
            tail.addNext(e);
            tail = tail.getNext();
        }
    }

    public function dequeue():T {
        var t = head;
        head = head.getNext();
        return t.getVal();
    }

    public function empty():Bool { 
        return head == null; 
    }

}

class QueueElem<T> {
    var val:T;
    var next:QueueElem<T>;

    public function new   (_val:T):Void { 
        val = _val; 
    }

    public function getVal():T {
        return val;
    }

    public function addNext(_next:QueueElem<T>):Void {
        next = _next;
    }

    public function getNext():QueueElem<T> {
        return next;
    }
}