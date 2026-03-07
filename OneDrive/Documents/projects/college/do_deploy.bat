@echo off
cd C:\Users\durai

REM Remove temp files
del /q "OneDrive\Documents\projects\college\git_push.bat" 2>nul
del /q "OneDrive\Documents\projects\college\git_push2.bat" 2>nul
del /q "OneDrive\Documents\projects\college\git_final.bat" 2>nul
del /q "OneDrive\Documents\projects\college\git_verify.bat" 2>nul
del /q "OneDrive\Documents\projects\college\commit_result.txt" 2>nul
del /q "OneDrive\Documents\projects\college\commit_result2.txt" 2>nul
del /q "OneDrive\Documents\projects\college\commit_final.txt" 2>nul
del /q "OneDrive\Documents\projects\college\verify.txt" 2>nul
del /q "OneDrive\Documents\projects\college\gitlog_result.txt" 2>nul
del /q "OneDrive\Documents\projects\college\run_git.bat" 2>nul

REM Stage cleanup and amend commit
git add "OneDrive/Documents/projects/college/" 2>nul
git commit --amend -m "Remove all mock data and demo login for production readiness" 2>nul > "OneDrive\Documents\projects\college\push_result.txt"

REM Push to GitHub
echo === PUSHING === >> "OneDrive\Documents\projects\college\push_result.txt"
git push origin main --force-with-lease >> "OneDrive\Documents\projects\college\push_result.txt" 2>&1

REM Deploy to Firebase
echo === DEPLOYING === >> "OneDrive\Documents\projects\college\push_result.txt"
cd "OneDrive\Documents\projects\college"
firebase deploy --only hosting >> push_result.txt 2>&1

echo === ALL DONE === >> push_result.txt
