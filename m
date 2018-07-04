Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7DC7210C278D
 for <linux-nvdimm@lists.01.org>; Wed,  4 Jul 2018 09:40:18 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v2 0/4] Assigning NULL to gfn of dax_direct_access if useless
Date: Thu,  5 Jul 2018 00:38:19 +0800
Message-Id: <20180704163823.9980-1-yehs2007@zoho.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org, dan.j.williams@intel.com
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, chengnt@lenovo.com, jack@suse.com, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, colyli@suse.de, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Changes since v1 [1]:
* Collect Jan's reviewed-by.
* According to Dan's suggestion, update the unit test infrastructure
  tools/testing/nvdimm/pmem-dax.c for checking the validity of gfn.

[1]: https://lkml.org/lkml/2018/7/4/81

---

Some functions within fs/dax don't need to get gfn from direct_access.
Assigning NULL to gfn of dax_direct_access is more intuitive and simple
than offering a useless local variable.

So all direct_access need to check the validity of pointer pfn for NULL
assignment. If pfn equals to NULL, it doesn't need to calculate its value.

---

Huaisheng Ye (4):
  nvdimm/pmem: check the validity of the pointer pfn
  nvdimm/pmem-dax: check the validity of the pointer pfn
  s390/block/dcssblk: check the validity of the pointer pfn
  fs/dax: Assign NULL to gfn of dax_direct_access if useless

 drivers/nvdimm/pmem.c           | 3 ++-
 drivers/s390/block/dcssblk.c    | 3 ++-
 fs/dax.c                        | 9 +++------
 tools/testing/nvdimm/pmem-dax.c | 6 ++++--
 4 files changed, 11 insertions(+), 10 deletions(-)

-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
