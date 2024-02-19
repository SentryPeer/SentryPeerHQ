// SPDX-License-Identifier: AGPL-3.0
// Copyright (c) 2023 Gavin Henry <ghenry@sentrypeer.org>
//   _____            _              _____
//  / ____|          | |            |  __ \
// | (___   ___ _ __ | |_ _ __ _   _| |__) |__  ___ _ __
//  \___ \ / _ \ '_ \| __| '__| | | |  ___/ _ \/ _ \ '__|
//  ____) |  __/ | | | |_| |  | |_| | |  |  __/  __/ |
// |_____/ \___|_| |_|\__|_|   \__, |_|   \___|\___|_|
//                              __/ |
//                             |___/
//
/** LiveView Hook **/

const SentrypeerApiLoggerRealtime = {
    updated() {
        const loggerElement = this.el
        loggerElement.scrollTop = loggerElement.scrollHeight
        console.log('SentrypeerApiLoggerRealtime updated: ' + loggerElement.scrollTop + ' ' + loggerElement.scrollHeight)
    }
}

export default SentrypeerApiLoggerRealtime
