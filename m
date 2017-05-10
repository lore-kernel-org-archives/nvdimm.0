Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 99F3021A134AE
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 11:03:08 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 16/16] fs: switch ->s_uuid to uuid_t
Date: Wed, 10 May 2017 20:02:14 +0200
Message-Id: <20170510180214.16852-17-hch@lst.de>
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

For some file systems we still memcpy into it, but in various places this
already allows us to use the proper uuid helpers.  More to come..

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/xen/tmem.c                  |  6 +++---
 fs/ext4/super.c                     |  2 +-
 fs/f2fs/super.c                     |  2 +-
 fs/gfs2/ops_fstype.c                |  2 +-
 fs/gfs2/sys.c                       | 22 +++++-----------------
 fs/ocfs2/super.c                    |  2 +-
 fs/xfs/xfs_mount.c                  |  2 +-
 include/linux/cleancache.h          |  2 +-
 include/linux/fs.h                  |  5 +++--
 mm/cleancache.c                     |  2 +-
 security/integrity/evm/evm_crypto.c |  2 +-
 security/integrity/ima/ima_policy.c |  2 +-
 12 files changed, 20 insertions(+), 31 deletions(-)

diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index 4ac2ca8a7656..bf13d1ec51f3 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -233,12 +233,12 @@ static int tmem_cleancache_init_fs(size_t pagesize)
 	return xen_tmem_new_pool(uuid_private, 0, pagesize);
 }
 
-static int tmem_cleancache_init_shared_fs(char *uuid, size_t pagesize)
+static int tmem_cleancache_init_shared_fs(uuid_t *uuid, size_t pagesize)
 {
 	struct tmem_pool_uuid shared_uuid;
 
-	shared_uuid.uuid_lo = *(u64 *)uuid;
-	shared_uuid.uuid_hi = *(u64 *)(&uuid[8]);
+	shared_uuid.uuid_lo = *(u64 *)&uuid->b[0];
+	shared_uuid.uuid_hi = *(u64 *)&uuid->b[8];
 	return xen_tmem_new_pool(shared_uuid, TMEM_POOL_SHARED, pagesize);
 }
 
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index c90edf09b0c3..b53e8b3082c0 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3951,7 +3951,7 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_qcop = &ext4_qctl_operations;
 	sb->s_quota_types = QTYPE_MASK_USR | QTYPE_MASK_GRP | QTYPE_MASK_PRJ;
 #endif
-	memcpy(sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
+	memcpy(&sb->s_uuid, es->s_uuid, sizeof(es->s_uuid));
 
 	INIT_LIST_HEAD(&sbi->s_orphan); /* unlinked but open files */
 	mutex_init(&sbi->s_orphan_lock);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 83355ec4a92c..0b89b0b7b9f7 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1937,7 +1937,7 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_time_gran = 1;
 	sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
 		(test_opt(sbi, POSIX_ACL) ? MS_POSIXACL : 0);
-	memcpy(sb->s_uuid, raw_super->uuid, sizeof(raw_super->uuid));
+	memcpy(&sb->s_uuid, raw_super->uuid, sizeof(raw_super->uuid));
 
 	/* init f2fs-specific super block info */
 	sbi->valid_super_block = valid_super_block;
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index ed67548b286c..b92135c202c2 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -203,7 +203,7 @@ static void gfs2_sb_in(struct gfs2_sbd *sdp, const void *buf)
 
 	memcpy(sb->sb_lockproto, str->sb_lockproto, GFS2_LOCKNAME_LEN);
 	memcpy(sb->sb_locktable, str->sb_locktable, GFS2_LOCKNAME_LEN);
-	memcpy(s->s_uuid, str->sb_uuid, 16);
+	memcpy(&s->s_uuid, str->sb_uuid, 16);
 }
 
 /**
diff --git a/fs/gfs2/sys.c b/fs/gfs2/sys.c
index 7a515345610c..e77bc52b468f 100644
--- a/fs/gfs2/sys.c
+++ b/fs/gfs2/sys.c
@@ -71,25 +71,14 @@ static ssize_t fsname_show(struct gfs2_sbd *sdp, char *buf)
 	return snprintf(buf, PAGE_SIZE, "%s\n", sdp->sd_fsname);
 }
 
-static int gfs2_uuid_valid(const u8 *uuid)
-{
-	int i;
-
-	for (i = 0; i < 16; i++) {
-		if (uuid[i])
-			return 1;
-	}
-	return 0;
-}
-
 static ssize_t uuid_show(struct gfs2_sbd *sdp, char *buf)
 {
 	struct super_block *s = sdp->sd_vfs;
-	const u8 *uuid = s->s_uuid;
+
 	buf[0] = '\0';
-	if (!gfs2_uuid_valid(uuid))
+	if (uuid_is_null(&s->s_uuid))
 		return 0;
-	return snprintf(buf, PAGE_SIZE, "%pUB\n", uuid);
+	return snprintf(buf, PAGE_SIZE, "%pUB\n", &s->s_uuid);
 }
 
 static ssize_t freeze_show(struct gfs2_sbd *sdp, char *buf)
@@ -712,14 +701,13 @@ static int gfs2_uevent(struct kset *kset, struct kobject *kobj,
 {
 	struct gfs2_sbd *sdp = container_of(kobj, struct gfs2_sbd, sd_kobj);
 	struct super_block *s = sdp->sd_vfs;
-	const u8 *uuid = s->s_uuid;
 
 	add_uevent_var(env, "LOCKTABLE=%s", sdp->sd_table_name);
 	add_uevent_var(env, "LOCKPROTO=%s", sdp->sd_proto_name);
 	if (!test_bit(SDF_NOJOURNALID, &sdp->sd_flags))
 		add_uevent_var(env, "JOURNALID=%d", sdp->sd_lockstruct.ls_jid);
-	if (gfs2_uuid_valid(uuid))
-		add_uevent_var(env, "UUID=%pUB", uuid);
+	if (!uuid_is_null(&s->s_uuid))
+		add_uevent_var(env, "UUID=%pUB", &s->s_uuid);
 	return 0;
 }
 
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index ca1646fbcaef..83005f486451 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -2062,7 +2062,7 @@ static int ocfs2_initialize_super(struct super_block *sb,
 	cbits = le32_to_cpu(di->id2.i_super.s_clustersize_bits);
 	bbits = le32_to_cpu(di->id2.i_super.s_blocksize_bits);
 	sb->s_maxbytes = ocfs2_max_file_offset(bbits, cbits);
-	memcpy(sb->s_uuid, di->id2.i_super.s_uuid,
+	memcpy(&sb->s_uuid, di->id2.i_super.s_uuid,
 	       sizeof(di->id2.i_super.s_uuid));
 
 	osb->osb_dx_mask = (1 << (cbits - bbits)) - 1;
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 682b336a7a6a..93a420160964 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -75,7 +75,7 @@ xfs_uuid_mount(
 
 	/* Publish UUID in struct super_block */
 	BUILD_BUG_ON(sizeof(mp->m_super->s_uuid) != sizeof(uuid_t));
