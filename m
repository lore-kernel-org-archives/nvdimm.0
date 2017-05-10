Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EE21621A04E04
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:02:57 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/16] block: remove blk_part_pack_uuid
Date: Wed, 10 May 2017 20:02:11 +0200
Message-Id: <20170510180214.16852-14-hch@lst.de>
In-Reply-To: <20170510180214.16852-1-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
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

This helper was only used by IMA of all things, which would get spurious
errors if CONFIG_BLOCK is disabled.  Just opencode the call there.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/genhd.h               | 11 -----------
 security/integrity/ima/ima_policy.c |  6 ++----
 2 files changed, 2 insertions(+), 15 deletions(-)

diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index acff9437e5c3..e619fae2f037 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -219,12 +219,6 @@ static inline struct gendisk *part_to_disk(struct hd_struct *part)
 	return NULL;
 }
 
-static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
-{
-	uuid_be_to_bin(uuid_str, (uuid_be *)to);
-	return 0;
-}
-
 static inline int disk_max_parts(struct gendisk *disk)
 {
 	if (disk->flags & GENHD_FL_EXT_DEVT)
@@ -736,11 +730,6 @@ static inline dev_t blk_lookup_devt(const char *name, int partno)
 	dev_t devt = MKDEV(0, 0);
 	return devt;
 }
-
-static inline int blk_part_pack_uuid(const u8 *uuid_str, u8 *to)
-{
-	return -EINVAL;
-}
 #endif /* CONFIG_BLOCK */
 
 #endif /* _LINUX_GENHD_H */
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index 3ab1067db624..4d1178610145 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -717,10 +717,8 @@ static int ima_parse_rule(char *rule, struct ima_rule_entry *entry)
 				break;
 			}
 
-			result = blk_part_pack_uuid(args[0].from,
-						    entry->fsuuid);
-			if (!result)
-				entry->flags |= IMA_FSUUID;
+			uuid_to_bin(args[0].from, (uuid_t *)entry->fsuuid);
+			entry->flags |= IMA_FSUUID;
 			break;
 		case Opt_uid_gt:
 		case Opt_euid_gt:
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
