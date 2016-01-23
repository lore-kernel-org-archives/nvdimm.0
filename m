Return-Path: <linux-ext4-owner@vger.kernel.org>
Date: Fri, 22 Jan 2016 21:01:02 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [RFC PATCH] dax, ext2, ext4, XFS: fix data corruption race
Message-ID: <20160123020102.GG2948@linux.intel.com>
References: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1453503971-5319-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: linux-ext4-owner@vger.kernel.org
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Jan Kara <jack@suse.com>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nvdimm@lists.01.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jan 22, 2016 at 04:06:11PM -0700, Ross Zwisler wrote:
> +++ b/fs/block_dev.c
> @@ -1733,13 +1733,28 @@ static const struct address_space_operations def_blk_aops = {
>   */
>  static int blkdev_dax_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
>  {
> -	return __dax_fault(vma, vmf, blkdev_get_block, NULL);
> +	int ret;
> +
> +	ret = __dax_fault(vma, vmf, blkdev_get_block, NULL, false);
> +
> +	if (WARN_ON_ONCE(ret == -EAGAIN))
> +		ret = VM_FAULT_SIGBUS;
> +
> +	return ret;
>  }

Let's not mix up -E returns and VM_FAULT returns.  We already have a
perfectly good VM_FAULT return value -- VM_FAULT_RETRY.
