Received: from esa9.hc1455-7.c3s2.iphmx.com (esa9.hc1455-7.c3s2.iphmx.com [139.138.36.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1504A28
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 02:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10907"; a="129539192"
X-IronPort-AV: E=Sophos;i="6.04,232,1695654000"; 
   d="scan'208";a="129539192"
Received: from unknown (HELO oym-r1.gw.nic.fujitsu.com) ([210.162.30.89])
  by esa9.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2023 11:19:32 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r1.gw.nic.fujitsu.com (Postfix) with ESMTP id 22687D2A02
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 11:19:30 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 54F7A28739
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 11:19:29 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id CC49E20077803
	for <nvdimm@lists.linux.dev>; Tue, 28 Nov 2023 11:19:28 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 1AF111A0070;
	Tue, 28 Nov 2023 10:19:27 +0800 (CST)
Message-ID: <1b874403-f59a-0688-c26d-1593c11c820e@fujitsu.com>
Date: Tue, 28 Nov 2023 10:19:27 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [NDCTL PATCH] cxl/region: Move cxl destroy_region() to new
 disable_region() helper
To: Dave Jiang <dave.jiang@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <170112921107.2687457.2741231995154639197.stgit@djiang5-mobl3>
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
In-Reply-To: <170112921107.2687457.2741231995154639197.stgit@djiang5-mobl3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28024.003
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28024.003
X-TMASE-Result: 10--8.067200-10.000000
X-TMASE-MatchedRID: 4y9/ylYYqyaPvrMjLFD6eAdJO1X873z+JuDBbd4NSqQTefx8PLB4oAun
	S16vgdV1Hr3zfXlPv77cL6ACd2BGu6ZY4PxfRMWETuctSpiuWyUUi4Ehat05499RlPzeVuQQyL5
	QmWOgMfCrRqARCiRCRFDAeXgU2drWtluGG+j/1f4cGzeKG+gwiH607foZgOWyHTMj5a5/7iagt4
	bI+KwqnTNk7MduL6bQRsM+EkEm//zKVlK+ZD4tD7+a7Hw+x9qZpR+m8tBi6ZLe6dEbvIyrxWcdu
	Y7Ph1FD4vM1YF6AJbZFi+KwZZttL7ew1twePJJB2KDPNsqphTL6C0ePs7A07QdNP5JHgU8AQcL2
	MbFd8ZPznFtmBeT7gGLCoKI4jsOla5WTHNnSipYNX0ZOp1LiI2Qsd+hNG1G8mw1Z0oFgqZ1DEaQ
	hBOl4/npAQDR12POz9Kpk6L5uXxvmjpqHWd5d8YvXMDl2Z/5HFUZFMicqbsM=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



> To keep the behavior consistent with the disable region operation, change
> the calling of cxl_region_disable() directly in destroy_region() to the
> new disable_region() helper in order to check whether the region is still
> online.
> 
> Suggested-by: Quanquan Cao <caoqq@fujitsu.com>
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>   cxl/region.c |  100 +++++++++++++++++++++++++++++-----------------------------
>   1 file changed, 50 insertions(+), 50 deletions(-)
> 
> diff --git a/cxl/region.c b/cxl/region.c
> index 5cbbf2749e2d..4091ee8d2713 100644
> --- a/cxl/region.c
> +++ b/cxl/region.c
> @@ -728,6 +728,55 @@ out:
>   	return rc;
>   }
>   
> +static int disable_region(struct cxl_region *region)
> +{
> +	const char *devname = cxl_region_get_devname(region);
> +	struct daxctl_region *dax_region;
> +	struct daxctl_memory *mem;
> +	struct daxctl_dev *dev;
> +	int failed = 0, rc;
> +
> +	dax_region = cxl_region_get_daxctl_region(region);
> +	if (!dax_region)
> +		goto out;
> +
> +	daxctl_dev_foreach(dax_region, dev) {
> +		mem = daxctl_dev_get_memory(dev);
> +		if (!mem)
> +			return -ENXIO;
> +
> +		/*
> +		 * If memory is still online and user wants to force it, attempt
> +		 * to offline it.
> +		 */
> +		if (daxctl_memory_is_online(mem)) {
> +			rc = daxctl_memory_offline(mem);
> +			if (rc < 0) {
> +				log_err(&rl, "%s: unable to offline %s: %s\n",
> +					devname,
> +					daxctl_dev_get_devname(dev),
> +					strerror(abs(rc)));
> +				if (!param.force)
> +					return rc;
> +
> +				failed++;
> +			}
> +		}
> +	}
> +
> +	if (failed) {
> +		log_err(&rl, "%s: Forcing region disable without successful offline.\n",
> +			devname);
> +		log_err(&rl, "%s: Physical address space has now been permanently leaked.\n",
> +			devname);
> +		log_err(&rl, "%s: Leaked address cannot be recovered until a reboot.\n",
> +			devname);
> +	}
> +
> +out:
> +	return cxl_region_disable(region);
> +}
> +
>   static int destroy_region(struct cxl_region *region)
>   {
>   	const char *devname = cxl_region_get_devname(region);
> @@ -737,7 +786,7 @@ static int destroy_region(struct cxl_region *region)
>   	/* First, unbind/disable the region if needed */
>   	if (cxl_region_is_enabled(region)) {
>   		if (param.force) {
> -			rc = cxl_region_disable(region);
> +			rc = disable_region(region);
>   			if (rc) {
>   				log_err(&rl, "%s: error disabling region: %s\n",
>   					devname, strerror(-rc));
> @@ -792,55 +841,6 @@ static int destroy_region(struct cxl_region *region)
>   	return cxl_region_delete(region);
>   }
>   
> -static int disable_region(struct cxl_region *region)
> -{
> -	const char *devname = cxl_region_get_devname(region);
> -	struct daxctl_region *dax_region;
> -	struct daxctl_memory *mem;
> -	struct daxctl_dev *dev;
> -	int failed = 0, rc;
> -
> -	dax_region = cxl_region_get_daxctl_region(region);
> -	if (!dax_region)
> -		goto out;
> -
> -	daxctl_dev_foreach(dax_region, dev) {
> -		mem = daxctl_dev_get_memory(dev);
> -		if (!mem)
> -			return -ENXIO;
> -
> -		/*
> -		 * If memory is still online and user wants to force it, attempt
> -		 * to offline it.
> -		 */
> -		if (daxctl_memory_is_online(mem)) {
> -			rc = daxctl_memory_offline(mem);
> -			if (rc < 0) {
> -				log_err(&rl, "%s: unable to offline %s: %s\n",
> -					devname,
> -					daxctl_dev_get_devname(dev),
> -					strerror(abs(rc)));
> -				if (!param.force)
> -					return rc;
> -
> -				failed++;
> -			}
> -		}
> -	}
> -
> -	if (failed) {
> -		log_err(&rl, "%s: Forcing region disable without successful offline.\n",
> -			devname);
> -		log_err(&rl, "%s: Physical address space has now been permanently leaked.\n",
> -			devname);
> -		log_err(&rl, "%s: Leaked address cannot be recovered until a reboot.\n",
> -			devname);
> -	}
> -
> -out:
> -	return cxl_region_disable(region);
> -}
> -
>   static int do_region_xable(struct cxl_region *region, enum region_actions action)
>   {
>   	switch (action) {
> 

Thank you very much for your patch.

Reviewed-by: Quanquan Cao <caoqq@fujitsu.com>
