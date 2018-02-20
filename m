Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D8B2121CF1D03
 for <linux-nvdimm@lists.01.org>; Mon, 19 Feb 2018 16:19:13 -0800 (PST)
Date: Tue, 20 Feb 2018 08:24:33 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v6 1/3] fs: allow per-device dax status checking for
 filesystems
Message-ID: <201802200834.rXDUV1nU%fengguang.wu@intel.com>
References: <151880065504.43131.6695118308172421769.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
In-Reply-To: <151880065504.43131.6695118308172421769.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org, darrick.wong@oracle.com, david@fromorbit.com, linux-xfs@vger.kernel.org, kbuild-all@01.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Darrick,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.16-rc2 next-20180219]
[cannot apply to dgc-xfs/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/fs-allow-per-device-dax-status-checking-for-filesystems/20180219-121644
config: x86_64-randconfig-s5-02200659 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

>> drivers/dax/super.c:85:5: error: redefinition of 'bdev_dax_supported'
    int bdev_dax_supported(struct block_device *bdev, int blocksize)
        ^~~~~~~~~~~~~~~~~~
   In file included from drivers/dax/super.c:23:0:
   include/linux/dax.h:56:19: note: previous definition of 'bdev_dax_supported' was here
    static inline int bdev_dax_supported(struct block_device *bdev,
                      ^~~~~~~~~~~~~~~~~~

vim +/bdev_dax_supported +85 drivers/dax/super.c

    74	
    75	/**
    76	 * bdev_dax_supported() - Check if the device supports dax for filesystem
    77	 * @bdev: block device to check
    78	 * @blocksize: The block size of the device
    79	 *
    80	 * This is a library function for filesystems to check if the block device
    81	 * can be mounted with dax option.
    82	 *
    83	 * Return: negative errno if unsupported, 0 if supported.
    84	 */
  > 85	int bdev_dax_supported(struct block_device *bdev, int blocksize)
    86	{
    87		struct dax_device *dax_dev;
    88		pgoff_t pgoff;
    89		int err, id;
    90		void *kaddr;
    91		pfn_t pfn;
    92		long len;
    93		char buf[BDEVNAME_SIZE];
    94	
    95		if (blocksize != PAGE_SIZE) {
    96			pr_debug("%s: error: unsupported blocksize for dax\n",
    97					bdevname(bdev, buf));
    98			return -EINVAL;
    99		}
   100	
   101		err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
   102		if (err) {
   103			pr_debug("%s: error: unaligned partition for dax\n",
   104					bdevname(bdev, buf));
   105			return err;
   106		}
   107	
   108		dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
   109		if (!dax_dev) {
   110			pr_debug("%s: error: device does not support dax\n",
   111					bdevname(bdev, buf));
   112			return -EOPNOTSUPP;
   113		}
   114	
   115		id = dax_read_lock();
   116		len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
   117		dax_read_unlock(id);
   118	
   119		put_dax(dax_dev);
   120	
   121		if (len < 1) {
   122			pr_debug("%s: error: dax access failed (%ld)\n",
   123					bdevname(bdev, buf), len);
   124			return len < 0 ? len : -EIO;
   125		}
   126	
   127		if ((IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn))
   128				|| pfn_t_devmap(pfn))
   129			/* pass */;
   130		else {
   131			pr_debug("%s: error: dax support not enabled\n",
   132					bdevname(bdev, buf));
   133			return -EOPNOTSUPP;
   134		}
   135	
   136		return 0;
   137	}
   138	EXPORT_SYMBOL_GPL(bdev_dax_supported);
   139	#endif
   140	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
