namespace Core.Source.Models.Dtos.Sync;

public class SyncResponseDto
{
    public DateTime SyncedAt { get; set; }
    public List<CategoryDto> Categories { get; set; } = new();
    public List<HabitDto> Habits { get; set; } = new();
    public List<HabitEntryDto> HabitEntries { get; set; } = new();
    public List<IdMappingDto> CategoryIdMappings { get; set; } = new();
    public List<IdMappingDto> HabitIdMappings { get; set; } = new();
    public List<IdMappingDto> HabitEntryIdMappings { get; set; } = new();
}

public class IdMappingDto
{
    public string ClientTempId { get; set; } = string.Empty;
    public int ServerId { get; set; }
}
