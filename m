Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7E219F135;
	Wed,  8 Jan 2025 03:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308485; cv=none; b=cNaAp/6Dyj3T4m4mFYt0w4qMG4MHwyXWGNwFrtAYDO32EEDlap0WVudXy87O3lK5dccBmYM9fDLhEg9OwgosD/Zl4mJJaHt1BHryv/N15V3P/Imr08m2os8L36DKXfVHirFKDb522tnu796c1soDmbwI/sPJ0j18J+P2oeuhwnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308485; c=relaxed/simple;
	bh=4hsOMAZJ7j21xofFoIQjJ3dhFztVfnFxioSs/Xh+tLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ed3+cWurognKkM0W3MAlGAAAY3sW4/tX+RJ/fDgNyQATaXgXsbX9s1rqeDe9rTYCHuQaZ7VTctKLp4e8id8icZXYuWnc8E2glhcgRdkXmDiLprvwqc1dEkDdNuJh7axFMxdYQxZK2/flAcgMd0o0UOS6qbZ+Vy/f4zMROh4f4Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=a31GGGxg; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="a31GGGxg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736308482; x=1767844482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4hsOMAZJ7j21xofFoIQjJ3dhFztVfnFxioSs/Xh+tLU=;
  b=a31GGGxgEW7UDsIfMpiaTVOONySgb8QNcNjRHi3Mkfz5pioO56OmiU6X
   DRNvt8a2VUElJZx/IdbckfNJ+93IsZf3UuHC6/MPkTb4762IozMkIDj2/
   cSaXmcbKR0D4pE4ryYtWQIP4hI6yI7JMsYCB+N4ptG8meDga67okMmIiz
   c24F0yzFUG/dM7fab3flYmlq4Fvddr4acTuJlLxdhwD8C1hWSVyT8M1gj
   kna63QjktcY9NB4KmKZyRB0vX9yAdavAkmaHkJQpyEP7IVcPOe1G9WsI5
   SRZbGg0Ie2fCoG5bEAlxqZIFPNz3wB1EyKMoViOb0fwC+RUm6aFYtKEW7
   w==;
X-CSE-ConnectionGUID: RD/nvHxtQDms4S+Nl4k97g==
X-CSE-MsgGUID: bDx2ne01RLa2+Ss661fzvw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47510428"
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="47510428"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 19:54:41 -0800
X-CSE-ConnectionGUID: SJ5v1rFaTKWUWQYQjFva9w==
X-CSE-MsgGUID: YgoBDvlkT9i+Phi1I3SMyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,297,1728975600"; 
   d="scan'208";a="103034161"
Received: from lkp-server01.sh.intel.com (HELO d63d4d77d921) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 07 Jan 2025 19:54:35 -0800
Received: from kbuild by d63d4d77d921 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tVN9M-000FaR-39;
	Wed, 08 Jan 2025 03:54:32 +0000
Date: Wed, 8 Jan 2025 11:54:32 +0800
From: kernel test robot <lkp@intel.com>
To: Alistair Popple <apopple@nvidia.com>, akpm@linux-foundation.org,
	dan.j.williams@intel.com, linux-mm@kvack.org
Cc: oe-kbuild-all@lists.linux.dev, Alistair Popple <apopple@nvidia.com>,
	lina@asahilina.net, zhang.lyra@gmail.com,
	gerald.schaefer@linux.ibm.com, vishal.l.verma@intel.com,
	dave.jiang@intel.com, logang@deltatee.com, bhelgaas@google.com,
	jack@suse.cz, jgg@ziepe.ca, catalin.marinas@arm.com,
	will@kernel.org, mpe@ellerman.id.au, npiggin@gmail.com,
	dave.hansen@linux.intel.com, ira.weiny@intel.com,
	willy@infradead.org, djwong@kernel.org, tytso@mit.edu,
	linmiaohe@huawei.com, david@redhat.com, peterx@redhat.com,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v5 15/25] huge_memory: Add vmf_insert_folio_pud()
Message-ID: <202501081149.VDLF8cwh-lkp@intel.com>
References: <5729b98a4f8edfec80edffddc36cac6dbaa8f4b9.1736221254.git-series.apopple@nvidia.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5729b98a4f8edfec80edffddc36cac6dbaa8f4b9.1736221254.git-series.apopple@nvidia.com>

Hi Alistair,

kernel test robot noticed the following build warnings:

[auto build test WARNING on e25c8d66f6786300b680866c0e0139981273feba]

url:    https://github.com/intel-lab-lkp/linux/commits/Alistair-Popple/fuse-Fix-dax-truncate-punch_hole-fault-path/20250107-114726
base:   e25c8d66f6786300b680866c0e0139981273feba
patch link:    https://lore.kernel.org/r/5729b98a4f8edfec80edffddc36cac6dbaa8f4b9.1736221254.git-series.apopple%40nvidia.com
patch subject: [PATCH v5 15/25] huge_memory: Add vmf_insert_folio_pud()
config: i386-buildonly-randconfig-004-20250108 (https://download.01.org/0day-ci/archive/20250108/202501081149.VDLF8cwh-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250108/202501081149.VDLF8cwh-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202501081149.VDLF8cwh-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> mm/huge_memory.c:1561: warning: Function parameter or struct member 'folio' not described in 'vmf_insert_folio_pud'
>> mm/huge_memory.c:1561: warning: Excess function parameter 'pfn' description in 'vmf_insert_folio_pud'


vim +1561 mm/huge_memory.c

  1551	
  1552	/**
  1553	 * vmf_insert_folio_pud - insert a pud size folio mapped by a pud entry
  1554	 * @vmf: Structure describing the fault
  1555	 * @pfn: pfn of the page to insert
  1556	 * @write: whether it's a write fault
  1557	 *
  1558	 * Return: vm_fault_t value.
  1559	 */
  1560	vm_fault_t vmf_insert_folio_pud(struct vm_fault *vmf, struct folio *folio, bool write)
> 1561	{
  1562		struct vm_area_struct *vma = vmf->vma;
  1563		unsigned long addr = vmf->address & PUD_MASK;
  1564		pud_t *pud = vmf->pud;
  1565		struct mm_struct *mm = vma->vm_mm;
  1566		spinlock_t *ptl;
  1567	
  1568		if (addr < vma->vm_start || addr >= vma->vm_end)
  1569			return VM_FAULT_SIGBUS;
  1570	
  1571		if (WARN_ON_ONCE(folio_order(folio) != PUD_ORDER))
  1572			return VM_FAULT_SIGBUS;
  1573	
  1574		ptl = pud_lock(mm, pud);
  1575		if (pud_none(*vmf->pud)) {
  1576			folio_get(folio);
  1577			folio_add_file_rmap_pud(folio, &folio->page, vma);
  1578			add_mm_counter(mm, mm_counter_file(folio), HPAGE_PUD_NR);
  1579		}
  1580		insert_pfn_pud(vma, addr, vmf->pud, pfn_to_pfn_t(folio_pfn(folio)), write);
  1581		spin_unlock(ptl);
  1582	
  1583		return VM_FAULT_NOPAGE;
  1584	}
  1585	EXPORT_SYMBOL_GPL(vmf_insert_folio_pud);
  1586	#endif /* CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE_PUD */
  1587	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
