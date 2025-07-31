Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5637E13B284;
	Thu, 31 Jul 2025 10:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753958198; cv=none; b=FkTmMIVMRUnjcl62yNeSJvjM7gQTg+bq3kwapu9F7315f0czAIU4eQa+pJyDn2XGgkJQxbVuvDuWQqXrg996oxaaJTt8c1f3a/3M3QUAC8dkG6hty98loQO7yNZMEgrmFvMOhfNK9sJgLgXHfP5dtVVMiadWY6hyxN/ZW4xd39o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753958198; c=relaxed/simple;
	bh=jQ2ihjVLU372ldX8Ock8Nt7ZOSTEavpx4ginsVjs6to=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k5nCqsycjAl18gTzVC23S4kzh99hgud55+mA08E/nhCq8O4QzpMCBC8cYx513up3acKNottEUVtx48xk73vvM1BPf198mORwtXm5w9cEVwnpp5S4aufbb26NVTdgkBuPDaM4K64PTIdYSYWUCacgWEX/qz9FNGZes+AXMJZl6RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RZ7QR96B; arc=none smtp.client-ip=192.198.163.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RZ7QR96B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753958196; x=1785494196;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jQ2ihjVLU372ldX8Ock8Nt7ZOSTEavpx4ginsVjs6to=;
  b=RZ7QR96BOnTPpCQtuuTA7m56hsrFN9toFgYQuZ8nuwJhNUVBbMch/hyI
   vBmkbV2KnutGUPdzkkpF+A/ER4CkKXGIcb0oocNpSjc92fUToVY388bfG
   bUDi8ZDXNqwiZ70kroGAl8uaIUh3/AUbz8AzYWHRbGXZ1A7CGSSH5dLcc
   JrRvEKu5ime1MPmFuBIfl7OKbTH54AZ5fSng4i7oo6y/Nn1CGSXJq/Der
   BLD1tJJpyon5wAaaGzBxe/LIX8IeHlio8tgE5oO4QOA/esJhtp83CUCv3
   WRkVM/t4/rmXzvFwQdvs/csmB9JZz5/u8XL/eiNxl3FyyoFdrjOH8TnXI
   g==;
X-CSE-ConnectionGUID: NgPXKYgxRFevUgJW0rsY7Q==
X-CSE-MsgGUID: 2wa1q5rtQx2bS0P6GUmJnA==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="81728074"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="81728074"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 03:36:35 -0700
X-CSE-ConnectionGUID: I5c8qlVxQw2mKI0lBWKGiQ==
X-CSE-MsgGUID: oZU8eTfdQtOJmE9b+f3SSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="163571393"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 31 Jul 2025 03:36:33 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhQeF-0003fw-24;
	Thu, 31 Jul 2025 10:36:31 +0000
Date: Thu, 31 Jul 2025 18:36:23 +0800
From: kernel test robot <lkp@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	gost.dev@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, a.manzanares@samsung.com,
	vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 20/20] cxl/pmem_region: Add sysfs attribute cxl region
 label updation/deletion
Message-ID: <202507311814.ngKmd10b-lkp@intel.com>
References: <20250730121209.303202-21-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-21-s.neeraj@samsung.com>

Hi Neeraj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f11a5f89910a7ae970fbce4fdc02d86a8ba8570f]

url:    https://github.com/intel-lab-lkp/linux/commits/Neeraj-Kumar/nvdimm-label-Introduce-NDD_CXL_LABEL-flag-to-set-cxl-label-format/20250730-202209
base:   f11a5f89910a7ae970fbce4fdc02d86a8ba8570f
patch link:    https://lore.kernel.org/r/20250730121209.303202-21-s.neeraj%40samsung.com
patch subject: [PATCH V2 20/20] cxl/pmem_region: Add sysfs attribute cxl region label updation/deletion
config: i386-randconfig-062-20250731 (https://download.01.org/0day-ci/archive/20250731/202507311814.ngKmd10b-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507311814.ngKmd10b-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507311814.ngKmd10b-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/cxl/core/pmem_region.c:127:1: sparse: sparse: symbol 'dev_attr_region_label_delete' was not declared. Should it be static?
>> drivers/cxl/core/pmem_region.c:135:24: sparse: sparse: symbol 'cxl_pmem_region_group' was not declared. Should it be static?

vim +/dev_attr_region_label_delete +127 drivers/cxl/core/pmem_region.c

   102	
   103	static ssize_t region_label_delete_store(struct device *dev,
   104					   struct device_attribute *attr,
   105					   const char *buf, size_t len)
   106	{
   107		struct cxl_pmem_region *cxlr_pmem = to_cxl_pmem_region(dev);
   108		struct cxl_region *cxlr = cxlr_pmem->cxlr;
   109		struct cxl_region_params *p = &cxlr->params;
   110		ssize_t rc;
   111	
   112		ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
   113		rc = ACQUIRE_ERR(rwsem_write_kill, &rwsem);
   114		if (rc)
   115			return rc;
   116	
   117		if (cxlr && cxlr->cxlr_pmem && cxlr->cxlr_pmem->nd_region) {
   118			rc = nd_region_label_delete(cxlr->cxlr_pmem->nd_region);
   119			if (rc)
   120				return rc;
   121		}
   122	
   123		p->region_label_state = 0;
   124	
   125		return len;
   126	}
 > 127	DEVICE_ATTR_WO(region_label_delete);
   128	
   129	static struct attribute *cxl_pmem_region_attrs[] = {
   130		&dev_attr_region_label_update.attr,
   131		&dev_attr_region_label_delete.attr,
   132		NULL
   133	};
   134	
 > 135	struct attribute_group cxl_pmem_region_group = {
   136		.attrs = cxl_pmem_region_attrs,
   137	};
   138	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
