Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 117D91A1E3A
 for <linux-nvdimm@lists.01.org>; Mon, 13 Jun 2016 15:32:23 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 6/6] dm: Enable DAX support for mapper device
Date: Mon, 13 Jun 2016 16:21:37 -0600
Message-Id: <1465856497-19698-7-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
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
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: axboe@kernel.dk, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com, viro@zeniv.linux.org.uk
List-ID: <linux-nvdimm@lists.01.org>

Add a new dm type, DM_TYPE_DAX_BIO_BASED, which indicates
that mapped device supports DAX and is bio based.  This new
type is used to assure that all target devices have DAX support
and remain that way after GENHD_FL_DAX is set to mapped device.

At initial table load, GENHD_FL_DAX is set to mapped device
when setting DM_TYPE_DAX_BIO_BASED to the type.  Any subsequent
table load to the mapped device must have the same type, or else
it fails per the check in table_load().

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alasdair Kergon <agk@redhat.com>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 drivers/md/dm-table.c |   12 +++++++++---
 drivers/md/dm.c       |    9 +++++++--
 drivers/md/dm.h       |    7 +++++++
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 626a5ec..81138e7 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -833,7 +833,7 @@ static bool __table_type_request_based(unsigned table_type)
 static int dm_table_set_type(struct dm_table *t)
 {
 	unsigned i;
-	unsigned bio_based = 0, request_based = 0, hybrid = 0;
+	unsigned bio_based = 0, request_based = 0, hybrid = 0, num_dax = 0;
 	bool use_blk_mq = false;
 	struct dm_target *tgt;
 	struct dm_dev_internal *dd;
@@ -849,6 +849,9 @@ static int dm_table_set_type(struct dm_table *t)
 		else
 			bio_based = 1;
 
+		if (tgt->dax_supported)
+			num_dax++;
+
 		if (bio_based && request_based) {
 			DMWARN("Inconsistent table: different target types"
 			       " can't be mixed up");
@@ -870,7 +873,10 @@ static int dm_table_set_type(struct dm_table *t)
 
 	if (bio_based) {
 		/* We must use this table as bio-based */
-		t->type = DM_TYPE_BIO_BASED;
+		if (num_dax && num_dax == t->num_targets)
+			t->type = DM_TYPE_DAX_BIO_BASED;
+		else
+			t->type = DM_TYPE_BIO_BASED;
 		return 0;
 	}
 
@@ -978,7 +984,7 @@ static int dm_table_alloc_md_mempools(struct dm_table *t, struct mapped_device *
 		return -EINVAL;
 	}
 
-	if (type == DM_TYPE_BIO_BASED)
+	if (dm_type_bio_based(type))
 		for (i = 0; i < t->num_targets; i++) {
 			tgt = t->targets + i;
 			per_io_data_size = max(per_io_data_size, tgt->per_io_data_size);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 6e9f958..41b8912 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2492,7 +2492,7 @@ static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
 
 	if (md->bs) {
 		/* The md already has necessary mempools. */
-		if (dm_table_get_type(t) == DM_TYPE_BIO_BASED) {
+		if (dm_type_bio_based(dm_table_get_type(t))) {
 			/*
 			 * Reload bioset because front_pad may have changed
 			 * because a different table was loaded.
@@ -2659,6 +2659,9 @@ void dm_set_md_type(struct mapped_device *md, unsigned type)
 {
 	BUG_ON(!mutex_is_locked(&md->type_lock));
 	md->type = type;
+
+	if (type == DM_TYPE_DAX_BIO_BASED)
+		dm_disk(md)->flags |= GENHD_FL_DAX;
 }
 
 unsigned dm_get_md_type(struct mapped_device *md)
@@ -2837,7 +2840,7 @@ out_kfree_tag_set:
 
 static unsigned filter_md_type(unsigned type, struct mapped_device *md)
 {
-	if (type == DM_TYPE_BIO_BASED)
+	if (dm_type_bio_based(type))
 		return type;
 
 	return !md->use_blk_mq ? DM_TYPE_REQUEST_BASED : DM_TYPE_MQ_REQUEST_BASED;
@@ -2867,6 +2870,7 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		}
 		break;
 	case DM_TYPE_BIO_BASED:
+	case DM_TYPE_DAX_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
 		/*
@@ -3573,6 +3577,7 @@ struct dm_md_mempools *dm_alloc_md_mempools(struct mapped_device *md, unsigned t
 
 	switch (type) {
 	case DM_TYPE_BIO_BASED:
+	case DM_TYPE_DAX_BIO_BASED:
 		cachep = _io_cache;
 		pool_size = dm_get_reserved_bio_based_ios();
 		front_pad = roundup(per_io_data_size, __alignof__(struct dm_target_io)) + offsetof(struct dm_target_io, clone);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index 13a758e..6d22667 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -39,6 +39,13 @@
 #define DM_TYPE_BIO_BASED		1
 #define DM_TYPE_REQUEST_BASED		2
 #define DM_TYPE_MQ_REQUEST_BASED	3
+#define DM_TYPE_DAX_BIO_BASED		4
+
+/*
+ * To check whether the DM type is bio-based or not.
+ */
+#define dm_type_bio_based(type) (((type) == DM_TYPE_BIO_BASED) || \
+				 ((type) == DM_TYPE_DAX_BIO_BASED))
 
 /*
  * List of devices that a metadevice uses and should open/close.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
