Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F2F63C5
	for <nvdimm@lists.linux.dev>; Fri,  9 Dec 2022 17:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670606791; x=1702142791;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=8uZsymVEszmRcWpfM3kYLUlwkXYDoyX0oFzJ+nXXB9o=;
  b=Q8Jjlq9vnhJXP0P/q/8wAi5sf3w4wdfvLC4cJhu4dR7PoB2Q+7VBk2QU
   E3f7KAKfGsZ3uBSVFe3ZZsBw1hnxRZOuniJ2JYrTjOTknX+0mqtr4fIAO
   WHasZCZP4yVoqEkf5kNx3DBIjXa5xFUMLPteoy+4dHMnrTwYakFSKuEpk
   dHq7lYl2hk3tnXUpXlSFmxANO4PIDbvHDOL138VkUQUecMgqlb3K6Gh+u
   +7Reir2h7DsPMJntnGC0S8QfEsFFYRfKCmG1fcTNTgez0aV8MwTFCuvxH
   gATXM/kH7dYurZ/zTDY3LyWJTm68FcpfkoJpdLZAeuA5jot6G8tL1LHtN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="300928762"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="300928762"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:26:30 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10556"; a="771922238"
X-IronPort-AV: E=Sophos;i="5.96,230,1665471600"; 
   d="scan'208";a="771922238"
Received: from xinjunwa-mobl.amr.corp.intel.com (HELO aschofie-mobl2) ([10.212.227.125])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2022 09:26:30 -0800
Date: Fri, 9 Dec 2022 09:26:29 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, vishal.l.verma@intel.com,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v2 08/18] cxl/list: Skip emitting pmem_size when it
 is zero
Message-ID: <Y5NvxaB2n1o834pF@aschofie-mobl2>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
 <167053492504.582963.9545867906512429034.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167053492504.582963.9545867906512429034.stgit@dwillia2-xfh.jf.intel.com>

On Thu, Dec 08, 2022 at 01:28:45PM -0800, Dan Williams wrote:
> The typical case is that CXL devices are pure ram devices. Only emit
> capacity sizes when they are non-zero to avoid confusion around whether
> pmem is available via partitioning or not.
> 
> The confusion being that a user may assign more meaning to the zero size
> value than it actually deserves. A zero value for either pmem or ram,
> doesn't indicate the devices capability for either mode.  Use the -I
> option to cxl list to include paritition info in the memdev listing.
> That will explicitly show the ram and pmem capabilities of the device.
> 
> Do the same for ram_size on the odd case that someone builds a pure pmem
> device.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>

> 
> Cc: Alison Schofield <alison.schofield@intel.com>
> [alison: clarify changelog]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/cxl/cxl-list.txt |    5 -----
>  cxl/json.c                     |   20 +++++++++++++-------
>  2 files changed, 13 insertions(+), 12 deletions(-)
> 
> diff --git a/Documentation/cxl/cxl-list.txt b/Documentation/cxl/cxl-list.txt
> index 14a2b4bb5c2a..56229abcb053 100644
> --- a/Documentation/cxl/cxl-list.txt
> +++ b/Documentation/cxl/cxl-list.txt
> @@ -70,7 +70,6 @@ configured.
>  {
>    "memdev":"mem0",
>    "pmem_size":"256.00 MiB (268.44 MB)",
> -  "ram_size":0,
>    "serial":"0",
>    "host":"0000:35:00.0"
>  }
> @@ -88,7 +87,6 @@ EXAMPLE
>    {
>      "memdev":"mem0",
>      "pmem_size":268435456,
> -    "ram_size":0,
>      "serial":0,
>      "host":"0000:35:00.0"
>    }
> @@ -101,7 +99,6 @@ EXAMPLE
>        {
>          "memdev":"mem0",
>          "pmem_size":"256.00 MiB (268.44 MB)",
> -        "ram_size":0,
>          "serial":"0"
>        }
>      ]
> @@ -129,7 +126,6 @@ OPTIONS
>    {
>      "memdev":"mem0",
>      "pmem_size":268435456,
> -    "ram_size":0,
>      "serial":0
>    },
>    {
> @@ -204,7 +200,6 @@ OPTIONS
>  [
>    {
>      "memdev":"mem0",
> -    "pmem_size":0,
>      "ram_size":273535729664,
>      "partition_info":{
>        "total_size":273535729664,
> diff --git a/cxl/json.c b/cxl/json.c
> index 2f3639ede2f8..292e8428ccee 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -305,7 +305,7 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  {
>  	const char *devname = cxl_memdev_get_devname(memdev);
>  	struct json_object *jdev, *jobj;
> -	unsigned long long serial;
> +	unsigned long long serial, size;
>  	int numa_node;
>  
>  	jdev = json_object_new_object();
> @@ -316,13 +316,19 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  	if (jobj)
>  		json_object_object_add(jdev, "memdev", jobj);
>  
> -	jobj = util_json_object_size(cxl_memdev_get_pmem_size(memdev), flags);
> -	if (jobj)
> -		json_object_object_add(jdev, "pmem_size", jobj);
> +	size = cxl_memdev_get_pmem_size(memdev);
> +	if (size) {
> +		jobj = util_json_object_size(size, flags);
> +		if (jobj)
> +			json_object_object_add(jdev, "pmem_size", jobj);
> +	}
>  
> -	jobj = util_json_object_size(cxl_memdev_get_ram_size(memdev), flags);
> -	if (jobj)
> -		json_object_object_add(jdev, "ram_size", jobj);
> +	size = cxl_memdev_get_ram_size(memdev);
> +	if (size) {
> +		jobj = util_json_object_size(size, flags);
> +		if (jobj)
> +			json_object_object_add(jdev, "ram_size", jobj);
> +	}
>  
>  	if (flags & UTIL_JSON_HEALTH) {
>  		jobj = util_cxl_memdev_health_to_json(memdev, flags);
> 
