Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E3917CF;
	Sat, 19 Mar 2022 08:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647679515; x=1679215515;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=k5pfSFVTly+M3cSKghoKNsmKVoZp5T4ZrPis3GmwE5I=;
  b=PNG2O5BgTOPF7GvoshkAcQRaoCUd+r1t0WPz3mwimpzDCBoypPhL/LgR
   EYY0bNxuUtmEPcHHu+WvozW+1chFUmhex6FJhJVCsVAWiKHOcZ2rdxwm+
   CWvxj+CkA2r5bskBipUoCcainhBBJn4bwzebvIlRe855pkaZM9BwNHhlW
   o3LY77BGj5SqAbmOkw066syaBAEH705YAUDrAdn2Pm73EgDYoPjuWMGXM
   RrAhu/UQcj0Z+5PezqSaxgdJQcv2tVjtJ6aifnVmkb1rQN5VQFpZN8VcL
   9qzOQ5AOtBraNQ8ONvh5S1PYWYHRlmWJ+Y2VdwBw3afk7TWATR2R1/uAK
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10290"; a="244759663"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="244759663"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 01:45:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="542300135"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by orsmga007.jf.intel.com with ESMTP; 19 Mar 2022 01:45:10 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
	(envelope-from <lkp@intel.com>)
	id 1nVUhw-000FmU-IK; Sat, 19 Mar 2022 08:45:08 +0000
Date: Sat, 19 Mar 2022 16:44:44 +0800
From: kernel test robot <lkp@intel.com>
To: Jane Chu <jane.chu@oracle.com>, david@fromorbit.com, djwong@kernel.org,
	dan.j.williams@intel.com, hch@infradead.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com, agk@redhat.com,
	snitzer@redhat.com, dm-devel@redhat.com, ira.weiny@intel.com,
	willy@infradead.org, vgoyal@redhat.com,
	linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: llvm@lists.linux.dev, kbuild-all@lists.01.org
Subject: Re: [PATCH v6 4/6] dax: add DAX_RECOVERY flag and .recovery_write
 dev_pgmap_ops
Message-ID: <202203191635.vyoiL17f-lkp@intel.com>
References: <20220319062833.3136528-5-jane.chu@oracle.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319062833.3136528-5-jane.chu@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jane,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on nvdimm/libnvdimm-for-next]
[also build test ERROR on device-mapper-dm/for-next linus/master v5.17-rc8 next-20220318]
[cannot apply to tip/x86/mm]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Jane-Chu/DAX-poison-recovery/20220319-143144
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
config: s390-randconfig-r044-20220318 (https://download.01.org/0day-ci/archive/20220319/202203191635.vyoiL17f-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project a6e70e4056dff962ec634c5bd4f2f4105a0bef71)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install s390 cross compiling tool for clang build
        # apt-get install binutils-s390x-linux-gnu
        # https://github.com/0day-ci/linux/commit/203570f765a6ad07eb5809850478a25a5257f7e2
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Jane-Chu/DAX-poison-recovery/20220319-143144
        git checkout 203570f765a6ad07eb5809850478a25a5257f7e2
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=s390 SHELL=/bin/bash drivers/s390/block/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from drivers/s390/block/dcssblk.c:24:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:464:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __raw_readb(PCI_IOBASE + addr);
                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:477:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:37:59: note: expanded from macro '__le16_to_cpu'
   #define __le16_to_cpu(x) __swab16((__force __u16)(__le16)(x))
                                                             ^
   include/uapi/linux/swab.h:102:54: note: expanded from macro '__swab16'
   #define __swab16(x) (__u16)__builtin_bswap16((__u16)(x))
                                                        ^
   In file included from drivers/s390/block/dcssblk.c:24:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:490:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
                                                           ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/big_endian.h:35:59: note: expanded from macro '__le32_to_cpu'
   #define __le32_to_cpu(x) __swab32((__force __u32)(__le32)(x))
                                                             ^
   include/uapi/linux/swab.h:115:54: note: expanded from macro '__swab32'
   #define __swab32(x) (__u32)__builtin_bswap32((__u32)(x))
                                                        ^
   In file included from drivers/s390/block/dcssblk.c:24:
   In file included from arch/s390/include/asm/io.h:75:
   include/asm-generic/io.h:501:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writeb(value, PCI_IOBASE + addr);
                               ~~~~~~~~~~ ^
   include/asm-generic/io.h:511:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:521:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
                                                         ~~~~~~~~~~ ^
   include/asm-generic/io.h:609:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsb(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:617:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsw(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:625:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           readsl(PCI_IOBASE + addr, buffer, count);
                  ~~~~~~~~~~ ^
   include/asm-generic/io.h:634:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesb(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:643:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesw(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
   include/asm-generic/io.h:652:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
           writesl(PCI_IOBASE + addr, buffer, count);
                   ~~~~~~~~~~ ^
>> drivers/s390/block/dcssblk.c:53:63: error: too few arguments to function call, expected 6, have 5
           rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
                ~~~~~~~~~~~~~~~~~                                       ^
   include/linux/dax.h:186:6: note: 'dax_direct_access' declared here
   long dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff, long nr_pages,
        ^
   12 warnings and 1 error generated.


vim +53 drivers/s390/block/dcssblk.c

7a2765f6e82063f Dan Williams 2017-01-26  46  
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  47  static int dcssblk_dax_zero_page_range(struct dax_device *dax_dev,
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  48  				       pgoff_t pgoff, size_t nr_pages)
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  49  {
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  50  	long rc;
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  51  	void *kaddr;
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  52  
79fa974ff6bc3f7 Vivek Goyal  2020-02-28 @53  	rc = dax_direct_access(dax_dev, pgoff, nr_pages, &kaddr, NULL);
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  54  	if (rc < 0)
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  55  		return rc;
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  56  	memset(kaddr, 0, nr_pages << PAGE_SHIFT);
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  57  	dax_flush(dax_dev, kaddr, nr_pages << PAGE_SHIFT);
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  58  	return 0;
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  59  }
79fa974ff6bc3f7 Vivek Goyal  2020-02-28  60  

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
