Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 12BE621E2BE26
 for <linux-nvdimm@lists.01.org>; Sat,  2 Sep 2017 17:28:49 -0700 (PDT)
Date: Sun, 3 Sep 2017 08:31:31 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-nvdimm:libnvdimm-for-next 9/22] drivers//dax/super.c:64:20:
 error: redefinition of 'fs_dax_get_by_bdev'
Message-ID: <201709030828.0riSjZnD%fengguang.wu@intel.com>
MIME-Version: 1.0
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
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, Christoph Hellwig <hch@lst.de>, Jan Kara <jack@suse.cz>, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
head:   8f98ae0c9b90bb46097e4f28e81e9ae6148e5694
commit: 78f35473508118df5ea04b9515ac3f1aaec0a980 [9/22] dax: introduce a fs_dax_get_by_bdev() helper
config: ia64-tiger_defconfig (attached as .config)
compiler: ia64-linux-gcc (GCC) 6.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        git checkout 78f35473508118df5ea04b9515ac3f1aaec0a980
        # save the attached .config to linux build tree
        make.cross ARCH=ia64 

All errors (new ones prefixed by >>):

>> drivers//dax/super.c:64:20: error: redefinition of 'fs_dax_get_by_bdev'
    struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
                       ^~~~~~~~~~~~~~~~~~
   In file included from drivers//dax/super.c:22:0:
   include/linux/dax.h:76:34: note: previous definition of 'fs_dax_get_by_bdev' was here
    static inline struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
                                     ^~~~~~~~~~~~~~~~~~

vim +/fs_dax_get_by_bdev +64 drivers//dax/super.c

    63	
  > 64	struct dax_device *fs_dax_get_by_bdev(struct block_device *bdev)
    65	{
    66		if (!blk_queue_dax(bdev->bd_queue))
    67			return NULL;
    68		return fs_dax_get_by_host(bdev->bd_disk->disk_name);
    69	}
    70	EXPORT_SYMBOL_GPL(fs_dax_get_by_bdev);
    71	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
