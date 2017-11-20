import UIKit



class MyLabel: UILabel {
    var intNum : Int!
    var isFound : Bool?
}



class ViewController: UIViewController
{
    @IBOutlet weak var gameView: UIView!
    
    var gameMode : Int!
    var compareMode : Bool! = false;
    var tilesArr: Array < MyLabel>! = []
    var centsArr: Array < CGPoint>! = []
    
    var fTile: MyLabel?
    var sTile: MyLabel?
    
    @IBOutlet weak var timerLabel: UILabel!
    
    var gameTimer : Timer!
    var curTime : Int!
    
    @IBAction func restartFunc(_ sender: Any)
    {
        for any in gameView.subviews
        {
            any.removeFromSuperview()
        }

        tilesArr = [];
        centsArr = [];
        
        compareMode = false;
        
        buildTiles();
        
        randomizeTiles()
        
        curTime = 0;
        gameTimer = Timer.scheduledTimer(timeInterval: 1,
                               target: self,
                               selector: #selector(timeFunc),
                               userInfo: nil,
                               repeats: true)
    }
    
    @objc func timeFunc ()
    {
        curTime = curTime + 1;
        
        let mins : Int = curTime / 60;
        let secs : Int = curTime % 60;
        
        let timeStr = String (mins) + "\' : " + String(secs) + "\"";
        print(timeStr)
        timerLabel.text = timeStr;
    }
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        gameMode = 4;
        buildTiles();
        
        
        randomizeTiles()
    }
    
    
    func randomizeTiles ()
    {
        
        for any: MyLabel in tilesArr
        {
            let randIndex = Int(arc4random()) %  centsArr.count
            any.center = centsArr[randIndex];
            centsArr.remove(at: randIndex)
            any.text = "?";
        }
    }
    
    
    
    func buildTiles ()
    {
        let tileW: CGFloat = gameView.frame.size.width / CGFloat( gameMode);
        
        
        var xCen = tileW / 2;
        var yCen = tileW / 2;
        
        for v in 0 ..< gameMode
        {
            for h in 0..<gameMode
            {
                let frame: CGRect = CGRect(x: 0, y: 0, width: tileW-2, height: tileW-2)
                let tile : MyLabel = MyLabel(frame: frame)
                
                let cen = CGPoint(x: xCen, y: yCen)
                tile.center = cen
                tilesArr.append(tile);
                centsArr.append(cen);
                tile.isFound = false;
                
                var num = v*gameMode + h + 1;
                if ( num > gameMode * gameMode / 2)
                {
                    num -= (gameMode * gameMode / 2)
                }
                
                // 2 arrays
                // for the tiles, in order
                // for centers, in order
                
                
                tile.text = String(num )
                tile.intNum = num;
                tile.isUserInteractionEnabled = true
                
                tile.textAlignment = NSTextAlignment.center;
                tile.font = UIFont.systemFont(ofSize: 40 )
                tile.backgroundColor = UIColor.purple
                
                gameView.addSubview(tile)
                xCen += tileW;
            }
            
            yCen += tileW;
            xCen = tileW / 2
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        let myTouch : UITouch = touches.first!;
        
        if ( !tilesArr.contains(myTouch.view as! MyLabel) )
        {
            return
        }
        
        

        let thisTile : MyLabel = myTouch.view as! MyLabel;
        
        UIView.transition(with: thisTile,
                          duration: 0.5,
                          options: UIViewAnimationOptions.transitionFlipFromRight,
                          animations: {
                            thisTile.text = String (thisTile.intNum)
                            thisTile.backgroundColor = UIColor.orange
                                },
                          completion:
            { (true) in
                if ( self.compareMode )
                {
                    self.sTile = thisTile;
                    self.compareMode = false;
                    
                    
                    self.compareFunc(firstTile: self.fTile!,
                                     secondTile: self.sTile!);
                }
                else
                {
                    self.fTile = thisTile;
                    self.compareMode = true;
                }
            })
    }
    
    func compareFunc (firstTile: MyLabel, secondTile: MyLabel)
    {
        if ( firstTile.intNum == secondTile.intNum)
        {
            UIView.animate(withDuration: 0.5, animations: {
                firstTile.text = "😀";
                firstTile.backgroundColor = UIColor.green;
                secondTile.text = "😀";
                secondTile.backgroundColor = UIColor.green;
                
                firstTile.isFound = true;
                secondTile.isFound = true;
                
                firstTile.isUserInteractionEnabled = false;
                secondTile.isUserInteractionEnabled = false;
              
                self.checkForWin()
            })
        }
        else
        {
            self.flipThemBack(inpTiles: [firstTile, secondTile]);
        }
    }
    
    func checkForWin ()
    {
        for any: MyLabel in tilesArr
        {
            if ( any.isFound == false)
            {
                return;
            }
        }
        
        print("Won")
    }
    
    
    
    
    func flipThemBack (inpTiles : Array <MyLabel>)
    {
        for any: MyLabel in inpTiles
        {
            UIView.transition(with: any,
                              duration: 0.5,
                              options: UIViewAnimationOptions.transitionFlipFromRight,
                              animations: {
                                any.text = "?"
                                any.backgroundColor = UIColor.purple
            }, completion: nil);
        }
    }
    
}










