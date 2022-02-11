Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF49E7C
	for <nvdimm@lists.linux.dev>; Fri, 11 Feb 2022 18:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644602405; x=1676138405;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=fDDGny/iyeoFOJHXpPTmtGt49foHBaYF7butWicdaLY=;
  b=NtpTrI4N+Hpk789eydyjDPgZcDl0sSs9K3g2CG6WTOgkjtD4F97eWFcj
   5fE++VLcsB9KLsqDAx26TWNMtodEM6zKskH9UMINm6OUMofHX7LY0/q0X
   I466JMdxtFh62AnxoG5hz8jRH73fUPJwaXAMlq5yhn8DBdIeLZPu7HfJK
   HBMnBhdNKwWj1CyKU3s0kU2M2DZTWDye4qe1pKsgGyj7nGvvOb2RASvCF
   sD+TnGUC7vlwcM5x1u/JY7Sh+61nb5XUq27CxRStJfZYLevSPqiJzKA+i
   JRftkYM++Kxt2LXNKzfcnQq1Nfgv0t/arU2N6rlWpNAuaXdMb0JTHRNIQ
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="274337649"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="274337649"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 10:00:05 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="500850554"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 11 Feb 2022 10:00:01 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nIaDB-0004vo-8s; Fri, 11 Feb 2022 18:00:01 +0000
Date: Sat, 12 Feb 2022 01:59:07 +0800
From: kernel test robot <lkp@intel.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hui Wang <hui.wang@canonical.com>, linux-acpi@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev
Cc: kbuild-all@lists.01.org, Len Brown <lenb@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v1 1/1] ACPI: Switch to use list_entry_is_head() helper
Message-ID: <202202120054.idhiETlD-lkp@intel.com>
References: <20220211110423.22733-1-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220211110423.22733-1-andriy.shevchenko@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Andy,

I love your patch! Yet something to improve:

[auto build test ERROR on rafael-pm/linux-next]
[also build test ERROR on nvdimm/libnvdimm-for-next v5.17-rc3 next-20220211]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Andy-Shevchenko/ACPI-Switch-to-use-list_entry_is_head-helper/20220211-190438
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
config: ia64-allmodconfig (https://download.01.org/0day-ci/archive/20220212/202202120054.idhiETlD-lkp@intel.com/config)
compiler: ia64-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/95f7c8c71bb18e505f5399a87cbb192f481c86fe
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Andy-Shevchenko/ACPI-Switch-to-use-list_entry_is_head-helper/20220211-190438
        git checkout 95f7c8c71bb18e505f5399a87cbb192f481c86fe
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=ia64 SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/acpi/acpi_ipmi.c: In function 'ipmi_cancel_tx_msg':
>> drivers/acpi/acpi_ipmi.c:369:17: error: expected ')' before 'return'
     369 |                 return;
         |                 ^~~~~~
   drivers/acpi/acpi_ipmi.c:368:12: note: to match this '('
     368 |         if (list_entry_is_head(tx_msg, &ipmi->tx_msg_list, head)
         |            ^
>> drivers/acpi/acpi_ipmi.c:372:1: error: expected expression before '}' token
     372 | }
         | ^


vim +369 drivers/acpi/acpi_ipmi.c

   352	
   353	static void ipmi_cancel_tx_msg(struct acpi_ipmi_device *ipmi,
   354				       struct acpi_ipmi_msg *msg)
   355	{
   356		struct acpi_ipmi_msg *tx_msg, *temp;
   357		unsigned long flags;
   358	
   359		spin_lock_irqsave(&ipmi->tx_msg_lock, flags);
   360		list_for_each_entry_safe(tx_msg, temp, &ipmi->tx_msg_list, head) {
   361			if (msg == tx_msg) {
   362				list_del(&tx_msg->head);
   363				break;
   364			}
   365		}
   366		spin_unlock_irqrestore(&ipmi->tx_msg_lock, flags);
   367	
   368		if (list_entry_is_head(tx_msg, &ipmi->tx_msg_list, head)
 > 369			return;
   370	
   371		acpi_ipmi_msg_put(tx_msg);
 > 372	}
   373	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
