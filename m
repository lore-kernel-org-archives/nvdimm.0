Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85ED019F49E;
	Thu, 31 Jul 2025 01:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753927065; cv=none; b=sYhvil16ogIlflfYfteSl99zJAEAIGpI1l8LjCuWP8lYEhr7gE7YEdk7a47xv7N80dvsqvO1Y54NdkRgPrWVY1sIDZ0Ao2jmak3wozLj5CoutjBqDkIzp2AGaBT965QC13o/klNC1SNtct4W6p+/zyWLWLDrUHYqRhKyJpWF63Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753927065; c=relaxed/simple;
	bh=i05GmqM81zKS35wQtpZ3+0MsPEMFmnpy12k1LxdLkGA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jscOFsmQ3eb2xBoUpQ4r9SVIrYrJjFqDlKAttkNKU+zHzeAc6BcL7CnmIOcaOsEM/r6AlOO4ZJhg+KbF08otZuDp1/en7UzLOJu5mucZ1XxfjcVHlNt6Ef8343ZgVc0SW+c4x0iRmonC5AGR+/xVyVIfMznmy8nLEnwHKH+Bbuk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=oKPmhK4f; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="oKPmhK4f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753927064; x=1785463064;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=i05GmqM81zKS35wQtpZ3+0MsPEMFmnpy12k1LxdLkGA=;
  b=oKPmhK4f4gVYj5+jeWdG1qFn2/DfV87jEMtaiL464T+E3Kj3hDHNDhhH
   x4HaKVDTZCdBWQ+FG3a0cg5BrCXcemOAR4jS5ijJ2PVCmgFbJFL7JWQpB
   MvZ8sPCayVgjXF88kcGuRaTEMGQYcjCFU1eUF/HZ7VF6sUp9CqTIREFvj
   6SMO9P8x3okbKAvnitdI+jAAIQm2RavX1gP+NbuiSWx5kP1id2IY8Y3Zw
   ZsWdjefYcWtXCumhDorRO/GSRMK/dJ+RG39EId5jQved5xf0Mc/vTqc/k
   J7fWqsiucQRJ1BwotdlWkhj8fpWwwIjWiqvCk6Smf3T/a+d0r8EgLjZ5O
   g==;
X-CSE-ConnectionGUID: byUysXP2QcKbBMZHnBDUoQ==
X-CSE-MsgGUID: LtOkFUfDTyiKOJ3w4bhivA==
X-IronPort-AV: E=McAfee;i="6800,10657,11507"; a="66510670"
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="66510670"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jul 2025 18:57:43 -0700
X-CSE-ConnectionGUID: clCmJ5T7R6eZgGfcS5g4yg==
X-CSE-MsgGUID: ALLHYw8VTNqYVqeJqdRkJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,353,1744095600"; 
   d="scan'208";a="163168924"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa007.jf.intel.com with ESMTP; 30 Jul 2025 18:57:41 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhIY6-0003KS-2E;
	Thu, 31 Jul 2025 01:57:38 +0000
Date: Thu, 31 Jul 2025 09:57:05 +0800
From: kernel test robot <lkp@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	gost.dev@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, a.manzanares@samsung.com,
	vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 19/20] cxl/pmem_region: Prep patch to accommodate
 pmem_region attributes
Message-ID: <202507310942.77glfQS3-lkp@intel.com>
References: <20250730121209.303202-20-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-20-s.neeraj@samsung.com>

Hi Neeraj,

kernel test robot noticed the following build errors:

[auto build test ERROR on f11a5f89910a7ae970fbce4fdc02d86a8ba8570f]

url:    https://github.com/intel-lab-lkp/linux/commits/Neeraj-Kumar/nvdimm-label-Introduce-NDD_CXL_LABEL-flag-to-set-cxl-label-format/20250730-202209
base:   f11a5f89910a7ae970fbce4fdc02d86a8ba8570f
patch link:    https://lore.kernel.org/r/20250730121209.303202-20-s.neeraj%40samsung.com
patch subject: [PATCH V2 19/20] cxl/pmem_region: Prep patch to accommodate pmem_region attributes
config: i386-buildonly-randconfig-001-20250731 (https://download.01.org/0day-ci/archive/20250731/202507310942.77glfQS3-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507310942.77glfQS3-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507310942.77glfQS3-lkp@intel.com/

All errors (new ones prefixed by >>):

   In file included from drivers/cxl/cxlmem.h:12,
                    from drivers/cxl/pci.c:15:
>> drivers/cxl/cxl.h:921:20: error: redefinition of 'create_pmem_region'
     921 | static inline void create_pmem_region(struct nvdimm *nvdimm)
         |                    ^~~~~~~~~~~~~~~~~~
   drivers/cxl/cxl.h:898:20: note: previous definition of 'create_pmem_region' with type 'void(struct nvdimm *)'
     898 | static inline void create_pmem_region(struct nvdimm *nvdimm)
         |                    ^~~~~~~~~~~~~~~~~~


vim +/create_pmem_region +921 drivers/cxl/cxl.h

   902	
   903	#ifdef CONFIG_CXL_PMEM_REGION
   904	bool is_cxl_pmem_region(struct device *dev);
   905	struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev);
   906	int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
   907	void create_pmem_region(struct nvdimm *nvdimm);
   908	#else
   909	static inline bool is_cxl_pmem_region(struct device *dev)
   910	{
   911		return false;
   912	}
   913	static inline struct cxl_pmem_region *to_cxl_pmem_region(struct device *dev)
   914	{
   915		return NULL;
   916	}
   917	static inline int devm_cxl_add_pmem_region(struct cxl_region *cxlr)
   918	{
   919		return 0;
   920	}
 > 921	static inline void create_pmem_region(struct nvdimm *nvdimm)
   922	{
   923	}
   924	#endif
   925	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
