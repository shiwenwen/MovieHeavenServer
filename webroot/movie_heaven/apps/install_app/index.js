window.onload = function(){
    if (browser.versions.ios) {
        var videoId = GetQueryString('videoId')
        console.log('videoId =' + videoId)
        // alert(navigator.userAgent)

        if (videoId) {

            if (!browser.versions.webApp) {
                document.getElementsByClassName('tip')[0].innerText= '欢迎使用观影天堂'
                window.location = 'watchmovieheaven://videoId=' + videoId;
            } else {
                document.getElementsByClassName('tip')[0].innerText= '请点击右上角，选择 用Safari打开，即可自动调起“观影天堂”播放此视频'
            }

        } else {
            if (!browser.versions.webApp) {
                document.getElementsByClassName('tip')[0].innerText= '欢迎使用观影天堂'
            } else {
                document.getElementsByClassName('tip')[0].innerText = '请点击右上角，选择 用Safari打开'
            }
        }

    } else {

        document.getElementsByClassName('logo')[0].src = './imgs/qrCode.jpg'
        document.getElementsByClassName('tip')[0].innerText= '请您使用iPhone(iPad)的Safari浏览器打开本页面,或者扫描下面二维码'

    }

};