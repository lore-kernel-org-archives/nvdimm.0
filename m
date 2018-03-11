Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x241.google.com (mail-it0-x241.google.com
 [IPv6:2607:f8b0:4001:c0b::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0F023223CDC0C
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 20:52:34 -0800 (PST)
Received: by mail-it0-x241.google.com with SMTP id u5-v6so7516108itc.1
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 20:58:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180311021406.GA388@thunk.org>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <20180311021406.GA388@thunk.org>
From: Andiry Xu <jix024@eng.ucsd.edu>
Date: Sat, 10 Mar 2018 20:58:52 -0800
Message-ID: <CAD4Szjt0xZ8Y1MM6-dcCGq3Y2FjkjK7=9O-LZHR4++TFZdh4Ug@mail.gmail.com>
Subject: Re: [RFC v2 00/83] NOVA: a new file system for persistent memory
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
To: "Theodore Y. Ts'o" <tytso@mit.edu>, Andiry Xu <jix024@eng.ucsd.edu>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-kernel@vger.kernel.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dan Williams <dan.j.williams@intel.com>, "Rudoff, Andy" <andy.rudoff@intel.com>, coughlan@redhat.com, Steven Swanson <swanson@cs.ucsd.edu>, Dave Chinner <david@fromorbit.com>, jack@suse.com, swhiteho@redhat.com, miklos@szeredi.hu, Jian Xu <andiry.xu@gmail.com>, Andiry Xu <jix024@cs.ucsd.edu>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Mar 10, 2018 at 6:14 PM, Theodore Y. Ts'o <tytso@mit.edu> wrote:
> FYI, your patch set doesn't even compile for me without these fixups.
> I'm not sure why you were trying to declare inline functions in a
> header file without the function body?
>

Thanks for catching this. I will fix it in the next version and adopt
stricter flags next time.

Thanks,
Andiry

>                                                 - Ted
>
> diff --git a/fs/nova/balloc.c b/fs/nova/balloc.c
> index 8e992156f28c..9c7b74aa712e 100644
> --- a/fs/nova/balloc.c
> +++ b/fs/nova/balloc.c
> @@ -74,12 +74,12 @@ static void nova_init_free_list(struct super_block *sb,
>                 free_list->block_end -= sbi->tail_reserved_blocks;
>  }
>
> -inline struct nova_range_node *nova_alloc_blocknode(struct super_block *sb)
> +struct nova_range_node *nova_alloc_blocknode(struct super_block *sb)
>  {
>         return nova_alloc_range_node(sb);
>  }
>
> -inline void nova_free_blocknode(struct super_block *sb,
> +void nova_free_blocknode(struct super_block *sb,
>         struct nova_range_node *node)
>  {
>         nova_free_range_node(node);
> @@ -206,7 +206,7 @@ int nova_insert_range_node(struct rb_root *tree,
>         return 0;
>  }
>
> -inline int nova_insert_blocktree(struct nova_sb_info *sbi,
> +int nova_insert_blocktree(struct nova_sb_info *sbi,
>         struct rb_root *tree, struct nova_range_node *new_node)
>  {
>         int ret;
> @@ -659,7 +659,7 @@ static int nova_new_blocks(struct super_block *sb, unsigned long *blocknr,
>
>  // Allocate data blocks.  The offset for the allocated block comes back in
>  // blocknr.  Return the number of blocks allocated.
> -inline int nova_new_data_blocks(struct super_block *sb,
> +int nova_new_data_blocks(struct super_block *sb,
>         struct nova_inode_info_header *sih, unsigned long *blocknr,
>         unsigned long start_blk, unsigned int num,
>         enum nova_alloc_init zero, int cpu,
> diff --git a/fs/nova/balloc.h b/fs/nova/balloc.h
> index 463fbac99eff..aca7e8c18dde 100644
> --- a/fs/nova/balloc.h
> +++ b/fs/nova/balloc.h
> @@ -62,18 +62,18 @@ enum alloc_type {
>
>  int nova_alloc_block_free_lists(struct super_block *sb);
>  void nova_delete_free_lists(struct super_block *sb);
> -inline struct nova_range_node *nova_alloc_blocknode(struct super_block *sb);
> -inline void nova_free_blocknode(struct super_block *sb,
> +struct nova_range_node *nova_alloc_blocknode(struct super_block *sb);
> +void nova_free_blocknode(struct super_block *sb,
>         struct nova_range_node *bnode);
>  extern void nova_init_blockmap(struct super_block *sb, int recovery);
>  extern unsigned long nova_count_free_blocks(struct super_block *sb);
> -inline int nova_insert_blocktree(struct nova_sb_info *sbi,
> +int nova_insert_blocktree(struct nova_sb_info *sbi,
>         struct rb_root *tree, struct nova_range_node *new_node);
>  extern int nova_free_data_blocks(struct super_block *sb,
>         struct nova_inode_info_header *sih, unsigned long blocknr, int num);
>  extern int nova_free_log_blocks(struct super_block *sb,
>         struct nova_inode_info_header *sih, unsigned long blocknr, int num);
> -extern inline int nova_new_data_blocks(struct super_block *sb,
> +extern int nova_new_data_blocks(struct super_block *sb,
>         struct nova_inode_info_header *sih, unsigned long *blocknr,
>         unsigned long start_blk, unsigned int num,
>         enum nova_alloc_init zero, int cpu,
> diff --git a/fs/nova/inode.c b/fs/nova/inode.c
> index 21be31a05d26..31ef258978ba 100644
> --- a/fs/nova/inode.c
> +++ b/fs/nova/inode.c
> @@ -440,7 +440,7 @@ struct inode *nova_iget(struct super_block *sb, unsigned long ino)
>         return ERR_PTR(err);
>  }
>
> -inline int nova_insert_inodetree(struct nova_sb_info *sbi,
> +int nova_insert_inodetree(struct nova_sb_info *sbi,
>         struct nova_range_node *new_node, int cpu)
>  {
>         struct rb_root *tree;
> diff --git a/fs/nova/inode.h b/fs/nova/inode.h
> index 086a7cba8ac3..1097e15ff7af 100644
> --- a/fs/nova/inode.h
> +++ b/fs/nova/inode.h
> @@ -254,7 +254,7 @@ int nova_init_inode_table(struct super_block *sb);
>  int nova_get_inode_address(struct super_block *sb, u64 ino,
>         u64 *pi_addr, int extendable);
>  struct inode *nova_iget(struct super_block *sb, unsigned long ino);
> -inline int nova_insert_inodetree(struct nova_sb_info *sbi,
> +int nova_insert_inodetree(struct nova_sb_info *sbi,
>         struct nova_range_node *new_node, int cpu);
>  u64 nova_new_nova_inode(struct super_block *sb, u64 *pi_addr);
>  struct inode *nova_new_vfs_inode(enum nova_new_inode_type type,
> diff --git a/fs/nova/super.c b/fs/nova/super.c
> index 039c003b698b..9f06ec847c95 100644
> --- a/fs/nova/super.c
> +++ b/fs/nova/super.c
> @@ -795,23 +795,23 @@ static void nova_put_super(struct super_block *sb)
>         sb->s_fs_info = NULL;
>  }
>
> -inline void nova_free_range_node(struct nova_range_node *node)
> +void nova_free_range_node(struct nova_range_node *node)
>  {
>         kmem_cache_free(nova_range_node_cachep, node);
>  }
>
> -inline void nova_free_inode_node(struct super_block *sb,
> +void nova_free_inode_node(struct super_block *sb,
>         struct nova_range_node *node)
>  {
>         nova_free_range_node(node);
>  }
>
> -inline void nova_free_file_write_item(struct nova_file_write_item *item)
> +void nova_free_file_write_item(struct nova_file_write_item *item)
>  {
>         kmem_cache_free(nova_file_write_item_cachep, item);
>  }
>
> -inline struct nova_file_write_item *
> +struct nova_file_write_item *
>  nova_alloc_file_write_item(struct super_block *sb)
>  {
>         struct nova_file_write_item *p;
> diff --git a/fs/nova/super.h b/fs/nova/super.h
> index bcbe862ac914..dc98346266e1 100644
> --- a/fs/nova/super.h
> +++ b/fs/nova/super.h
> @@ -160,11 +160,11 @@ static inline struct nova_super_block *nova_get_super(struct super_block *sb)
>
>  extern void nova_error_mng(struct super_block *sb, const char *fmt, ...);
>  extern struct nova_range_node *nova_alloc_range_node(struct super_block *sb);
> -extern inline struct nova_range_node *nova_alloc_inode_node(struct super_block *sb);
> +extern struct nova_range_node *nova_alloc_inode_node(struct super_block *sb);
>  extern struct nova_file_write_item *
>  nova_alloc_file_write_item(struct super_block *sb);
>  extern void nova_free_range_node(struct nova_range_node *node);
> -extern inline void nova_free_inode_node(struct super_block *sb,
> +extern void nova_free_inode_node(struct super_block *sb,
>         struct nova_range_node *node);
>  void nova_free_file_write_item(struct nova_file_write_item *item);
>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
