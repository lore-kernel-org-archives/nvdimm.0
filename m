Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACF02D023;
	Thu, 31 Jul 2025 01:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753925873; cv=none; b=loQfx/QCsp0c0R991mDGeqUcjUmJZx6eRfwbOxv20aaqxAeXsDMO6yaDvLIFP1v6vM/PgDPyFxJUqTwJ6RmbMB5qeDXkG5P8tDJ5MDGBE1t4D2ZsS75ddx4ZxrZ6Y2rqrnheUMMAyB08P/6GrKu6SJG8EYbeNqzjiPvzTIqebbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753925873; c=relaxed/simple;
	bh=tboXCaX23B4pFc785beSwve/i0aMqxCvICjurEX3pMU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dl1ohAMwwoKY0evwkaFbgYmUUIs8eoqE91uwKHrJFpxEqJ/i7blA5v1OQS0Vpr/XctrIkyv2W2Duubq4kxqU+Zk41BxzD9Qk8g3eqorge0ihfDrQ52qfMgbVOag+Kr+ZSC0vW7IdnDzRybMfNlk+sfTqcFcNMi5RRFPYqK0YQ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TQiVS+nW; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TQiVS+nW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753925871; x=1785461871;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tboXCaX23B4pFc785beSwve/i0aMqxCvICjurEX3pMU=;
  b=TQiVS+nWYv+zpONAae/4TednAMtmKzW3fXVkWeCPsSJOXtJoGV3dArA2
   5IfNEtHVKOs55OGd4X6vVtFW3IN9731wcj8RECtb11WCDzChcOw5q5yES
   gGHwGEkCODoB/O1/zKkHlzLEq3eYsfLmzSbkGK5vbWUW6T9SUhVdW3K31
   We6QuWvowfyVCU4reN/1355d8bxT+NxYVRgqVZkCFmK8cbsKMQ5IbuRD5
   uLE5TLjRcnhjrWtAFt6hj6XxqsbRSzob9X4MvkGii7/W+qrqodx5fuCEO
   ofDHIMY76envSs+ZCk+ewtT9xGtXFX/DcZvmPObSb2QKJLWzIZCZBxcJ0
   g==;
X-CSE-ConnectionGUID: +N6UAM3JQL6FkHkIuxuqpw==
X-CSE-MsgGUID: CJ67hZspStyPYWwKl9RQug==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="59884866"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="59884866"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 18:37:41 -0700
X-CSE-ConnectionGUID: dsACBGSFRfexQ1QkdmQBAg==
X-CSE-MsgGUID: FNXVJz9kRCSUekvRRjIO6g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="163586026"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa008.fm.intel.com with ESMTP; 30 Jul 2025 18:37:38 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhIEi-0003JA-2B;
	Thu, 31 Jul 2025 01:37:36 +0000
Date: Thu, 31 Jul 2025 09:36:45 +0800
From: kernel test robot <lkp@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	gost.dev@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, a.manzanares@samsung.com,
	vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 18/20] cxl/pmem: Add support of cxl lsa 2.1 support in
 cxl pmem
Message-ID: <202507310929.lJ3DlrYh-lkp@intel.com>
References: <20250730121209.303202-19-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-19-s.neeraj@samsung.com>

Hi Neeraj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f11a5f89910a7ae970fbce4fdc02d86a8ba8570f]

url:    https://github.com/intel-lab-lkp/linux/commits/Neeraj-Kumar/nvdimm-label-Introduce-NDD_CXL_LABEL-flag-to-set-cxl-label-format/20250730-202209
base:   f11a5f89910a7ae970fbce4fdc02d86a8ba8570f
patch link:    https://lore.kernel.org/r/20250730121209.303202-19-s.neeraj%40samsung.com
patch subject: [PATCH V2 18/20] cxl/pmem: Add support of cxl lsa 2.1 support in cxl pmem
config: i386-randconfig-011-20250731 (https://download.01.org/0day-ci/archive/20250731/202507310929.lJ3DlrYh-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507310929.lJ3DlrYh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507310929.lJ3DlrYh-lkp@intel.com/

All warnings (new ones prefixed by >>):

   drivers/cxl/core/region.c: In function 'create_pmem_region':
>> drivers/cxl/core/region.c:2692:35: warning: variable 'cxl_nvb' set but not used [-Wunused-but-set-variable]
    2692 |         struct cxl_nvdimm_bridge *cxl_nvb;
         |                                   ^~~~~~~


vim +/cxl_nvb +2692 drivers/cxl/core/region.c

  2687	
  2688	void create_pmem_region(struct nvdimm *nvdimm)
  2689	{
  2690		struct cxl_nvdimm *cxl_nvd;
  2691		struct cxl_memdev *cxlmd;
> 2692		struct cxl_nvdimm_bridge *cxl_nvb;
  2693		struct cxl_pmem_region_params *params;
  2694		struct cxl_root_decoder *cxlrd;
  2695		struct cxl_decoder *cxld;
  2696		struct cxl_region *cxlr;
  2697	
  2698		if (!nvdimm_has_cxl_region(nvdimm))
  2699			return;
  2700	
  2701		lockdep_assert_held(&cxl_rwsem.region);
  2702		cxl_nvd = nvdimm_provider_data(nvdimm);
  2703		params = nvdimm_get_cxl_region_param(nvdimm);
  2704		cxlmd = cxl_nvd->cxlmd;
  2705		cxl_nvb = cxlmd->cxl_nvb;
  2706		cxlrd = cxlmd->cxlrd;
  2707	
  2708		/*
  2709		 * FIXME: Limitation: Region creation support only for
  2710		 * interleave way == 1
  2711		 */
  2712		if (!(params->nlabel == 1))
  2713			dev_info(&cxlmd->dev,
  2714				 "Region Creation is not supported with iw > 1\n");
  2715		else {
  2716			cxld = cxl_find_free_ep_decoder(cxlmd->endpoint);
  2717			cxlr = cxl_create_region(cxlrd, CXL_PARTMODE_PMEM,
  2718						 atomic_read(&cxlrd->region_id),
  2719						 params, cxld);
  2720			if (IS_ERR(cxlr))
  2721				dev_info(&cxlmd->dev, "Region Creation failed\n");
  2722		}
  2723	}
  2724	EXPORT_SYMBOL_NS_GPL(create_pmem_region, "CXL");
  2725	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
