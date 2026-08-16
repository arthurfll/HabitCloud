namespace Core.Source.Models;

public static class CategoryOptions
{
    public const int MaxCategoriesPerUser = 20;
    public const int PageSize = 10;

    public static readonly IReadOnlyList<string> Icons = new[]
    {
        "bi-briefcase", "bi-laptop", "bi-building", "bi-clipboard-check",
        "bi-heart-pulse", "bi-bicycle", "bi-trophy", "bi-activity",
        "bi-book", "bi-moon-stars", "bi-brightness-high", "bi-stars",
        "bi-mortarboard", "bi-pencil", "bi-journal-text",
        "bi-cup-hot", "bi-egg-fried", "bi-apple",
        "bi-wallet2", "bi-cash-coin", "bi-piggy-bank",
        "bi-house", "bi-alarm", "bi-brush",
        "bi-controller", "bi-music-note-beamed", "bi-palette", "bi-camera",
        "bi-people", "bi-chat-heart",
        "bi-moon", "bi-droplet", "bi-tree",
    };

    public static readonly IReadOnlyList<string> Colors = new[]
    {
        "#0d6efd", "#6610f2", "#6f42c1", "#d63384",
        "#dc3545", "#fd7e14", "#ffc107", "#198754",
        "#20c997", "#0dcaf0", "#0d9488", "#84cc16",
        "#f43f5e", "#6c757d", "#495057", "#212529",
    };

    public static bool IsValidIcon(string? icon) => icon is not null && Icons.Contains(icon);

    public static bool IsValidColor(string? color) => color is not null && Colors.Contains(color);
}
