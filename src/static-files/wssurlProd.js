

function makeWssUrl(uri) {
    let wsProtocol = location.protocol === 'http:' ? 'ws' : 'wss';
    let port = parseInt(location.port);
    return wsProtocol + '://' + location.hostname + ':' + port + '/' + uri;
}
