Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB247392B6A;
	Fri, 23 Jan 2026 05:31:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769146313; cv=none; b=Vah9Bzb+lWlU1pHQiSsq33oO0SZVf+ntayltynL01xfVImUiMpKiXBeIVOhNrGyoQGfmm++VX2XNhnqAkqll+Yp2oc0XpcA+XqckQvgYIEljWD5crm7YabVFjKA3fZLu0Nt00VT3QTG08253jG2lYzw6rn0NYMPZyb8GMl9gu/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769146313; c=relaxed/simple;
	bh=6555LqyRbicDS9IM3bg1O2TIluGcJj7F11rI8vrsCQM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mvbNUOkfyYCCY+8VL9XlDJLPQuxZE4w1QSRHj38k6x0RykZ2uHboOd9K85Y5grkaFucAsA9dO7+f/hp5y6WvvM2KKPJZDTkwYhYwJYpYxVqJoveZghgAOV3j1xgaJo2X8yHflUD0FMIn9TbvHakENwJkeCViVv/oxjbQPAlLMyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mYAxJKwI; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mYAxJKwI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1769146309; x=1800682309;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=6555LqyRbicDS9IM3bg1O2TIluGcJj7F11rI8vrsCQM=;
  b=mYAxJKwImCzUDf6pd4V/8DHWvf9fWqWFC9GBaqBWBzVTci1o3SggquVp
   ZLvVuhB/RAriym3+2sVfZ3ReD+2ohVhaoqPf647EwggjKyeh85KKfR+jR
   05HN4ddbeR+TZ6bOcYQxC2mwiamYG4/hlteI0PTmy2Jyu6wPoLvg/uJHq
   cvevWIRhcRIzGKGQx8kCBmy3HGCzw15/x6xn6nvmPyC2cpIaM4Zbyt+J9
   yUCpfTaGOhrA6I3aum5i1T52w3mOaxvbNAZ1YFl3h5rtiQIHGF19+5StN
   KQnEdspnaOWxkMP5Q7Kaq/xQCbG97vvBr2t88hiIl2AtZWkurbC3NuGI1
   Q==;
X-CSE-ConnectionGUID: 1IRV14eHQjG1hMAzzg9/Lw==
X-CSE-MsgGUID: OADkoKlXQSaIxzOzbOMZLg==
X-IronPort-AV: E=McAfee;i="6800,10657,11679"; a="70563179"
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="70563179"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 21:31:43 -0800
X-CSE-ConnectionGUID: Ug8nxIJAT4Oi7W/VLkzx9g==
X-CSE-MsgGUID: RtUbWqjbTrq4IGkLyP1MDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,247,1763452800"; 
   d="scan'208";a="211443441"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa004.jf.intel.com with ESMTP; 22 Jan 2026 21:31:34 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vj9lc-00000000TYU-0Cg4;
	Fri, 23 Jan 2026 05:31:32 +0000
Date: Fri, 23 Jan 2026 13:30:56 +0800
From: kernel test robot <lkp@intel.com>
To: Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>,
	linux-cxl@vger.kernel.org, linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-fsdevel@vger.kernel.org,
	linux-pm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Ard Biesheuvel <ardb@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Yazen Ghannam <yazen.ghannam@amd.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Len Brown <len.brown@intel.com>, Pavel Machek <pavel@kernel.org>,
	Li Ming <ming.li@zohomail.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Ying Huang <huang.ying.caritas@gmail.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nathan Fontenot <nathan.fontenot@amd.com>,
	Terry Bowman <terry.bowman@amd.com>,
	Robert Richter <rrichter@amd.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Zhijian Li <lizhijian@fujitsu.com>
Subject: Re: [PATCH v5 6/7] dax/hmem, cxl: Defer and resolve ownership of
 Soft Reserved memory ranges
Message-ID: <202601231309.JYIKhk2G-lkp@intel.com>
References: <20260122045543.218194-7-Smita.KoralahalliChannabasappa@amd.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122045543.218194-7-Smita.KoralahalliChannabasappa@amd.com>

Hi Smita,

kernel test robot noticed the following build errors:

[auto build test ERROR on bc62f5b308cbdedf29132fe96e9d591e526527e1]

url:    https://github.com/intel-lab-lkp/linux/commits/Smita-Koralahalli/dax-hmem-Request-cxl_acpi-and-cxl_pci-before-walking-Soft-Reserved-ranges/20260122-130032
base:   bc62f5b308cbdedf29132fe96e9d591e526527e1
patch link:    https://lore.kernel.org/r/20260122045543.218194-7-Smita.KoralahalliChannabasappa%40amd.com
patch subject: [PATCH v5 6/7] dax/hmem, cxl: Defer and resolve ownership of Soft Reserved memory ranges
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20260123/202601231309.JYIKhk2G-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260123/202601231309.JYIKhk2G-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202601231309.JYIKhk2G-lkp@intel.com/

All errors (new ones prefixed by >>, old ones prefixed by <<):

>> ERROR: modpost: "cxl_bus_type" [drivers/dax/hmem/dax_hmem.ko] undefined!

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
