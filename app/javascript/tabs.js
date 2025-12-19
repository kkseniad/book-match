document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".tabs").forEach(tabsContainer => {
    const container = tabsContainer.parentElement;
    const tabs = tabsContainer.querySelectorAll(".tab");
    const contents = container.querySelectorAll(".tab-content");

    tabs.forEach(tab => {
      tab.addEventListener("click", () => {
        const name = tab.dataset.tab;

        // Deactivate tabs
        tabs.forEach(t => t.classList.remove("active"));

        // Hide all content in THIS container only
        contents.forEach(c => c.classList.remove("active"));

        // Activate clicked tab
        tab.classList.add("active");

        // Show matching content
        const activeContent = container.querySelector(
          `.tab-content[data-content="${name}"]`
        );

        if (activeContent) {
          activeContent.classList.add("active");
        }
      });
    });
  });
});
