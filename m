Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7364B16428;
	Fri, 30 Jun 2023 20:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1688158067; x=1719694067;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=I4k8ZYawBmj1oCbgYAV6GU0kOK0L8D712MUx0qlARW0=;
  b=iPfU6zymQNASwpRApGABIsSZGlZbJx+8KreasXvZ5VkTVnK1nqBbzNi5
   U1IQ18Nql4EwDnPIKp2yui7oAAoOat749gvsBbPuIDad3fXD1t6YgYAt/
   Aibn+KdS/kPxpHie1U80Nz3oL+dVsC3kYoZYofwRXhD49djUODPnPzNaP
   fws7ag8noFkTSIgiMaYPYa5Ud8fRsudg+J38mgK994kehrJkJtnEUx5Ei
   I8nw9mCW34Pwf5ggZPXv1lcH5M/npwVusHwyT4R6lLOQleukfZthw98xm
   qjCugM6iyd+3JVBRfVFvU+UU1sOHUzLjle3K3xPOIrzcxAyqTxhc6Ho9S
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="365066363"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="365066363"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2023 13:47:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10757"; a="717942706"
X-IronPort-AV: E=Sophos;i="6.01,171,1684825200"; 
   d="scan'208";a="717942706"
Received: from lkp-server01.sh.intel.com (HELO 783282924a45) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 30 Jun 2023 13:47:43 -0700
Received: from kbuild by 783282924a45 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qFL1q-000FMR-2x;
	Fri, 30 Jun 2023 20:47:42 +0000
Date: Sat, 1 Jul 2023 04:47:19 +0800
From: kernel test robot <lkp@intel.com>
To: Michal Wilczynski <michal.wilczynski@intel.com>,
	linux-acpi@vger.kernel.org
Cc: oe-kbuild-all@lists.linux.dev, rafael@kernel.org,
	dan.j.williams@intel.com, vishal.l.verma@intel.com, lenb@kernel.org,
	dave.jiang@intel.com, ira.weiny@intel.com, rui.zhang@intel.com,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Michal Wilczynski <michal.wilczynski@intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>
Subject: Re: [PATCH v6 7/9] acpi/nfit: Move handler installing logic to driver
Message-ID: <202307010426.IaTkXyNX-lkp@intel.com>
References: <20230630183344.891077-8-michal.wilczynski@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230630183344.891077-8-michal.wilczynski@intel.com>

Hi Michal,

kernel test robot noticed the following build warnings:

[auto build test WARNING on rafael-pm/linux-next]
[also build test WARNING on nvdimm/libnvdimm-for-next]
[cannot apply to nvdimm/dax-misc]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Michal-Wilczynski/acpi-bus-Introduce-wrappers-for-ACPICA-event-handler-install-remove/20230701-023629
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
patch link:    https://lore.kernel.org/r/20230630183344.891077-8-michal.wilczynski%40intel.com
patch subject: [PATCH v6 7/9] acpi/nfit: Move handler installing logic to driver
config: x86_64-allyesconfig (https://download.01.org/0day-ci/archive/20230701/202307010426.IaTkXyNX-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce: (https://download.01.org/0day-ci/archive/20230701/202307010426.IaTkXyNX-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202307010426.IaTkXyNX-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> drivers/acpi/nfit/core.c:3294:6: warning: no previous prototype for 'acpi_nfit_remove_notify_handler' [-Wmissing-prototypes]
    3294 | void acpi_nfit_remove_notify_handler(void *data)
         |      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/acpi_nfit_remove_notify_handler +3294 drivers/acpi/nfit/core.c

  3293	
> 3294	void acpi_nfit_remove_notify_handler(void *data)
  3295	{
  3296		struct acpi_device *adev = data;
  3297	
  3298		acpi_dev_remove_notify_handler(adev,
  3299					       ACPI_DEVICE_NOTIFY,
  3300					       acpi_nfit_notify);
  3301	}
  3302	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
