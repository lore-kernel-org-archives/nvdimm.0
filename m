Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10ED274B23
	for <nvdimm@lists.linux.dev>; Mon,  8 Jun 2026 23:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780960791; cv=none; b=bJIKsDydzPr9PJv8ubUsHknLdo3XirPWDljHByG1uy79tiWR9867EAHu16GXjksdSyVQtbDBpehLvnSyBoR2rOEPEXH3N5m8oQVjf1G3OmEbgHfVRRoVGWmuUzB0L+M9wtsSGe1extqgybUaKLAEmkzJSsvK8n/g2yyRX3//odg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780960791; c=relaxed/simple;
	bh=8hvDOVKJszXEp+AYzLQL+Hh1YHha7RC7l80DkTfftXU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UKDViT98yDB8e++9RDTgxEBLDI/2RtGoYZN+09Xlku0QDFeHg+6RKoti/fYyBcqARCYkCrO1ZaHNb9lsBdu0kJMIO/PCE5bZDOKMhmUd5ojvchkNEOllEFuBB7FcIvImFtixg5XK3sSJIz76fu75mpveEaD72j50z/aaXGZ5qeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=brw9HwuZ; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="brw9HwuZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780960790; x=1812496790;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8hvDOVKJszXEp+AYzLQL+Hh1YHha7RC7l80DkTfftXU=;
  b=brw9HwuZw9jU227kPdxuaLX2PtIpXqYq38HwwkVWOAqKi1AYIhs3TSd0
   G05al7OYsbuX/cFlq97v9AvK/0C0HO+c25Zjo4uLF1jS1Arx1IeLCBB03
   zsDsP3jNz7WjF+frEcENsyyrC02N4S06WJAKje/3Bew7K6ws9ntyj4U21
   qGRLoiGgqkOjlDNIXW6TU5PU5zef8HKzUg9YfIYBKr0PaSqvHx+ar6DG2
   Q3g5EAxPY1FrjjvRlQQjQuvf9vIYevVj5WuQFqW3/2DEkQABIYMzMVwTq
   Y6z2Qb/SU15MQF19e4MmoiXnZvAfL9v+9LeVarLXdaF9BljnGTem5mDlY
   w==;
X-CSE-ConnectionGUID: pgbqdKQ4SaGq9VRRZatdzw==
X-CSE-MsgGUID: 5peFvjNcRY2JMRGMQ7s4bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11811"; a="80845266"
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="80845266"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:19:49 -0700
X-CSE-ConnectionGUID: Rc30jgW8ShKp6U8th0KI/w==
X-CSE-MsgGUID: E9ltthh3QzKUootU9EcD8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,195,1774335600"; 
   d="scan'208";a="249606962"
Received: from bradocaj-mobl.ger.corp.intel.com (HELO [10.125.109.162]) ([10.125.109.162])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2026 16:19:48 -0700
Message-ID: <06747633-ed22-48a2-b8d0-c9b544a682f8@intel.com>
Date: Mon, 8 Jun 2026 16:19:47 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/7] libcxl: Add Dynamic RAM A partition mode support
To: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
 linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Dan Williams <djbw@kernel.org>,
 Jonathan Cameron <jic23@kernel.org>, Davidlohr Bueso <dave@stgolabs.net>,
 Ira Weiny <iweiny@kernel.org>, Alison Schofield
 <alison.schofield@intel.com>, John Groves <John@Groves.net>,
 Gregory Price <gourry@gourry.net>, Ira Weiny <ira.weiny@intel.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-3-anisa.su@samsung.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260523095043.471098-3-anisa.su@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 5/23/26 2:50 AM, Anisa Su wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> Dynamic capacity partitions are exposed as a singular dynamic ram
> partition.
> 
> Add CXL library support to read this partition information.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>

Missing Anisa sign off.

Can probably squash this and the next commit so the usage is shown for the reviewer.

DJ

