Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Thu, 31 Aug 2017 10:22:53 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 3/4] ext2: perform dax_device lookup at mount
Message-ID: <20170831082253.GD7897@quack2.suse.cz>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150412224334.10177.12994820445044936627.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <150412224334.10177.12994820445044936627.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-xfs@vger.kernel.org, linux-ext4@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 30-08-17 12:44:03, Dan Williams wrote:
> The ->iomap_begin() operation is a hot path, so cache the
> fs_dax_get_by_host() result at mount time to avoid the incurring the
> hash lookup overhead on a per-i/o basis.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me (and it looks even cleaner than your previous approach).
Just one nit below. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 7b1bc9059863..d9dd999568c2 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -144,6 +144,7 @@ static void ext2_put_super (struct super_block * sb)
>  	int db_count;
>  	int i;
>  	struct ext2_sb_info *sbi = EXT2_SB(sb);
> +	struct dax_device *dax_dev = sbi->s_daxdev;
>  
>  	ext2_quota_off_umount(sb);
>  
> @@ -172,6 +173,7 @@ static void ext2_put_super (struct super_block * sb)
>  	sb->s_fs_info = NULL;
>  	kfree(sbi->s_blockgroup_lock);
>  	kfree(sbi);
> +	fs_put_dax(dax_dev);

The local variable looks superfluous here. I'd just do
	fs_put_dax(sbi->s_daxdev);

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
