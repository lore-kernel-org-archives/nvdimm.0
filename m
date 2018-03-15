Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp2120.oracle.com (aserp2120.oracle.com [141.146.126.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 433DA20956069
 for <linux-nvdimm@lists.01.org>; Wed, 14 Mar 2018 22:06:39 -0700 (PDT)
Date: Wed, 14 Mar 2018 22:06:53 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [RFC v2 04/83] NOVA inode definition.
Message-ID: <20180315050653.GC4860@magnolia>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-5-git-send-email-jix024@eng.ucsd.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1520705944-6723-5-git-send-email-jix024@eng.ucsd.edu>
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
To: Andiry Xu <jix024@eng.ucsd.edu>
Cc: coughlan@redhat.com, linux-nvdimm@lists.01.org, Andiry Xu <jix024@cs.ucsd.edu>, miklos@szeredi.hu, david@fromorbit.com, linux-kernel@vger.kernel.org, jack@suse.com, linux-fsdevel@vger.kernel.org, swanson@cs.ucsd.edu, swhiteho@redhat.com, andiry.xu@gmail.com
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Mar 10, 2018 at 10:17:45AM -0800, Andiry Xu wrote:
> From: Andiry Xu <jix024@cs.ucsd.edu>
> 
> inode.h defines the non-volatile and volatile NOVA inode data structures.
> 
> The non-volatile NOVA inode (nova_inode) is aligned to 128 bytes and contains
> file/directory metadata information. The most important fields
> are log_head and log_tail. log_head points to the start of
> the log, and log_tail points to the end of the latest committed
> log entry. NOVA make updates to the inode by appending
> to the log tail and update the log_tail pointer atomically.
> 
> The volatile NOVA inode (nova_inode_info) contains necessary
> information to limit access to the non-volatile NOVA inode during runtime.
> It has a radix tree to map file offset or filenames to the corresponding
> log entries.
> 
> Signed-off-by: Andiry Xu <jix024@cs.ucsd.edu>
> ---
>  fs/nova/inode.h | 187 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 187 insertions(+)
>  create mode 100644 fs/nova/inode.h
> 
> diff --git a/fs/nova/inode.h b/fs/nova/inode.h
> new file mode 100644
> index 0000000..f9187e3
> --- /dev/null
> +++ b/fs/nova/inode.h
> @@ -0,0 +1,187 @@
> +#ifndef __INODE_H
> +#define __INODE_H
> +
> +struct nova_inode_info_header;
> +struct nova_inode;
> +
> +#include "super.h"
> +
> +enum nova_new_inode_type {
> +	TYPE_CREATE = 0,
> +	TYPE_MKNOD,
> +	TYPE_SYMLINK,
> +	TYPE_MKDIR
> +};
> +
> +
> +/*
> + * Structure of an inode in PMEM
> + * Keep the inode size to within 120 bytes: We use the last eight bytes
> + * as inode table tail pointer.

I would've expected a
BUILD_BUG_ON(NOVA_INODE_SIZE - sizeof(struct nova_inode) == 8);
or something to enforce this.

(Or just equate inode number with byte offset?  I looked ahead at the
directory entries and they seem to be 64-bit...)

I guess I'm being lazy and doing a on-disk-format-only review. :)

> + */
> +struct nova_inode {
> +
> +	/* first 40 bytes */
> +	u8	i_rsvd;		 /* reserved. used to be checksum */

Magic number?

> +	u8	valid;		 /* Is this inode valid? */
> +	u8	deleted;	 /* Is this inode deleted? */

Would i_mode == 0 cover these?

> +	u8	i_blk_type;	 /* data block size this inode uses */

I would've thought these would just be bits of i_flags?

Also, if I have a 1G blocksize file and free space fragments to the
point that there's > 1G of free space but none of it contiguous, I guess
I can expect ENOSPC?

> +	__le32	i_flags;	 /* Inode flags */
> +	__le64	i_size;		 /* Size of data in bytes */
> +	__le32	i_ctime;	 /* Inode modification time */
> +	__le32	i_mtime;	 /* Inode b-tree Modification time */
> +	__le32	i_atime;	 /* Access time */

Same y2038 grumble from the previous patch.

> +	__le16	i_mode;		 /* File mode */
> +	__le16	i_links_count;	 /* Links count */
> +
> +	__le64	i_xattr;	 /* Extended attribute block */
> +
> +	/* second 40 bytes */
> +	__le32	i_uid;		 /* Owner Uid */
> +	__le32	i_gid;		 /* Group Id */
> +	__le32	i_generation;	 /* File version (for NFS) */
> +	__le32	i_create_time;	 /* Create time */
> +	__le64	nova_ino;	 /* nova inode number */
> +
> +	__le64	log_head;	 /* Log head pointer */
> +	__le64	log_tail;	 /* Log tail pointer */
> +
> +	/* last 40 bytes */
> +	__le64	create_epoch_id; /* Transaction ID when create */
> +	__le64	delete_epoch_id; /* Transaction ID when deleted */
> +
> +	struct {
> +		__le32 rdev;	 /* major/minor # */
> +	} dev;			 /* device inode */
> +
> +	__le32	csum;            /* CRC32 checksum */
> +	/* Leave 8 bytes for inode table tail pointer */
> +} __attribute((__packed__));
> +
> +/*
> + * NOVA-specific inode state kept in DRAM
> + */
> +struct nova_inode_info_header {
> +	/* For files, tree holds a map from file offsets to
> +	 * write log entries.
> +	 *
> +	 * For directories, tree holds a map from a hash of the file name to
> +	 * dentry log entry.
> +	 */
> +	struct radix_tree_root tree;
> +	struct rw_semaphore i_sem;	/* Protect log and tree */
> +	unsigned short i_mode;		/* Dir or file? */
> +	unsigned int i_flags;
> +	unsigned long log_pages;	/* Num of log pages */
> +	unsigned long i_size;
> +	unsigned long i_blocks;
> +	unsigned long ino;
> +	unsigned long pi_addr;
> +	unsigned long valid_entries;	/* For thorough GC */
> +	unsigned long num_entries;	/* For thorough GC */
> +	u64 last_setattr;		/* Last setattr entry */
> +	u64 last_link_change;		/* Last link change entry */
> +	u64 last_dentry;		/* Last updated dentry */
> +	u64 trans_id;			/* Transaction ID */
> +	u64 log_head;			/* Log head pointer */
> +	u64 log_tail;			/* Log tail pointer */
> +	u8  i_blk_type;
> +};
> +
> +/*
> + * DRAM state for inodes
> + */
> +struct nova_inode_info {
> +	struct nova_inode_info_header header;
> +	struct inode vfs_inode;
> +};
> +
> +
> +static inline struct nova_inode_info *NOVA_I(struct inode *inode)
> +{
> +	return container_of(inode, struct nova_inode_info, vfs_inode);
> +}
> +
> +static inline void sih_lock(struct nova_inode_info_header *header)

"sih"?  What happened to the "nova" prefix?

--D

> +{
> +	down_write(&header->i_sem);
> +}
> +
> +static inline void sih_unlock(struct nova_inode_info_header *header)
> +{
> +	up_write(&header->i_sem);
> +}
> +
> +static inline void sih_lock_shared(struct nova_inode_info_header *header)
> +{
> +	down_read(&header->i_sem);
> +}
> +
> +static inline void sih_unlock_shared(struct nova_inode_info_header *header)
> +{
> +	up_read(&header->i_sem);
> +}
> +
> +static inline unsigned int
> +nova_inode_blk_shift(struct nova_inode_info_header *sih)
> +{
> +	return blk_type_to_shift[sih->i_blk_type];
> +}
> +
> +static inline uint32_t nova_inode_blk_size(struct nova_inode_info_header *sih)
> +{
> +	return blk_type_to_size[sih->i_blk_type];
> +}
> +
> +static inline u64 nova_get_reserved_inode_addr(struct super_block *sb,
> +	u64 inode_number)
> +{
> +	return (NOVA_DEF_BLOCK_SIZE_4K * RESERVE_INODE_START) +
> +			inode_number * NOVA_INODE_SIZE;
> +}
> +
> +static inline struct nova_inode *nova_get_reserved_inode(struct super_block *sb,
> +	u64 inode_number)
> +{
> +	struct nova_sb_info *sbi = NOVA_SB(sb);
> +	u64 addr;
> +
> +	addr = nova_get_reserved_inode_addr(sb, inode_number);
> +
> +	return (struct nova_inode *)(sbi->virt_addr + addr);
> +}
> +
> +static inline struct nova_inode *nova_get_inode_by_ino(struct super_block *sb,
> +						  u64 ino)
> +{
> +	if (ino == 0 || ino >= NOVA_NORMAL_INODE_START)
> +		return NULL;
> +
> +	return nova_get_reserved_inode(sb, ino);
> +}
> +
> +static inline struct nova_inode *nova_get_inode(struct super_block *sb,
> +	struct inode *inode)
> +{
> +	struct nova_inode_info *si = NOVA_I(inode);
> +	struct nova_inode_info_header *sih = &si->header;
> +	struct nova_inode fake_pi;
> +	void *addr;
> +	int rc;
> +
> +	addr = nova_get_block(sb, sih->pi_addr);
> +	rc = memcpy_mcsafe(&fake_pi, addr, sizeof(struct nova_inode));
> +	if (rc)
> +		return NULL;
> +
> +	return (struct nova_inode *)addr;
> +}
> +
> +static inline int nova_persist_inode(struct nova_inode *pi)
> +{
> +	nova_flush_buffer(pi, sizeof(struct nova_inode), 1);
> +	return 0;
> +}
> +
> +#endif
> -- 
> 2.7.4
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