> ---
>  Documentation/cxl/lib/libcxl.txt |  6 +++--
>  cxl/lib/libcxl.c                 | 43 ++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym               |  4 +++
>  cxl/lib/private.h                |  3 +++
>  cxl/libcxl.h                     | 10 +++++++-
>  5 files changed, 63 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
> index 5c3ebd4..9921ac1 100644
> --- a/Documentation/cxl/lib/libcxl.txt
> +++ b/Documentation/cxl/lib/libcxl.txt
> @@ -74,6 +74,7 @@ int cxl_memdev_get_major(struct cxl_memdev *memdev);
>  int cxl_memdev_get_minor(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
> +unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
>  const char *cxl_memdev_get_firmware_version(struct cxl_memdev *memdev);
>  size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
>  int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
> @@ -93,8 +94,8 @@ The character device node for command submission can be found by default
>  at /dev/cxl/mem%d, or created with a major / minor returned from
>  cxl_memdev_get_{major,minor}().
>  
> -The 'pmem_size' and 'ram_size' attributes return the current
> -provisioning of DPA (Device Physical Address / local capacity) in the
> +The 'pmem_size', 'ram_size', and 'dynamic_ram_a_size' attributes return the
> +current provisioning of DPA (Device Physical Address / local capacity) in the
>  device.
>  
>  cxl_memdev_get_numa_node() returns the affinitized CPU node number if
> @@ -453,6 +454,7 @@ enum cxl_decoder_mode {
>  	CXL_DECODER_MODE_MIXED,
>  	CXL_DECODER_MODE_PMEM,
>  	CXL_DECODER_MODE_RAM,
> +	CXL_DECODER_MODE_DYNAMIC_RAM_A,
>  };
>  enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
>  int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
> diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
> index e55a7b4..be0bc03 100644
> --- a/cxl/lib/libcxl.c
> +++ b/cxl/lib/libcxl.c
> @@ -501,6 +501,9 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
>  		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
>  			if (root_decoder->qos_class != memdev->pmem_qos_class)
>  				return true;
> +		} else if (region->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
> +			if (root_decoder->qos_class != memdev->dynamic_ram_a_qos_class)
> +				return true;
>  		}
>  	}
>  
> @@ -1426,6 +1429,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>  	if (sysfs_read_attr(ctx, path, buf) == 0)
>  		memdev->ram_size = strtoull(buf, NULL, 0);
>  
> +	sprintf(path, "%s/dynamic_ram_a/size", cxlmem_base);
> +	if (sysfs_read_attr(ctx, path, buf) == 0)
> +		memdev->dynamic_ram_a_size = strtoull(buf, NULL, 0);
> +
>  	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
>  	if (sysfs_read_attr(ctx, path, buf) < 0)
>  		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
> @@ -1438,6 +1445,12 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
>  	else
>  		memdev->ram_qos_class = atoi(buf);
>  
> +	sprintf(path, "%s/dynamic_ram_a/qos_class", cxlmem_base);
> +	if (sysfs_read_attr(ctx, path, buf) < 0)
> +		memdev->dynamic_ram_a_qos_class = CXL_QOS_CLASS_NONE;
> +	else
> +		memdev->dynamic_ram_a_qos_class = atoi(buf);
> +
>  	sprintf(path, "%s/payload_max", cxlmem_base);
>  	if (sysfs_read_attr(ctx, path, buf) == 0) {
>  		memdev->payload_max = strtoull(buf, NULL, 0);
> @@ -1685,6 +1698,11 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
>  	return memdev->ram_size;
>  }
>  
> +CXL_EXPORT unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev)
> +{
> +	return memdev->dynamic_ram_a_size;
> +}
> +
>  CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
>  {
>  	return memdev->pmem_qos_class;
> @@ -1695,6 +1713,11 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
>  	return memdev->ram_qos_class;
>  }
>  
> +CXL_EXPORT int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev)
> +{
> +	return memdev->dynamic_ram_a_qos_class;
> +}
> +
>  CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
>  {
>  	return memdev->firmware_version;
> @@ -2465,6 +2488,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  			decoder->mode = CXL_DECODER_MODE_MIXED;
>  		else if (strcmp(buf, "none") == 0)
>  			decoder->mode = CXL_DECODER_MODE_NONE;
> +		else if (strcmp(buf, "dynamic_ram_a") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
>  		else
>  			decoder->mode = CXL_DECODER_MODE_MIXED;
>  	} else
> @@ -2504,6 +2529,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  	case CXL_PORT_SWITCH:
>  		decoder->pmem_capable = true;
>  		decoder->volatile_capable = true;
> +		decoder->dynamic_ram_a_capable = true;
>  		decoder->mem_capable = true;
>  		decoder->accelmem_capable = true;
>  		sprintf(path, "%s/locked", cxldecoder_base);
> @@ -2528,6 +2554,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  			{ "cap_type3", &decoder->mem_capable },
>  			{ "cap_ram", &decoder->volatile_capable },
>  			{ "cap_pmem", &decoder->pmem_capable },
> +			{ "cap_dynamic_ram_a", &decoder->dynamic_ram_a_capable },
>  			{ "locked", &decoder->locked },
>  		};
>  
> @@ -2778,6 +2805,9 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
>  	case CXL_DECODER_MODE_RAM:
>  		sprintf(buf, "ram");
>  		break;
> +	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
> +		sprintf(buf, "dynamic_ram_a");
> +		break;
>  	default:
>  		err(ctx, "%s: unsupported mode: %d\n",
>  		    cxl_decoder_get_devname(decoder), mode);
> @@ -2829,6 +2859,11 @@ CXL_EXPORT bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder)
>  	return decoder->volatile_capable;
>  }
>  
> +CXL_EXPORT bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder)
> +{
> +	return decoder->dynamic_ram_a_capable;
> +}
> +
>  CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
>  {
>  	return decoder->mem_capable;
> @@ -2903,6 +2938,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
>  		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
>  	else if (mode == CXL_DECODER_MODE_RAM)
>  		sprintf(path, "%s/create_ram_region", decoder->dev_path);
> +	else if (mode == CXL_DECODER_MODE_DYNAMIC_RAM_A)
> +		sprintf(path, "%s/create_dynamic_ram_a_region", decoder->dev_path);
>  
>  	rc = sysfs_read_attr(ctx, path, buf);
>  	if (rc < 0) {
> @@ -2954,6 +2991,12 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
>  	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
>  }
>  
> +CXL_EXPORT struct cxl_region *
> +cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder)
> +{
> +	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_DYNAMIC_RAM_A);
> +}
> +
>  CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
>  {
>  	return decoder->nr_targets;
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index ed4429f..258bdd3 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -294,6 +294,10 @@ global:
>  	cxl_memdev_get_fwctl;
>  	cxl_fwctl_get_major;
>  	cxl_fwctl_get_minor;
> +	cxl_memdev_get_dynamic_ram_a_size;
> +	cxl_memdev_get_dynamic_ram_a_qos_class;
> +	cxl_decoder_is_dynamic_ram_a_capable;
> +	cxl_decoder_create_dynamic_ram_a_region;
>  } LIBECXL_8;
>  
>  LIBCXL_10 {
> diff --git a/cxl/lib/private.h b/cxl/lib/private.h
> index d2d71fc..37b7b06 100644
> --- a/cxl/lib/private.h
> +++ b/cxl/lib/private.h
> @@ -52,8 +52,10 @@ struct cxl_memdev {
>  	struct list_node list;
>  	unsigned long long pmem_size;
>  	unsigned long long ram_size;
> +	unsigned long long dynamic_ram_a_size;
>  	int ram_qos_class;
>  	int pmem_qos_class;
> +	int dynamic_ram_a_qos_class;
>  	int payload_max;
>  	size_t lsa_size;
>  	struct kmod_module *module;
> @@ -159,6 +161,7 @@ struct cxl_decoder {
>  	unsigned int interleave_granularity;
>  	bool pmem_capable;
>  	bool volatile_capable;
> +	bool dynamic_ram_a_capable;
>  	bool mem_capable;
>  	bool accelmem_capable;
>  	bool locked;
> diff --git a/cxl/libcxl.h b/cxl/libcxl.h
> index e91af90..fd41122 100644
> --- a/cxl/libcxl.h
> +++ b/cxl/libcxl.h
> @@ -75,8 +75,10 @@ struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
>  struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
>  unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
> +unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
>  int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
>  int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
> +int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev);
>  const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
>  bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
>  size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
> @@ -210,6 +212,7 @@ enum cxl_decoder_mode {
>  	CXL_DECODER_MODE_MIXED,
>  	CXL_DECODER_MODE_PMEM,
>  	CXL_DECODER_MODE_RAM,
> +	CXL_DECODER_MODE_DYNAMIC_RAM_A,
>  };
>  
>  static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
> @@ -219,9 +222,10 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
>  		[CXL_DECODER_MODE_MIXED] = "mixed",
>  		[CXL_DECODER_MODE_PMEM] = "pmem",
>  		[CXL_DECODER_MODE_RAM] = "ram",
> +		[CXL_DECODER_MODE_DYNAMIC_RAM_A] = "dynamic_ram_a",
>  	};
>  
> -	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
> +	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DYNAMIC_RAM_A)
>  		mode = CXL_DECODER_MODE_NONE;
>  	return names[mode];
>  }
> @@ -235,6 +239,8 @@ cxl_decoder_mode_from_ident(const char *ident)
>  		return CXL_DECODER_MODE_RAM;
>  	else if (strcmp(ident, "pmem") == 0)
>  		return CXL_DECODER_MODE_PMEM;
> +	else if (strcmp(ident, "dynamic_ram_a") == 0)
> +		return CXL_DECODER_MODE_DYNAMIC_RAM_A;
>  	return CXL_DECODER_MODE_NONE;
>  }
>  
> @@ -264,6 +270,7 @@ cxl_decoder_get_target_type(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
> +bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
>  bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
>  unsigned int
> @@ -272,6 +279,7 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
>  struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
> +struct cxl_region *cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder);
>  struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
>  					    const char *ident);
>  struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);

