using Core.Source.Models;

namespace Core.Source.Models.Dtos.Sync;

public class SyncRequestDto
{
    public DateTime? LastSyncedAt { get; set; }
    public List<CategorySyncItemDto> Categories { get; set; } = new();
    public List<HabitSyncItemDto> Habits { get; set; } = new();
    public List<HabitEntrySyncItemDto> HabitEntries { get; set; } = new();
}

public class CategorySyncItemDto
{
    /// <summary>Null when the record was created offline and doesn't have a server id yet.</summary>
    public int? Id { get; set; }

    /// <summary>Required when Id is null; echoed back in the response's id mapping.</summary>
    public string? ClientTempId { get; set; }

    public string Name { get; set; } = string.Empty;
    public string Icon { get; set; } = string.Empty;
    public string Color { get; set; } = string.Empty;
    public DateTime UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
}

public class HabitSyncItemDto
{
    public int? Id { get; set; }
    public string? ClientTempId { get; set; }

    public string Name { get; set; } = string.Empty;

    /// <summary>Server-known category id. Use CategoryClientTempId instead when the category was also created offline in the same batch.</summary>
    public int? CategoryId { get; set; }
    public string? CategoryClientTempId { get; set; }

    public HabitFrequencyType FrequencyType { get; set; }
    public int? IntervalDays { get; set; }
    public int? DayOfMonth { get; set; }
    public DayOfWeek? DayOfWeek { get; set; }
    public DateOnly StartDate { get; set; }
    public DateTime UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
}

public class HabitEntrySyncItemDto
{
    public int? Id { get; set; }
    public string? ClientTempId { get; set; }

    /// <summary>Server-known habit id. Use HabitClientTempId instead when the habit was also created offline in the same batch.</summary>
    public int? HabitId { get; set; }
    public string? HabitClientTempId { get; set; }

    public string Date { get; set; } = string.Empty;
    public string Status { get; set; } = string.Empty;
    public DateTime UpdatedAt { get; set; }
    public bool IsDeleted { get; set; }
}
