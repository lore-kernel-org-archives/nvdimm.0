Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0EAD022106DE0
 for <linux-nvdimm@lists.01.org>; Mon,  2 Apr 2018 06:27:57 -0700 (PDT)
Date: Mon, 2 Apr 2018 21:27:04 +0800
From: kbuild test robot <fengguang.wu@intel.com>
Subject: [linux-nvdimm:libnvdimm-for-next 49/56] fs/ext4/super.c:955:
 undefined reference to `fs_dax_release'
Message-ID: <201804022101.uKi3dECz%fengguang.wu@intel.com>
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
Cc: Jan Kara <jack@suse.cz>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Christoph Hellwig <hch@lst.de>, kbuild-all@01.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git libnvdimm-for-next
head:   c2638e7534a1bfca30284b46a29bda820dc16b97
commit: f9c63b454621fc2a0d73b387c8bf6122c4e84d39 [49/56] mm, dev_pagemap: introduce CONFIG_DEV_PAGEMAP_OPS
config: x86_64-randconfig-r0-04022007 (attached as .config)
compiler: gcc-6 (Debian 6.4.0-9) 6.4.0 20171026
reproduce:
        git checkout f9c63b454621fc2a0d73b387c8bf6122c4e84d39
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   fs/ext4/super.o: In function `ext4_put_super':
>> fs/ext4/super.c:955: undefined reference to `fs_dax_release'
   fs/ext4/super.o: In function `fs_dax_claim_bdev':
>> include/linux/dax.h:132: undefined reference to `fs_dax_claim'
   fs/ext4/super.o: In function `ext4_fill_super':
   fs/ext4/super.c:4411: undefined reference to `fs_dax_release'
   fs/xfs/xfs_super.o: In function `fs_dax_claim_bdev':
>> include/linux/dax.h:132: undefined reference to `fs_dax_claim'
   fs/xfs/xfs_super.o: In function `xfs_open_devices':
