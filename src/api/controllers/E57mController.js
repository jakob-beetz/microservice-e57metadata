/**
 * E57mController
 *
 * @description :: Server-side logic for managing e57ms
 * @help        :: See http://links.sailsjs.org/docs/controllers
 */

var E57Metadata = require('../../bindings/e57metadata/app');

module.exports = {
    extract: function(req, res, next) {
        var files = req.params.all().files,
            e57ms = [];

        // console.log('files: ' + JSON.stringify(files, null, 4));

        for (var idx = 0; idx < files.length; idx++) {
            var file = files[idx],
                e57mInfo = {
                    originatingFile: file,
                    status: 'pending',
                    metadata: {}
                };

            // The outside 'idx' is bound to the anonymous callback function in line 43
            // to have the idx available for triggering the sending of the response.
            E57m.create(e57mInfo, function(idx, err, e57m) {
                if (err) return next(err);

                var e57Metadata = new E57Metadata();
                e57Metadata.extractFromFile(e57m);

                e57ms.push(e57m);

                if (idx === files.length - 1) {
                    res.send(201, {
                        e57ms: e57ms // Wrap into 'e57ms' key for Ember.js compatibility
                    });
                }
            }.bind(this, idx));
        };
    }
};