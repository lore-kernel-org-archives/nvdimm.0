Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 116A22128A65F
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jun 2019 02:11:10 -0700 (PDT)
From: Pankaj Gupta <pagupta@redhat.com>
Subject: [PATCH v11 4/7] dm: enable synchronous dax
Date: Mon, 10 Jun 2019 14:37:27 +0530
Message-Id: <20190610090730.8589-5-pagupta@redhat.com>
In-Reply-To: <20190610090730.8589-1-pagupta@redhat.com>
References: <20190610090730.8589-1-pagupta@redhat.com>
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
To: dm-devel@redhat.com, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-acpi@vger.kernel.org, qemu-devel@nongnu.org, linux-ext4@vger.kernel.org, linux-xfs@vger.kernel.org
Cc: rdunlap@infradead.org, jack@suse.cz, snitzer@redhat.com, mst@redhat.com, jasowang@redhat.com, david@fromorbit.com, lcapitulino@redhat.com, adilger.kernel@dilger.ca, zwisler@kernel.org, aarcange@redhat.com, jstaron@google.com, darrick.wong@oracle.com, david@redhat.com, willy@infradead.org, hch@infradead.org, nilal@redhat.com, lenb@kernel.org, kilobyte@angband.pl, riel@surriel.com, yuval.shaia@oracle.com, stefanha@redhat.com, pbonzini@redhat.com, kwolf@redhat.com, tytso@mit.edu, xiaoguangrong.eric@gmail.com, cohuck@redhat.com, rjw@rjwysocki.net, imammedo@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

 This patch sets dax device 'DAXDEV_SYNC' flag if all the target
 devices of device mapper support synchrononous DAX. If device
 mapper consists of both synchronous and asynchronous dax devices,
 we don't set 'DAXDEV_SYNC' flag.

Signed-off-by: Pankaj Gupta <pagupta@redhat.com>
---
 drivers/md/dm-table.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 350cf0451456..c5160d846fe6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -890,10 +890,17 @@ static int device_supports_dax(struct dm_target *ti, struct dm_dev *dev,
 			start, len);
 }
 
+static int device_synchronous(struct dm_target *ti, struct dm_dev *dev,
+				       sector_t start, sector_t len, void *data)
+{
+	return dax_synchronous(dev->dax_dev);
+}
+
 bool dm_table_supports_dax(struct dm_table *t, int blocksize)
 {
 	struct dm_target *ti;
 	unsigned i;
+	bool dax_sync = true;
 
 	/* Ensure that all targets support DAX. */
 	for (i = 0; i < dm_table_get_num_targets(t); i++) {
@@ -906,7 +913,14 @@ bool dm_table_supports_dax(struct dm_table *t, int blocksize)
 		    !ti->type->iterate_devices(ti, device_supports_dax,
 			    &blocksize))
 			return false;
+
+		/* Check devices support synchronous DAX */
+		if (dax_sync &&
+		    !ti->type->iterate_devices(ti, device_synchronous, NULL))
+			dax_sync = false;
 	}
+	if (dax_sync)
+		set_dax_synchronous(t->md->dax_dev);
 
 	return true;
 }
-- 
2.20.1

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