>> fs/xfs/xfs_super.c:816: undefined reference to `fs_dax_release'
   fs/xfs/xfs_super.c:820: undefined reference to `fs_dax_release'
   fs/xfs/xfs_super.c:823: undefined reference to `fs_dax_release'
   fs/xfs/xfs_super.o: In function `xfs_close_devices':
   fs/xfs/xfs_super.c:727: undefined reference to `fs_dax_release'
   fs/xfs/xfs_super.c:735: undefined reference to `fs_dax_release'
   fs/xfs/xfs_super.o:fs/xfs/xfs_super.c:738: more undefined references to `fs_dax_release' follow

vim +955 fs/ext4/super.c

ac27a0ec1 Dave Kleikamp     2006-10-11  913  
ac27a0ec1 Dave Kleikamp     2006-10-11  914  	/* Debugging code just in case the in-memory inode orphan list
ac27a0ec1 Dave Kleikamp     2006-10-11  915  	 * isn't empty.  The on-disk one can be non-empty if we've
ac27a0ec1 Dave Kleikamp     2006-10-11  916  	 * detected an error and taken the fs readonly, but the
ac27a0ec1 Dave Kleikamp     2006-10-11  917  	 * in-memory list had better be clean by this point. */
ac27a0ec1 Dave Kleikamp     2006-10-11  918  	if (!list_empty(&sbi->s_orphan))
ac27a0ec1 Dave Kleikamp     2006-10-11  919  		dump_orphan_list(sb, sbi);
ac27a0ec1 Dave Kleikamp     2006-10-11  920  	J_ASSERT(list_empty(&sbi->s_orphan));
ac27a0ec1 Dave Kleikamp     2006-10-11  921  
89d96a6f8 Theodore Ts'o     2015-06-20  922  	sync_blockdev(sb->s_bdev);
f98393a64 Peter Zijlstra    2007-05-06  923  	invalidate_bdev(sb->s_bdev);
ac27a0ec1 Dave Kleikamp     2006-10-11  924  	if (sbi->journal_bdev && sbi->journal_bdev != sb->s_bdev) {
ac27a0ec1 Dave Kleikamp     2006-10-11  925  		/*
ac27a0ec1 Dave Kleikamp     2006-10-11  926  		 * Invalidate the journal device's buffers.  We don't want them
ac27a0ec1 Dave Kleikamp     2006-10-11  927  		 * floating about in memory - the physical journal device may
ac27a0ec1 Dave Kleikamp     2006-10-11  928  		 * hotswapped, and it breaks the `ro-after' testing code.
ac27a0ec1 Dave Kleikamp     2006-10-11  929  		 */
ac27a0ec1 Dave Kleikamp     2006-10-11  930  		sync_blockdev(sbi->journal_bdev);
f98393a64 Peter Zijlstra    2007-05-06  931  		invalidate_bdev(sbi->journal_bdev);
617ba13b3 Mingming Cao      2006-10-11  932  		ext4_blkdev_remove(sbi);
ac27a0ec1 Dave Kleikamp     2006-10-11  933  	}
dec214d00 Tahsin Erdogan    2017-06-22  934  	if (sbi->s_ea_inode_cache) {
dec214d00 Tahsin Erdogan    2017-06-22  935  		ext4_xattr_destroy_cache(sbi->s_ea_inode_cache);
dec214d00 Tahsin Erdogan    2017-06-22  936  		sbi->s_ea_inode_cache = NULL;
dec214d00 Tahsin Erdogan    2017-06-22  937  	}
47387409e Tahsin Erdogan    2017-06-22  938  	if (sbi->s_ea_block_cache) {
47387409e Tahsin Erdogan    2017-06-22  939  		ext4_xattr_destroy_cache(sbi->s_ea_block_cache);
47387409e Tahsin Erdogan    2017-06-22  940  		sbi->s_ea_block_cache = NULL;
9c191f701 T Makphaibulchoke 2014-03-18  941  	}
c5e06d101 Johann Lombardi   2011-05-24  942  	if (sbi->s_mmp_tsk)
c5e06d101 Johann Lombardi   2011-05-24  943  		kthread_stop(sbi->s_mmp_tsk);
9060dd2c5 Eric Sandeen      2016-11-26  944  	brelse(sbi->s_sbh);
ac27a0ec1 Dave Kleikamp     2006-10-11  945  	sb->s_fs_info = NULL;
3197ebdb1 Theodore Ts'o     2009-03-31  946  	/*
3197ebdb1 Theodore Ts'o     2009-03-31  947  	 * Now that we are completely done shutting down the
3197ebdb1 Theodore Ts'o     2009-03-31  948  	 * superblock, we need to actually destroy the kobject.
3197ebdb1 Theodore Ts'o     2009-03-31  949  	 */
3197ebdb1 Theodore Ts'o     2009-03-31  950  	kobject_put(&sbi->s_kobj);
3197ebdb1 Theodore Ts'o     2009-03-31  951  	wait_for_completion(&sbi->s_kobj_unregister);
0441984a3 Darrick J. Wong   2012-04-29  952  	if (sbi->s_chksum_driver)
0441984a3 Darrick J. Wong   2012-04-29  953  		crypto_free_shash(sbi->s_chksum_driver);
705895b61 Pekka Enberg      2009-02-15  954  	kfree(sbi->s_blockgroup_lock);
e213635ee Dan Williams      2017-10-21 @955  	fs_dax_release(sbi->s_daxdev, sb);
ac27a0ec1 Dave Kleikamp     2006-10-11  956  	kfree(sbi);
ac27a0ec1 Dave Kleikamp     2006-10-11  957  }
ac27a0ec1 Dave Kleikamp     2006-10-11  958  

:::::: The code at line 955 was first introduced by commit
:::::: e213635ee4633126c4482ead3c79231d124f4b03 mm, dax: enable filesystems to trigger dev_pagemap ->page_free callbacks

:::::: TO: Dan Williams <dan.j.williams@intel.com>
:::::: CC: Dan Williams <dan.j.williams@intel.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
