Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 45564210D6935
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 04:42:19 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 86B48AC002B
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 20:42:11 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [PATCH] ndctl, monitor: Change the fail log priority to err.
Date: Thu, 2 Aug 2018 11:42:09 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA9C824@g01jpexmbkw24>
References: <20180801185538.27084-1-msys.mizuma@gmail.com>
In-Reply-To: <20180801185538.27084-1-msys.mizuma@gmail.com>
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
To: 'Masayoshi Mizuma' <msys.mizuma@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "Mizuma, Masayoshi" <m.mizuma@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Masayoshi Mizuma [mailto:msys.mizuma@gmail.com]
> Sent: Thursday, August 2, 2018 3:56 AM
> To: linux-nvdimm@lists.01.org
> Cc: Masayoshi Mizuma <msys.mizuma@gmail.com>; Qi, Fuli/斉 福利
> <qi.fuli@jp.fujitsu.com>; Mizuma, Masayoshi/水間 理仁 <m.mizuma@jp.fujitsu.com>
> Subject: [PATCH] ndctl, monitor: Change the fail log priority to err.
> 
> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> 
> fail() is called if an error happens, but the log priority is debug, so user may
> not notice the error.
> Let's change the priority to err.
> 
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> ---
>  ndctl/monitor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/ndctl/monitor.c b/ndctl/monitor.c index 84d51c4..68bbf65 100644
> --- a/ndctl/monitor.c
> +++ b/ndctl/monitor.c
> @@ -40,7 +40,7 @@ static int did_fail;
>  #define fail(fmt, ...) \
>  do { \
>  	did_fail = 1; \
> -	dbg(ctx, "ndctl-%s:%s:%d: " fmt, \
> +	err(ctx, "ndctl-%s:%s:%d: " fmt, \
>  			VERSION, __func__, __LINE__, ##__VA_ARGS__); \  } while (0)
> 

Hi Masa,

The debug messages which are from fail() include source code line numbers and function name,
these are useful for developers not typical users. Therefore, we made it a debug level print.
Currently the debug level cannot be outputted is a bug.
I will make a patch for adding [--verbose] option to emit debug messages and changing the log level of some messages.

Thanks,
QI

> --
> 2.18.0
> 
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
