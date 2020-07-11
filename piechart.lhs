> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts          #-}
> {-# LANGUAGE TypeFamilies              #-}
>
> import Diagrams.Prelude
> import Diagrams.Backend.SVG.CmdLine
>
> percents = [25,15,30,10,20]           -- make sure these add up to 100
> categories = ["first","second","third","fourth","fifth"]
> n = fromIntegral $ length percents
> h = round $ n/2
> wedges = (*3.6) <$> scanl1 (+) percents
>
> -- if there are over 11 percentages, need to add more by hand
> darks c = [(blend 0.70 c black),(blend 0.50 c black),(blend 0.40 c black),(blend 0.30 c black),(blend 0.20 c black)]
> lites c = [(blend 0.95 c gray), (blend 0.85 c gray), (blend 0.75 c gray), (blend 0.65 c gray), (blend 0.55 c gray)]
> shades c
>  | (even n)  = [c] ++ take h (darks c) ++ (reverse $ take (h-1) (lites c)) -- favoring darks over lights
>  | otherwise = [c] ++ take h (darks c) ++ (reverse $ take  h    (lites c))
> 
> mids [x] = []
> mids (x:y:xs) = (x + 0.5*(y-x)) : mids (y:xs)
> midpoints = mids (scanl (+) 0 percents)
> 
> labels d  []     []     []    = mempty
> labels d (w:ws) (p:ps) (m:ms) = ( ((text w # scale 0.15 === strutY 0.15 === text (show p ++ "%") # scale 0.11)
>                                 # rotate (-3.6*m @@ deg))                 -- inner rotation (to keep text straight)
>                                 # translateX d # rotate (3.6*m @@ deg) )  -- outer rotation around origin
>                                 <> labels d ws ps ms
> annotations d = labels d categories percents midpoints
> 
> -- Customize wedge thickness (closer to 1 --> thinner wedge)
> hollowPie (pct,clr) = annularWedge 1 0.55 xDir (pct @@ deg) # fc clr
> -- Customize the color(s) here
> colors = shades red
>
> example :: Diagram B
> example = (mconcat $ map hollowPie $ zip wedges colors)
>           <> (text "100"     # scale 0.50 # translateY 0.1 === strutY 0.3 === 
>               text "percent" # scale 0.25)
>           <> annotations 1.3                -- how far labels are from border
>           <> circle 1.5 # lc white          -- keeps labels from being cut off
>
> main = mainWith example
>
> -- To convert SVG to PDF, use one of the following links:
> --  1) https://document.online-convert.com/convert/svg-to-pdf
> --  2) https://www.zamzar.com/convert/svg-to-pdf/ 
> -- NB: the middle text will be higher up than in the SVG version
>