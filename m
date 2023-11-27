Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CECA156E3
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 09:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10906"; a="140528652"
X-IronPort-AV: E=Sophos;i="6.04,230,1695654000"; 
   d="scan'208";a="140528652"
Received: from unknown (HELO oym-r2.gw.nic.fujitsu.com) ([210.162.30.90])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Nov 2023 18:34:58 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 7065EDC879
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 18:34:55 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 69AF1D5E39
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 18:34:54 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id F040A20074730
	for <nvdimm@lists.linux.dev>; Mon, 27 Nov 2023 18:34:53 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id 627A91A0071;
	Mon, 27 Nov 2023 17:34:53 +0800 (CST)
Message-ID: <4910174f-4cda-a664-62ee-a6b37f96efac@fujitsu.com>
Date: Mon, 27 Nov 2023 17:34:53 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [NDCTL PATCH v3] cxl/region: Add -f option for disable-region
To: Dave Jiang <dave.jiang@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 dan.j.williams@intel.com, yangx.jy@fujitsu.com
References: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
In-Reply-To: <169878724592.82931.11180459815481606425.stgit@djiang5-mobl3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28022.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28022.006
X-TMASE-Result: 10--7.844900-10.000000
X-TMASE-MatchedRID: Y0uQemhUR+GPvrMjLFD6eJTQgFTHgkhZ7/Ktm1YD8UJRXC4cX65cJItU
	W2TdSbkol/NSQGlzTvYGE8TlUNTQBfXhWE12qWg+zr16YOzjZ136xaEr/b4wE99RjZujPiSkM/N
	vkyt9Qust+E/D3/oNlPYxukP2XD9gAjdZzv0qrOYF7cpFXK76TUsY9G/RZ3FCNWuN5LFStoU6LC
	39ZB+Qn4EV1Mt3/Y7E1KgPgvd6AVqTXkhSOdXFg95x7RpGJf1aBGvINcfHqhcVdewhX2WAAThbu
	aUQKXpspFedpgCFxaUYPKESeEkoF1xxDx5qbkR9OX/V8P8ail1ZDL1gLmoa/ALDAYP4AXVR7nY5
	1lwLq08nRE+fI6etkjzwkOTign5xsnc8TN4GKF7Bu7Frs7ZjFvJGRqNa9xDnSsMfxGFXfDeMVhw
	qBydOrL5/6HiOECuRUAXI5UUCilzFUQg4HLF2+GUkI6wHhrBc5VXrbHg2/4JYe3/imoqI2tQTAL
	RUDgR9z/3NrTLUMeU=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0



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

>   static int do_region_xable(struct cxl_region *region, enum region_actions action)
>   {
>   	switch (action) {
>   	case ACTION_ENABLE:
>   		return cxl_region_enable(region);
>   	case ACTION_DISABLE:
> -		return cxl_region_disable(region);
> +		return disable_region(region);
>   	case ACTION_DESTROY:
>   		return destroy_region(region);
>   	default:

Hi Dave

In this patch, a new function 'disable_region(region)' has been added. 
When using the 'cxl destroy-region region0 -f' command, there's a check 
first, followed by the 'destroy-region' operation. In terms of 
user-friendliness, which function is more user-friendly: 
'cxl_region_disable(region)' or 'disable_region(region)'?

Attach destroy_region section code
static int destroy_region(struct cxl_region *region)
{
     const char *devname = cxl_region_get_devname(region);
     unsigned int ways, i;
     int rc;

     /* First, unbind/disable the region if needed */
     if (cxl_region_is_enabled(region)) {
         if (param.force) {
             rc = cxl_region_disable(region);
             if (rc) {
                 log_err(&rl, "%s: error disabling region: %s\n",
                     devname, strerror(-rc));
                 return rc;
             }
         } else {
             log_err(&rl, "%s active. Disable it or use --force\n",
                 devname);
             return -EBUSY;
         }
     }

I have considered two options for your reference:

1.Assuming the user hasn't executed the 'cxl disable-region region0' 
command and directly runs 'cxl destroy-region region0 -f', using the 
'disable_region(region)' function to first take the region offline and 
then disable it might be more user-friendly.
2.If the user executes the 'cxl disable-region region0' command but 
fails to take it offline successfully, then runs 'cxl destroy-region 
region0 -f', using the 'cxl_region_disable(region)' function to directly 
'disable region' and then 'destroy region' would also be reasonable.





