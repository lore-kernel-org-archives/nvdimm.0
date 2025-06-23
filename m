Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A92F2441AA;
	Mon, 23 Jun 2025 10:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750672841; cv=none; b=d+UWozm8rsU6WXAydhaDQouLyN4kVkB6TNphJTP17LEy0Pzs2OkRDj3x2QMeFjuYQ232K8slPiw3fbW0nPc3FPsuTvodigVaMsvzB4YjjWv6e5x4NCAD1JeVkiHVI/fOmsy/WwP41LSQ2oAZbSRLOfCu82X4SJmEhd0uv5aGi8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750672841; c=relaxed/simple;
	bh=mlsBkLPwnwFNOessEiLCY8jBWTi4OVNKvirIMXCCP3s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=km87fvftjrsEYXzGnSNszX1PteTqUvSv+bATX9baGQOy1lkc7HHFJFv6VB6c4/51rB04CL1vibcCZEKSKKyj2paqY7jT3sD94MxlBlUR1/9zHoki6NJJDuO3lpbqvhPaZMw+WnS3/C3c1BSLtee5wkTF76CH0xT0S7hSCdrXSMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O4+i66bk; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O4+i66bk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1750672840; x=1782208840;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=mlsBkLPwnwFNOessEiLCY8jBWTi4OVNKvirIMXCCP3s=;
  b=O4+i66bk4fulQamcBStdKsgl6cc9YNTTti9HIPSasmoKaKze34MaOZSO
   Xh5ZdmDa/7pPPE4LMYLqeDsxs999W5/D8uZ8Sq1xRHfFxops5MEOaQzh5
   f9Os/AAKI4fe1TDbghkzdDZHjJ9CQz0XXVaZ8uHU752g2m9a7Bud5HuIJ
   Dd0q20ewhaHzgzGiG2tDdRpKeCX60G9lxCrn9oPlt+RyX3XeANbE9ADqM
   OTdUNT01vT4lYrMzV9hqtLvvslZ9WTHy4EidtdMMgB0aGLVxFsp0BSZQT
   VqpMwhcF/I77t0N6qRU7r55N4Au9E4gu3mTp1z5/uI3ARxUCGneOfMQw8
   A==;
X-CSE-ConnectionGUID: IQOo+QrYQ/mVPZE1hZ6AWA==
X-CSE-MsgGUID: g74/qNtqQ3WjRhECubDZwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11472"; a="64227979"
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="64227979"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2025 03:00:38 -0700
X-CSE-ConnectionGUID: +kTBJ6BUReqF77uTavrz5A==
X-CSE-MsgGUID: M67+NKF7SYOMzjjsFSwQZw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,258,1744095600"; 
   d="scan'208";a="151023876"
Received: from lkp-server01.sh.intel.com (HELO e8142ee1dce2) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 23 Jun 2025 03:00:32 -0700
Received: from kbuild by e8142ee1dce2 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1uTdyX-000NvS-0i;
	Mon, 23 Jun 2025 10:00:29 +0000
Date: Mon, 23 Jun 2025 18:00:06 +0800
From: kernel test robot <lkp@intel.com>
To: Michal Clapinski <mclapinski@google.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, "Paul E. McKenney" <paulmck@kernel.org>,
	Thomas Huth <thuth@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Ard Biesheuvel <ardb@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Michal Clapinski <mclapinski@google.com>
Subject: Re: [PATCH v3 2/2] libnvdimm: add nd_e820.pmem automatic devdax
 conversion
Message-ID: <202506231721.IePmiDyz-lkp@intel.com>
References: <20250612114210.2786075-3-mclapinski@google.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250612114210.2786075-3-mclapinski@google.com>

Hi Michal,

kernel test robot noticed the following build warnings:

[auto build test WARNING on linus/master]
[also build test WARNING on nvdimm/libnvdimm-for-next v6.16-rc3 next-20250623]
[cannot apply to nvdimm/dax-misc]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Michal-Clapinski/libnvdimm-e820-Add-a-new-parameter-to-split-e820-entry-into-many-regions/20250612-194354
base:   linus/master
patch link:    https://lore.kernel.org/r/20250612114210.2786075-3-mclapinski%40google.com
patch subject: [PATCH v3 2/2] libnvdimm: add nd_e820.pmem automatic devdax conversion
config: x86_64-randconfig-r111-20250621 (https://download.01.org/0day-ci/archive/20250623/202506231721.IePmiDyz-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250623/202506231721.IePmiDyz-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202506231721.IePmiDyz-lkp@intel.com/

sparse warnings: (new ones prefixed by >>)
>> drivers/nvdimm/pfn_devs.c:684:23: sparse: sparse: incorrect type in assignment (different base types) @@     expected restricted __le32 [usertype] align @@     got restricted __le64 [usertype] @@
   drivers/nvdimm/pfn_devs.c:684:23: sparse:     expected restricted __le32 [usertype] align
   drivers/nvdimm/pfn_devs.c:684:23: sparse:     got restricted __le64 [usertype]

vim +684 drivers/nvdimm/pfn_devs.c

   646	
   647	int nd_pfn_set_dax_defaults(struct nd_pfn *nd_pfn)
   648	{
   649		struct nd_pfn_sb *pfn_sb = nd_pfn->pfn_sb;
   650		struct nd_namespace_common *ndns = nd_pfn->ndns;
   651		struct nd_region *nd_region = to_nd_region(nd_pfn->dev.parent);
   652		struct nd_namespace_io *nsio;
   653		struct resource *res;
   654		unsigned long align;
   655	
   656		if (!pfn_sb || !ndns)
   657			return -ENODEV;
   658	
   659		if (!is_memory(nd_pfn->dev.parent))
   660			return -ENODEV;
   661	
   662		if (nd_region->provider_data) {
   663			align = (unsigned long)nd_region->provider_data;
   664		} else {
   665			nsio = to_nd_namespace_io(&ndns->dev);
   666			res = &nsio->res;
   667			align = nd_best_supported_alignment(res->start, res->end);
   668			if (!align) {
   669				dev_err(&nd_pfn->dev, "init failed, resource misaligned\n");
   670				return -EOPNOTSUPP;
   671			}
   672		}
   673	
   674		memset(pfn_sb, 0, sizeof(*pfn_sb));
   675	
   676		if (!nd_pfn->uuid) {
   677			nd_pfn->uuid = kmemdup(pfn_sb->uuid, 16, GFP_KERNEL);
   678			if (!nd_pfn->uuid)
   679				return -ENOMEM;
   680			nd_pfn->align = align;
   681			nd_pfn->mode = PFN_MODE_RAM;
   682		}
   683	
 > 684		pfn_sb->align = cpu_to_le64(nd_pfn->align);
   685		pfn_sb->mode = cpu_to_le32(nd_pfn->mode);
   686	
   687		return nd_pfn_checks(nd_pfn, 0, 0, 0);
   688	}
   689	EXPORT_SYMBOL(nd_pfn_set_dax_defaults);
   690	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
