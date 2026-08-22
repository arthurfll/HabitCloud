$(function () {
    var $app = $('#statsApp');
    if ($app.length === 0) {
        return;
    }

    var chart = null;

    function get(url, data) {
        return $.ajax({ url: url, method: 'GET', data: data });
    }

    function formatLabel(dateStr) {
        var parts = dateStr.split('-');
        return parts[2] + '/' + parts[1];
    }

    function renderChart(dailySeries) {
        var labels = dailySeries.map(function (p) { return formatLabel(p.date); });
        var data = dailySeries.map(function (p) { return p.percentDone; });

        var ctx = document.getElementById('statsLineChart').getContext('2d');
        if (chart) {
            chart.destroy();
        }
        chart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: labels,
                datasets: [{
                    label: '% de hábitos concluídos',
                    data: data,
                    borderColor: '#0d6efd',
                    backgroundColor: 'rgba(13, 110, 253, 0.15)',
                    tension: 0.2,
                    fill: true,
                    spanGaps: true
                }]
            },
            options: {
                scales: { y: { min: 0, max: 100, ticks: { callback: function (v) { return v + '%'; } } } },
                plugins: { legend: { display: false } }
            }
        });
    }

    function renderPerHabit(perHabit) {
        var $list = $('#statsPerHabitList').empty();
        $('#statsEmptyMessage').toggleClass('d-none', perHabit.length > 0);

        perHabit.forEach(function (h) {
            var $item = $('<div class="list-group-item d-flex justify-content-between align-items-center">');
            var $label = $('<span>').text(h.name);
            var $percent = $('<span class="fw-bold">').text(h.percentDone + '%');
            $item.append($label).append($percent);
            $list.append($item);
        });
    }

    function renderStats(stats) {
        renderChart(stats.dailySeries);
        renderPerHabit(stats.perHabit);
    }

    function loadStats(days) {
        get('?handler=Stats', { days: days }).done(function (res) {
            if (res.success) {
                renderStats(res.stats);
            }
        });
    }

    $('.period-btn').on('click', function () {
        $('.period-btn').removeClass('active');
        $(this).addClass('active');
        loadStats(parseInt($(this).attr('data-days'), 10));
    });

    var initialStats = JSON.parse($('#initialStatsData').text() || 'null');
    if (initialStats) {
        renderStats(initialStats);
    }
});
