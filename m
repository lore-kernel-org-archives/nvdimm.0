Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2354.austin.hpe.com (g2t2354.austin.hpe.com [15.233.44.27])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 911301A1E15
 for <linux-nvdimm@lists.01.org>; Tue, 28 Jun 2016 12:38:03 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/2] dm snap: add fake origin_direct_access
Date: Tue, 28 Jun 2016 13:37:16 -0600
Message-Id: <1467142636-21094-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
References: <1467142636-21094-1-git-send-email-toshi.kani@hpe.com>
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
To: snitzer@redhat.com
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, agk@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

dax-capable mapped-device is marked as DM_TYPE_DAX_BIO_BASED,
which supports both dax and bio-based operations.  dm-snap
needs to work with dax-capable device when bio-based operation
is used.

Add fake origin_direct_access() to origin device so that its
origin device is also marked as DM_TYPE_DAX_BIO_BASED for
dax-capable device.  This allows to extend target's DM table.
dm-snap works normally when bio-based operation is used.

dm-snap does not support dax operation, and mount with dax
option to a target device or snapshot device fails.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 drivers/md/dm-snap.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 69ab1ff..c472f04 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -2301,6 +2301,13 @@ static int origin_map(struct dm_target *ti, struct bio *bio)
 	return do_origin(o->dev, bio);
 }
 
+static long origin_direct_access(struct dm_target *ti, sector_t sector,
+		void __pmem **kaddr, pfn_t *pfn, long size)
+{
+	DMWARN("device does not support dax.");
+	return -EIO;
+}
+
 /*
  * Set the target "max_io_len" field to the minimum of all the snapshots'
  * chunk sizes.
@@ -2360,6 +2367,7 @@ static struct target_type origin_target = {
 	.postsuspend = origin_postsuspend,
 	.status  = origin_status,
 	.iterate_devices = origin_iterate_devices,
+	.direct_access = origin_direct_access,
 };
 
 static struct target_type snapshot_target = {
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
