Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from sender-pp-092.zoho.com (sender-pp-092.zoho.com [135.84.80.237])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9215211B506D
 for <linux-nvdimm@lists.01.org>; Tue,  8 Jan 2019 21:31:49 -0800 (PST)
From: Huaisheng Ye <yehs2007@zoho.com>
Subject: [RFC PATCH v2 0/4] add parameter for pmem cache device init
Date: Wed,  9 Jan 2019 13:31:23 +0800
Message-Id: <20190109053127.8128-1-yehs2007@zoho.com>
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
To: snitzer@redhat.com, agk@redhat.com
Cc: jack@suse.cz, corbet@lwn.net, chengnt@lenovo.com, linux-nvdimm@lists.01.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

From: Huaisheng Ye <yehs1@lenovo.com>

This patch set could be used for dm-writecache when use persistent
memory as cache data device.

Patch 1 and 2 go towards removing unused parameter and codes which
actually doesn't really work.

Patch 3 and 4 are targeted at solving problem fn ctr failed to work
due to invalid magic or version, which is caused by the super block
of pmem has messy data stored.

Changes Since v1:
	- add optional parameter reinit to avoid invalid magic or
	  version.
	[1]: https://lkml.org/lkml/2019/1/3/43

Huaisheng Ye (4):
  dm-writecache: remove unused size to writecache_flush_region
  dm-writecache: get rid of memory_data flush to writecache_flush_entry
  dm-writecache: expand pmem_reinit for struct dm_writecache
  Documentation/device-mapper: add optional parameter reinit

 Documentation/device-mapper/writecache.txt |  4 ++++
 drivers/md/dm-writecache.c                 | 19 +++++++++++--------
 2 files changed, 15 insertions(+), 8 deletions(-)

-- 
1.8.3.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
