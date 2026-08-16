$(function () {
    var $app = $('#categoriaApp');
    if ($app.length === 0) {
        return;
    }

    var maxCategories = parseInt($app.attr('data-max-categories'), 10) || 0;
    var pageSize = parseInt($app.attr('data-page-size'), 10) || 10;
    var currentPage = parseInt($app.attr('data-current-page'), 10) || 1;
    var hubUrl = $app.attr('data-hub-url');
    var antiForgeryToken = $('#antiForgeryForm input[name="__RequestVerificationToken"]').val();

    var totalCount = parseInt($app.attr('data-total-count'), 10) || 0;
    var knownIds = new Set();
    $('#categoryList .category-row').each(function () {
        knownIds.add(String($(this).data('id')));
    });

    function post(url, data) {
        return $.ajax({
            url: url,
            method: 'POST',
            data: data,
            headers: { 'X-CSRF-TOKEN': antiForgeryToken }
        });
    }

    function escapeHtml(value) {
        return $('<div>').text(value == null ? '' : value).html();
    }

    function buildRowHtml(category) {
        var id = category.id;
        return '' +
            '<div class="category-row d-flex align-items-center gap-2 p-2 border rounded bg-white" data-id="' + id + '">' +
            '<input type="text" class="form-control category-name-input" maxlength="50" value="' + escapeHtml(category.name) + '" data-id="' + id + '" placeholder="Nome da categoria" aria-label="Nome da categoria" />' +
            '<button type="button" class="category-color-circle category-picker-trigger" data-id="' + id + '" data-icon="' + category.icon + '" data-color="' + category.color + '" style="background-color:' + category.color + '" title="Alterar ícone e cor" aria-label="Alterar ícone e cor"></button>' +
            '<button type="button" class="category-icon-btn category-picker-trigger" data-id="' + id + '" data-icon="' + category.icon + '" data-color="' + category.color + '" title="Alterar ícone e cor" aria-label="Alterar ícone e cor">' +
            '<i class="bi ' + category.icon + '"></i>' +
            '</button>' +
            '</div>';
    }

    function updateAddButtonState() {
        var reachedLimit = totalCount >= maxCategories;
        $('#btnAddCategory').prop('disabled', reachedLimit);
        $('#limitMessage').toggleClass('d-none', !reachedLimit);
    }

    function addRowToList(category) {
        var idStr = String(category.id);
        if (knownIds.has(idStr)) {
            return;
        }
        knownIds.add(idStr);
        totalCount++;
        updateAddButtonState();

        if (currentPage === 1) {
            $('#emptyState').addClass('d-none');
            $('#categoryList').prepend(buildRowHtml(category));

            var $rows = $('#categoryList .category-row');
            if ($rows.length > pageSize) {
                $rows.last().remove();
            }
        }
    }

    function updateRowInList(category) {
        var $row = $('#categoryList .category-row[data-id="' + category.id + '"]');
        if ($row.length === 0) {
            return;
        }
        $row.find('.category-name-input').val(category.name);
        $row.find('.category-picker-trigger')
            .attr('data-icon', category.icon)
            .attr('data-color', category.color);
        $row.find('.category-color-circle').css('background-color', category.color);
        $row.find('.category-icon-btn i').attr('class', 'bi ' + category.icon);
    }

    // --- Edição inline do nome ---
    $('#categoryList').on('change', '.category-name-input', function () {
        var $input = $(this);
        var id = $input.data('id');
        var name = $input.val().trim();

        if (!name) {
            $input.focus();
            return;
        }

        post('?handler=UpdateName', { id: id, name: name }).done(function (res) {
            if (res.success) {
                $input.val(res.category.name);
            }
        }).fail(function () {
            alert('Não foi possível atualizar o nome da categoria.');
        });
    });

    $('#categoryList').on('keydown', '.category-name-input', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            this.blur();
        }
    });

    // --- Modal seletor de ícone e cor ---
    var pickerModalEl = document.getElementById('pickerModal');
    var pickerModal = new bootstrap.Modal(pickerModalEl);
    var pickerTarget = null;

    function openPicker($trigger) {
        var icon = $trigger.attr('data-icon');
        var color = $trigger.attr('data-color');
        pickerTarget = { id: $trigger.attr('data-id'), $trigger: $trigger };

        $('#pickerModal .icon-option').removeClass('selected');
        $('#pickerModal .icon-option[data-icon="' + icon + '"]').addClass('selected');
        $('#pickerModal .color-option').removeClass('selected');
        $('#pickerModal .color-option[data-color="' + color + '"]').addClass('selected');

        pickerModal.show();
    }

    $(document).on('click', '.category-picker-trigger', function () {
        openPicker($(this));
    });

    $('#pickerModal').on('click', '.icon-option', function () {
        if (!pickerTarget) {
            return;
        }
        var icon = $(this).data('icon');
        $('#pickerModal .icon-option').removeClass('selected');
        $(this).addClass('selected');
        applyIconSelection(pickerTarget, icon);
    });

    $('#pickerModal').on('click', '.color-option', function () {
        if (!pickerTarget) {
            return;
        }
        var color = $(this).data('color');
        $('#pickerModal .color-option').removeClass('selected');
        $(this).addClass('selected');
        applyColorSelection(pickerTarget, color);
    });

    function applyIconSelection(target, icon) {
        target.$trigger.attr('data-icon', icon);

        post('?handler=UpdateIcon', { id: target.id, icon: icon }).done(function (res) {
            if (res.success) {
                updateRowInList(res.category);
            }
        }).fail(function () {
            alert('Não foi possível atualizar o ícone.');
        });
    }

    function applyColorSelection(target, color) {
        target.$trigger.attr('data-color', color);

        post('?handler=UpdateColor', { id: target.id, color: color }).done(function (res) {
            if (res.success) {
                updateRowInList(res.category);
            }
        }).fail(function () {
            alert('Não foi possível atualizar a cor.');
        });
    }

    // --- Seleção de ícone/cor dentro do modal de criação (sem AJAX, aplicado ao criar) ---
    $('#createIconGrid').on('click', '.icon-option', function () {
        var icon = $(this).data('icon');
        $('#createIconGrid .icon-option').removeClass('selected');
        $(this).addClass('selected');
        $('#newCategoryPreview').attr('data-icon', icon);
        $('#newCategoryPreviewIcon').attr('class', 'bi ' + icon);
    });

    $('#createColorGrid').on('click', '.color-option', function () {
        var color = $(this).data('color');
        $('#createColorGrid .color-option').removeClass('selected');
        $(this).addClass('selected');
        $('#newCategoryPreview').attr('data-color', color).css('background-color', color);
    });

    // --- Criação de categoria ---
    $('#btnCreateCategory').on('click', function () {
        var name = $('#newCategoryName').val().trim();
        var icon = $('#newCategoryPreview').attr('data-icon');
        var color = $('#newCategoryPreview').attr('data-color');

        $('#createError').addClass('d-none').text('');

        if (!name) {
            $('#createError').removeClass('d-none').text('Informe um nome para a categoria.');
            return;
        }

        post('?handler=Create', { name: name, icon: icon, color: color }).done(function (res) {
            if (res.success) {
                addRowToList(res.category);
                $('#newCategoryName').val('');
                bootstrap.Modal.getOrCreateInstance(document.getElementById('createModal')).hide();
            }
        }).fail(function (xhr) {
            var message = 'Não foi possível criar a categoria.';
            if (xhr.responseJSON && xhr.responseJSON.error === 'LimitReached') {
                message = 'Você atingiu o limite de ' + maxCategories + ' categorias.';
            }
            $('#createError').removeClass('d-none').text(message);
        });
    });

    // --- SignalR: atualização em tempo real ---
    if (hubUrl && window.signalR) {
        var connection = new signalR.HubConnectionBuilder()
            .withUrl(hubUrl)
            .withAutomaticReconnect()
            .build();

        connection.on('CategoryCreated', function (category) {
            addRowToList(category);
        });

        connection.on('CategoryUpdated', function (category) {
            updateRowInList(category);
        });

        connection.start().catch(function (err) {
            console.error('Falha ao conectar ao SignalR:', err);
        });
    }
});
