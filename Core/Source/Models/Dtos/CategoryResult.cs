namespace Core.Source.Models.Dtos;

public enum CategoryOperationError
{
    None,
    NotFound,
    Forbidden,
    LimitReached,
    InvalidName,
    InvalidIcon,
    InvalidColor,
}

public class CategoryResult
{
    public bool Success { get; set; }
    public CategoryOperationError Error { get; set; } = CategoryOperationError.None;
    public CategoryDto? Category { get; set; }

    public static CategoryResult Ok(CategoryDto category) => new() { Success = true, Category = category };

    public static CategoryResult Fail(CategoryOperationError error) => new() { Success = false, Error = error };
}
