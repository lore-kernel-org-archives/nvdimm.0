Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 286D321FC7479
 for <linux-nvdimm@lists.01.org>; Sat,  7 Oct 2017 23:41:55 -0700 (PDT)
Date: Sun, 8 Oct 2017 14:45:01 +0800
From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v8 2/2] IB/core: use MAP_DIRECT to fix / enable RDMA to
 DAX mappings
Message-ID: <201710081447.sQSonloO%fengguang.wu@intel.com>
MIME-Version: 1.0
In-Reply-To: <150743537023.13602.3520782942682280917.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, "J. Bruce Fields" <bfields@fieldses.org>, linux-mm@kvack.org, Jeff Layton <jlayton@poochiereds.net>, Sean Hefty <sean.hefty@intel.com>, Ashok Raj <ashok.raj@intel.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, Joerg Roedel <joro@8bytes.org>, Christoph Hellwig <hch@lst.de>, Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-api@vger.kernel.org, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, iommu@lists.linux-foundation.org, kbuild-all@01.org, linux-fsdevel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

[auto build test ERROR on rdma/master]
[also build test ERROR on v4.14-rc3 next-20170929]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Dan-Williams/iommu-up-level-sg_num_pages-from-amd-iommu/20171008-133505
base:   https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git master
config: i386-randconfig-n0-201741 (attached as .config)
compiler: gcc-4.8 (Debian 4.8.4-1) 4.8.4
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All errors (new ones prefixed by >>):

>> drivers/infiniband/core/umem.c:39:29: fatal error: linux/mapdirect.h: No such file or directory
    #include <linux/mapdirect.h>
                                ^
   compilation terminated.

vim +39 drivers/infiniband/core/umem.c

  > 39	#include <linux/mapdirect.h>
    40	#include <linux/export.h>
    41	#include <linux/hugetlb.h>
    42	#include <linux/slab.h>
    43	#include <rdma/ib_umem_odp.h>
    44	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
