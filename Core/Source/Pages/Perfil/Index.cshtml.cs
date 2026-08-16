using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.RazorPages;

namespace Core.Source.Pages.Perfil;

[Authorize]
public class IndexModel : PageModel
{
    public string? Email => User.Identity?.Name;
}
