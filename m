Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA5DC21123E30
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 09:23:59 -0700 (PDT)
Subject: Re: [PATCH v2 1/2] ext4: Close race between direct IO and
 ext4_break_layouts()
References: <153374910694.40645.17166196534680658204.stgit@djiang5-desk3.ch.intel.com>
From: Eric Sandeen <esandeen@redhat.com>
Message-ID: <e5232336-757e-2338-5b28-7dfadc8eb2c8@redhat.com>
Date: Mon, 10 Sep 2018 11:23:56 -0500
MIME-Version: 1.0
In-Reply-To: <153374910694.40645.17166196534680658204.stgit@djiang5-desk3.ch.intel.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: sandeen@redhat.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>, tytso@mit.edu, darrick.wong@oracle.com, jack@suse.cz, zwisler@kernel.org
Cc: linux-nvdimm@lists.01.org, david@fromorbit.com, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, lczerner@redhat.com, linux-ext4@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On 8/8/18 12:25 PM, Dave Jiang wrote:
> From: Ross Zwisler <zwisler@kernel.org>
> 
> If the refcount of a page is lowered between the time that it is returned
> by dax_busy_page() and when the refcount is again checked in
> ext4_break_layouts() => ___wait_var_event(), the waiting function
> ext4_wait_dax_page() will never be called.  This means that
> ext4_break_layouts() will still have 'retry' set to false, so we'll stop
> looping and never check the refcount of other pages in this inode.
> 
> Instead, always continue looping as long as dax_layout_busy_page() gives us
> a page which it found with an elevated refcount.
> 
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Reviewed-by: Jan Kara <jack@suse.cz>

Ted - wondering if this one is still on your radar?

Thanks,
-Eric

> ---
> 
> v2:
> - remove verbiage in comment header (Jan)
> 
>  fs/ext4/inode.c |    9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
> index 8f6ad7667974..d2663a1e3ec2 100644
> --- a/fs/ext4/inode.c
> +++ b/fs/ext4/inode.c
> @@ -4191,9 +4191,8 @@ int ext4_update_disksize_before_punch(struct inode *inode, loff_t offset,
>  	return 0;
>  }
>  
> -static void ext4_wait_dax_page(struct ext4_inode_info *ei, bool *did_unlock)
> +static void ext4_wait_dax_page(struct ext4_inode_info *ei)
>  {
> -	*did_unlock = true;
>  	up_write(&ei->i_mmap_sem);
>  	schedule();
>  	down_write(&ei->i_mmap_sem);
> @@ -4203,14 +4202,12 @@ int ext4_break_layouts(struct inode *inode)
>  {
>  	struct ext4_inode_info *ei = EXT4_I(inode);
>  	struct page *page;
> -	bool retry;
>  	int error;
>  
>  	if (WARN_ON_ONCE(!rwsem_is_locked(&ei->i_mmap_sem)))
>  		return -EINVAL;
>  
>  	do {
> -		retry = false;
>  		page = dax_layout_busy_page(inode->i_mapping);
>  		if (!page)
>  			return 0;
> @@ -4218,8 +4215,8 @@ int ext4_break_layouts(struct inode *inode)
>  		error = ___wait_var_event(&page->_refcount,
>  				atomic_read(&page->_refcount) == 1,
>  				TASK_INTERRUPTIBLE, 0, 0,
> -				ext4_wait_dax_page(ei, &retry));
> -	} while (error == 0 && retry);
> +				ext4_wait_dax_page(ei));
> +	} while (error == 0);
>  
>  	return error;
>  }
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
