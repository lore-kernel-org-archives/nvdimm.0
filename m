Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EA67E
	for <nvdimm@lists.linux.dev>; Mon, 25 Apr 2022 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650904465; x=1682440465;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZYTVedgyRPyp5vY18ocyoCSbrb5gKagd4hpHITPwGkg=;
  b=dlicGbBXIhez5K5Joo5yQzaiL/HYWd0W/47lcVME8scj/NkqeW8EdByg
   q7nVjn4YG5y9ySfYsKGM6CS4QKGSTaZV6EvsVnHIpebG8Gf+opkGvfRSP
   VjF4tB1WZvdV5MkIbt3/lmgzxsVOCEMPzG9bK24Qg/sobIfpOG/U+jsTj
   IU7q8rh6Pm4uAIG7Pkh2cRuko3DHgOqdozrKr4RrkUV5H349Ygk6BmzeC
   PDIkzT94cHWOInc8qKwrSFaqlGvfV+OqEKbYnIt//RkH8DbPSUwESxpRj
   layqpkEQJiG2dood7CjJGKLDcBFvHFmmqoJOWhU2hAKNcWWW8Phs3o30j
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10328"; a="325786912"
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="325786912"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2022 09:34:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,288,1643702400"; 
   d="scan'208";a="537670469"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 25 Apr 2022 09:34:22 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
	(envelope-from <lkp@intel.com>)
	id 1nj1fJ-0002hC-8X;
	Mon, 25 Apr 2022 16:34:21 +0000
Date: Tue, 26 Apr 2022 00:33:59 +0800
From: kernel test robot <lkp@intel.com>
To: cgel.zte@gmail.com, dan.j.williams@intel.com
Cc: kbuild-all@lists.01.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	Minghao Chi <chi.minghao@zte.com.cn>,
	Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] device-dax: use kobj_to_dev()
Message-ID: <202204260044.wlRoUZiW-lkp@intel.com>
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
config: i386-randconfig-r016-20220425 (https://download.01.org/0day-ci/archive/20220426/202204260044.wlRoUZiW-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/83eff180ded41da8e042373de81fa823835a1be0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review cgel-zte-gmail-com/device-dax-use-kobj_to_dev/20220425-185400
        git checkout 83eff180ded41da8e042373de81fa823835a1be0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/dax/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/dax/bus.c: In function 'dax_region_visible':
>> drivers/dax/bus.c:516:9: error: expected ',' or ';' before 'struct'
     516 |         struct dax_region *dax_region = dev_get_drvdata(dev);
         |         ^~~~~~
>> drivers/dax/bus.c:518:23: error: 'dax_region' undeclared (first use in this function)
     518 |         if (is_static(dax_region))
         |                       ^~~~~~~~~~
   drivers/dax/bus.c:518:23: note: each undeclared identifier is reported only once for each function it appears in
   drivers/dax/bus.c:515:24: warning: unused variable 'dev' [-Wunused-variable]
     515 |         struct device *dev = kobj_to_dev(kobj)
         |                        ^~~


vim +516 drivers/dax/bus.c

0f3da14a4f0503 Dan Williams 2020-10-13  511  
c2f3011ee697f8 Dan Williams 2020-10-13  512  static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
c2f3011ee697f8 Dan Williams 2020-10-13  513  		int n)
c2f3011ee697f8 Dan Williams 2020-10-13  514  {
83eff180ded41d Minghao Chi  2022-04-25  515  	struct device *dev = kobj_to_dev(kobj)
c2f3011ee697f8 Dan Williams 2020-10-13 @516  	struct dax_region *dax_region = dev_get_drvdata(dev);
c2f3011ee697f8 Dan Williams 2020-10-13  517  
0f3da14a4f0503 Dan Williams 2020-10-13 @518  	if (is_static(dax_region))
0f3da14a4f0503 Dan Williams 2020-10-13  519  		if (a == &dev_attr_available_size.attr
0f3da14a4f0503 Dan Williams 2020-10-13  520  				|| a == &dev_attr_create.attr
0f3da14a4f0503 Dan Williams 2020-10-13  521  				|| a == &dev_attr_seed.attr
0f3da14a4f0503 Dan Williams 2020-10-13  522  				|| a == &dev_attr_delete.attr)
c2f3011ee697f8 Dan Williams 2020-10-13  523  			return 0;
c2f3011ee697f8 Dan Williams 2020-10-13  524  	return a->mode;
c2f3011ee697f8 Dan Williams 2020-10-13  525  }
c2f3011ee697f8 Dan Williams 2020-10-13  526  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
