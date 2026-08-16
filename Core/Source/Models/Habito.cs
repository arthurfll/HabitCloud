using System.ComponentModel.DataAnnotations;

namespace Core.Source.Models;

public class Habito
{
    public int Id { get; set; }

    [Required]
    [MaxLength(50)]
    public string Name { get; set; } = string.Empty;

    [Required]
    public string UserId { get; set; } = string.Empty;

    [Required]
    public int CategoryId { get; set; }

    public Category? Category { get; set; }

    [Required]
    public HabitFrequencyType FrequencyType { get; set; }

    /// <summary>A cada quantos dias (0 = todo dia, 1-30 = a cada N dias). Usado quando FrequencyType = EveryNDays.</summary>
    public int? IntervalDays { get; set; }

    /// <summary>Dia do mês (1-31). Usado quando FrequencyType = DayOfMonth.</summary>
    public int? DayOfMonth { get; set; }

    /// <summary>Dia da semana. Usado quando FrequencyType = DayOfWeek.</summary>
    public DayOfWeek? DayOfWeek { get; set; }

    /// <summary>Data de referência para o cálculo de "a cada N dias".</summary>
    public DateOnly StartDate { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;

    public DateTime UpdatedAt { get; set; } = DateTime.UtcNow;

    public bool IsDeleted { get; set; }
}
