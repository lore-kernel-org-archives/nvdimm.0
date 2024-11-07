Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BF79366
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 18:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731004072; cv=none; b=EH6hJx3MI1TF3LdJdDRii496/aB/PW9IFhV35ZrgFYRhPkGZorlGke8kY0fiLMubqZx905TcFcQRneeFAnqbP3lB2XsZwe4XDPFnr1XE3LViGBz7SbeVysODinq+4U8zme4pi4KxrgLTKCpiD9Gj2wCVjyrdIwt8+cWJBv9iltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731004072; c=relaxed/simple;
	bh=oTHLzMRP1Qorc0S2DojD/Vax8d5DaE6boSz6HRp8+OA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qATDV/WH0HotHeTT6Phfz3VUyyxUBbu11p70rQKOdNe8vJmcc5QXRdjQ0JfrRgbyrUKrlpkY3TYs8WEJSopp+dzDb43S431Vlz6We6WrE6e6B4cXCECN/3wiSv1fVpsbg0yLjXG5rqpiZZVW0wUkr9Gd2eUFuSHMtiK6jOGIUV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HdgC4vZa; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HdgC4vZa"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731004071; x=1762540071;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=oTHLzMRP1Qorc0S2DojD/Vax8d5DaE6boSz6HRp8+OA=;
  b=HdgC4vZajgi/QNzJoPyJGeb+oKHh2TongxaEeNBQZwG5PUSYb2SmQc+p
   mcS2zacOJcz11Z2d++khu37LRs04qkFnKXmdBYC97o4N2fzIhqDDl6qmd
   jkax1uRIOvezpO49wmEiCupozpS5O6l/jFLiDduHBF2Hha3bCB1jjjnCt
   PTD7b0Yb0yZLT5JURGuZp1I5eOmOg/Dzmwig0lbXy47aP8Sjqt+n5WnS0
   IMtgn4CS2ionaUvWvaxSNNNEsn3k3N5RkOwDM4xtMmLVBCVBgBOrIPBAJ
   0KMBSe6TnIMPBgs4P8Z/a0OGKOUygS5qYQuFmK6s5cpqzQSsTg1HCh0/N
   w==;
X-CSE-ConnectionGUID: PQYsTL1ERuSdSvOS73t5hw==
X-CSE-MsgGUID: tw9oBcEMREOfTLDNz0hm7Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="30267117"
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="30267117"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 10:27:50 -0800
X-CSE-ConnectionGUID: RUXCsaG1SSKTjOGi/QnkOA==
X-CSE-MsgGUID: 5APjRSoDTIy8Gnu89SxQ3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,135,1728975600"; 
   d="scan'208";a="116042584"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO aschofie-mobl2.lan) ([10.125.110.171])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 10:27:50 -0800
Date: Thu, 7 Nov 2024 10:27:48 -0800
From: Alison Schofield <alison.schofield@intel.com>
To: ira.weiny@intel.com
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>,
	Navneet Singh <navneet.singh@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, Sushant1 Kumar <sushant1.kumar@intel.com>
Subject: Re: [ndctl PATCH v2 4/6] cxl/region: Add creation of Dynamic
 capacity regions
Message-ID: <Zy0GpLWyxsjm5A7F@aschofie-mobl2.lan>
References: <20241104-dcd-region2-v2-0-be057b479eeb@intel.com>
 <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241104-dcd-region2-v2-4-be057b479eeb@intel.com>

On Mon, Nov 04, 2024 at 08:10:48PM -0600, Ira Weiny wrote:
> From: Navneet Singh <navneet.singh@intel.com>
> 
> CXL Dynamic Capacity Devices (DCDs) optionally support dynamic capacity
> with up to eight partitions (Regions) (dc0-dc7).  CXL regions can now be
> spare and defined as dynamic capacity (dc).
> 
> Add support for DCD devices.  Query for DCD capabilities.  Add the
> ability to add DC partitions to a CXL DC region.
> 
> Signed-off-by: Navneet Singh <navneet.singh@intel.com>
> Co-authored-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Signed-off-by: Sushant1 Kumar <sushant1.kumar@intel.com>
> Co-authored-by: Ira Weiny <ira.weiny@intel.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> 
> ---
> Changes:
> [Fan: Properly initialize index]
> ---
>  cxl/json.c         | 26 +++++++++++++++
>  cxl/lib/libcxl.c   | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  cxl/lib/libcxl.sym |  3 ++
>  cxl/lib/private.h  |  6 +++-
>  cxl/libcxl.h       | 55 +++++++++++++++++++++++++++++--
>  cxl/memdev.c       |  7 +++-
>  cxl/region.c       | 49 ++++++++++++++++++++++++++--
>  7 files changed, 234 insertions(+), 7 deletions(-)


As I send this third snippet of patch review and wonder if I'm being
odd, I've decided no, it's not me - this patch is doing too many
things in one patch.

If you look at the history in ndctl, a new feature add like this is
typically added in mulitple patches like:
- add the libcxl support
- enable the creation of DCD regions
- add DCD info to cxl list

Can you split this up, along the lines I suggest or however it makes
sense for this feature.

and one more bit below...

> 
> diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
> index b5d9bdcc38e09812f26afc1cb0e804f86784b8e6..351da7512e05080d847fd87740488d613462dbc9 100644
> --- a/cxl/lib/libcxl.sym
> +++ b/cxl/lib/libcxl.sym
> @@ -19,6 +19,7 @@ global:
>  	cxl_memdev_get_ctx;
>  	cxl_memdev_get_pmem_size;
>  	cxl_memdev_get_ram_size;
> +	cxl_memdev_get_dc_size;
>  	cxl_memdev_get_firmware_verison;
>  	cxl_cmd_get_devname;
>  	cxl_cmd_new_raw;
> @@ -247,6 +248,8 @@ LIBCXL_5 {
>  global:
>  	cxl_region_get_mode;
>  	cxl_decoder_create_ram_region;
> +	cxl_decoder_is_dc_capable;
> +	cxl_decoder_create_dc_region;
>  	cxl_region_get_daxctl_region;
>  	cxl_port_get_parent_dport;
>  } LIBCXL_4;

New symbols need to be appended in a new section, not inserted.
See predecessors.


snip


> 
