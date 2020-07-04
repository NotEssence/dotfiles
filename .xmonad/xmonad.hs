-- My XMonad Config

import Control.Monad

import XMonad

-- Hooks
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))

-- Utils
import XMonad.Util.Run
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig
import XMonad.Util.SpawnOnce

-- Actions
import XMonad.Actions.WithAll
import XMonad.Actions.Promote
import XMonad.Actions.CycleWS
import XMonad.Actions.RotSlaves
import XMonad.Actions.CopyWindow
import XMonad.Actions.DynamicWorkspaces

-- Layout
import XMonad.Layout.LayoutModifier
import XMonad.Layout.ResizableTile
import XMonad.Layout.Spacing

-- Prompts
import XMonad.Prompt
import XMonad.Prompt.Input
import XMonad.Prompt.FuzzyMatch
import XMonad.Prompt.Man
import XMonad.Prompt.Pass
import XMonad.Prompt.Shell (shellPrompt)
import XMonad.Prompt.Ssh
import XMonad.Prompt.XMonad
import Control.Arrow (first)

import Data.Monoid
import System.Exit

import qualified XMonad.StackSet as W
import qualified Data.Map        as M

confirm :: [String] -> String -> X () -> X ()
confirm opts opt f = do
    response <- dmenu opts
    when (response == opt) f

myTerminal = "kitty"

myFocusFollowsMouse = True
myClickJustFocuses  = False

myBorderWidth   = 2

myModMask       = mod4Mask -- Super
-- myWorkspaces    = ["1","2","3","4","5","6","7","8","9"]

xmobarEscape :: String -> String
xmobarEscape = concatMap doubleLts
   where  doubleLts '<' = "<<"
          doubleLts x   = [x]

myWorkspaces :: [String]
myWorkspaces = ["dev", "www", "sys", "doc", "vbox", "chat", "mus", "vid", "gfx"]

myNormalBorderColor  = "#292d3e"
myFocusedBorderColor = "#bbc5ff"

------------------------------------------------------------------------
-- Layouts
------------------------------------------------------------------------

mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

myLayout = avoidStruts (tiled ||| Mirror tiled ||| Full)
  where
     -- default tiling algorithm partitions the screen into two panes
     tiled   = mySpacing 6 $ Tall nmaster delta ratio
     full    = mySpacing 6 $ Full

     -- The default number of windows in the master pane
     nmaster = 1

     -- Default proportion of screen occupied by master pane
     ratio   = 1/2

     -- Percent of screen to increment by when resizing panes
     delta   = 3/100

------------------------------------------------------------------------
-- Key & Mouse Bindings
------------------------------------------------------------------------

myKeys :: [(String, X ())]
myKeys =
  -- XMonad
    [ ("M-r", spawn "xmonad --recompile; xmonad --restart")
    , ("M-q", confirm ["Cancel", "Quit"] "Quit" $ io exitSuccess)

  -- Apps
    , ("M-<return>", spawn myTerminal)
    , ("M-p",        spawn "dmenu_run -fn \"Mononoki\" -l 10 -p \"dmenu:\"")

    , ("M-a e", spawn "emacsclient -c -a ''")
    , ("M-a f", spawn "firefox")
    , ("M-a n", spawn "nautilus")

    , ("M-a k", spawn $ myTerminal ++ " sh -c \"kak\"")
    , ("M-a c", spawn $ myTerminal ++ " sh -c \"kak ~/.xmonad/xmonad.hs\"")

  -- Windows
    , ("M-S-c", kill1)
    , ("M-S-a", killAll)

  -- Navigation
    , ("M-m", windows W.focusMaster)
    , ("M-j", windows W.focusDown)
    , ("M-k", windows W.focusUp)

    , ("M-S-j", windows W.swapDown)
    , ("M-S-k", windows W.swapUp)
    , ("M-<backspace>", promote)

    , ("M1-C-<Tab>", rotSlavesDown)
    , ("M1-S-<Tab>", rotAllDown)
  -- Layouts
    , ("M-<Tab>", sendMessage NextLayout)

    , ("M-h",   sendMessage Shrink)
    , ("M-S-l", sendMessage Expand)
    , ("M-C-j", sendMessage MirrorShrink)
    , ("M-C-k", sendMessage MirrorExpand)
  -- Emacs
    , ("C-e e", spawn "emacsclient -c -a ''")
    , ("C-e b", spawn "emacsclient -c -a '' --eval (ibuffer)")
    , ("C-e d", spawn "emacsclient -c -a '' --eval (dired nil)")
    , ("C-e s", spawn "emacsclient -c -a '' --eval (eshell)")
  -- Workspaces
    , ("M-S-n", nextWS)
    , ("M-S-p", prevWS)

    , ("M-1", windows $ W.greedyView "dev")
    , ("M-2", windows $ W.greedyView "www")
    , ("M-3", windows $ W.greedyView "sys")
    , ("M-4", windows $ W.greedyView "doc")
    , ("M-5", windows $ W.greedyView "vbox")
    , ("M-6", windows $ W.greedyView "chat")
    , ("M-7", windows $ W.greedyView "mus")
    , ("M-8", windows $ W.greedyView "vid")
    , ("M-9", windows $ W.greedyView "gfx")
    ]

