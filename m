Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69FE9210C2787
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 19:05:59 -0700 (PDT)
Received: from g01jpfmpwkw01.exch.g01.fujitsu.local
 (g01jpfmpwkw01.exch.g01.fujitsu.local [10.0.193.38])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id ADFFFAC0083
 for <linux-nvdimm@lists.01.org>; Tue, 31 Jul 2018 11:05:51 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl, test/monitor: fix inject-smart field in
 test_filter_dimmevent
Date: Tue, 31 Jul 2018 02:05:50 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E3223DA9B7DB@g01jpexmbkw24>
References: <20180730193522.30458-1-vishal.l.verma@intel.com>
In-Reply-To: <20180730193522.30458-1-vishal.l.verma@intel.com>
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
> Sent: Tuesday, July 31, 2018 4:35 AM
> To: linux-nvdimm@lists.01.org
> Cc: Vishal Verma <vishal.l.verma@intel.com>; Qi, Fuli/斉 福利
> <qi.fuli@jp.fujitsu.com>
> Subject: [ndctl PATCH] ndctl, test/monitor: fix inject-smart field in
> test_filter_dimmevent
> 
> Change the inject-smart field from -s to -m when testing the dimm-media-temperature
> event. The -s seems to have been a copy-paste error.
> 
> Cc: QI Fuli <qi.fuli@jp.fujitsu.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  test/monitor.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/test/monitor.sh b/test/monitor.sh index 1bbfd14..29d4ea1 100755
> --- a/test/monitor.sh
> +++ b/test/monitor.sh
> @@ -152,7 +152,7 @@ test_filter_dimmevent()
>  	inject_value=$($NDCTL list -H -d $monitor_dimms | jq
> -r .[]."health"."temperature_threshold")
>  	inject_value=$((inject_value + 1))
>  	start_monitor "-d $monitor_dimms -D dimm-media-temperature"
> -	inject_smart "-s $inject_value"
> +	inject_smart "-m $inject_value"
>  	check_result "$monitor_dimms"
>  	stop_monitor
>  }

Hi Vishal,

Yes, this is a copy-paste error and I am sorry for this.

Thank you very much.
QI

> --
> 2.14.4
> 
> 


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
