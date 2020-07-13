# power by @xyb
import os
import parseopt
import strformat
import strutils

import nicypkg/functions

let
  prompt = uidsymbol(root = color("#", fg = red, bg = white),
                     user = color("$", green))
  nl = "\n"
  cwd = color(tilde(getCwd(suffix = " ")), cyan)
  venv = virtualenv(suffix = " ")

  ahead = color("⬆ ", yellow)
  behind = color("⬇ ", yellow)
  untracked = color("?", yellow)
  changed = color("✎", yellow)
  staged = color("✔ ", yellow)
  conflicted = color("✼", yellow)
  stash = color("⎘", yellow)

  gs = newGitStats()
  gitStatus = gs.status(ahead, behind, untracked, changed, staged,
    conflicted, stash)
  gitBranch = color(gs.branch(), yellow)
  git = gitBranch & gitStatus

var
  jobs = ""
  exitStatus = ""
  lastRun = ""
  p = initOptParser(commandLineParams().join(" "))

while true:
  p.next()
  case p.kind
  of cmdEnd:
    break
  of cmdShortOption, cmdLongOption:
    if p.val.len == 0:
      continue
    case p.key
    of "e", "exit-status":
      exitStatus = numberCondition(p.val, notZero = color(p.val, red))
    of "j", "jobs":
      let haveJobs = color(jobs(p.val), cyan)
      jobs = numberCondition(p.val, notZero = haveJobs)
    of "s", "run-seconds":
      let longRun = color(runtime(p.val), yellow)
      lastRun = numberCondition(p.val, notZero = longRun)
    else:
      discard
  of cmdArgument:
    discard

# the prompt
echo fmt"{nl}{venv}{cwd}{git}{lastRun}{nl}{jobs}{exitStatus}{prompt} "
