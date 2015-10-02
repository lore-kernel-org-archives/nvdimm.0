Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Fri, 2 Oct 2015 16:16:05 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] ext2, ext4: warn when mounting with dax enabled
Message-ID: <20151002141605.GC14603@quack.suse.cz>
References: <20150929194806.5276.863.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150929194806.5276.863.stgit@dwillia2-desk3.jf.intel.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: ross.zwisler@linux.intel.com, david@fromorbit.com, Theodore Ts'o <tytso@mit.edu>, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>, linux-ext4@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue 29-09-15 15:48:11, Dan Williams wrote:
> Similar to XFS warn when mounting DAX while it is still considered under
> development.  Also, aspects of the DAX implementation, for example
> synchronization against multiple faults and faults causing block
> allocation, depend on the correct implementation in the filesystem.  The
> maturity of a given DAX implementation is filesystem specific.
> 
> Cc: Jan Kara <jack@suse.com>
> Cc: "Theodore Ts'o" <tytso@mit.edu>
> Cc: Andreas Dilger <adilger.kernel@dilger.ca>
> Cc: Matthew Wilcox <willy@linux.intel.com>
> Cc: linux-ext4@vger.kernel.org
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Reported-by: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Agreed. You can add:
Acked-by: Jan Kara <jack@suse.com>

								Honza

> ---
> Given the pending investigations [1], and rather than marking FS_DAX
> broken, warn about DAX usage until we've landed fixes for the issues
> that Dave has identified.
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2015-September/002266.html
> 
>  fs/ext2/super.c |    2 ++
>  fs/ext4/super.c |    6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ext2/super.c b/fs/ext2/super.c
> index 900e19cf9ef6..2597b0663bf2 100644
> --- a/fs/ext2/super.c
> +++ b/fs/ext2/super.c
> @@ -566,6 +566,8 @@ static int parse_options(char *options, struct super_block *sb)
>  			/* Fall through */
>  		case Opt_dax:
>  #ifdef CONFIG_FS_DAX
> +			ext2_msg(sb, KERN_WARNING,
> +		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
>  			set_opt(sbi->s_mount_opt, DAX);
>  #else
>  			ext2_msg(sb, KERN_INFO, "dax option not supported");
> diff --git a/fs/ext4/super.c b/fs/ext4/super.c
> index a63c7b0a10cf..4db6eb0b6979 100644
> --- a/fs/ext4/super.c
> +++ b/fs/ext4/super.c
> @@ -1656,8 +1656,12 @@ static int handle_mount_opt(struct super_block *sb, char *opt, int token,
>  		}
>  		sbi->s_jquota_fmt = m->mount_opt;
>  #endif
> -#ifndef CONFIG_FS_DAX
>  	} else if (token == Opt_dax) {
> +#ifdef CONFIG_FS_DAX
> +		ext4_msg(sb, KERN_WARNING,
> +		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
> +			sbi->s_mount_opt |= m->mount_opt;
> +#else
>  		ext4_msg(sb, KERN_INFO, "dax option not supported");
>  		return -1;
>  #endif
> 
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
