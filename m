Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3B4FC02
	for <nvdimm@lists.linux.dev>; Mon,  7 Aug 2023 13:14:39 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.226])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RKGr46QBXz6802T;
	Mon,  7 Aug 2023 21:09:40 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Mon, 7 Aug
 2023 14:14:36 +0100
Date: Mon, 7 Aug 2023 14:14:35 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Jehoon Park <jehoon.park@samsung.com>
CC: <linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Dave
 Jiang" <dave.jiang@intel.com>, Davidlohr Bueso <dave@stgolabs.net>, "Kyungsan
 Kim" <ks0204.kim@samsung.com>, Junhyeok Im <junhyeok.im@samsung.com>
Subject: Re: [ndctl PATCH v2 2/3] libcxl: Fix accessors for temperature
 field to support negative value
Message-ID: <20230807141435.00004eb0@Huawei.com>
In-Reply-To: <20230807063549.5942-3-jehoon.park@samsung.com>
References: <20230807063549.5942-1-jehoon.park@samsung.com>
	<CGME20230807063538epcas2p4965d5d117b8ef87ac4217bec53beff95@epcas2p4.samsung.com>
	<20230807063549.5942-3-jehoon.park@samsung.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml500002.china.huawei.com (7.191.160.78) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Mon,  7 Aug 2023 15:35:48 +0900
Jehoon Park <jehoon.park@samsung.com> wrote:

> Add a new macro function to retrieve a signed value such as a temperature.
> Modify accessors for signed value to return INT_MAX when error occurs and
> set errno to corresponding errno codes.

None of the callers have been modified to deal with INTMAX until next patch.
So I think you need to combine the two to avoid temporary breakage.

Also you seem to be also changing the health status.  That seems
to be unrelated to the negative temperature support so shouldn't
really be in same patch.

> 
> Signed-off-by: Jehoon Park <jehoon.park@samsung.com>
> ---
>  cxl/lib/libcxl.c | 32 +++++++++++++++++++++-----------
>  1 file changed, 21 insertions(+), 11 deletions(-)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index af4ca44..fc64de1 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -3661,11 +3661,23 @@ cxl_cmd_alert_config_get_life_used_prog_warn_threshold(struct cxl_cmd *cmd)
>  			 life_used_prog_warn_threshold);
>  }
>  
> +#define cmd_get_field_s16(cmd, n, N, field)				\
> +do {									\
> +	struct cxl_cmd_##n *c =						\
> +		(struct cxl_cmd_##n *)cmd->send_cmd->out.payload;	\
> +	int rc = cxl_cmd_validate_status(cmd, CXL_MEM_COMMAND_ID_##N);	\
> +	if (rc)	{							\
> +		errno = -rc;						\
> +		return INT_MAX;						\
> +	}								\
> +	return (int16_t)le16_to_cpu(c->field);				\
> +} while(0)
> +
>  CXL_EXPORT int
>  cxl_cmd_alert_config_get_dev_over_temperature_crit_alert_threshold(
>  	struct cxl_cmd *cmd)
>  {
> -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
>  			  dev_over_temperature_crit_alert_threshold);
>  }
>  
> @@ -3673,7 +3685,7 @@ CXL_EXPORT int
>  cxl_cmd_alert_config_get_dev_under_temperature_crit_alert_threshold(
>  	struct cxl_cmd *cmd)
>  {
> -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
>  			  dev_under_temperature_crit_alert_threshold);
>  }
>  
> @@ -3681,7 +3693,7 @@ CXL_EXPORT int
>  cxl_cmd_alert_config_get_dev_over_temperature_prog_warn_threshold(
>  	struct cxl_cmd *cmd)
>  {
> -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
>  			  dev_over_temperature_prog_warn_threshold);
>  }
>  
> @@ -3689,7 +3701,7 @@ CXL_EXPORT int
>  cxl_cmd_alert_config_get_dev_under_temperature_prog_warn_threshold(
>  	struct cxl_cmd *cmd)
>  {
> -	cmd_get_field_u16(cmd, get_alert_config, GET_ALERT_CONFIG,
> +	cmd_get_field_s16(cmd, get_alert_config, GET_ALERT_CONFIG,
>  			  dev_under_temperature_prog_warn_threshold);
>  }
>  
> @@ -3905,8 +3917,6 @@ CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
>  {
>  	int rc = health_info_get_life_used_raw(cmd);
>  
> -	if (rc < 0)
> -		return rc;

Why has this one changed?  It's a u8 so not as far as I can see affected by
your new signed accessor.


>  	if (rc == CXL_CMD_HEALTH_INFO_LIFE_USED_NOT_IMPL)
>  		return -EOPNOTSUPP;
>  	return rc;
> @@ -3914,7 +3924,7 @@ CXL_EXPORT int cxl_cmd_health_info_get_life_used(struct cxl_cmd *cmd)
>  
>  static int health_info_get_temperature_raw(struct cxl_cmd *cmd)
>  {
> -	cmd_get_field_u16(cmd, get_health_info, GET_HEALTH_INFO,
> +	cmd_get_field_s16(cmd, get_health_info, GET_HEALTH_INFO,
>  				 temperature);
>  }
>  
> @@ -3922,10 +3932,10 @@ CXL_EXPORT int cxl_cmd_health_info_get_temperature(struct cxl_cmd *cmd)
>  {
>  	int rc = health_info_get_temperature_raw(cmd);
>  
> -	if (rc < 0)
> -		return rc;
> -	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL)
> -		return -EOPNOTSUPP;
> +	if (rc == CXL_CMD_HEALTH_INFO_TEMPERATURE_NOT_IMPL) {
> +		errno = EOPNOTSUPP;
> +		return INT_MAX;
> +	}
>  	return rc;
>  }
>  

