Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B890210C6695
 for <linux-nvdimm@lists.01.org>; Tue, 14 Aug 2018 17:30:37 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id C0220AC0121
 for <linux-nvdimm@lists.01.org>; Wed, 15 Aug 2018 09:30:32 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH 1/3] ndctl, monitor: Fix formatting for --log in
 the man page
Date: Wed, 15 Aug 2018 00:30:30 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DAA1493@g01jpexmbkw24>
References: <20180814230555.3498-1-vishal.l.verma@intel.com>
In-Reply-To: <20180814230555.3498-1-vishal.l.verma@intel.com>
Content-Language: ja-JP
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
> Sent: Wednesday, August 15, 2018 8:06 AM
> To: linux-nvdimm@lists.01.org
> Cc: Vishal Verma <vishal.l.verma@intel.com>; Qi, Fuli/斉 福利
> <qi.fuli@jp.fujitsu.com>
> Subject: [ndctl PATCH 1/3] ndctl, monitor: Fix formatting for --log in the man page
> 
> Change the --log option to be similar to other options-with-arguments, such as --map.
> 
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Fixes: 8d2d75f76f1e ("ndctl, monitor: set default log destination to syslog if...")
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  Documentation/ndctl/ndctl-monitor.txt | 23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/Documentation/ndctl/ndctl-monitor.txt
> b/Documentation/ndctl/ndctl-monitor.txt
> index 9a8d76b..363c398 100644
> --- a/Documentation/ndctl/ndctl-monitor.txt
> +++ b/Documentation/ndctl/ndctl-monitor.txt
> @@ -65,20 +65,17 @@ OPTIONS
>  	A 'namespaceX.Y' device name, or namespace region plus id tuple
>  	'X.Y'.
> 
> --l <file | syslog | standard>::
> ---log=<file | syslog | standard>::
> +-l::
> +--log=::
>  	Send log messages to the specified destination.
> -+
> ---
> -<file>::
> -	Send log messages to specified <file>. When fopen() is not able
> -	to open <file>, log messages will be forwarded to syslog.
> -syslog::
> -	Send messages to syslog.
> -standard::
> -	Send messages to standard output.
> ---
> -+
> +	- "<file>":
> +	  Send log messages to specified <file>. When fopen() is not able
> +	  to open <file>, log messages will be forwarded to syslog.
> +	- "syslog":
> +	  Send messages to syslog.
> +	- "standard":
> +	  Send messages to standard output.
> +

Looks good to me.
Please feel free to add: Reviewed-by: QI Fuli <qi.fui@jp.fujitsu.com>

Thanks,
QI

>  The default log destination is 'syslog' if "--daemon" is specified,  otherwise 'standard'.
> Note that standard and relative path for <file>  will not work if "--daemon" is specified.
> --
> 2.14.4
> 
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
