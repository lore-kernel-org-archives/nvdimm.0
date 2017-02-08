Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8357282087
 for <linux-nvdimm@lists.01.org>; Wed,  8 Feb 2017 04:12:22 -0800 (PST)
Date: Wed, 8 Feb 2017 20:11:57 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH] acpi, nfit: skip ARS on machine-check-recovery capable
 platforms
Message-ID: <201702082041.zYXlrFgN%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <148651103020.2605.2544850985469410207.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on pm/linux-next]
[also build test ERROR on v4.10-rc7 next-20170207]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/acpi-nfit-skip-ARS-on-machine-check-recovery-capable-platforms/20170208-081649
base:   https://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git linux-next
config: i386-randconfig-x0-02081903 (attached as .config)
compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

   In file included from arch/x86/include/asm/current.h:4:0,
                    from include/linux/mutex.h:13,
                    from include/linux/notifier.h:13,
                    from drivers/acpi/nfit/mce.c:15:
   drivers/acpi/nfit/mce.c: In function 'is_ars_required':
>> drivers/acpi/nfit/mce.c:97:37: error: 'mcsafe_key' undeclared (first use in this function)
            if (static_branch_unlikely(&mcsafe_key))
                                        ^
   include/linux/compiler.h:168:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/linux/jump_label.h:387:44: note: in expansion of macro 'static_key_enabled'
    #define static_branch_unlikely(x) unlikely(static_key_enabled(&(x)->key))
                                               ^~~~~~~~~~~~~~~~~~
>> drivers/acpi/nfit/mce.c:97:13: note: in expansion of macro 'static_branch_unlikely'
            if (static_branch_unlikely(&mcsafe_key))
                ^~~~~~~~~~~~~~~~~~~~~~
   drivers/acpi/nfit/mce.c:97:37: note: each undeclared identifier is reported only once for each function it appears in
            if (static_branch_unlikely(&mcsafe_key))
                                        ^
   include/linux/compiler.h:168:42: note: in definition of macro 'unlikely'
    # define unlikely(x) __builtin_expect(!!(x), 0)
                                             ^
   include/linux/jump_label.h:387:44: note: in expansion of macro 'static_key_enabled'
    #define static_branch_unlikely(x) unlikely(static_key_enabled(&(x)->key))
                                               ^~~~~~~~~~~~~~~~~~
>> drivers/acpi/nfit/mce.c:97:13: note: in expansion of macro 'static_branch_unlikely'
            if (static_branch_unlikely(&mcsafe_key))
                ^~~~~~~~~~~~~~~~~~~~~~

vim +/mcsafe_key +97 drivers/acpi/nfit/mce.c

     9	 *
    10	 * This program is distributed in the hope that it will be useful, but
    11	 * WITHOUT ANY WARRANTY; without even the implied warranty of
    12	 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    13	 * General Public License for more details.
    14	 */
  > 15	#include <linux/notifier.h>
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
    29		if (!(mce->status & MCACOD))
    30			return NOTIFY_DONE;
    31	
    32		/*
    33		 * mce->addr contains the physical addr accessed that caused the
    34		 * machine check. We need to walk through the list of NFITs, and see
    35		 * if any of them matches that address, and only then start a scrub.
    36		 */
    37		mutex_lock(&acpi_desc_lock);
    38		list_for_each_entry(acpi_desc, &acpi_descs, list) {
    39			struct device *dev = acpi_desc->dev;
    40			int found_match = 0;
    41	
    42			mutex_lock(&acpi_desc->init_mutex);
    43			list_for_each_entry(nfit_spa, &acpi_desc->spas, list) {
    44				struct acpi_nfit_system_address *spa = nfit_spa->spa;
    45	
    46				if (nfit_spa_type(spa) != NFIT_SPA_PM)
    47					continue;
    48				/* find the spa that covers the mce addr */
    49				if (spa->address > mce->addr)
    50					continue;
    51				if ((spa->address + spa->length - 1) < mce->addr)
    52					continue;
    53				found_match = 1;
    54				dev_dbg(dev, "%s: addr in SPA %d (0x%llx, 0x%llx)\n",
    55					__func__, spa->range_index, spa->address,
    56					spa->length);
    57				/*
    58				 * We can break at the first match because we're going
    59				 * to rescan all the SPA ranges. There shouldn't be any
    60				 * aliasing anyway.
    61				 */
    62				break;
    63			}
    64			mutex_unlock(&acpi_desc->init_mutex);
    65	
    66			if (!found_match)
    67				continue;
    68	
    69			/* If this fails due to an -ENOMEM, there is little we can do */
    70			nvdimm_bus_add_poison(acpi_desc->nvdimm_bus,
    71					ALIGN(mce->addr, L1_CACHE_BYTES),
    72					L1_CACHE_BYTES);
    73			nvdimm_region_notify(nfit_spa->nd_region,
    74					NVDIMM_REVALIDATE_POISON);
    75	
    76			if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON) {
    77				/*
    78				 * We can ignore an -EBUSY here because if an ARS is
    79				 * already in progress, just let that be the last
    80				 * authoritative one
    81				 */
    82				acpi_nfit_ars_rescan(acpi_desc);
    83			}
    84			break;
    85		}
    86	
    87		mutex_unlock(&acpi_desc_lock);
    88		return NOTIFY_DONE;
    89	}
    90	
    91	static struct notifier_block nfit_mce_dec = {
    92		.notifier_call	= nfit_handle_mce,
    93	};
    94	
    95	bool is_ars_required(void)
    96	{
  > 97	        if (static_branch_unlikely(&mcsafe_key))
    98	                return false;
    99		return true;
   100	}

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
