Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAED22095B9C1
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 01:48:10 -0700 (PDT)
Date: Thu, 17 Aug 2017 16:49:48 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 3/3] fs, xfs: introduce MAP_DIRECT for creating
 block-map-sealed file ranges
Message-ID: <201708171637.gudWyG5I%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150277754211.23945.458876600578531019.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-api@vger.kernel.org, darrick.wong@oracle.com, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, kbuild-all@01.org, luto@kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on linus/master]
[also build test ERROR on v4.13-rc5 next-20170816]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/fs-xfs-introduce-S_IOMAP_SEALED/20170817-114711
config: xtensa-allmodconfig (attached as .config)
compiler: xtensa-linux-gcc (GCC) 4.9.0
reproduce:
        wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=xtensa 

All error/warnings (new ones prefixed by >>):

   mm/mmap.c: In function 'do_mmap':
   mm/mmap.c:1391:8: error: 'MAP_VALIDATE' undeclared (first use in this function)
      case MAP_VALIDATE:
           ^
   mm/mmap.c:1391:8: note: each undeclared identifier is reported only once for each function it appears in
   In file included from mm/mmap.c:17:0:
>> include/linux/mman.h:11:29: error: 'MAP_DIRECT' undeclared (first use in this function)
    #define MAP_SUPPORTED_MASK (MAP_DIRECT)
                                ^
>> mm/mmap.c:1392:18: note: in expansion of macro 'MAP_SUPPORTED_MASK'
       if (flags & ~(MAP_SUPPORTED_MASK | MAP_VALIDATE))
                     ^

vim +/MAP_DIRECT +11 include/linux/mman.h

     9	
    10	/* the MAP_VALIDATE set of supported flags */
  > 11	#define	MAP_SUPPORTED_MASK (MAP_DIRECT)
    12	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
