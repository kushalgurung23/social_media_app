"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
const lodash_1 = __importDefault(require("lodash"));
const nodemailer_1 = __importDefault(require("nodemailer"));
const emailFields = [
    'from',
    'replyTo',
    'to',
    'cc',
    'bcc',
    'subject',
    'text',
    'html',
    'attachments',
];
module.exports = {
    provider: 'nodemailer',
    name: 'Nodemailer',
    init(providerOptions, settings) {
        const transporter = nodemailer_1.default.createTransport(providerOptions);
        return {
            send(options) {
                // Default values.
                const emailOptions = {
                    ...lodash_1.default.pick(options, emailFields),
                    from: options.from || settings.defaultFrom,
                    replyTo: options.replyTo || settings.defaultReplyTo,
                    text: options.text || options.html,
                    html: options.html || options.text,
                };
                return transporter.sendMail(emailOptions);
            },
        };
    },
};
//# sourceMappingURL=index.js.map