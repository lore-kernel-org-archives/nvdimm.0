Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A805521F6A6FC
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 17:17:14 -0800 (PST)
Date: Thu, 1 Mar 2018 09:22:47 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 1/3] fs: allow per-device dax status checking for
 filesystems
Message-ID: <201803010915.KJGs7One%fengguang.wu@intel.com>
References: <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
In-Reply-To: <151871655228.27617.3514495396592472682.stgit@djiang5-desk3.ch.intel.com>
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
[also build test ERROR on v4.16-rc3 next-20180228]
[cannot apply to dgc-xfs/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dave-Jiang/minimal-DAX-support-for-XFS-realtime-device/20180218-154220
config: i386-randconfig-c0-03010621 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

>> drivers/dax/super.c:86:5: error: redefinition of 'bdev_dax_supported'
    int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
        ^~~~~~~~~~~~~~~~~~
   In file included from drivers/dax/super.c:23:0:
   include/linux/dax.h:62:19: note: previous definition of 'bdev_dax_supported' was here
    static inline int bdev_dax_supported(struct super_block *sb,
                      ^~~~~~~~~~~~~~~~~~

vim +/bdev_dax_supported +86 drivers/dax/super.c

    74	
    75	/**
    76	 * bdev_dax_supported() - Check if the device supports dax for filesystem
    77	 * @sb: The superblock of the device
    78	 * @bdev: block device to check
    79	 * @blocksize: The block size of the device
    80	 *
    81	 * This is a library function for filesystems to check if the block device
    82	 * can be mounted with dax option.
    83	 *
    84	 * Return: negative errno if unsupported, 0 if supported.
    85	 */
  > 86	int bdev_dax_supported(struct super_block *sb, struct block_device *bdev,
    87			       int blocksize)
    88	{
    89		struct dax_device *dax_dev;
    90		pgoff_t pgoff;
    91		int err, id;
    92		void *kaddr;
    93		pfn_t pfn;
    94		long len;
    95	
    96		if (blocksize != PAGE_SIZE) {
    97			pr_debug("VFS (%s): error: unsupported blocksize for dax\n",
    98					sb->s_id);
    99			return -EINVAL;
   100		}
   101	
   102		err = bdev_dax_pgoff(bdev, 0, PAGE_SIZE, &pgoff);
   103		if (err) {
   104			pr_debug("VFS (%s): error: unaligned partition for dax\n",
   105					sb->s_id);
   106			return err;
   107		}
   108	
   109		dax_dev = dax_get_by_host(bdev->bd_disk->disk_name);
   110		if (!dax_dev) {
   111			pr_debug("VFS (%s): error: device does not support dax\n",
   112					sb->s_id);
   113			return -EOPNOTSUPP;
   114		}
   115	
   116		id = dax_read_lock();
   117		len = dax_direct_access(dax_dev, pgoff, 1, &kaddr, &pfn);
   118		dax_read_unlock(id);
   119	
   120		put_dax(dax_dev);
   121	
   122		if (len < 1) {
   123			pr_debug("VFS (%s): error: dax access failed (%ld)\n",
   124					sb->s_id, len);
   125			return len < 0 ? len : -EIO;
   126		}
   127	
   128		if ((IS_ENABLED(CONFIG_FS_DAX_LIMITED) && pfn_t_special(pfn))
   129				|| pfn_t_devmap(pfn))
   130			/* pass */;
   131		else {
   132			pr_debug("VFS (%s): error: dax support not enabled\n",
   133					sb->s_id);
   134			return -EOPNOTSUPP;
   135		}
   136	
   137		return 0;
   138	}
   139	EXPORT_SYMBOL_GPL(bdev_dax_supported);
   140	#endif
   141	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
