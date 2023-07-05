Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEE71548B
	for <nvdimm@lists.linux.dev>; Wed,  5 Jul 2023 23:28:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688599722; x=1720135722;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=td2zakmKMwosjr9MPPIZfOYBx4d0YM0sNWN22EecsJg=;
  b=F/X2gq8sMijMMvvjp8lrjXFjjuY01RuUinLY5M2yOQ4ftyl2GpoJfRHt
   wp+12jVkPRDGwhpyWefzsbyYf7uEt+9cKhT/AEeAyklH3gcAiuN/89F23
   IlOjLnTYQ1gn5+3hXsNXGI9mGgbGazHLf828C54uf12uyeJgqwSLMmr4P
   CGk7zKOMKf+xw7u5xo3AeZ7jV4DjOoa2BMPQ0PH0Q1mvg6iBkmTUv2w3c
   boAF1aaqXO1wRF0wOV2+0eTQTv1CXXHG/MVOnOi00cIieusxa5gzqaJTe
   71jegp7zQOkY0B0CrcPklT39nlPkLPkTfgDBWSRxhYIxJV6NU3FapqD82
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="362333951"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="362333951"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 16:28:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10762"; a="719394171"
X-IronPort-AV: E=Sophos;i="6.01,184,1684825200"; 
   d="scan'208";a="719394171"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2) ([10.209.61.134])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2023 16:28:40 -0700
Date: Wed, 5 Jul 2023 16:28:39 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: nvdimm@lists.linux.dev, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH] ACPI: NFIT: add helper to_nfit_mem() to take device to
 nfit_mem
Message-ID: <ZKX8p0/H2OKKSh91@aschofie-mobl2>
References: <20230703131729.1009861-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230703131729.1009861-1-ben.dooks@codethink.co.uk>

On Mon, Jul 03, 2023 at 02:17:29PM +0100, Ben Dooks wrote:
> Add a quick helper to just do struct device to the struct nfit_mem
> field it should be referencing. This reduces the number of code
> lines in some of the followgn code as it removes the intermediate
> struct nvdimm.
> 

Hi Ben,
This a useful cleanup. Minor comments below.
Alison

> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
> ---
>  drivers/acpi/nfit/core.c | 27 +++++++++++++--------------
>  1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
> index 0fcc247fdfac..9213b426b125 100644
> --- a/drivers/acpi/nfit/core.c
> +++ b/drivers/acpi/nfit/core.c
> @@ -1361,18 +1361,22 @@ static const struct attribute_group *acpi_nfit_attribute_groups[] = {
>  	NULL,
>  };
>  
> -static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
> +static struct nfit_mem *to_nfit_mem(struct device *dev)
>  {
>  	struct nvdimm *nvdimm = to_nvdimm(dev);
> -	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
> +	return  nvdimm_provider_data(nvdimm);

I was going to say add a space before that return, but checkpatch
beat me to it, with a warning. Please fix that up.
WARNING: Missing a blank line after declarations

> +}
> +
> +static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
> +{
> +	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
>  
>  	return __to_nfit_memdev(nfit_mem);
>  }

I was a bit puzzled why the diff looked awkward because when I applied
the patch it fell nicely in order with the new helper function first.
It all merges the same in the end but it's easier on reviewers eyes
when well presented. Consider using diff.algorithm=patience (output
shown below) when things scramble needlessly.

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -1361,18 +1361,22 @@ static const struct attribute_group *acpi_nfit_attribute_groups[] = {
 	NULL,
 };
 
+static struct nfit_mem *to_nfit_mem(struct device *dev)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	return  nvdimm_provider_data(nvdimm);
+}
+
 static struct acpi_nfit_memory_map *to_nfit_memdev(struct device *dev)
 {
-	struct nvdimm *nvdimm = to_nvdimm(dev);
-	struct nfit_mem *nfit_mem = nvdimm_provider_data(nvdimm);
+	struct nfit_mem *nfit_mem = to_nfit_mem(dev);
 
 	return __to_nfit_memdev(nfit_mem);
 }

snip

> 
