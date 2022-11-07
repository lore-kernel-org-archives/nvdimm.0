Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A914015C91
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 22:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667861277; x=1699397277;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Aqf0w5kAD7DdapEu09eXoWqYNCSclhyGW5VCjVSkcS0=;
  b=nAI26WJAAShSQ2UaLkxquBYkyp9N0BhicoCUl3pZSN/m0TCzgU+zkdlu
   CoDR3y4kjL6dgutJDeCOW/W3N45fvmR6ExaTC78c4blu7dFOzoEMPdJ3w
   tiVUG5qrC/FU0Y1Oxs0OM3SkN8g5Dy9GgY9uCnOIzzAgi4kul9RBfS462
   WubPw4P13vjuW/YyQrnD7/yrCIMKZ0fo656eE9YI2S2zFt/PqXJiyXN8N
   0q8AkEcUynWBn9OECgKzJYkd8greuLRafKNTBFQUxrZuANeOZa1Qzx9Qk
   ZNTa0SZu+lUxZgz6c26DzNh3W/zRkwhvz69kanstL0O3qvKbVC7bIqyj7
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="312328934"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="312328934"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:47:57 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="614043889"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="614043889"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.100.77])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 14:47:57 -0800
Date: Mon, 7 Nov 2022 14:47:55 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 06/15] cxl/list: Skip emitting pmem_size when it is
 zero
Message-ID: <Y2mLGxdAAQjcflbq@aschofie-mobl2>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
 <166777844020.1238089.5777920571190091563.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166777844020.1238089.5777920571190091563.stgit@dwillia2-xfh.jf.intel.com>

On Sun, Nov 06, 2022 at 03:47:20PM -0800, Dan Williams wrote:
> The typical case is that CXL devices are pure ram devices. Only emit
> capacity sizes when they are non-zero to avoid confusion around whether
> pmem is available via partitioning or not.
> 
> Do the same for ram_size on the odd case that someone builds a pure pmem
> device.

The cxl list man page needs a couple of examples updated.

> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  cxl/json.c |   20 +++++++++++++-------
>  1 file changed, 13 insertions(+), 7 deletions(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 63c17519aba1..1b1669ab021d 100644
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
