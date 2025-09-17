// 버튼 클릭 이벤트
document.getElementById("btn").addEventListener("click", () => {
  alert("버튼을 눌렀네요! 🎉 환영합니다!");
});

// 다크 모드 토글
const toggleBtn = document.getElementById("darkModeToggle");
toggleBtn.addEventListener("click", () => {
  document.body.classList.toggle("dark");

  // 버튼 텍스트 변경
  if (document.body.classList.contains("dark")) {
    toggleBtn.textContent = "☀️ 라이트 모드";
  } else {
    toggleBtn.textContent = "🌙 다크 모드";
  }
});

