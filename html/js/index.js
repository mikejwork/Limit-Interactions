var interacts = new Ractive({
    el: '#app',
    data: {
        array: []
    },
    template: `
        {{#each array:i}}
            {{#if active}}
                <div class="col"><div class="row"><div class="col"><button on-click='select' data-index='{{i}}' class="btn btn-primary" type="button" style="text-shadow: 2px 2px 4px #000000; color:white; background: rgba(13,110,253,0);border-radius: 0px;padding: 0px;font-size: 14px;border-width: 0px;border-color: white;"><i class="{{icon}}" style="color:#349feb; margin-right: 0px;width: 20px;height: 10px;text-align: center;"></i>{{label}}</button></div></div></div>
            {{/if}}
        {{/each}}
        
    `,
    init: function () {
        this.on('select', function (event) {
            var index = event.node.getAttribute('data-index');

            $.post('http://limit_interactions/select', JSON.stringify({
                index: index,
            }));

        });
    },
    addItem: function (item) {
        this.push('array', {
            label: item.label,
            icon: item.icon,
            active: true
        });
    },
    getArray: function() {
        return this.get('array');
    }
});

$(function () {
    window.onload = (e) => {
        window.addEventListener("message", (event) => {
            var data = event.data;
            if (data !== undefined) {
                if (data.type === "refresh") {

                    for (var i in data.arr) {
                        interacts.set('array[' + i + '].active', data.arr[i].active);
                    }
                }

                if (data.type === "reset") {

                    for (var i in interacts.getArray()) {
                        interacts.set('array[' + i + '].active', false);
                    }
                }

                if (data.type === "toggle") {
                    if (data.bool) {
                        document.getElementById('div_interact').style.display = "block";
                    } else {
                        document.getElementById('div_interact').style.display = "none";
                    }
                }

                if (data.type === "addZone") {
                    interacts.addItem(data.zone)
                }
            }
        });
    }
})