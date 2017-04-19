Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D8C321A0480F
 for <linux-nvdimm@lists.01.org>; Wed, 19 Apr 2017 10:11:31 -0700 (PDT)
Subject: [4.4-stable PATCH 0/2] libnvdimm: stable fixes for 4.4
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Apr 2017 10:05:41 -0700
Message-ID: <149262154180.9164.2041560731963237508.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
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
To: stable@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, Jens Axboe <axboe@fb.com>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Robert Hu <robert.hu@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi -stable team,

Here is a backport for commit 11e63f6d920d "x86, pmem: fix broken
__copy_user_nocache cache-bypass assumptions", and another block layer
fix that allows the libnvdimm unit tests to run.

I have copied Jens and Jan on the block-layer fix in case they have any
concerns.

---

Dan Williams (2):
      x86, pmem: fix broken __copy_user_nocache cache-bypass assumptions
      block: fix del_gendisk() vs blkdev_ioctl crash


 arch/x86/include/asm/pmem.h |   45 +++++++++++++++++++++++++++++++------------
 block/genhd.c               |    1 -
 2 files changed, 32 insertions(+), 14 deletions(-)
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
