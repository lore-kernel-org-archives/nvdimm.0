Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 878322F37
	for <nvdimm@lists.linux.dev>; Mon,  7 Nov 2022 20:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667852622; x=1699388622;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZNQpSdbft8os7UBc1T7ie740D4/M6gAht1R7k+2zG14=;
  b=HhHhPpG/2ISEY0TfWiiXKyR1jzo9wWlVYVeBZv7sPF4AJkNCVB1GRVkj
   sc4ltoEqDi9RJSk39m4K4vDBcPSHzcLzbWXeVD52FPeJCsabjMcL6O7n/
   eYSWLakBJF4IxS5wvgfR/w2mvCQf7ebVywhzfXxtvzhlWULO12EgDTjUt
   5X877hfcAPM5sACj1briepP7GG6MmIWr87wTOJK3dnJ984zjfB7QL+5pp
   +/MkajZ6sV6Ni6WZf/HSR12ejUMy7tjA1Om8y0K7N87iXaubjNh2ZlRyF
   fBqYNeVDvbgXWpfXIw50qD0O1isaCiF13YSHJdmlVv3aERLheoxN+7gHZ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="308140586"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="308140586"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 12:23:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10524"; a="725290475"
X-IronPort-AV: E=Sophos;i="5.96,145,1665471600"; 
   d="scan'208";a="725290475"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.100.77])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2022 12:23:41 -0800
Date: Mon, 7 Nov 2022 12:23:39 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 06/15] cxl/list: Skip emitting pmem_size when it is
 zero
Message-ID: <Y2lpS3COS9YdJnon@aschofie-mobl2>
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

Maybe a few more words around what confusion this seeks to avoid.
The confusion being that a user may assign more meaning to the zero
size value than it actually deserves. A zero value for either 
pmem or ram, doesn't indicate the devices capability for either mode.
Use the -I option to cxl list to include paritition info in the
memdev listing. That will explicitly show the ram and pmem capabilities
of the device.


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