-	memcpy(&mp->m_super->s_uuid, uuid, sizeof(uuid_t));
+	uuid_copy(&mp->m_super->s_uuid, uuid);
 
 	if (mp->m_flags & XFS_MOUNT_NOUUID)
 		return 0;
diff --git a/include/linux/cleancache.h b/include/linux/cleancache.h
index fccf7f44139d..bbb3712dd892 100644
--- a/include/linux/cleancache.h
+++ b/include/linux/cleancache.h
@@ -27,7 +27,7 @@ struct cleancache_filekey {
 
 struct cleancache_ops {
 	int (*init_fs)(size_t);
-	int (*init_shared_fs)(char *uuid, size_t);
+	int (*init_shared_fs)(uuid_t *uuid, size_t);
 	int (*get_page)(int, struct cleancache_filekey,
 			pgoff_t, struct page *);
 	void (*put_page)(int, struct cleancache_filekey,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 26488b419965..cdffd2f86aa0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -30,6 +30,7 @@
 #include <linux/percpu-rwsem.h>
 #include <linux/workqueue.h>
 #include <linux/delayed_call.h>
+#include <linux/uuid.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1326,8 +1327,8 @@ struct super_block {
 
 	struct sb_writers	s_writers;
 
-	char s_id[32];				/* Informational name */
-	u8 s_uuid[16];				/* UUID */
+	char			s_id[32];	/* Informational name */
+	uuid_t			s_uuid;		/* UUID */
 
 	void 			*s_fs_info;	/* Filesystem private info */
 	unsigned int		s_max_links;
diff --git a/mm/cleancache.c b/mm/cleancache.c
index ba5d8f3e6d68..f7b9fdc79d97 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -130,7 +130,7 @@ void __cleancache_init_shared_fs(struct super_block *sb)
 	int pool_id = CLEANCACHE_NO_BACKEND_SHARED;
 
 	if (cleancache_ops) {
-		pool_id = cleancache_ops->init_shared_fs(sb->s_uuid, PAGE_SIZE);
+		pool_id = cleancache_ops->init_shared_fs(&sb->s_uuid, PAGE_SIZE);
 		if (pool_id < 0)
 			pool_id = CLEANCACHE_NO_POOL;
 	}
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index d7f282d75cc1..1d32cd20009a 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -164,7 +164,7 @@ static void hmac_add_misc(struct shash_desc *desc, struct inode *inode,
 	hmac_misc.mode = inode->i_mode;
 	crypto_shash_update(desc, (const u8 *)&hmac_misc, sizeof(hmac_misc));
 	if (evm_hmac_attrs & EVM_ATTR_FSUUID)
-		crypto_shash_update(desc, inode->i_sb->s_uuid,
+		crypto_shash_update(desc, &inode->i_sb->s_uuid.b[0],
 				    sizeof(inode->i_sb->s_uuid));
 	crypto_shash_final(desc, digest);
 }
diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
index da3e7d50e0d7..659dbcc83d2f 100644
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -244,7 +244,7 @@ static bool ima_match_rules(struct ima_rule_entry *rule, struct inode *inode,
 	    && rule->fsmagic != inode->i_sb->s_magic)
 		return false;
 	if ((rule->flags & IMA_FSUUID) &&
-	    memcmp(&rule->fsuuid, inode->i_sb->s_uuid, sizeof(rule->fsuuid)))
+	    !uuid_equal(&rule->fsuuid, &inode->i_sb->s_uuid))
 		return false;
 	if ((rule->flags & IMA_UID) && !rule->uid_op(cred->uid, rule->uid))
 		return false;
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
