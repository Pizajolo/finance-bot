const xlabels = [];
const prices = [];

window.addEventListener('load', load_data);

async function setup() {
    const ctx = document.getElementById('myChart').getContext('2d');
    const myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: xlabels,
            datasets: [{
                label: 'Apple price',
                data: prices,
                backgroundColor: 'rgba(78, 115, 223, 0.8)',
                borderColor: 'rgba(78, 115, 223, 0.8)',
                fill: false,
                pointRadius: 0
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: false
                    }
                }]
            },
            maintainAspectRatio: false
        }
    });
}

async function load_data() {
    const request = new XMLHttpRequest();
    const share = document.getElementById('share_name').textContent;
    request.open('POST', '/search');

    // Callback function for when request completes
    request.onload = () => {
        // Extract JSON data from request
        const data = JSON.parse(request.responseText);
        const ctx = document.getElementById('myChart').getContext('2d');
        const myChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: data['Date'],
            datasets: [{
                label: 'Stock price',
                data: data['Prices'],
                backgroundColor: 'rgba(78, 115, 223, 0.8)',
                borderColor: 'rgba(78, 115, 223, 0.8)',
                fill: false,
                pointRadius: 0
            }]
        },
        options: {
            scales: {
                yAxes: [{
                    ticks: {
                        beginAtZero: false
                    }
                }]
            },
            maintainAspectRatio: false
        }
    });
    };

    // Add data to send with request
    const data = new FormData();
    data.append('search_query', share.toString());
    // Send request
    request.send(data);
    return false;
}