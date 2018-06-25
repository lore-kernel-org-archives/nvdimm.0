Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BC8D9202E53DD
 for <linux-nvdimm@lists.01.org>; Mon, 25 Jun 2018 13:09:12 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] ndctl, list: add controller temperature threshold
Date: Mon, 25 Jun 2018 20:09:10 +0000
Message-ID: <1529957348.27147.12.camel@intel.com>
References: <20180625084217.10608-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180625084217.10608-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <D48FF80526A13444B3AE2A55975DB916@intel.com>
MIME-Version: 1.0
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "qi.fuli@jp.fujitsu.com" <qi.fuli@jp.fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-06-25 at 17:42 +0900, QI Fuli wrote:
> This patch adds controller temperature threshold to list.
> When the dimm-controller-temperature event fires, users need to know
> the current controller temperature threshold value.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  ndctl/util/json-smart.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
> index 9482b35..d590b0c 100644
> --- a/ndctl/util/json-smart.c
> +++ b/ndctl/util/json-smart.c
> @@ -47,6 +47,18 @@ static void smart_threshold_to_json(struct ndctl_dimm
> *dimm,
>  					"temperature_threshold", jobj);
>  	}
>  
> +	if (alarm_control & ND_SMART_TEMP_TRIP) {

I think you want to use ND_SMART_CTEMP_TRIP here.

> +		unsigned int temp;
> +		double t;
> +
> +		temp =
> ndctl_cmd_smart_threshold_get_ctrl_temperature(cmd);
> +		t = ndctl_decode_smart_temperature(temp);
> +		jobj = json_object_new_double(t);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +				"controller_temperature_threshold",
> jobj);
> +	}
> +
>  	if (alarm_control & ND_SMART_SPARE_TRIP) {
>  		unsigned int spares;
 
We also seem to be missing from the listing, an
alarm_controller_temperature field to show whether or not the alarm is
enabled. Can you add that as well as part of this?


Thanks,
	-Vishal
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
