Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id ECCE021EB528B
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 01:22:13 -0700 (PDT)
Date: Thu, 31 Aug 2017 10:24:27 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v3 4/4] ext4: perform dax_device lookup at mount
Message-ID: <20170831082427.GE7897@quack2.suse.cz>
References: <150412222686.10177.8031279869867070772.stgit@dwillia2-desk3.amr.corp.intel.com>
 <150412224853.10177.6213990706281408829.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150412224853.10177.6213990706281408829.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Theodore Ts'o <tytso@mit.edu>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed 30-08-17 12:44:08, Dan Williams wrote:
> The ->iomap_begin() operation is a hot path, so cache the
> fs_dax_get_by_host() result at mount time to avoid the incurring the
> hash lookup overhead on a per-i/o basis.
> 
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Jan Kara <jack@suse.cz>
> Reported-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good to me. You can add:

Reviewed-by: Jan Kara <jack@suse.cz>

With the same nit as for ext2:

> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index d61a70e2193a..0b3d94e25efb 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -864,6 +864,7 @@ static inline void ext4_quota_off_umount(struct super_block *sb)
>  static void ext4_put_super(struct super_block *sb)
>  {
>  	struct ext4_sb_info *sbi = EXT4_SB(sb);
> +	struct dax_device *dax_dev = sbi->s_daxdev;
>  	struct ext4_super_block *es = sbi->s_es;
>  	int aborted = 0;
>  	int i, err;
> @@ -952,6 +953,7 @@ static void ext4_put_super(struct super_block *sb)
>  		crypto_free_shash(sbi->s_chksum_driver);
>  	kfree(sbi->s_blockgroup_lock);
>  	kfree(sbi);
> +	fs_put_dax(dax_dev);

Just remove dax_dev local variable...

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
