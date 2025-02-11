Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435481386C9
	for <nvdimm@lists.linux.dev>; Tue, 11 Feb 2025 03:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739243561; cv=none; b=YhkvkFOFu+c+Zlv+S9MO5H7pKgQSRJB8nRH4TVUgPmjnLtKcm1YGGzUaop4gWPtxvd3U4b5i+c6wdABH6yHHQ5jqz4I4aACpSE1+woRilEPMoftGo+NiIYRT7Mf8B6X3SZNcwVsgdcFssY2X+U20/H+hpz2MaairMks1cE8dpcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739243561; c=relaxed/simple;
	bh=C1L6Jb89qXdtunN6oKq7/qSks+56abqYPL5Qg7JIjVc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p62BzF7RsiwsbzQcEttcbrAOEGm4IdqzZNwuQBoPXhHDabkvB94h5o3iK3HN3bJaRbiaMDYNj6F+1rlZrFTBV6eR9KR/1i0zoutpracvoBSU5wjDOb5fb0K/Uwhv2TGjClIIF1vqyTqyfgQGS56oUjNyashFECqWks2UCXRe4dQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eywc/CHP; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eywc/CHP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739243559; x=1770779559;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=C1L6Jb89qXdtunN6oKq7/qSks+56abqYPL5Qg7JIjVc=;
  b=eywc/CHPbXO8w/Xbu2VDsmX0ug0vUoofQHrW4BNj9pvHJ9RVAbYiMAjW
   dvBr4+QjLEb5d/49Y/HUtREEnEH8HmqjpjvLbtEcmQPVj01RfFJKIHFvw
   0Vie6P2rO31OQ1mFzn8NsidWTth2kaDia9/wAzCA3xetzTtpmDXdem2VJ
   5IRM3fuMn5UvtRjx5yczQNvijOT+bAi50dpmjkpLCoZUyaqDue99oT3lt
   g1R3ipi2H3yw+QsjiD4HJlmL6rpnwcdnjeFnHfvVTxV5YfUsszeTq1gRg
   ZAl6SJSdfPV8/MG9EzwOkFiLzixikAQtUJtwlYOLMixUuUZ/j5XjXHnSY
   Q==;
X-CSE-ConnectionGUID: 5efbcgh4TEGZoQfp+LqETg==
X-CSE-MsgGUID: Redn8FcaTXKNDR+4cOfPMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="39736863"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="39736863"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:12:39 -0800
X-CSE-ConnectionGUID: 6LAXlBBHQPWzWWA1yX7prQ==
X-CSE-MsgGUID: Mo+bFgifQZCRTfYHEUYKww==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112357087"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.111.205])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 19:12:38 -0800
Date: Mon, 10 Feb 2025 19:12:36 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Sushant1 Kumar <sushant1.kumar@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH v4 5/9] libcxl: Add Dynamic Capacity region support
Message-ID: <Z6rAJK_SZuY0BBO9@aschofie-mobl2.lan>
References: <20241214-dcd-region2-v4-0-36550a97f8e2@intel.com>
 <20241214-dcd-region2-v4-5-36550a97f8e2@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241214-dcd-region2-v4-5-36550a97f8e2@intel.com>

On Sat, Dec 14, 2024 at 08:58:32PM -0600, Ira Weiny wrote:
> CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> sparse and defined as dynamic capacity (dc).
> 
> Add support for DCD devices and regions to libcxl.  Add documentation
> for the new interfaces.

It seems helpers (defined or modified) in this set can be used more.
I gave one example below. Again, I'll catch it on the next rev.

> 
> Based on an original patch from Navneet Singh.
> 
> Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Co-developed-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  Documentation/cxl/lib/libcxl.txt | 17 ++++++-
>  cxl/lib/libcxl.c                 | 98 ++++++++++++++++++++++++++++++++++++++++
>  cxl/lib/libcxl.sym               |  3 ++
>  cxl/lib/private.h                |  4 ++
>  cxl/libcxl.h                     | 52 ++++++++++++++++++++-
>  5 files changed, 171 insertions(+), 3 deletions(-)

snip

> @@ -2275,6 +2305,22 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
>  			decoder->mode = CXL_DECODER_MODE_RAM;
>  		else if (strcmp(buf, "pmem") == 0)
>  			decoder->mode = CXL_DECODER_MODE_PMEM;
> +		else if (strcmp(buf, "dc0") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC0;
> +		else if (strcmp(buf, "dc1") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC1;
> +		else if (strcmp(buf, "dc2") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC2;
> +		else if (strcmp(buf, "dc3") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC3;
> +		else if (strcmp(buf, "dc4") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC4;
> +		else if (strcmp(buf, "dc5") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC5;
> +		else if (strcmp(buf, "dc6") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC6;
> +		else if (strcmp(buf, "dc7") == 0)
> +			decoder->mode = CXL_DECODER_MODE_DC7;
>  		else if (strcmp(buf, "mixed") == 0)
>  			decoder->mode = CXL_DECODER_MODE_MIXED;
>  		else if (strcmp(buf, "none") == 0)

If the modes survive, above can be simplified, probably as a separate
function using cxl_region_mode_name(), cxl_decoder_mode_is_dc() to get
to the mode without all those strcmps. Check all the predefined modes
first, then all the dc modes.

snip

> @@ -2592,6 +2648,30 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
>  	case CXL_DECODER_MODE_RAM:
>  		sprintf(buf, "ram");
>  		break;
> +	case CXL_DECODER_MODE_DC0:
> +		sprintf(buf, "dc0");
> +		break;
> +	case CXL_DECODER_MODE_DC1:
> +		sprintf(buf, "dc1");
> +		break;
> +	case CXL_DECODER_MODE_DC2:
> +		sprintf(buf, "dc2");
> +		break;
> +	case CXL_DECODER_MODE_DC3:
> +		sprintf(buf, "dc3");
> +		break;
> +	case CXL_DECODER_MODE_DC4:
> +		sprintf(buf, "dc4");
> +		break;
> +	case CXL_DECODER_MODE_DC5:
> +		sprintf(buf, "dc5");
> +		break;
> +	case CXL_DECODER_MODE_DC6:
> +		sprintf(buf, "dc6");
> +		break;
> +	case CXL_DECODER_MODE_DC7:
> +		sprintf(buf, "dc7");
> +		break;
>  	default:
>  		err(ctx, "%s: unsupported mode: %d\n",
>  		    cxl_decoder_get_devname(decoder), mode);

Again, if all these modes survive, this can tidy up like:

@@ -2593,9 +2646,14 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
                sprintf(buf, "ram");
                break;
        default:
-               err(ctx, "%s: unsupported mode: %d\n",
-                   cxl_decoder_get_devname(decoder), mode);
-               return -EINVAL;
+               if (cxl_decoder_mode_is_dc(mode)) {
+                       sprintf(buf, "dc%d", mode - CXL_DECODER_MODE_DC0);
+               } else {
+                       err(ctx, "%s: unsupported mode: %d\n",
+                           cxl_decoder_get_devname(decoder), mode);
+                       return -EINVAL;
+               }
+               break;
        }


snip to end.
