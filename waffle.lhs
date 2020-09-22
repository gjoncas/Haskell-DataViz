> {-# LANGUAGE NoMonomorphismRestriction #-}
> {-# LANGUAGE FlexibleContexts          #-}
> {-# LANGUAGE TypeFamilies              #-}
>
> import Diagrams.Prelude
> import Diagrams.Backend.SVG.CmdLine
> 
> colour = purple -- sRGB 0.463 0.0 0.196  --burgundy
> mytitle = "Chart title"
> spacing = 0.25
> myshape = square 1
>
> labels   = ["A","B","C","D","E"]
> percents = [16,36,15,32,1]                    --NB: must add up to 100
> --colours  = [red,blue,green,yellow,deeppink]
> colours  = shades colour
> n = fromIntegral $ length percents
> h = round $ n/2
>
> -- All colors are shades of main color (if over 7 percentages, add more by hand)
> darks c = [(blend 0.1 c black),(blend 0.4 c black),(blend 0.7 c black),(blend 0.9 c black)]
> lites c = [(blend 0.9 c white),(blend 0.6 c white),(blend 0.4 c white)]
> shades c
>  | (even n)  = take h (darks c) ++ [c] ++ (take (h-1) (lites c)) -- favoring darks over lights
>  | otherwise = take h (darks c) ++ [c] ++ (take  h    (lites c))
>
> allcolors    []     []  = []
> allcolors    _      []  = error "More percents than colors"
> allcolors    []     _   = error "More colors than percents"
> allcolors (p:ps) (c:cs) = replicate p c ++ allcolors ps cs
>
> -- split colors into groups of 10, for each row/column
> rowcolors :: [a] -> [[a]]
> rowcolors [] = []
> rowcolors cs = (take 10 cs) : rowcolors (drop 10 cs)
>
> colorList :: (Ord a, Floating a) => [[Colour a]]
> colorList = rowcolors $ allcolors percents colours
> 
> line    []  = mempty
> line (c:cs) = (myshape # fc c # lw none) : line cs     --or: lc c # lw veryThin
>
> grid  xs = vsep spacing $ map (hsep spacing . line) xs --grid going up, horizontally
> grid' xs = hsep spacing $ map (vsep spacing . line) xs --grid going right, vertically
>
> legend     []    []  = mempty
> legend (c:cs) (l:ls) = (hsep 0.5 [myshape # fc c # lw none, baselineText l # translateY (-0.3) # scale 0.6]) : legend cs ls
>
> example :: Diagram B
> example = hsep 1.5 [vsep (1.25) [ --reverse the order to get title on top
>                                  grid colorList,
>                                  text mytitle # translateX (5*(1+spacing)-spacing)
>                                 ],
>                     vsep spacing (legend colours labels)
>                     ] # pad 1.1
>
> main = mainWith example
>
> {- NOTES:
> - To group the shapes by column, just use grid' instead of grid in example
> - Need to adjust size for each shape, e.g. circle 0.5 instead of square 1
> - I haven't added a legend title, but it should be easy: just use vsep again
>       - the legend items should be self-explanatory from the title anyway
> - Need to manually adjust padding for long legend names (unavoidable)
> - vertical centering for legend: (vsep spacing (legend colours labels)) # translateX (-5*(1+spacing)-spacing)
> - The shading is a pain in the ass, and likely needs to be adjusted if you're using a weird color
> -}