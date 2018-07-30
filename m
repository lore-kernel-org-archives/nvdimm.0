Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3DA65210C5145
 for <linux-nvdimm@lists.01.org>; Sun, 29 Jul 2018 19:27:39 -0700 (PDT)
Received: from g01jpfmpwkw03.exch.g01.fujitsu.local
 (g01jpfmpwkw03.exch.g01.fujitsu.local [10.0.193.57])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 56250AC0156
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 11:27:32 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl: deprecate undocumented short-options
Date: Mon, 30 Jul 2018 02:27:30 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA995BD@g01jpexmbkw24>
References: <20180727183050.13047-1-vishal.l.verma@intel.com>
In-Reply-To: <20180727183050.13047-1-vishal.l.verma@intel.com>
Content-Language: en-US
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Vishal Verma [mailto:vishal.l.verma@intel.com]
> Sent: Saturday, July 28, 2018 3:31 AM
> To: linux-nvdimm@lists.01.org
> Cc: Vishal Verma <vishal.l.verma@intel.com>; Qi, Fuli/斉 福利
> <qi.fuli@jp.fujitsu.com>
> Subject: [ndctl PATCH] ndctl: deprecate undocumented short-options
> 
> The inject-smart and monitor man pages refrained from displaying short options for
> various arguments (alarms, daemon) due to a lack of a coherent letter that could
> be made to relate to the event name. It was expected that the user will always use
> the long option for these. Since the OPT_STRING helper refused to take an empty string
> for the short option, we used bogus characters for each of them.
> 
> However there is a better way to provide no short options, and that is by using '\0'
> for the short option field to OPT_STRING. Replace the bogus characters with '\0'
> so that the 'short help' also becomes consistent with the man pages.
> 
> Cc: Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  ndctl/inject-smart.c | 7 ++++---
>  ndctl/monitor.c      | 2 +-
>  2 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/ndctl/inject-smart.c b/ndctl/inject-smart.c index 006ea2a..edb87e1
> 100644
> --- a/ndctl/inject-smart.c
> +++ b/ndctl/inject-smart.c
> @@ -73,7 +73,7 @@ OPT_STRING('M', "media-temperature-threshold", \
>  	&param.media_temperature_threshold, \
>  	"set smart media temperature threshold", \
>  	"set threshold value for smart media temperature"), \ -OPT_STRING('x',
> "media-temperature-alarm", &param.media_temperature_alarm, \
> +OPT_STRING('\0', "media-temperature-alarm",
> +&param.media_temperature_alarm, \
>  	"smart media temperature alarm", \
>  	"enable or disable the smart media temperature alarm"), \  OPT_STRING('c',
> "ctrl-temperature", &param.ctrl_temperature, \ @@ -83,7 +83,7 @@ OPT_STRING('C',
> "ctrl-temperature-threshold", \
>  	&param.ctrl_temperature_threshold, \
>  	"set smart controller temperature threshold", \
>  	"set threshold value for smart controller temperature"), \ -OPT_STRING('y',
> "ctrl-temperature-alarm", &param.ctrl_temperature_alarm, \
> +OPT_STRING('\0', "ctrl-temperature-alarm",
> +&param.ctrl_temperature_alarm, \
>  	"smart controller temperature alarm", \
>  	"enable or disable the smart controller temperature alarm"),
> \  OPT_STRING('s', "spares", &param.spares, \ @@ -92,13 +92,14 @@ OPT_STRING('s',
> "spares", &param.spares, \  OPT_STRING('S', "spares-threshold",
> &param.spares_threshold, \
>  	"set smart spares threshold", \
>  	"set a threshold value for smart spares"), \ -OPT_STRING('z', "spares-alarm",
> &param.spares_alarm, \
> +OPT_STRING('\0', "spares-alarm", &param.spares_alarm, \
>  	"smart spares alarm", \
>  	"enable or disable the smart spares alarm"), \  OPT_BOOLEAN('f', "fatal",
> &param.fatal, "inject fatal smart health status"), \  OPT_BOOLEAN('U',
> "unsafe-shutdown", &param.unsafe_shutdown, \
>  	"inject smart unsafe shutdown status")
> 
> +
>  static const struct option smart_opts[] = {
>  	SMART_OPTIONS(),
>  	OPT_END(),
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c index b97d1ea..c6419ad 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -583,7 +583,7 @@ int cmd_monitor(int argc, const char **argv, void *ctx)
>  				"where to output the monitor's notification"),
>  		OPT_FILENAME('c', "config-file", &monitor.config_file,
>  				"config-file", "override the default config"),
> -		OPT_BOOLEAN('x', "daemon", &monitor.daemon,
> +		OPT_BOOLEAN('\0', "daemon", &monitor.daemon,
>  				"run ndctl monitor as a daemon"),
>  		OPT_BOOLEAN('u', "human", &monitor.human,
>  				"use human friendly output formats"),

Looks good to me.
Please feel free to add: Reviewed-by: QI Fuli <qi.fuli@jp.fujitsu.com>

Thanks,
QI

> --
> 2.14.4
> 
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
