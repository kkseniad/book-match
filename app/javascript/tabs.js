document.addEventListener("DOMContentLoaded", () => {
  const tabs = document.querySelectorAll(".tab");
  const contents = document.querySelectorAll(".tab-content");

  function activateTab(tabName) {
    tabs.forEach(tab => {
      tab.classList.toggle("active", tab.dataset.tab === tabName);
    });

    contents.forEach(content => {
      content.classList.toggle(
        "active",
        content.dataset.content === tabName
      );
    });
  }

  tabs.forEach(tab => {
    tab.addEventListener("click", () => {
      activateTab(tab.dataset.tab);
    });
  });

  document.querySelectorAll(".clickable-stat").forEach(stat => {
    stat.addEventListener("click", () => {
      activateTab(stat.dataset.tabTarget);
    });
  });
});
