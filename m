Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 624EB210C0F60
 for <linux-nvdimm@lists.01.org>; Tue, 24 Jul 2018 01:45:57 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH 0/5] Do not request a pointer kaddr when not required
Date: Tue, 24 Jul 2018 16:45:05 +0800
Message-Id: <20180724084510.6104-1-yehs2007@zoho.com>
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
Cc: axboe@kernel.dk, linux-s390@vger.kernel.org, chengnt@lenovo.com, linux-fsdevel@vger.kernel.org, heiko.carstens@de.ibm.com, linux-kernel@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org, schwidefsky@de.ibm.com, jack@suse.cz
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Some functions within fs/dax and dax/super don't need to get kaddr from
direct_access. Assigning NULL to kaddr to ->direct_access() is more
straightforward and simple than offering a useless local pointer.

So all direct_access() need to check the validity of second rank pointer
kaddr for NULL assignment. If kaddr equals to NULL, it doesn't need to
calculate its value.

* This series are supplement to [PATCH v2 00/14]mm: Asynchronous +
  multithreaded memmap init for ZONE_DEVICE. [1]

[1]: https://lkml.org/lkml/2018/7/16/828

Huaisheng Ye (5):
  libnvdimm, pmem: Allow a NULL-kaddr to ->direct_access()
  tools/testing/nvdimm: Allow a NULL-kaddr to ->direct_access()
  s390, dcssblk: Allow a NULL-kaddr to ->direct_access()
  filesystem-dax: Do not request a pointer kaddr when not required
  dax/super: Do not request a pointer kaddr when not required

 drivers/dax/super.c             | 3 +--
 drivers/nvdimm/pmem.c           | 4 +++-
 drivers/s390/block/dcssblk.c    | 3 ++-
 fs/dax.c                        | 3 +--
 tools/testing/nvdimm/pmem-dax.c | 6 ++++--
 5 files changed, 11 insertions(+), 8 deletions(-)

-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
