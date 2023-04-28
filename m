Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E133D86
	for <nvdimm@lists.linux.dev>; Fri, 28 Apr 2023 15:54:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682697291; x=1714233291;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QLPrIph+fe/SWwZ8cw8dSek/MCRr8k7nKEFX0clMKJU=;
  b=BUaC9VSt4WaXQBCJsldbYIWdzTCJXGP4Bo43R+4QJuICtDHE+JI7Bjbp
   bsK+TCkgnqgcAqkbVRXvWDIe5Phedjg6MySHI1HUHhcKmIU0SqPF1FAIX
   uZueBiybGb+6A6/aJbdSWfSicK0GS/XZa+mcz4gmL7Z1y/1N3psRST7ox
   OgXZ8xYsDKHcOx/IljmjHtGq9vNVaRyA+X46TVkxF1HXNpGmqf+jM3pg9
   PVs/bFN4CEP6GVP+lGq70Xn0mtvHSRYqkbgYroL69yB86mN7jvAzq8kQr
   WlmG/uAmQCZHag6ezO4SEGwPsyhn8jec45Z1/dS/g6rN1YPvyHyTfLu4J
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="375776785"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="375776785"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 08:54:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10694"; a="688862672"
X-IronPort-AV: E=Sophos;i="5.99,235,1677571200"; 
   d="scan'208";a="688862672"
Received: from egliskay-mobl.amr.corp.intel.com (HELO [10.212.108.170]) ([10.212.108.170])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2023 08:54:50 -0700
Message-ID: <30c92901-48e3-61d8-5865-632af4a5fb97@intel.com>
Date: Fri, 28 Apr 2023 08:54:49 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.10.0
Subject: Re: [PATCH 1/4] cxl/list: Fix filtering RCDs
Content-Language: en-US
To: Dan Williams <dan.j.williams@intel.com>, vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
References: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
 <168236637746.1027628.14674251843014155022.stgit@dwillia2-xfh.jf.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <168236637746.1027628.14674251843014155022.stgit@dwillia2-xfh.jf.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/23 12:59 PM, Dan Williams wrote:
> Attempts to filter by memdev fail when the memdev is an RCD (RCH topology):
> 
>      # cxl list -BEM -m 11
>        Warning: no matching devices found
> 
>      [
>      ]
> 
> This is caused by VH topology assumption where an intervening host-bridge
> port is expected between the root CXL port and the endpoint. In an RCH
> topology an endpoint is integrated in the host-bridge.
> 
> Search for endpoints directly attached to the root:
> 
>      # cxl list -BEMu -m 11
>      {
>        "bus":"root3",
>        "provider":"cxl_test",
>        "endpoints:root3":[
>          {
>            "endpoint":"endpoint22",
>            "host":"mem11",
>            "depth":1,
>            "memdev":{
>              "memdev":"mem11",
>              "ram_size":"2.00 GiB (2.15 GB)",
>              "serial":"0xa",
>              "numa_node":0,
>              "host":"cxl_rcd.10"
>            }
>          }
>        ]
>      }
> 
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>   cxl/lib/libcxl.c |   19 ++++++++++++++++---
>   1 file changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index 59e5bdbcc750..e6c94d623303 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -1457,8 +1457,9 @@ CXL_EXPORT int cxl_memdev_enable(struct cxl_memdev *memdev)
>   	return 0;
>   }
>   
> -static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
> -						   struct cxl_memdev *memdev)
> +static struct cxl_endpoint *
> +cxl_port_recurse_endpoint(struct cxl_port *parent_port,
> +			  struct cxl_memdev *memdev)
>   {
>   	struct cxl_endpoint *endpoint;
>   	struct cxl_port *port;
> @@ -1468,7 +1469,7 @@ static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
>   			if (strcmp(cxl_endpoint_get_host(endpoint),
>   				   cxl_memdev_get_devname(memdev)) == 0)
>   				return endpoint;
> -		endpoint = cxl_port_find_endpoint(port, memdev);
> +		endpoint = cxl_port_recurse_endpoint(port, memdev);
>   		if (endpoint)
>   			return endpoint;
>   	}
> @@ -1476,6 +1477,18 @@ static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
>   	return NULL;
>   }
>   
> +static struct cxl_endpoint *cxl_port_find_endpoint(struct cxl_port *parent_port,
> +						   struct cxl_memdev *memdev)
> +{
> +	struct cxl_endpoint *endpoint;
> +
> +	cxl_endpoint_foreach(parent_port, endpoint)
> +		if (strcmp(cxl_endpoint_get_host(endpoint),
> +			   cxl_memdev_get_devname(memdev)) == 0)
> +			return endpoint;
> +	return cxl_port_recurse_endpoint(parent_port, memdev);
> +}
> +
>   CXL_EXPORT struct cxl_endpoint *
>   cxl_memdev_get_endpoint(struct cxl_memdev *memdev)
>   {
> 
> 
