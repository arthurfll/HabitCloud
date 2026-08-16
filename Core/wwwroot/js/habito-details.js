$(function () {
    var $app = $('#habitDetailApp');
    if ($app.length === 0) {
        return;
    }

    var habitId = parseInt($app.attr('data-id'), 10);
    var currentYear = parseInt($app.attr('data-year'), 10);
    var currentMonth = parseInt($app.attr('data-month'), 10);
    var hubUrl = $app.attr('data-hub-url');
    var antiForgeryToken = $('#antiForgeryForm input[name="__RequestVerificationToken"]').val();

    var monthNames = [
        'Janeiro', 'Fevereiro', 'Março', 'Abril', 'Maio', 'Junho',
        'Julho', 'Agosto', 'Setembro', 'Outubro', 'Novembro', 'Dezembro'
    ];

    function post(url, data) {
        return $.ajax({
            url: url,
            method: 'POST',
            data: data,
            headers: { 'X-CSRF-TOKEN': antiForgeryToken }
        });
    }

    function get(url, data) {
        return $.ajax({ url: url, method: 'GET', data: data });
    }

    function applyStatusClasses($cell, due, status) {
        $cell.removeClass('due not-due status-done status-not-done');
        if (due) {
            $cell.addClass('due');
            if (status === 'Done') {
                $cell.addClass('status-done');
            } else if (status === 'NotDone') {
                $cell.addClass('status-not-done');
            }
        } else {
            $cell.addClass('not-due');
        }
    }

    function renderCalendar(data) {
        var $grid = $('#calendarGrid');
        $grid.empty();

        if (!data || !data.days || data.days.length === 0) {
            return;
        }

        var firstDate = new Date(data.days[0].date + 'T00:00:00');
        var offset = firstDate.getDay();

        for (var i = 0; i < offset; i++) {
            $grid.append('<div class="calendar-day empty"></div>');
        }

        data.days.forEach(function (day) {
            var dayNum = parseInt(day.date.split('-')[2], 10);
            var $cell = $('<div class="calendar-day">')
                .attr('data-date', day.date)
                .text(dayNum);
            applyStatusClasses($cell, day.due, day.status);
            $grid.append($cell);
        });

        $('#calendarTitle').text(monthNames[data.month - 1] + ' ' + data.year);
    }

    function loadMonth(year, month) {
        get('?handler=Calendar', { id: habitId, year: year, month: month }).done(function (res) {
            if (res.success) {
                currentYear = res.calendar.year;
                currentMonth = res.calendar.month;
                renderCalendar(res.calendar);
            }
        });
    }

    // --- Render inicial (sem round-trip extra) ---
    var initialDataEl = document.getElementById('initialCalendarData');
    if (initialDataEl && initialDataEl.textContent) {
        try {
            var initialData = JSON.parse(initialDataEl.textContent);
            if (!initialData || !initialData.days || initialData.days.length === 0) {
                throw new Error('Dados iniciais do calendário ausentes ou inválidos.');
            }
            renderCalendar(initialData);
        } catch (e) {
            loadMonth(currentYear, currentMonth);
        }
    } else {
        loadMonth(currentYear, currentMonth);
    }

    $('#btnPrevMonth').on('click', function () {
        var m = currentMonth - 1;
        var y = currentYear;
        if (m < 1) {
            m = 12;
            y--;
        }
        loadMonth(y, m);
    });

    $('#btnNextMonth').on('click', function () {
        var m = currentMonth + 1;
        var y = currentYear;
        if (m > 12) {
            m = 1;
            y++;
        }
        loadMonth(y, m);
    });

    // --- Clique no dia do calendário ---
    $('#calendarGrid').on('click', '.calendar-day.due', function () {
        var $cell = $(this);
        var date = $cell.attr('data-date');

        post('?handler=ToggleEntry', { id: habitId, date: date }).done(function (res) {
            if (res.success) {
                applyStatusClasses($cell, res.entry.due, res.entry.status);
            }
        }).fail(function () {
            alert('Não foi possível atualizar esse dia.');
        });
    });

    // --- Edição inline do nome ---
    $('#habitNameInput').on('change', function () {
        var $input = $(this);
        var name = $input.val().trim();

        if (!name) {
            $input.focus();
            return;
        }

        post('?handler=UpdateName', { id: habitId, name: name }).done(function (res) {
            if (res.success) {
                $input.val(res.habit.name);
                document.title = res.habit.name;
            }
        }).fail(function () {
            alert('Não foi possível atualizar o nome do hábito.');
        });
    });

    $('#habitNameInput').on('keydown', function (e) {
        if (e.key === 'Enter') {
            e.preventDefault();
            this.blur();
        }
    });

    // --- SignalR: atualização em tempo real ---
    if (hubUrl && window.signalR) {
        var connection = new signalR.HubConnectionBuilder()
            .withUrl(hubUrl)
            .withAutomaticReconnect()
            .build();

        connection.on('HabitUpdated', function (habit) {
            if (habit.id === habitId) {
                $('#habitNameInput').val(habit.name);
            }
        });

        connection.on('HabitEntryUpdated', function (entry) {
            if (entry.habitId !== habitId) {
                return;
            }
            var $cell = $('#calendarGrid .calendar-day[data-date="' + entry.date + '"]');
            if ($cell.length > 0) {
                applyStatusClasses($cell, entry.due, entry.status);
            }
        });

        connection.start().catch(function (err) {
            console.error('Falha ao conectar ao SignalR:', err);
        });
    }
});
