> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts          #-}
> {-# LANGUAGE TypeFamilies              #-}
>
> import Diagrams.Prelude
> import Diagrams.Backend.SVG.CmdLine
>
> percents = [71.1,57.9,52.6,42.1]                --inner to outer; looks better if biggest to smallest
> category = ["first","second","third","fourth"]  --counterclockwise wedges, labels
> extrapct = [10.0,28.9]
> extracat = ["extra1","extra2"]                  --clockwise wedges, labels
> spacings = [1.35, 1.35, 1.35, 1.5]              --label positions (note: last one is further out)
> howWide  = 0.15                                 --width of wedges
> wedges   = (*3.6) <$> percents                  --counterclockwise wedges, in degrees
> xwedges  = (*3.6) <$> extrapct                  --clockwise wedges, in degrees
>
> dark c  = blend 0.5 c black                            --customize colors:
> colors  = [dark red,dark purple,dark green,dark blue]  --counterclockwise wedges
> xcolors = [dark pink, dark yellow]                     --clockwise wedges
> mcircle = blend 0.15 gray white                        --middle circle
> 
> labels    []     []     []     []    = mempty
> labels (d:ds) (w:ws) (p:ps) (m:ms) = ( ((text w # scale 0.15 # bold === strutY 0.2 === text (show p ++ "%") # scale 0.12)
>                                      # rotate (-1*m @@ deg))               -- inner rotation (to keep text straight)
>                                      # translateX d # rotate (m @@ deg) )  -- outer rotation around origin
>                                      <> labels ds ws ps ms
> annotations  = labels spacings category percents wedges
> extranotes d = labels d extracat extrapct ((*(-1.8)) <$> extrapct)
> 
> multiPie' d w [] = []
> multiPie' d w ((pct,clr,n):ts) = annularWedge (0.5+n*w) (0.5+(n-1)*w) xDir    -- how wide the wedge is (assumed n starts at 1)
>                                  (d*pct @@ deg)                               -- clockwise (-1) or counter (1)
>                                  # fc clr # lc clr : multiPie' d w ts         -- colors
> multiPie ts = multiPie'   1  howWide ts
> extraPie ts = multiPie' (-1) howWide ts
>
> example :: Diagram B
> example =    (mconcat $ multiPie $ zip3  wedges  colors [1..])                     -- counterclockwise wedges
>           <> (mconcat $ multiPie $ zip3 xwedges xcolors [2,3])                     -- clockwise wedges
>           <> (text "Center" # scale 0.25 # translateY 0.1 === strutY 0.3 === 
>               text "label"  # scale 0.25) <> circle 0.5 # fc mcircle # lc mcircle  -- middle circle
>           <> annotations <> extranotes [1.3,1.3]                                   -- labels
>           <> unitCircle # scaleX 1.65 # lc white                                   -- keeps labels from being cut off
>
> main = mainWith example
>
> -- To convert SVG to PDF, use one of the following links:
> --  1) https://document.online-convert.com/convert/svg-to-pdf
> --  2) https://www.zamzar.com/convert/svg-to-pdf/ 
>
> -- NB: Code will break if percents, categories & colors don't have the same number of entries
> --     May need manual adjustment so that clockwise & counterclockwise wedges don't overlap