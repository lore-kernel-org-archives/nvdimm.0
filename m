Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E19A223DB0F9
 for <linux-nvdimm@lists.01.org>; Sat, 17 Mar 2018 23:20:36 -0700 (PDT)
Date: Sun, 18 Mar 2018 14:26:47 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v6 07/15] fs, dax: use page->mapping to warn if truncate
 collides with a busy page
Message-ID: <201803181442.ZhdoKejk%fengguang.wu@intel.com>
References: <152112912106.24669.9677997765966949415.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <152112912106.24669.9677997765966949415.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.16-rc5 next-20180316]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dax-fix-dma-vs-truncate-hole-punch/20180318-050250
config: xtensa-allmodconfig (attached as .config)
compiler: xtensa-linux-gcc (GCC) 7.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=xtensa 

All error/warnings (new ones prefixed by >>):

   fs/dax.c: In function 'dax_entry_size':
>> fs/dax.c:308:10: error: 'HPAGE_SIZE' undeclared (first use in this function); did you mean 'PAGE_SIZE'?
      return HPAGE_SIZE;
             ^~~~~~~~~~
             PAGE_SIZE
   fs/dax.c:308:10: note: each undeclared identifier is reported only once for each function it appears in
>> fs/dax.c:311:1: warning: control reaches end of non-void function [-Wreturn-type]
    }
    ^

vim +308 fs/dax.c

   300	
   301	static unsigned long dax_entry_size(void *entry)
   302	{
   303		if (dax_is_zero_entry(entry))
   304			return 0;
   305		else if (dax_is_empty_entry(entry))
   306			return 0;
   307		else if (dax_is_pmd_entry(entry))
 > 308			return HPAGE_SIZE;
   309		else
   310			return PAGE_SIZE;
 > 311	}
   312	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
