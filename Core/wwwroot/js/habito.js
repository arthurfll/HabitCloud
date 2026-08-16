$(function () {
    var $app = $('#habitoApp');
    if ($app.length === 0) {
        return;
    }

    var maxHabits = parseInt($app.attr('data-max-habits'), 10) || 0;
    var totalCount = parseInt($app.attr('data-total-count'), 10) || 0;
    var hubUrl = $app.attr('data-hub-url');
    var antiForgeryToken = $('#antiForgeryForm input[name="__RequestVerificationToken"]').val();

    var knownIds = new Set();
    $('#habitList .habit-row').each(function () {
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

    // Bootstrap ignores hide() while the modal's own show transition is still running
    // (e.g. when a fast submit follows right after opening). Retry shortly after as a safety net.
    function safeHideModal(modalEl) {
        bootstrap.Modal.getOrCreateInstance(modalEl).hide();
        setTimeout(function () {
            if (modalEl.classList.contains('show')) {
                bootstrap.Modal.getInstance(modalEl).hide();
            }
        }, 350);
    }

    function escapeHtml(value) {
        return $('<div>').text(value == null ? '' : value).html();
    }

    function escapeAttr(value) {
        return String(value == null ? '' : value).replace(/"/g, '&quot;');
    }

    function buildRowHtml(habit) {
        return '' +
            '<div class="habit-row d-flex align-items-center gap-2 p-2 border rounded bg-white" data-id="' + habit.id + '">' +
            '<span class="category-badge" style="background-color:' + escapeAttr(habit.categoryColor) + '" title="' + escapeAttr(habit.categoryName) + '">' +
            '<i class="bi ' + habit.categoryIcon + '"></i>' +
            '</span>' +
            '<input type="text" class="form-control habit-name-input" maxlength="50" value="' + escapeHtml(habit.name) + '" data-id="' + habit.id + '" placeholder="Nome do hábito" aria-label="Nome do hábito" />' +
            '<span class="badge text-bg-light text-secondary habit-frequency-badge d-none d-sm-inline-block">' + escapeHtml(habit.frequencyLabel) + '</span>' +
            '<a class="btn btn-outline-secondary" href="/Habito/Details/' + habit.id + '" title="Ver calendário"><i class="bi bi-calendar3"></i></a>' +
            '</div>';
    }

    function updateAddButtonState() {
        var reachedLimit = totalCount >= maxHabits;
        $('#btnAddHabit').prop('disabled', reachedLimit);
        $('#limitMessage').toggleClass('d-none', !reachedLimit);
    }

    function addRowToList(habit) {
        var idStr = String(habit.id);
        if (knownIds.has(idStr)) {
            return;
        }
        knownIds.add(idStr);
        totalCount++;
        updateAddButtonState();

        $('#emptyState').addClass('d-none');
        $('#habitList').append(buildRowHtml(habit));
    }

    function updateRowInList(habit) {
        var $row = $('#habitList .habit-row[data-id="' + habit.id + '"]');
        if ($row.length === 0) {
            return;
        }
        $row.find('.habit-name-input').val(habit.name);
    }

    // --- Edição inline do nome ---
    $('#habitList').on('change', '.habit-name-input', function () {
        var $input = $(this);
        var id = $input.data('id');
        var name = $input.val().trim();

        if (!name) {
            $input.focus();
            return;
        }

        post('?handler=UpdateName', { id: id, name: name }).done(function (res) {
            if (res.success) {
                $input.val(res.habit.name);
            }
        }).fail(function () {
            alert('Não foi possível atualizar o nome do hábito.');
        });
    });

    $('#habitList').on('keydown', '.habit-name-input', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            this.blur();
        }
    });

    // --- Formulário de frequência: mostra/esconde campos conforme o tipo ---
    function refreshFrequencyFields() {
        var type = $('#newHabitFrequencyType').val();
        $('#fieldEveryNDays').toggleClass('d-none', type !== 'EveryNDays');
        $('#fieldDayOfMonth').toggleClass('d-none', type !== 'DayOfMonth');
        $('#fieldDayOfWeek').toggleClass('d-none', type !== 'DayOfWeek');
    }

    $('#newHabitFrequencyType').on('change', refreshFrequencyFields);
    refreshFrequencyFields();

    // --- Criação de hábito ---
    $('#btnCreateHabit').on('click', function () {
        var name = $('#newHabitName').val().trim();
        var categoryId = $('#newHabitCategory').val();
        var frequencyType = $('#newHabitFrequencyType').val();

        var data = { name: name, categoryId: categoryId, frequencyType: frequencyType };

        if (frequencyType === 'EveryNDays') {
            data.intervalDays = $('#newHabitIntervalDays').val();
        } else if (frequencyType === 'DayOfMonth') {
            data.dayOfMonth = $('#newHabitDayOfMonth').val();
        } else if (frequencyType === 'DayOfWeek') {
            data.dayOfWeek = $('#newHabitDayOfWeek').val();
        }

        $('#createHabitError').addClass('d-none').text('');

        if (!name) {
            $('#createHabitError').removeClass('d-none').text('Informe um nome para o hábito.');
            return;
        }
        if (!categoryId) {
            $('#createHabitError').removeClass('d-none').text('Selecione uma categoria.');
            return;
        }

        post('?handler=Create', data).done(function (res) {
            if (res.success) {
                addRowToList(res.habit);
                $('#newHabitName').val('');
                safeHideModal(document.getElementById('createHabitModal'));
            }
        }).fail(function (xhr) {
            var message = 'Não foi possível criar o hábito.';
            if (xhr.responseJSON && xhr.responseJSON.error === 'LimitReached') {
                message = 'Você atingiu o limite de ' + maxHabits + ' hábitos.';
            }
            $('#createHabitError').removeClass('d-none').text(message);
        });
    });

    // --- SignalR: atualização em tempo real ---
    if (hubUrl && window.signalR) {
        var connection = new signalR.HubConnectionBuilder()
            .withUrl(hubUrl)
            .withAutomaticReconnect()
            .build();

        connection.on('HabitCreated', function (habit) {
            addRowToList(habit);
        });

        connection.on('HabitUpdated', function (habit) {
            updateRowInList(habit);
        });

        connection.start().catch(function (err) {
            console.error('Falha ao conectar ao SignalR:', err);
        });
    }
});
