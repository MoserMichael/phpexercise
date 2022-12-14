
function WsptyClient() {
    this._connection = null;
};

WsptyClient.prototype.connect = function(options) {
    this._connection = options.ws;

    this._connection.onopen = function() {
        options.onConnect();
    };

    this._connection.onmessage = function(evt) {
        console.log('onmessage:', evt.data);
        var data = JSON.parse(evt.data);
        if (data.error !== undefined) {
            options.onError(data.error);
        }
        if (data.data !== undefined) {
            options.onData(data.data);
        }
    };

    this._connection.onclose = function(evt) {
        options.onClose();
    };
};

WsptyClient.prototype.send = function(data) {
    this._connection.send(JSON.stringify({'data': data}));
};

WsptyClient.prototype.resize = function(cols, rows) {
    this._connection.send(JSON.stringify({'cols': cols, 'rows': rows }));
};
