Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FBB1223DB0F9
 for <linux-nvdimm@lists.01.org>; Sat, 17 Mar 2018 15:08:37 -0700 (PDT)
Date: Sun, 18 Mar 2018 06:14:32 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v6 11/15] mm, fs, dax: handle layout changes to pinned
 dax mappings
Message-ID: <201803180613.V0nL0svH%fengguang.wu@intel.com>
References: <152112914418.24669.11429662058087306821.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <152112914418.24669.11429662058087306821.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.16-rc5 next-20180316]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dax-fix-dma-vs-truncate-hole-punch/20180318-050250
config: x86_64-randconfig-x010-201811 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   drivers/dax/super.c: In function 'generic_dax_pagefree':
>> drivers/dax/super.c:170:2: error: implicit declaration of function 'wake_up_var'; did you mean 'wake_up_nr'? [-Werror=implicit-function-declaration]
     wake_up_var(&page->_refcount);
     ^~~~~~~~~~~
     wake_up_nr
   cc1: some warnings being treated as errors

vim +170 drivers/dax/super.c

   166	
   167	#if IS_ENABLED(CONFIG_FS_DAX)
   168	static void generic_dax_pagefree(struct page *page, void *data)
   169	{
 > 170		wake_up_var(&page->_refcount);
   171	}
   172	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
