Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 34F122195406F
 for <linux-nvdimm@lists.01.org>; Thu, 20 Apr 2017 19:22:42 -0700 (PDT)
Date: Fri, 21 Apr 2017 10:21:59 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] acpi, nfit: fix the memory error check in nfit_handle_mce
Message-ID: <201704211005.QjuD0bvn%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <20170420221818.23522-1-vishal.l.verma@intel.com>
Content-Disposition: inline
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-acpi@vger.kernel.org, kbuild-all@01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

[auto build test WARNING on pm/linux-next]
[also build test WARNING on v4.11-rc7 next-20170420]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Vishal-Verma/acpi-nfit-fix-the-memory-error-check-in-nfit_handle_mce/20170421-084359
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
config: x86_64-randconfig-x005-201716 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All warnings (new ones prefixed by >>):

   drivers/acpi/nfit/mce.c: In function 'nfit_handle_mce':
>> drivers/acpi/nfit/mce.c:29:30: warning: comparison of constant '128ul' with boolean expression is always false [-Wbool-compare]
     if (!(mce->status & 0xef80) == BIT(7))
                                 ^~
>> drivers/acpi/nfit/mce.c:29:30: warning: logical not is only applied to the left hand side of comparison [-Wlogical-not-parentheses]

vim +/128ul +29 drivers/acpi/nfit/mce.c

    13	 * General Public License for more details.
    14	 */
    15	#include <linux/notifier.h>
    16	#include <linux/acpi.h>
    17	#include <linux/nd.h>
    18	#include <asm/mce.h>
    19	#include "nfit.h"
    20	
    21	static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
    22				void *data)
    23	{
    24		struct mce *mce = (struct mce *)data;
    25		struct acpi_nfit_desc *acpi_desc;
    26		struct nfit_spa *nfit_spa;
    27	
    28		/* We only care about memory errors */
  > 29		if (!(mce->status & 0xef80) == BIT(7))
    30			return NOTIFY_DONE;
    31	
    32		/*
    33		 * mce->addr contains the physical addr accessed that caused the
    34		 * machine check. We need to walk through the list of NFITs, and see
    35		 * if any of them matches that address, and only then start a scrub.
    36		 */
    37		mutex_lock(&acpi_desc_lock);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
