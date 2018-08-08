Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52B42210E2A6A
 for <linux-nvdimm@lists.01.org>; Wed,  8 Aug 2018 11:31:16 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2] ndctl, list: add alarm_enable_<field> to list
Date: Wed, 8 Aug 2018 18:31:14 +0000
Message-ID: <1533753073.7673.2.camel@intel.com>
References: <20180808024335.12793-1-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180808024335.12793-1-qi.fuli@jp.fujitsu.com>
Content-Language: en-US
Content-ID: <D2A001F63A63D340A7EED9D29EB244B6@intel.com>
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


On Wed, 2018-08-08 at 11:43 +0900, QI Fuli wrote:
> This patch adds alarm_enable_<field> to list, so that users could
> check
> if the "ndctl inject-smart --<field>-alarm=on/off" works well or not.
> 
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
> v1 -> v2:
>  remove the renaming for list items.

Thanks, looks good and applied.

> 
>  ndctl/util/json-smart.c | 27 +++++++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
> 
> diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c
> index 6a1f294..e25483d 100644
> --- a/ndctl/util/json-smart.c
> +++ b/ndctl/util/json-smart.c
> @@ -39,34 +39,61 @@ static void smart_threshold_to_json(struct
> ndctl_dimm *dimm,
>  		unsigned int temp;
>  		double t;
>  
> +		jobj = json_object_new_boolean(true);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +					"alarm_enable_media_temperat
> ure", jobj);
>  		temp =
> ndctl_cmd_smart_threshold_get_temperature(cmd);
>  		t = ndctl_decode_smart_temperature(temp);
>  		jobj = json_object_new_double(t);
>  		if (jobj)
>  			json_object_object_add(jhealth,
>  					"temperature_threshold",
> jobj);
> +	} else {
> +		jobj = json_object_new_boolean(false);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +					"alarm_enable_media_temperat
> ure", jobj);
>  	}
>  
>  	if (alarm_control & ND_SMART_CTEMP_TRIP) {
>  		unsigned int temp;
>  		double t;
>  
> +		jobj = json_object_new_boolean(true);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +					"alarm_enable_ctrl_temperatu
> re", jobj);
>  		temp =
> ndctl_cmd_smart_threshold_get_ctrl_temperature(cmd);
>  		t = ndctl_decode_smart_temperature(temp);
>  		jobj = json_object_new_double(t);
>  		if (jobj)
>  			json_object_object_add(jhealth,
>  				"controller_temperature_threshold",
> jobj);
> +	} else {
> +		jobj = json_object_new_boolean(false);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +					"alarm_enable_ctrl_temperatu
> re", jobj);
>  	}
>  
>  	if (alarm_control & ND_SMART_SPARE_TRIP) {
>  		unsigned int spares;
>  
> +		jobj = json_object_new_boolean(true);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +					"alarm_enable_spares",
> jobj);
>  		spares = ndctl_cmd_smart_threshold_get_spares(cmd);
>  		jobj = json_object_new_int(spares);
>  		if (jobj)
>  			json_object_object_add(jhealth,
>  					"spares_threshold", jobj);
> +	} else {
> +		jobj = json_object_new_boolean(false);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +					"alarm_enable_spares",
> jobj);
>  	}
>  
>   out:
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
