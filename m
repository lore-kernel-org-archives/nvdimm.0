Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 75459210E2A43
 for <linux-nvdimm@lists.01.org>; Fri,  1 Jun 2018 14:55:15 -0700 (PDT)
Date: Fri, 1 Jun 2018 17:55:13 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2 4/7] dm: prevent DAX mounts if not supported
Message-ID: <20180601215513.GA18712@redhat.com>
References: <20180529195106.14268-1-ross.zwisler@linux.intel.com>
 <20180529195106.14268-5-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180529195106.14268-5-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, May 29 2018 at  3:51pm -0400,
Ross Zwisler <ross.zwisler@linux.intel.com> wrote:

> Currently the code in dm_dax_direct_access() only checks whether the target
> type has a direct_access() operation defined, not whether the underlying
> block devices all support DAX.  This latter property can be seen by looking
> at whether we set the QUEUE_FLAG_DAX request queue flag when creating the
> DM device.

Wait... I thought DAX support was all or nothing?

> This is problematic if we have, for example, a dm-linear device made up of
> a PMEM namespace in fsdax mode followed by a ramdisk from BRD.
> QUEUE_FLAG_DAX won't be set on the dm-linear device's request queue, but
> we have a working direct_access() entry point and the first member of the
> dm-linear set *does* support DAX.

If you don't have a uniformly capable device then it is very dangerous
to advertise that the entire device has a certain capability.  That
completely bit me in the past with discard (because for every IO I
wasn't then checking if the destination device supported discards).

It is all well and good that you're adding that check here.  But what I
don't like is how you're saying QUEUE_FLAG_DAX implies direct_access()
operation exists.. yet for raw PMEM namespaces we just discussed how
that is a lie.

SO this type of change showcases how the QUEUE_FLAG_DAX doesn't _really_
imply direct_access() exists.

> This allows the user to create a filesystem on the dm-linear device, and
> then mount it with DAX.  The filesystem's bdev_dax_supported() test will
> pass because it'll operate on the first member of the dm-linear device,
> which happens to be a fsdax PMEM namespace.
> 
> All DAX I/O will then fail to that dm-linear device because the lack of
> QUEUE_FLAG_DAX prevents fs_dax_get_by_bdev() from working.  This means that
> the struct dax_device isn't ever set in the filesystem, so
> dax_direct_access() will always return -EOPNOTSUPP.

Now you've lost me... these past 2 paragraphs.  Why can a user mount it
is DAX mode?  Because bdev_dax_supported() only accesses the first
portion (which happens to have DAX capabilities?)

Isn't this exactly why you should be checking for QUEUE_FLAG_DAX in the
caller (bdev_dax_supported)?  Why not use bdev_get_queue() and verify
QUEUE_FLAG_DAX is set in there?

> By failing out of dm_dax_direct_access() if QUEUE_FLAG_DAX isn't set we let
> the filesystem know we don't support DAX at mount time.  The filesystem
> will then silently fall back and remove the dax mount option, causing it to
> work properly.

This shouldn't be needed.  Again, QUEUE_FLAG_DAX wasn't set.. so don't
allow code to falsely try operations that should've been gated by the
fact it wasn't set.

SO Nack on this patch.. until/unless I'm corrected ;)

Thanks,
Mike


> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Fixes: commit 545ed20e6df6 ("dm: add infrastructure for DAX support")
> ---
>  drivers/md/dm.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/md/dm.c b/drivers/md/dm.c
> index 0a7b0107ca78..9728433362d1 100644
> --- a/drivers/md/dm.c
> +++ b/drivers/md/dm.c
> @@ -1050,14 +1050,13 @@ static long dm_dax_direct_access(struct dax_device *dax_dev, pgoff_t pgoff,
>  
>  	if (!ti)
>  		goto out;
> -	if (!ti->type->direct_access)
> +	if (!blk_queue_dax(md->queue))
>  		goto out;
>  	len = max_io_len(sector, ti) / PAGE_SECTORS;
>  	if (len < 1)
>  		goto out;
>  	nr_pages = min(len, nr_pages);
> -	if (ti->type->direct_access)
> -		ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
> +	ret = ti->type->direct_access(ti, pgoff, nr_pages, kaddr, pfn);
>  
>   out:
>  	dm_put_live_table(md, srcu_idx);
> -- 
> 2.14.3
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
