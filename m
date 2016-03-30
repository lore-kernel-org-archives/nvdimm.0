Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 972D21A1E3A
 for <linux-nvdimm@lists.01.org>; Tue, 29 Mar 2016 20:02:05 -0700 (PDT)
Date: Wed, 30 Mar 2016 11:00:12 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v2 5/5] dax: handle media errors in dax_do_io
Message-ID: <201603301035.IXzhGMnJ%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <1459303190-20072-6-git-send-email-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, xfs@oss.sgi.com, linux-block@vger.kernel.org, linux-mm@kvack.org, kbuild-all@01.org, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

[auto build test WARNING on linux-nvdimm/libnvdimm-for-next]
[also build test WARNING on v4.6-rc1 next-20160329]
[cannot apply to xfs/for-next]
[if your patch is applied to the wrong git tree, please drop us a note to help improving the system]

url:    https://github.com/0day-ci/linux/commits/Vishal-Verma/dax-handling-of-media-errors/20160330-100409
base:   https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm libnvdimm-for-next
config: x86_64-randconfig-i0-03300245 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings

All warnings (new ones prefixed by >>):

   fs/ext4/indirect.c: In function 'ext4_ind_direct_IO':
>> fs/ext4/indirect.c:719:11: warning: 'ret_saved' may be used uninitialized in this function [-Wmaybe-uninitialized]
      ssize_t ret_saved = 0;
              ^

vim +/ret_saved +719 fs/ext4/indirect.c

   703			smp_mb();
   704			if (unlikely(ext4_test_inode_state(inode,
   705							    EXT4_STATE_DIOREAD_LOCK))) {
   706				inode_dio_end(inode);
   707				goto locked;
   708			}
   709			if (IS_DAX(inode))
   710				ret = dax_do_io(iocb, inode, iter, offset,
   711						ext4_dio_get_block, NULL, 0);
   712			else
   713				ret = __blockdev_direct_IO(iocb, inode,
   714							   inode->i_sb->s_bdev, iter,
   715							   offset, ext4_dio_get_block,
   716							   NULL, NULL, 0);
   717			inode_dio_end(inode);
   718		} else {
 > 719			ssize_t ret_saved = 0;
   720	
   721	locked:
   722			if (IS_DAX(inode)) {
   723				ret = dax_do_io(iocb, inode, iter, offset,
   724						ext4_dio_get_block, NULL, DIO_LOCKING);
   725				if (ret == -EIO && iov_iter_rw(iter) == WRITE)
   726					ret_saved = ret;
   727				else

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
