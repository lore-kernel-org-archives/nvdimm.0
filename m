Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x241.google.com (mail-qk0-x241.google.com
 [IPv6:2607:f8b0:400d:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 107B9209831D4
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 11:31:33 -0700 (PDT)
Received: by mail-qk0-x241.google.com with SMTP id b5-v6so15661640qkg.6
 for <linux-nvdimm@lists.01.org>; Fri, 13 Jul 2018 11:31:33 -0700 (PDT)
Subject: Re: [ndctl PATCH v12 5/5] ndctl, test: add a new unit test for monitor
References: <20180713155403.30020-1-qi.fuli@jp.fujitsu.com>
 <20180713155403.30020-6-qi.fuli@jp.fujitsu.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <66e213f9-3e82-2e62-3570-c8a4ea82c5f0@gmail.com>
Date: Fri, 13 Jul 2018 14:31:32 -0400
MIME-Version: 1.0
In-Reply-To: <20180713155403.30020-6-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: qi.fuli@jp.fujitsu.com, linux-nvdimm@lists.01.org
Cc: tokunaga.keiich@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Qi,

On 07/13/2018 11:54 AM, QI Fuli wrote:
> Add a new unit test to test all options of the monitor command.
> 
> Based-on-patch-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> Acked-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
[...]
> +test_filter_dimmevent()
> +{
> +	monitor_dimms="$(get_monitor_dimm | awk '{print $1}')"
> +
> +	start_monitor "-d $monitor_dimms -D dimm-unclean-shutdown"
> +	inject_smart "-U"
> +	check_result "$monitor_dimms"
> +	stop_monitor
> +

> +	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."spares_threshold")

        inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r "(.[]) | .health.spares_threshold")

> +	inject_value=$((inject_value - 1))
> +	start_monitor "-d $monitor_dimms -D dimm-spares-remaining"
> +	inject_smart "-s $inject_value"
> +	check_result "$monitor_dimms"
> +	stop_monitor
> +

> +	inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r .[]."health"."temperature_threshold")

        inject_value=$($NDCTL list -H -d $monitor_dimms | jq -r "(.[]) | .health.temperature_threshold")

The rest looks good. Please feel free to add:... 
Oh, it has already added, nice :-)

> Acked-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>

Thanks,
Masa
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
