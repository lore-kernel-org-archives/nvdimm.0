Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 598C8211982FB
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 01:34:11 -0700 (PDT)
Received: from g01jpfmpwkw02.exch.g01.fujitsu.local
 (g01jpfmpwkw02.exch.g01.fujitsu.local [10.0.193.56])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id A3A29AC0214
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jun 2018 17:34:02 +0900 (JST)
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Subject: RE: [ndctl PATCH] ndctl, list: Add controller temperature
Date: Thu, 14 Jun 2018 08:34:00 +0000
Message-ID: <0DEDF3B159719A448A49EF0E7B11E322332C2D17@G01JPEXMBKW02>
References: <152893146792.8891.9589382470202184792.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152893146792.8891.9589382470202184792.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
To: 'Dan Williams' <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Dan
> Williams
> Sent: Thursday, June 14, 2018 8:11 AM
> To: linux-nvdimm@lists.01.org
> Subject: [ndctl PATCH] ndctl, list: Add controller temperature
> 
> Emit the controller temperature if the smart payload includes this field.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/util/json-smart.c |   10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/ndctl/util/json-smart.c b/ndctl/util/json-smart.c index
> 4020423bb8c8..9482b35a43d6 100644
> --- a/ndctl/util/json-smart.c
> +++ b/ndctl/util/json-smart.c
> @@ -109,6 +109,16 @@ struct json_object *util_dimm_health_to_json(struct ndctl_dimm
> *dimm)
>  			json_object_object_add(jhealth, "temperature_celsius",
> jobj);
>  	}
> 
> +	if (flags & ND_SMART_CTEMP_VALID) {
> +		unsigned int temp = ndctl_cmd_smart_get_ctrl_temperature(cmd);
> +		double t = ndctl_decode_smart_temperature(temp);
> +
> +		jobj = json_object_new_double(t);
> +		if (jobj)
> +			json_object_object_add(jhealth,
> +					"controller_temperature_celsius", jobj);
> +	}
> +
>  	if (flags & ND_SMART_SPARES_VALID) {
>  		unsigned int spares = ndctl_cmd_smart_get_spares(cmd);
> 
> 

Hi Dan,

I think it would be more helpful to additionally add controller_temperature_threshold to list.

Qi

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
