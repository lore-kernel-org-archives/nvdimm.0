Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AF183211B5A4C
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 18:31:15 -0800 (PST)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [PATCH v3 0/5] Optimize writecache when using pmem as cache
Date: Thu, 31 Jan 2019 10:29:50 +0800
Message-Id: <20190131022955.9920-1-yehs2007@zoho.com>
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
To: mpatocka@redhat.com, snitzer@redhat.com, agk@redhat.com
Cc: jack@suse.cz, corbet@lwn.net, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

This patch set could be used for dm-writecache when use persistent
memory as cache data device.

Patch 1 and 2 go towards removing unused parameter and codes which
actually doesn't really work.

Patch 3 and 4 are targeted at solving problem fn ctr failed to work
due to invalid magic or version, which is caused by the super block
of pmem has messy data stored.

Patch 5 is used for getting the status of seq_count.

Changes Since v2: 
        - seq_count is important for flush operations, output it within status
          for debugging and analyzing code behavior.
	[1]: https://lkml.org/lkml/2019/1/3/43
        [2]: https://lkml.org/lkml/2019/1/9/6

Huaisheng Ye (5):
  dm-writecache: remove unused size to writecache_flush_region
  dm-writecache: get rid of memory_data flush to writecache_flush_entry
  dm-writecache: expand pmem_reinit for struct dm_writecache
  Documentation/device-mapper: add optional parameter reinit
  dm-writecache: output seq_count within status

 Documentation/device-mapper/writecache.txt |  4 ++++
 drivers/md/dm-writecache.c                 | 23 +++++++++++++----------
 2 files changed, 17 insertions(+), 10 deletions(-)

-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
