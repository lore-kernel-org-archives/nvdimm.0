Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 170621A1E21
 for <linux-nvdimm@lists.01.org>; Sat,  9 Jul 2016 21:48:59 -0700 (PDT)
Date: Sun, 10 Jul 2016 12:47:10 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 08/17] libnvdimm: introduce nvdimm_flush() and
 nvdimm_has_flush()
Message-ID: <201607101237.dmgprEIr%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <146812111205.32932.3785207412939078453.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Hi,

[auto build test ERROR on linux-nvdimm/libnvdimm-for-next]
[also build test ERROR on next-20160708]
[cannot apply to v4.7-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/replace-pcommit-with-ADR-or-directed-flushing/20160710-113558
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: i386-randconfig-r0-201628 (attached as .config)
compiler: gcc-6 (Debian 6.1.1-1) 6.1.1 20160430
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

   drivers/nvdimm/region_devs.c: In function 'nvdimm_flush':
>> drivers/nvdimm/region_devs.c:887:4: error: implicit declaration of function 'writeq' [-Werror=implicit-function-declaration]
       writeq(1, ndrd->flush_wpq[i][0]);
       ^~~~~~
   cc1: some warnings being treated as errors

vim +/writeq +887 drivers/nvdimm/region_devs.c

   881		 * writes to avoid the cache via arch_memcpy_to_pmem().  The
   882		 * final wmb() ensures ordering for the NVDIMM flush write.
   883		 */
   884		wmb();
   885		for (i = 0; i < nd_region->ndr_mappings; i++)
   886			if (ndrd->flush_wpq[i][0])
 > 887				writeq(1, ndrd->flush_wpq[i][0]);
   888		wmb();
   889	}
   890	EXPORT_SYMBOL_GPL(nvdimm_flush);

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
