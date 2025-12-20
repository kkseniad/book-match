document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".tabs").forEach(tabsContainer => {
    const tabs = tabsContainer.querySelectorAll(".tab");
    const contents = document.querySelectorAll(".tab-content");

    tabs.forEach(tab => {
      tab.addEventListener("click", () => {
        const name = tab.dataset.tab;

        // Deactivate all tabs in this group
        tabs.forEach(t => t.classList.remove("active"));

        // Hide matching content
        contents.forEach(c => {
          c.classList.toggle("active", c.dataset.content === name);
        });

        // Activate clicked tab
        tab.classList.add("active");
      });
    });
  });
});
