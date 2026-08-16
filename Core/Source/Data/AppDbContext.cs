using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Core.Source.Models;

namespace Core.Source.Data;

public class AppDbContext : IdentityDbContext<IdentityUser>
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Habito> Habitos => Set<Habito>();
    public DbSet<HabitEntry> HabitEntries => Set<HabitEntry>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<Category>(entity =>
        {
            entity.Property(c => c.Name).HasMaxLength(50).IsRequired();
            entity.Property(c => c.Icon).HasMaxLength(50).IsRequired();
            entity.Property(c => c.Color).HasMaxLength(7).IsRequired();
            entity.Property(c => c.UserId).IsRequired();

            entity.HasOne(c => c.User)
                .WithMany()
                .HasForeignKey(c => c.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasIndex(c => c.UserId);
        });

        builder.Entity<Habito>(entity =>
        {
            entity.Property(h => h.Name).HasMaxLength(50).IsRequired();
            entity.Property(h => h.UserId).IsRequired();

            entity.HasOne(h => h.User)
                .WithMany()
                .HasForeignKey(h => h.UserId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasOne(h => h.Category)
                .WithMany()
                .HasForeignKey(h => h.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasIndex(h => h.UserId);
        });

        builder.Entity<HabitEntry>(entity =>
        {
            entity.HasOne(e => e.Habit)
                .WithMany()
                .HasForeignKey(e => e.HabitId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasIndex(e => new { e.HabitId, e.Date }).IsUnique();
        });
    }
}