myMouse =
    [ ((myModMask, button1), (\w -> focus w >> mouseMoveWindow w
                                            >> windows W.shiftMaster))
    , ((myModMask, button2), (\w -> focus w >> windows W.shiftMaster))
    , ((myModMask, button3), (\w -> focus w >> mouseResizeWindow w
                                            >> windows W.shiftMaster))
    ]

------------------------------------------------------------------------
-- Main
------------------------------------------------------------------------

myManageHook = composeAll
    [ className =? "MPlayer"        --> doFloat
    , className =? "Gimp"           --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "kdesktop"       --> doIgnore ]

myEventHook = mempty
myLogHook = return ()

myStartupHook = do
    spawnOnce "nitrogen --restore &"
    spawnOnce "compton &"
    spawnOnce "emacs --daemon &"

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

main = do
    xmproc <- spawnPipe "xmobar /home/theloompa/.config/xmobar/xmobar.config"
    xmonad $ docks $ def
        -- simple stuff
        { terminal           = myTerminal
        , focusFollowsMouse  = myFocusFollowsMouse
        , clickJustFocuses   = myClickJustFocuses
        , borderWidth        = myBorderWidth
        , modMask            = myModMask
        , workspaces         = myWorkspaces
        , normalBorderColor  = myNormalBorderColor
        , focusedBorderColor = myFocusedBorderColor

        -- hooks, layouts
        , layoutHook         = myLayout
        , manageHook         = myManageHook
        , handleEventHook    = myEventHook
        , logHook            = myLogHook <+> dynamicLogWithPP xmobarPP
                                 { ppOutput = \x -> hPutStrLn xmproc x
                                   , ppCurrent = xmobarColor "#c3e88d" "" . wrap "[" "]" -- Current workspace in xmobar
                                   , ppVisible = xmobarColor "#c3e88d" ""                -- Visible but not current workspace
                                   , ppHidden  = xmobarColor "#82AAFF" "" . wrap "*" ""  -- Hidden workspaces in xmobar
                                   , ppHiddenNoWindows =  xmobarColor "#c3e88d" "" . wrap "[" "]" -- Only shows visible workspaces. Useful for TreeSelect.
                                   , ppTitle  = xmobarColor "#d0d0d0" "" . shorten 60    -- Title of active window in xmobar
                                   , ppSep    =  "<fc=#666666> | </fc>"                  -- Separators in xmobar
                                   , ppUrgent = xmobarColor "#C45500" "" . wrap "!" "!"  -- Urgent workspace
                                   , ppExtras = [windowCount]                            -- # of windows current workspace
                                   , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
                                 }
        , startupHook        = docksStartupHook <+> myStartupHook
        } `additionalKeysP` myKeys
          `additionalMouseBindings` myMouse

