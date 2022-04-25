Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FB37E;
	Mon, 25 Apr 2022 18:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650911188; x=1682447188;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jzQ9R7uQvM7Ar4hkHhfKsohSU59ehFv4fTDdCMY0mMA=;
  b=IM7auPJrb5DqaMnlK3lM4kvYadLEwSBewVFKsGGp+uY3htCCP0BGzYU+
   So4WXz511bQGz9wgsfn1NV5pRKvWAYFIpl8OcIBMT5BsW/ju9Jz9F3IAa
   gxn6/Rjigypdz5ybbLsCagkRTrFJOaX7HD1nKOwrio1GGyaaH5IIw0IOn
   qncYNP6LlnItFAKpKRT38A64k/N64GbhcM3WoHNtGUuptxlDp5+4mbVHH
   kiN8kUqg1mQJxhSmURdLlN2xPO6M+6jgLKkVkdNPcse68gerh1azcQfeb
   blE2L8+8qsV9eiIwr78U9sfVIW8DEe4c72lMltjJFmpuZyhOLMoJA5KYw
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="351775939"
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="351775939"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 11:26:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,289,1643702400"; 
   d="scan'208";a="677346229"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga004.jf.intel.com with ESMTP; 25 Apr 2022 11:26:24 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
	(envelope-from <lkp@intel.com>)
	id 1nj3Pk-0002lK-6v;
	Mon, 25 Apr 2022 18:26:24 +0000
Date: Tue, 26 Apr 2022 02:25:46 +0800
From: kernel test robot <lkp@intel.com>
To: cgel.zte@gmail.com, dan.j.williams@intel.com
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org, vishal.l.verma@intel.com,
	dave.jiang@intel.com, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] device-dax: use kobj_to_dev()
Message-ID: <202204260238.kDqgLOsU-lkp@intel.com>
References: <20220425105307.3515215-1-chi.minghao@zte.com.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220425105307.3515215-1-chi.minghao@zte.com.cn>

Hi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.18-rc4 next-20220422]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/cgel-zte-gmail-com/device-dax-use-kobj_to_dev/20220425-185400
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git af2d861d4cd2a4da5137f795ee3509e6f944a25b
config: hexagon-randconfig-r041-20220425 (https://download.01.org/0day-ci/archive/20220426/202204260238.kDqgLOsU-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 1cddcfdc3c683b393df1a5c9063252eb60e52818)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/83eff180ded41da8e042373de81fa823835a1be0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/device-dax-use-kobj_to_dev/20220425-185400
        git checkout 83eff180ded41da8e042373de81fa823835a1be0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/dax/bus.c:515:40: error: expected ';' at end of declaration
           struct device *dev = kobj_to_dev(kobj)
                                                 ^
                                                 ;
   1 error generated.


vim +515 drivers/dax/bus.c

   511	
   512	static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
   513			int n)
   514	{
 > 515		struct device *dev = kobj_to_dev(kobj)
   516		struct dax_region *dax_region = dev_get_drvdata(dev);
   517	
   518		if (is_static(dax_region))
   519			if (a == &dev_attr_available_size.attr
   520					|| a == &dev_attr_create.attr
   521					|| a == &dev_attr_seed.attr
   522					|| a == &dev_attr_delete.attr)
   523				return 0;
   524		return a->mode;
   525	}
   526	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
