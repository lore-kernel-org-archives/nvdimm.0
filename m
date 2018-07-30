Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7132D210C0F4C
 for <linux-nvdimm@lists.01.org>; Mon, 30 Jul 2018 00:16:38 -0700 (PDT)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 0/6] kaddr and pfn can be NULL to ->direct_access()
Date: Mon, 30 Jul 2018 15:15:42 +0800
Message-Id: <20180730071548.9172-1-yehs2007@zoho.com>
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
Cc: jack@suse.cz, snitzer@redhat.com, heiko.carstens@de.ibm.com, dm-devel@redhat.com, agk@redhat.com, linux-s390@vger.kernel.org, willy@infradead.org, bart.vanassche@wdc.com, keescook@chromium.org, chengnt@lenovo.com, colyli@suse.de, schwidefsky@de.ibm.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

Changes since v2 [2]:
* Collect Martin and Mike's acks for dcssblk and dm-writecache;
* Rebase the series of patch to v4.18-rc7.

Changes since v1 [1]:
* Involve the previous patches for pfn can be NULL.
* Reword the patch descriptions according to Christian's comment.
* According to Ross's suggestion, replace local pointer dummy_addr
  with NULL within md/dm-writecache for direct_access.

[1]: https://lkml.org/lkml/2018/7/24/199
[2]: https://lkml.org/lkml/2018/7/25/581

Some functions within fs/dax, dax/super and md/dm-writecache don't
need to get local pointer kaddr or variable pfn from direct_access.
Assigning NULL to kaddr or pfn with ->direct_access() is more
straightforward and simple than offering a useless local pointer or
variable.

So all ->direct_access() need to check the validity of pointer kaddr
and pfn for NULL assignment. If either of them is equal to NULL, that
is to say callers may have no need for kaddr or pfn, so this series of
patch are prepared for allowing them to pass in NULL instead of having
to pass in a local pointer or variable that they then just throw away.

Huaisheng Ye (6):
  libnvdimm, pmem: kaddr and pfn can be NULL to ->direct_access()
  s390, dcssblk: kaddr and pfn can be NULL to ->direct_access()
  tools/testing/nvdimm: kaddr and pfn can be NULL to ->direct_access()
  dax/super: Do not request a pointer kaddr when not required
  md/dm-writecache: Don't request pointer dummy_addr when not required
  filesystem-dax: Do not request kaddr and pfn when not required

 drivers/dax/super.c             |  3 +--
 drivers/md/dm-writecache.c      |  3 +--
 drivers/nvdimm/pmem.c           |  7 +++++--
 drivers/s390/block/dcssblk.c    |  8 +++++---
 fs/dax.c                        | 13 ++++---------
 tools/testing/nvdimm/pmem-dax.c | 12 ++++++++----
 6 files changed, 24 insertions(+), 22 deletions(-)

-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
