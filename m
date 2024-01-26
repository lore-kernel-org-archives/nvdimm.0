Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83269208C5
	for <nvdimm@lists.linux.dev>; Fri, 26 Jan 2024 18:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706292117; cv=none; b=aPWqmdbwkHPXC3KG1UseCjJMUWrK3ejcJh+GXQ0rAKaQQblZNhle5m2tlrF7nuvzim4XHPVQ/SKw0V98afh8I5grQdjwKyccbybmRUsDgckQF3jBYsiKRMOhvm9Xgj0F8eDL1Zi8mIGjUe+8Q6G4QkOiPlesf8VbDOOQocSneFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706292117; c=relaxed/simple;
	bh=UVId2mJ5SkVmLG2AO+s/CfhdcBiuQemjN6Ac3yvBFT4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eqHNkU+CMSfXfWjDaWv5SjWa/SZiB4zYXWYg+UrLXpb8lXx5VYsiOPmaZ7lZbpalWlirBut4MEg3IwJnNcEZPeA3d7AdEoAP5VToaGg15ieYaR7oeX3aHm4yew8MLjEfzEnTrCxaB1zrab+Rj3XbSJj6+MtJvaq0P2YQHHFViqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VE0+M7at; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VE0+M7at"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706292115; x=1737828115;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=UVId2mJ5SkVmLG2AO+s/CfhdcBiuQemjN6Ac3yvBFT4=;
  b=VE0+M7at7/uMrPl4X4jnrjdc7RnCZGD4WTwEYNFFrLwpC5K8pmg1h3ab
   ix0We85RjOKjhsVjCSTbba2JVFoOWujccPKiMSRNiWKgnHIAnUrQJFQ4S
   s0Uf5YEuB8tjUF4dsLNCHFyD15JqtEzVb/nMex1AGL7Mm7gJHzY5NRBnG
   qitXAKgzxCmBNrRXvvAx0w6cNh76cHXr3+Fnkoofy1zNi55zlMldZHOfx
   KHe5wwUsbitr+Eqaon2t9Un1qMtXnmLTTnFmpV4CUmEawO8MfuLgoSpNB
   gbhe+5RHSOulqhe3C/s2BZuMy5bj0pzf9Y4FkCUVZM+xcll8nCK9aLf56
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="16060636"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="16060636"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 10:01:54 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10964"; a="930429035"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="930429035"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.37.71])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2024 10:01:53 -0800
Date: Fri, 26 Jan 2024 10:01:51 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	vishal.l.verma@intel.com
Subject: Re: [NDCTL PATCH v3 2/3] ndctl: cxl: Add QoS class support for the
 memory device
Message-ID: <ZbPzj90keGE0zr0K@aschofie-mobl2>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
 <170612968788.2745924.12035270102793649199.stgit@djiang5-mobl3>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170612968788.2745924.12035270102793649199.stgit@djiang5-mobl3>

On Wed, Jan 24, 2024 at 01:54:47PM -0700, Dave Jiang wrote:
> Add libcxl API to retrieve the QoS class tokens for the memory
> devices. Two API calls are added. One for 'ram' or 'volatile'
> mode and another for 'pmem' or 'persistent' mode. Support also added
> for displaying the QoS class tokens through the 'cxl list' command.
> There can be 1 or more QoS class tokens for the memory device if
> they are valid. The qos_class tokens are displayed behind -vvv
> verbose level.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>

One tidbit below. 

Reviewed-by: Alison Schofield <alison.schofield@intel.com>


> ---
> v3:
> - Rebase to pending branch
> - Skip from failing if no qos_class sysfs attrib found
> ---
>  cxl/json.c         |   36 +++++++++++++++++++++++++++++++++++-
>  cxl/lib/libcxl.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym |    2 ++
>  cxl/lib/private.h  |    2 ++
>  cxl/libcxl.h       |    7 +++++++
>  5 files changed, 94 insertions(+), 1 deletion(-)
> 
> diff --git a/cxl/json.c b/cxl/json.c
> index 48a43ddf14b0..dcbac8c14f03 100644
> --- a/cxl/json.c
> +++ b/cxl/json.c
> @@ -770,12 +770,32 @@ err_free:
>  	return jpoison;
>  }
>  
> +static struct json_object *get_qos_json_object(struct json_object *jdev,
> +					       struct qos_class *qos_class)
> +{
> +	struct json_object *jqos_array = json_object_new_array();
> +	struct json_object *jobj;
> +	int i;
> +
> +	if (!jqos_array)
> +		return NULL;
> +
> +	for (i = 0; i < qos_class->nr; i++) {
> +		jobj = json_object_new_int(qos_class->qos[i]);
> +		if (jobj)
> +			json_object_array_add(jqos_array, jobj);
> +	}
> +
> +	return jqos_array;
> +}
> +
>  struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		unsigned long flags)
>  {
>  	const char *devname = cxl_memdev_get_devname(memdev);
> -	struct json_object *jdev, *jobj;
> +	struct json_object *jdev, *jobj, *jqos;

Can the generic *jobj be used below rather than adding the new *jqos?


>  	unsigned long long serial, size;
> +	struct qos_class *qos_class;
>  	int numa_node;
>  
>  	jdev = json_object_new_object();
> @@ -791,6 +811,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		jobj = util_json_object_size(size, flags);
>  		if (jobj)
>  			json_object_object_add(jdev, "pmem_size", jobj);
> +
> +		if (flags & UTIL_JSON_QOS_CLASS) {
> +			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
> +			jqos = get_qos_json_object(jdev, qos_class);
> +			if (jqos)
> +				json_object_object_add(jdev, "pmem_qos_class", jqos);
> +		}
>  	}
>  
>  	size = cxl_memdev_get_ram_size(memdev);
> @@ -798,6 +825,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
>  		jobj = util_json_object_size(size, flags);
>  		if (jobj)
>  			json_object_object_add(jdev, "ram_size", jobj);
> +
> +		if (flags & UTIL_JSON_QOS_CLASS) {
> +			qos_class = cxl_memdev_get_ram_qos_class(memdev);
> +			jqos = get_qos_json_object(jdev, qos_class);
> +			if (jqos)
> +				json_object_object_add(jdev, "ram_qos_class", jqos);
> +		}
>  	}
>  
>  	if (flags & UTIL_JSON_HEALTH) {

snip

> 
> 
