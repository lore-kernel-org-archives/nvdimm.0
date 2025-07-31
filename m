Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3E822F740;
	Thu, 31 Jul 2025 13:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753967573; cv=none; b=lX/c2IZvUhkk2+TqcwSDJ84CiQLQCrlxzm3EEHKyeWEVBhJtBNVplcUqqF5Ie/iUEasYdcBHM8iIQ6/cl56EouKUwLp9/8thzD/2redf1S/5K7ij6U4Avq4IuBWoW6IIabIa+UEGPom+4YbVB263O0rQ7F2kqfVHP8u0/RnYT6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753967573; c=relaxed/simple;
	bh=jZLdsZQ5WfGV3C4JEATfrhBZZ5kJbzDkacOrP/JQ+O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AQwHgT6dLHScN9Ma7/WTpgaFlvTQbtTKLlqW3OFRFkhRVvv0F6+UNc5YucNrXCFYDZvf6IM7ayhSVyBrLMVyJhESJ5EA9K3APu02T2/gzzhkaI/qKIR1CxU1uATEAsRO0bbKYTgnH0REqfCILJO9i2aDbXqV2oQ05E9Dz7+fHXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fsCh+FCM; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fsCh+FCM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1753967572; x=1785503572;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jZLdsZQ5WfGV3C4JEATfrhBZZ5kJbzDkacOrP/JQ+O4=;
  b=fsCh+FCMV7ChIIcNc4FNeTJHEfWuyK4yOZ/Q9/vIdHBrUUOeY1lpPlwD
   Au1iPoa58BobYBCGSN5IWTbfRBPe6fjgBPnE13N9oP5O6csvdbBZLIBSu
   mhQK/0sRG6wufTqP2GPCtM/PuEWEPUeLT5ABrKUMFWcBx2+Y4sy+vNSqt
   Q4xXofq7neiC8FEY8Zn6/u3shcpClrRwhiqN67BFLVPaLRunsojEW/y/a
   StPsdMsUk4ThFmaQENrX2iQGNQOvINyHm+jXQ8aFztTKvKdnsGWFI2ecJ
   J8vIikvl8XP4Cty8neN6ZwulJBMdKSZ8/dTXPyXnDES0q1u3u3qywoqAr
   w==;
X-CSE-ConnectionGUID: Q+k8sY6bTnGT+LHVr1darw==
X-CSE-MsgGUID: S8posxKhT9i8uL0YBwIyMg==
X-IronPort-AV: E=McAfee;i="6800,10657,11508"; a="59937214"
X-IronPort-AV: E=Sophos;i="6.17,353,1747724400"; 
   d="scan'208";a="59937214"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jul 2025 06:12:52 -0700
X-CSE-ConnectionGUID: evHrPxyvTyeRQx9IDd9DLg==
X-CSE-MsgGUID: DbrrJ+e0R5mAtm/WdaGwjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,353,1747724400"; 
   d="scan'208";a="168657129"
Received: from lkp-server01.sh.intel.com (HELO 160750d4a34c) ([10.239.97.150])
  by orviesa005.jf.intel.com with ESMTP; 31 Jul 2025 06:12:49 -0700
Received: from kbuild by 160750d4a34c with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uhT5T-0003mu-1H;
	Thu, 31 Jul 2025 13:12:47 +0000
Date: Thu, 31 Jul 2025 21:12:01 +0800
From: kernel test robot <lkp@intel.com>
To: Neeraj Kumar <s.neeraj@samsung.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	gost.dev@samsung.com
Cc: oe-kbuild-all@lists.linux.dev, a.manzanares@samsung.com,
	vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: Re: [PATCH V2 03/20] nvdimm/namespace_label: Add namespace label
 changes as per CXL LSA v2.1
Message-ID: <202507312016.4ga8UpF5-lkp@intel.com>
References: <20250730121209.303202-4-s.neeraj@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250730121209.303202-4-s.neeraj@samsung.com>

Hi Neeraj,

kernel test robot noticed the following build warnings:

[auto build test WARNING on f11a5f89910a7ae970fbce4fdc02d86a8ba8570f]

url:    https://github.com/intel-lab-lkp/linux/commits/Neeraj-Kumar/nvdimm-label-Introduce-NDD_CXL_LABEL-flag-to-set-cxl-label-format/20250730-202209
base:   f11a5f89910a7ae970fbce4fdc02d86a8ba8570f
patch link:    https://lore.kernel.org/r/20250730121209.303202-4-s.neeraj%40samsung.com
patch subject: [PATCH V2 03/20] nvdimm/namespace_label: Add namespace label changes as per CXL LSA v2.1
config: x86_64-randconfig-121-20250731 (https://download.01.org/0day-ci/archive/20250731/202507312016.4ga8UpF5-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14+deb12u1) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250731/202507312016.4ga8UpF5-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202507312016.4ga8UpF5-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
   drivers/nvdimm/label.c: note: in included file (through drivers/nvdimm/nd-core.h):
>> drivers/nvdimm/nd.h:314:37: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] align @@     got restricted __le16 [usertype] @@
   drivers/nvdimm/nd.h:314:37: sparse:     expected restricted __le32 [usertype] align
   drivers/nvdimm/nd.h:314:37: sparse:     got restricted __le16 [usertype]

vim +314 drivers/nvdimm/nd.h

   308	
   309	static inline void nsl_set_alignment(struct nvdimm_drvdata *ndd,
   310					     struct nd_namespace_label *ns_label,
   311					     u32 align)
   312	{
   313		if (ndd->cxl)
 > 314			ns_label->cxl.align = __cpu_to_le16(align);
   315	}
   316	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
