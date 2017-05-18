Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 526AF21A16EFB
 for <linux-nvdimm@lists.01.org>; Wed, 17 May 2017 23:28:25 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 19/23] partitions/ldm: switch to use uuid_t
Date: Thu, 18 May 2017 08:27:01 +0200
Message-Id: <20170518062705.25902-20-hch@lst.de>
In-Reply-To: <20170518062705.25902-1-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

And the uuid helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/partitions/ldm.c | 10 +++++-----
 block/partitions/ldm.h |  6 ++----
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/block/partitions/ldm.c b/block/partitions/ldm.c
index edcea70674c9..bbf929e80b94 100644
--- a/block/partitions/ldm.c
+++ b/block/partitions/ldm.c
@@ -115,7 +115,7 @@ static bool ldm_parse_privhead(const u8 *data, struct privhead *ph)
 		ldm_error("PRIVHEAD disk size doesn't match real disk size");
 		return false;
 	}
-	if (uuid_be_to_bin(data + 0x0030, (uuid_be *)ph->disk_id)) {
+	if (uuid_to_bin(data + 0x0030, &ph->disk_id)) {
 		ldm_error("PRIVHEAD contains an invalid GUID.");
 		return false;
 	}
@@ -234,7 +234,7 @@ static bool ldm_compare_privheads (const struct privhead *ph1,
 		(ph1->logical_disk_size  == ph2->logical_disk_size)	&&
 		(ph1->config_start       == ph2->config_start)		&&
 		(ph1->config_size        == ph2->config_size)		&&
-		!memcmp (ph1->disk_id, ph2->disk_id, GUID_SIZE));
+		uuid_equal(&ph1->disk_id, &ph2->disk_id));
 }
 
 /**
@@ -557,7 +557,7 @@ static struct vblk * ldm_get_disk_objid (const struct ldmdb *ldb)
 
 	list_for_each (item, &ldb->v_disk) {
 		struct vblk *v = list_entry (item, struct vblk, list);
-		if (!memcmp (v->vblk.disk.disk_id, ldb->ph.disk_id, GUID_SIZE))
+		if (uuid_equal(&v->vblk.disk.disk_id, &ldb->ph.disk_id))
 			return v;
 	}
 
@@ -892,7 +892,7 @@ static bool ldm_parse_dsk3 (const u8 *buffer, int buflen, struct vblk *vb)
 	disk = &vb->vblk.disk;
 	ldm_get_vstr (buffer + 0x18 + r_diskid, disk->alt_name,
 		sizeof (disk->alt_name));
-	if (uuid_be_to_bin(buffer + 0x19 + r_name, (uuid_be *)disk->disk_id))
+	if (uuid_to_bin(buffer + 0x19 + r_name, &disk->disk_id))
 		return false;
 
 	return true;
@@ -927,7 +927,7 @@ static bool ldm_parse_dsk4 (const u8 *buffer, int buflen, struct vblk *vb)
 		return false;
 
 	disk = &vb->vblk.disk;
-	memcpy (disk->disk_id, buffer + 0x18 + r_name, GUID_SIZE);
+	uuid_copy(&disk->disk_id, (uuid_t *)(buffer + 0x18 + r_name));
 	return true;
 }
 
diff --git a/block/partitions/ldm.h b/block/partitions/ldm.h
index 374242c0971a..f4c6055df956 100644
--- a/block/partitions/ldm.h
+++ b/block/partitions/ldm.h
@@ -112,8 +112,6 @@ struct frag {				/* VBLK Fragment handling */
 
 /* In memory LDM database structures. */
 
-#define GUID_SIZE		16
-
 struct privhead {			/* Offsets and sizes are in sectors. */
 	u16	ver_major;
 	u16	ver_minor;
@@ -121,7 +119,7 @@ struct privhead {			/* Offsets and sizes are in sectors. */
 	u64	logical_disk_size;
 	u64	config_start;
 	u64	config_size;
-	u8	disk_id[GUID_SIZE];
+	uuid_t	disk_id;
 };
 
 struct tocblock {			/* We have exactly two bitmaps. */
@@ -154,7 +152,7 @@ struct vblk_dgrp {			/* VBLK Disk Group */
 };
 
 struct vblk_disk {			/* VBLK Disk */
-	u8	disk_id[GUID_SIZE];
+	uuid_t	disk_id;
 	u8	alt_name[128];
 };
 
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
