Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795216FA2
	for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 01:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fujitsu.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
X-IronPort-AV: E=McAfee;i="6600,9927,10909"; a="141296132"
X-IronPort-AV: E=Sophos;i="6.04,237,1695654000"; 
   d="scan'208";a="141296132"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2023 10:41:44 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id AE4B1D9D8F
	for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 10:41:41 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id E56A7D616C
	for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 10:41:40 +0900 (JST)
Received: from edo.cn.fujitsu.com (edo.cn.fujitsu.com [10.167.33.5])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id 614DD6CB1C
	for <nvdimm@lists.linux.dev>; Thu, 30 Nov 2023 10:41:40 +0900 (JST)
Received: from [10.167.220.145] (unknown [10.167.220.145])
	by edo.cn.fujitsu.com (Postfix) with ESMTP id D308F1A0071;
	Thu, 30 Nov 2023 09:41:39 +0800 (CST)
Message-ID: <c4af4018-aec2-4874-ab9b-b24b88e9d9dc@fujitsu.com>
Date: Thu, 30 Nov 2023 09:41:39 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [NDCTL PATCH v2 2/2] cxl: Add check for regions before disabling
 memdev
To: Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
 nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com
References: <170120423159.2725915.14670830315829916850.stgit@djiang5-mobl3>
 <170120423751.2725915.8152057882418377474.stgit@djiang5-mobl3>
From: =?UTF-8?B?Q2FvLCBRdWFucXVhbi/mm7kg5YWo5YWo?= <caoqq@fujitsu.com>
In-Reply-To: <170120423751.2725915.8152057882418377474.stgit@djiang5-mobl3>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-28028.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-28028.004
X-TMASE-Result: 10--4.471100-10.000000
X-TMASE-MatchedRID: AyN7oo9wR5uPvrMjLFD6eJTQgFTHgkhZXQP3X+FD21ATefx8PLB4oE1N
	J2MN+nPka+o/S6GsElBTtuW5X/TasERV7C9ojOZ1EVuC0eNRYvKlR2Q+0FuebvmrkkH6JvZBPrT
	BAt3E1ioXjQchKpIrqqnmDHpokNZJO4kcA8kjsz/v7rnu8XKYwwmWvXEqQTm5wLkNMQzGl5B+Kr
	WCPbERPyqq0O5S3DJ8w06evX0vRhJmLA2er53RRLPx3rO+jk2Qh6nwisY6+c2dzjX37VUcWmm2l
	eUHzyoXtasxpUmh4e7u5J7i9V7QtUPbYPqd/GaJRU4X3Mu13IxaY5+vdounCD3jhzzlBjmIkKVW
	5HpbOFnDzSde0I1kYJGTpe1iiCJq71zr0FZRMbBGONWF/6P/Cg2V/fR8BQ7CKrauXd3MZDXtbOt
	q4+YAAMJhRPrfKcx98Cj1L461M7C47E3JlypOPULHT7GxRvR5Etp++axjLfltbBT5zPx2HTCWfi
	mTkwMi32hU/rUP+VMkmHYVaS8Vs4XYkloiMEdyXn+SCTwlr3Ayyohnaci49PcG7jjNxAW9
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0


> Add a check for memdev disable to see if there are active regions present
> before disabling the device. This is necessary now regions are present to
> fulfill the TODO that was left there. The best way to determine if a
> region is active is to see if there are decoders enabled for the mem
> device. This is also best effort as the state is only a snapshot the
> kernel provides and is not atomic WRT the memdev disable operation. The
> expectation is the admin issuing the command has full control of the mem
> device and there are no other agents also attempt to control the device.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
> v2:
> - Warn if active region regardless of -f. (Alison)
> - Expound on -f behavior in man page. (Vishal)
> ---
>   Documentation/cxl/cxl-disable-memdev.txt |    4 +++-
>   cxl/memdev.c                             |   17 ++++++++++++++---
>   2 files changed, 17 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-disable-memdev.txt b/Documentation/cxl/cxl-disable-memdev.txt
> index c4edb93ee94a..34b720288705 100644
> --- a/Documentation/cxl/cxl-disable-memdev.txt
> +++ b/Documentation/cxl/cxl-disable-memdev.txt
> @@ -27,7 +27,9 @@ include::bus-option.txt[]
>   	a device if the tool determines the memdev is in active usage. Recall
>   	that CXL memory ranges might have been established by platform
>   	firmware and disabling an active device is akin to force removing
> -	memory from a running system.
> +	memory from a running system. Going down this path does not offline
> +	active memory if they are currently online. User is recommended to
> +	offline and disable the appropriate regions before disabling the memdevs.
>   
>   -v::
>   	Turn on verbose debug messages in the library (if libcxl was built with
> diff --git a/cxl/memdev.c b/cxl/memdev.c
> index 2dd2e7fcc4dd..1d3121915284 100644
> --- a/cxl/memdev.c
> +++ b/cxl/memdev.c
> @@ -437,14 +437,25 @@ static int action_free_dpa(struct cxl_memdev *memdev,
>   
>   static int action_disable(struct cxl_memdev *memdev, struct action_context *actx)
>   {
> +	struct cxl_endpoint *ep;
> +	struct cxl_port *port;
> +
>   	if (!cxl_memdev_is_enabled(memdev))
>   		return 0;
>   
> -	if (!param.force) {
> -		/* TODO: actually detect rather than assume active */
> +	ep = cxl_memdev_get_endpoint(memdev);
> +	if (!ep)
> +		return -ENODEV;
> +
> +	port = cxl_endpoint_get_port(ep);
> +	if (!port)
> +		return -ENODEV;
> +
> +	if (cxl_port_decoders_committed(port)) {
>   		log_err(&ml, "%s is part of an active region\n",
>   			cxl_memdev_get_devname(memdev));
> -		return -EBUSY;
> +		if (!param.force)
> +			return -EBUSY;
>   	}
>   
>   	return cxl_memdev_disable_invalidate(memdev);
> 
> 

Reviewed-by: Quanquan Cao <caoqq@fujitsu.com>
