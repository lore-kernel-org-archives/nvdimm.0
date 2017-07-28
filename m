Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A192B2095DBA2
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 09:55:16 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/3] remove rw_page() from brd, pmem and btt
Date: Fri, 28 Jul 2017 10:56:01 -0600
Message-Id: <20170728165604.10455-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jerome Marchand <jmarchan@redhat.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, Minchan Kim <minchan@kernel.org>, Jan Kara <jack@suse.cz>, "karam . lee" <karam.lee@lge.com>, seungho1.park@lge.com, Nitin Gupta <ngupta@vflare.org>
List-ID: <linux-nvdimm@lists.01.org>

Dan Williams and Christoph Hellwig have recently expressed doubt about
whether the rw_page() interface made sense for synchronous memory drivers
[1][2].  It's unclear whether this interface has any performance benefit
for these drivers, but as we continue to fix bugs it is clear that it does
have a maintenance burden.  This series removes the rw_page()
implementations in brd, pmem and btt to relieve this burden.

The last existing user of the rw_page interface is the zram driver, and
according to the changelog for the patch that added zram_rw_page() that
driver does see a clear performance gain:

  I implemented the feature in zram and tested it.  Test bed was the G2, LG
  electronic mobile device, whtich has msm8974 processor and 2GB memory.

  With a memory allocation test program consuming memory, the system
  generates swap.

  Operating time of swap_write_page() was measured.

  --------------------------------------------------
  |             |   operating time   | improvement |
  |             |  (20 runs average) |             |
  --------------------------------------------------
  |with patch   |    1061.15 us      |    +2.4%    |
  --------------------------------------------------
  |without patch|    1087.35 us      |             |
  --------------------------------------------------

  Each test(with paged_io,with BIO) result set shows normal distribution
  and has equal variance.  I mean the two values are valid result to
  compare.  I can say operation with paged I/O(without BIO) is faster 2.4%
  with confidence level 95%.

These patches have passed ext4 and XFS xfstest regression testing with
a memory mode pmem driver (without DAX), with pmem + btt and with brd.

These patches apply cleanly to the current v4.13-rc2 based linux/master.

[1] https://lists.01.org/pipermail/linux-nvdimm/2017-July/011389.html
[2] https://www.mail-archive.com/linux-block@vger.kernel.org/msg11170.html

Ross Zwisler (3):
  btt: remove btt_rw_page()
  pmem: remove pmem_rw_page()
  brd: remove brd_rw_page()

 drivers/block/brd.c   | 10 ----------
 drivers/nvdimm/btt.c  | 15 ---------------
 drivers/nvdimm/pmem.c | 21 ---------------------
 3 files changed, 46 deletions(-)

-- 
2.9.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
