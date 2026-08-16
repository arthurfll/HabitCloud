using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;

namespace Core.Source.Models;

public class Category
{
    public int Id { get; set; }

    [Required]
    [MaxLength(50)]
    public string Name { get; set; } = string.Empty;

    [Required]
    [MaxLength(50)]
    public string Icon { get; set; } = string.Empty;

    [Required]
    [MaxLength(7)]
    public string Color { get; set; } = string.Empty;

    [Required]
    public string UserId { get; set; } = string.Empty;

    public IdentityUser? User { get; set; }

    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
}
