Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151102042958.6610.65193.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20151102042941.6610.27784.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20151102042958.6610.65193.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Mon, 18 Jan 2016 11:42:43 +0100
Message-ID: <CAMuHMdVTXDJ_KF95u+uNCJcs6pT2eJmVSg6at_vfAfp2ovctnQ@mail.gmail.com>
Subject: Re: [PATCH v3 03/15] block, dax: fix lifetime of in-kernel dax
 mappings with dax_map_atomic()
From: Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jens Axboe <axboe@fb.com>, Jens Axboe <axboe@kernel.dk>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Jan Kara <jack@suse.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

On Mon, Nov 2, 2015 at 5:29 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> The DAX implementation needs to protect new calls to ->direct_access()
> and usage of its return value against unbind of the underlying block
> device.  Use blk_queue_enter()/blk_queue_exit() to either prevent
> blk_cleanup_queue() from proceeding, or fail the dax_map_atomic() if the
> request_queue is being torn down.

> index f8e543839e5c..a480729c00ec 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c

>  static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>                       loff_t start, loff_t end, get_block_t get_block,
>                       struct buffer_head *bh)
>  {
> -       ssize_t retval = 0;
> -       loff_t pos = start;
> -       loff_t max = start;
> -       loff_t bh_max = start;
> -       void __pmem *addr;
> +       loff_t pos = start, max = start, bh_max = start;
> +       struct block_device *bdev = NULL;
> +       int rw = iov_iter_rw(iter), rc;

fs/dax.c:138: warning: ‘rc’ may be used uninitialized in this function

rc will be uninitialized if start == end, and the while loop below is never
executed. I don't know whether it's 100% guaranteed this isn't the case.

Note that the old retval was preinitialized to 0.

> +       long map_len = 0;
> +       unsigned long pfn;
> +       void __pmem *addr = NULL;
> +       void __pmem *kmap = (void __pmem *) ERR_PTR(-EIO);
>         bool hole = false;
>         bool need_wmb = false;
>
> -       if (iov_iter_rw(iter) != WRITE)
> +       if (rw == READ)
>                 end = min(end, i_size_read(inode));
>
>         while (pos < end) {

> @@ -175,8 +219,9 @@ static ssize_t dax_io(struct inode *inode, struct iov_iter *iter,
>
>         if (need_wmb)
>                 wmb_pmem();
> +       dax_unmap_atomic(bdev, kmap);
>
> -       return (pos == start) ? retval : pos - start;
> +       return (pos == start) ? rc : pos - start;
>  }


Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
