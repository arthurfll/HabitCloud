using Microsoft.AspNetCore.DataProtection.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using Core.Source.Models;

namespace Core.Source.Data;

public class AppDbContext : DbContext, IDataProtectionKeyContext
{
    public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options)
    {
    }

    public DbSet<Category> Categories => Set<Category>();
    public DbSet<Habito> Habitos => Set<Habito>();
    public DbSet<HabitEntry> HabitEntries => Set<HabitEntry>();
    public DbSet<DataProtectionKey> DataProtectionKeys => Set<DataProtectionKey>();

    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);

        builder.Entity<Category>(entity =>
        {
            entity.Property(c => c.Name).HasMaxLength(50).IsRequired();
            entity.Property(c => c.Icon).HasMaxLength(50).IsRequired();
            entity.Property(c => c.Color).HasMaxLength(7).IsRequired();
            entity.Property(c => c.UserId).IsRequired();

            entity.HasIndex(c => c.UserId);
            entity.HasIndex(c => new { c.UserId, c.UpdatedAt });
        });

        builder.Entity<Habito>(entity =>
        {
            entity.Property(h => h.Name).HasMaxLength(50).IsRequired();
            entity.Property(h => h.UserId).IsRequired();

            entity.HasOne(h => h.Category)
                .WithMany()
                .HasForeignKey(h => h.CategoryId)
                .OnDelete(DeleteBehavior.Restrict);

            entity.HasIndex(h => h.UserId);
            entity.HasIndex(h => new { h.UserId, h.UpdatedAt });
        });

        builder.Entity<HabitEntry>(entity =>
        {
            entity.HasOne(e => e.Habit)
                .WithMany()
                .HasForeignKey(e => e.HabitId)
                .OnDelete(DeleteBehavior.Cascade);

            entity.HasIndex(e => new { e.HabitId, e.Date }).IsUnique();
            entity.HasIndex(e => e.UpdatedAt);
        });
    }
}
