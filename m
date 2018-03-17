Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 17A11223DB0F9
 for <linux-nvdimm@lists.01.org>; Sat, 17 Mar 2018 15:05:34 -0700 (PDT)
Date: Sun, 18 Mar 2018 06:11:35 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v6 15/15] xfs, dax: introduce xfs_break_dax_layouts()
Message-ID: <201803180504.JmKVXfiX%fengguang.wu@intel.com>
References: <152112917064.24669.8101553386217458496.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <152112917064.24669.8101553386217458496.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

I love your patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v4.16-rc5]
[cannot apply to next-20180316]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/dax-fix-dma-vs-truncate-hole-punch/20180318-050250
config: x86_64-randconfig-x014-201811 (attached as .config)
compiler: gcc-7 (Debian 7.3.0-1) 7.3.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

All errors (new ones prefixed by >>):

   fs/xfs/xfs_file.c: In function 'xfs_break_dax_layouts':
>> fs/xfs/xfs_file.c:786:8: error: implicit declaration of function '___wait_var_event'; did you mean 'xfs_wait_var_event'? [-Werror=implicit-function-declaration]
     ret = ___wait_var_event(&page->_refcount,
           ^~~~~~~~~~~~~~~~~
           xfs_wait_var_event
>> fs/xfs/xfs_file.c:788:10: error: invalid use of void expression
       0, 0, xfs_wait_var_event(inode, iolock));
             ^~~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors

vim +786 fs/xfs/xfs_file.c

   773	
   774	static int
   775	xfs_break_dax_layouts(
   776		struct inode		*inode,
   777		uint			iolock)
   778	{
   779		struct page		*page;
   780		int			ret;
   781	
   782		page = dax_layout_busy_page(inode->i_mapping);
   783		if (!page)
   784			return 0;
   785	
 > 786		ret = ___wait_var_event(&page->_refcount,
   787				atomic_read(&page->_refcount) == 1, TASK_INTERRUPTIBLE,
 > 788				0, 0, xfs_wait_var_event(inode, iolock));
   789		if (ret < 0)
   790			return ret;
   791		return 1;
   792	}
   793	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
