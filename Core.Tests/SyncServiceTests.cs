using Core.Source.Data;
using Core.Source.Models;
using Core.Source.Models.Dtos.Sync;
using Core.Source.Repositories;
using Core.Source.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging.Abstractions;

namespace Core.Tests;

public class SyncServiceTests
{
    private const string UserId = "cognito-sub-user-1";

    private static (AppDbContext Db, SyncService Service) CreateService()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseInMemoryDatabase(Guid.NewGuid().ToString())
            .Options;
        var db = new AppDbContext(options);

        var service = new SyncService(
            new CategoryRepository(db),
            new HabitRepository(db),
            new HabitEntryRepository(db),
            NullLogger<SyncService>.Instance);

        return (db, service);
    }

    [Fact]
    public async Task NewCategoryFromClient_IsInserted_AndIdMappingReturned()
    {
        var (db, service) = CreateService();

        var request = new SyncRequestDto
        {
            LastSyncedAt = null,
            Categories = new List<CategorySyncItemDto>
            {
                new() { ClientTempId = "tmp-1", Name = "Saúde", Icon = "bi-heart-pulse", Color = "#dc3545", UpdatedAt = DateTime.UtcNow },
            },
        };

        var response = await service.SyncAsync(UserId, request);

        Assert.Single(response.CategoryIdMappings);
        Assert.Equal("tmp-1", response.CategoryIdMappings[0].ClientTempId);
        Assert.Contains(response.Categories, c => c.Name == "Saúde" && c.Id == response.CategoryIdMappings[0].ServerId);
        Assert.Single(db.Categories);
    }

    [Fact]
    public async Task Conflict_ServerIsNewer_ClientChangeIsRejected_AndServerVersionIsReturned()
    {
        var (db, service) = CreateService();
        var serverEditTime = new DateTime(2026, 8, 16, 12, 0, 0, DateTimeKind.Utc);

        var category = new Category
        {
            Name = "Nome do servidor",
            Icon = "bi-cloud",
            Color = "#0d6efd",
            UserId = UserId,
            CreatedAt = serverEditTime.AddDays(-1),
            UpdatedAt = serverEditTime,
        };
        db.Categories.Add(category);
        await db.SaveChangesAsync();

        var request = new SyncRequestDto
        {
            LastSyncedAt = serverEditTime.AddDays(-1),
            Categories = new List<CategorySyncItemDto>
            {
                new()
                {
                    Id = category.Id,
                    Name = "Nome antigo do celular",
                    Icon = "bi-cloud",
                    Color = "#0d6efd",
                    UpdatedAt = serverEditTime.AddHours(-1), // older than the server's edit
                },
            },
        };

        var response = await service.SyncAsync(UserId, request);

        var stored = await db.Categories.FindAsync(category.Id);
        Assert.Equal("Nome do servidor", stored!.Name);
        Assert.Contains(response.Categories, c => c.Id == category.Id && c.Name == "Nome do servidor");
    }

    [Fact]
    public async Task Conflict_ClientIsNewer_ClientChangeIsApplied()
    {
        var (db, service) = CreateService();
        var serverEditTime = new DateTime(2026, 8, 16, 12, 0, 0, DateTimeKind.Utc);

        var category = new Category
        {
            Name = "Nome antigo",
            Icon = "bi-cloud",
            Color = "#0d6efd",
            UserId = UserId,
            CreatedAt = serverEditTime.AddDays(-1),
            UpdatedAt = serverEditTime,
        };
        db.Categories.Add(category);
        await db.SaveChangesAsync();

        var clientEditTime = serverEditTime.AddHours(2);
        var request = new SyncRequestDto
        {
            LastSyncedAt = serverEditTime.AddDays(-1),
            Categories = new List<CategorySyncItemDto>
            {
                new() { Id = category.Id, Name = "Nome novo do celular", Icon = "bi-cloud", Color = "#0d6efd", UpdatedAt = clientEditTime },
            },
        };

        var response = await service.SyncAsync(UserId, request);

        var stored = await db.Categories.FindAsync(category.Id);
        Assert.Equal("Nome novo do celular", stored!.Name);
        Assert.Contains(response.Categories, c => c.Id == category.Id && c.Name == "Nome novo do celular");
    }

    [Fact]
    public async Task Deletion_FromClient_SoftDeletesServerRow_AndTombstonePropagates()
    {
        var (db, service) = CreateService();
        var serverEditTime = new DateTime(2026, 8, 16, 12, 0, 0, DateTimeKind.Utc);

        var category = new Category
        {
            Name = "Vai sumir",
            Icon = "bi-cloud",
            Color = "#0d6efd",
            UserId = UserId,
            CreatedAt = serverEditTime.AddDays(-1),
            UpdatedAt = serverEditTime,
        };
        db.Categories.Add(category);
        await db.SaveChangesAsync();

        var request = new SyncRequestDto
        {
            LastSyncedAt = serverEditTime.AddDays(-1),
            Categories = new List<CategorySyncItemDto>
            {
                new() { Id = category.Id, Name = category.Name, Icon = category.Icon, Color = category.Color, UpdatedAt = serverEditTime.AddMinutes(1), IsDeleted = true },
            },
        };

        var response = await service.SyncAsync(UserId, request);

        var stored = await db.Categories.FindAsync(category.Id);
        Assert.True(stored!.IsDeleted);
        Assert.Contains(response.Categories, c => c.Id == category.Id && c.IsDeleted);
    }

    [Fact]
    public async Task HabitCreatedOfflineWithNewCategory_ResolvesCategoryClientTempId()
    {
        var (db, service) = CreateService();
        var now = DateTime.UtcNow;

        var request = new SyncRequestDto
        {
            Categories = new List<CategorySyncItemDto>
            {
                new() { ClientTempId = "cat-tmp", Name = "Estudos", Icon = "bi-book", Color = "#6610f2", UpdatedAt = now },
            },
            Habits = new List<HabitSyncItemDto>
            {
                new()
                {
                    ClientTempId = "habit-tmp",
                    Name = "Ler 10 páginas",
                    CategoryClientTempId = "cat-tmp",
                    FrequencyType = HabitFrequencyType.EveryNDays,
                    IntervalDays = 0,
                    StartDate = DateOnly.FromDateTime(now),
                    UpdatedAt = now,
                },
            },
        };

        var response = await service.SyncAsync(UserId, request);

        var createdCategoryId = response.CategoryIdMappings.Single().ServerId;
        var createdHabit = Assert.Single(response.Habits);
        Assert.Equal(createdCategoryId, createdHabit.CategoryId);
    }
}
