> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts          #-}
> {-# LANGUAGE TypeFamilies              #-}
>
> import Diagrams.Prelude
> import Diagrams.Backend.SVG.CmdLine
>
> colors = [sRGB (123/255) (192/255) (247/255), --cyan   --outer to inner
>           sRGB (059/255) (138/255) (217/255), --blue
>           sRGB (241/255) (130/255) (038/255), --orange
>           sRGB (255/255) (219/255) (105/255)] --yellow
>
> categories = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"]
> wedgeWidths = take 12 $ repeat (100/12)  --units are in percentage points, e.g. 33.3
> percents = [[12814,3054,4376,4229],
>   {-Feb-}   [8814,5067,13987,3932],
>   {-Mar-}   [11624,7004,3574,5221],
>   {-Apr-}   [8814,9054,4376,5256],
>   {-May-}   [9998,5043,4572,3308],
>   {-Jun-}   [12321,15067,3417,5432],
>   {-Jul-}   [10342,10119,9231,9701],
>   {-Aug-}   [4814,3054,4376,4229],
>   {-Sep-}   [8814,5067,3987,3932],
>   {-Oct-}   [11624,17004,3574,5221],
>   {-Nov-}   [8814,9054,4376,9256],
>   {-Dec-}   [12998,8814,4572,3308]]
> proportions n = map (sum . (drop n)) percents           --total number for each wedge(/month)
> total = sum $ proportions 0
> heights n = map ((*100) . (/total)) (proportions n)     --percentage for each wedge out of total
> maxHeight  = maximum $ heights 0
> endings = (*3.6) <$> wedgeWidths                        --units are in degrees
> starts  = (negate . (/100)) <$> scanl1 (+) wedgeWidths  --units are in percent, e.g. 0.33
> nlayers = length colors                                 --number of layers; need at least 2
>
> mids [x] = []
> mids (x:y:xs) = (x + 0.5*(y-x)) : mids (y:xs)
> midpoints = mids (scanl (+) 0 wedgeWidths)
>
> labels d  []     []     []    _ = mempty
> labels d (w:ws) (p:ps) (m:ms) s = ( ((text w # scale 0.85)
>                                   # rotate (s*90 @@ deg))                       -- inner rotation (orienting text)
>                                   # translateX d # rotate (((-3.6)*m) @@ deg) ) -- outer rotation around origin
>                                   <> labels d ws ps ms s
> q = floor $ (fromIntegral $ length categories) / 4    --short for quadrant
> -- first and last quadrants rotated by -90, middle quadrants rotated by 90
> annotations d = labels (maxHeight+d) (take q categories) (take q wedgeWidths) (take q midpoints) (-1) <>
>                 labels (maxHeight+d) (take (2*q) $ drop q categories) (take (2*q) $ drop q wedgeWidths) (take (2*q) $ drop q midpoints) (1) <>
>                 labels (maxHeight+d) (drop (3*q) categories) (drop (3*q) wedgeWidths) (drop (3*q) midpoints) (-1)
> --annotations d = labels (maxHeight+d) categories wedgeWidths midpoints
>
> piePiece (hgt,pos,pct) = wedge hgt (rotateBy pos xDir) (pct @@ deg)
> pieLayer n c = (mconcat $ map piePiece $ zip3 (heights n) starts endings) # fc c # lc (blend 0.8 c black)
>
> example :: Diagram B
> example = annotations 1 <> (mconcat $ map (\n -> pieLayer n (colors !! n)) [(nlayers-1),(nlayers-2)..0])
>
> main = mainWith (example # rotateBy (1/4) # pad 1.1)
>
>{- TO DO:
> - Annotations should be(?) for wedge height (% of observations), not wedge width (% of time period)
> - Write a function to shift sections (e.g. move the 2nd-innermost to innermost)
> - Option: circles radiating from the center to indicate magnitude (e.g. every 5%)
> - Experiment with ways to blend colors
> - [[12814,3054,4376,4229],[8814,5067,13987,3932],[11624,7004,3574,5221],[8814,9054,4376,5256],[9998,5043,4572,3308],[12321,15067,3417,5432],[10342,10119,9231,9701],[4814,3054,4376,4229],[8814,5067,3987,3932],[11624,17004,3574,5221],[8814,9054,4376,9256],[12998,8814,4572,3308]]
> 
> -- To convert SVG to PDF, use one of the following links:
> --  1) https://document.online-convert.com/convert/svg-to-pdf
> --  2) https://www.zamzar.com/convert/svg-to-pdf/ 
> -- NB: the middle text will be higher up than in the SVG version
>-}