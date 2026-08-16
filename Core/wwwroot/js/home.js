$(function () {
    var $app = $('#homeApp');
    if ($app.length === 0) {
        return;
    }

    var hubUrl = $app.attr('data-hub-url');
    var antiForgeryToken = $('#antiForgeryForm input[name="__RequestVerificationToken"]').val();

    function post(url, data) {
        return $.ajax({
            url: url,
            method: 'POST',
            data: data,
            headers: { 'X-CSRF-TOKEN': antiForgeryToken }
        });
    }

    function todayIso() {
        var now = new Date();
        var y = now.getFullYear();
        var m = String(now.getMonth() + 1).padStart(2, '0');
        var d = String(now.getDate()).padStart(2, '0');
        return y + '-' + m + '-' + d;
    }

    function applyCheckButtonState($btn, status) {
        $btn.attr('data-status', status);
        $btn.removeClass('btn-success btn-danger btn-outline-secondary');

        if (status === 'Done') {
            $btn.addClass('btn-success').html('Feito');
        } else if (status === 'NotDone') {
            $btn.addClass('btn-danger').html('Não feito');
        } else {
            $btn.addClass('btn-outline-secondary').html('<i class="bi bi-check-lg"></i>');
        }
    }

    $('#todayHabitList').on('click', '.habit-check-btn', function () {
        var $btn = $(this);
        var id = $btn.data('id');

        post('/Home/ToggleHabit', { id: id }).done(function (res) {
            if (res.success) {
                applyCheckButtonState($btn, res.entry.status);
            }
        }).fail(function () {
            alert('Não foi possível atualizar o hábito.');
        });
    });

    if (hubUrl && window.signalR) {
        var connection = new signalR.HubConnectionBuilder()
            .withUrl(hubUrl)
            .withAutomaticReconnect()
            .build();

        connection.on('HabitEntryUpdated', function (entry) {
            if (entry.date !== todayIso()) {
                return;
            }
            var $btn = $('#todayHabitList .habit-check-btn[data-id="' + entry.habitId + '"]');
            if ($btn.length > 0) {
                applyCheckButtonState($btn, entry.status);
            }
        });

        connection.on('HabitUpdated', function (habit) {
            var $row = $('#todayHabitList .habit-row[data-id="' + habit.id + '"]');
            if ($row.length > 0) {
                $row.find('span.flex-grow-1').text(habit.name);
            }
        });

        connection.start().catch(function (err) {
            console.error('Falha ao conectar ao SignalR:', err);
        });
    }
});
