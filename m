From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/3] iopmem : Add a block device driver for PCIe attached
 IO memory.
Date: Thu, 27 Oct 2016 23:45:56 -0700
Message-ID: <20161028064556.GA3231@infradead.org>
References: <1476826937-20665-1-git-send-email-sbates@raithlin.com>
 <1476826937-20665-3-git-send-email-sbates@raithlin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1476826937-20665-3-git-send-email-sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stephen Bates <stephen.bates-dzo6w/eZyo2tG0bUXCXiUA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ross.zwisler-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, willy-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, jim.macdonald-FgSLVYC75IpWk0Htik3J/w@public.gmane.org, sbates-Rgftl6RXld5BDgjK7y7TUQ@public.gmane.org, logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

> Signed-off-by: Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>

FYI, that address has bounced throught the whole thread for me,
replacing it with a known good one for now.


> + * This driver is heavily based on drivers/block/pmem.c.
> + * Copyright (c) 2014, Intel Corporation.
> + * Copyright (C) 2007 Nick Piggin
> + * Copyright (C) 2007 Novell Inc.

Is there anything left of it actually?  I didn't spot anything
obvious.  Nevermind that we don't have a file with that name anymore :)

> +  /*
> +   * We can only access the iopmem device with full 32-bit word
> +   * accesses which cannot be gaurantee'd by the regular memcpy
> +   */

Odd comment formatting. 

> +static void memcpy_from_iopmem(void *dst, const void *src, size_t sz)
> +{
> +	u64 *wdst = dst;
> +	const u64 *wsrc = src;
> +	u64 tmp;
> +
> +	while (sz >= sizeof(*wdst)) {
> +		*wdst++ = *wsrc++;
> +		sz -= sizeof(*wdst);
> +	}
> +
> +	if (!sz)
> +		return;
> +
> +	tmp = *wsrc;
> +	memcpy(wdst, &tmp, sz);
> +}

And then we dod a memcpy here anyway.  And no volatile whatsover, so
the compiler could do anything to it.  I defintively feel a bit uneasy
about having this in the driver as well.  Can we define the exact
semantics for this and define it by the system, possibly in an arch
specific way?

> +static void iopmem_do_bvec(struct iopmem_device *iopmem, struct page *page,
> +			   unsigned int len, unsigned int off, bool is_write,
> +			   sector_t sector)
> +{
> +	phys_addr_t iopmem_off = sector * 512;
> +	void *iopmem_addr = iopmem->virt_addr + iopmem_off;
> +
> +	if (!is_write) {
> +		read_iopmem(page, off, iopmem_addr, len);
> +		flush_dcache_page(page);
> +	} else {
> +		flush_dcache_page(page);
> +		write_iopmem(iopmem_addr, page, off, len);
> +	}

How about moving the  address and offset calculation as well as the
cache flushing into read_iopmem/write_iopmem and removing this function?

> +static blk_qc_t iopmem_make_request(struct request_queue *q, struct bio *bio)
> +{
> +	struct iopmem_device *iopmem = q->queuedata;
> +	struct bio_vec bvec;
> +	struct bvec_iter iter;
> +
> +	bio_for_each_segment(bvec, bio, iter) {
> +		iopmem_do_bvec(iopmem, bvec.bv_page, bvec.bv_len,
> +			    bvec.bv_offset, op_is_write(bio_op(bio)),
> +			    iter.bi_sector);

op_is_write just checks the data direction.  I'd feel much more
comfortable with a switch on the op, e.g.

	switch (bio_op(bio))) {
	case REQ_OP_READ:
		bio_for_each_segment(bvec, bio, iter)
			read_iopmem(iopmem, bvec, iter.bi_sector);
		break;
	case REQ_OP_READ:
		bio_for_each_segment(bvec, bio, iter)
			write_iopmem(iopmem, bvec, iter.bi_sector);
	defualt:
		WARN_ON_ONCE(1);
		bio->bi_error = -EIO;
		break;
	}
			

> +static long iopmem_direct_access(struct block_device *bdev, sector_t sector,
> +			       void **kaddr, pfn_t *pfn, long size)
> +{
> +	struct iopmem_device *iopmem = bdev->bd_queue->queuedata;
> +	resource_size_t offset = sector * 512;
> +
> +	if (!iopmem)
> +		return -ENODEV;

I don't think this can ever happen, can it?

> +static DEFINE_IDA(iopmem_instance_ida);
> +static DEFINE_SPINLOCK(ida_lock);
> +
> +static int iopmem_set_instance(struct iopmem_device *iopmem)
> +{
> +	int instance, error;
> +
> +	do {
> +		if (!ida_pre_get(&iopmem_instance_ida, GFP_KERNEL))
> +			return -ENODEV;
> +
> +		spin_lock(&ida_lock);
> +		error = ida_get_new(&iopmem_instance_ida, &instance);
> +		spin_unlock(&ida_lock);
> +
> +	} while (error == -EAGAIN);
> +
> +	if (error)
> +		return -ENODEV;
> +
> +	iopmem->instance = instance;
> +	return 0;
> +}
> +
> +static void iopmem_release_instance(struct iopmem_device *iopmem)
> +{
> +	spin_lock(&ida_lock);
> +	ida_remove(&iopmem_instance_ida, iopmem->instance);
> +	spin_unlock(&ida_lock);
> +}
> +

Just use ida_simple_get/ida_simple_remove instead to take care
of the locking and preloading, and get rid of these two functions.


> +static int iopmem_attach_disk(struct iopmem_device *iopmem)
> +{
> +	struct gendisk *disk;
> +	int nid = dev_to_node(iopmem->dev);
> +	struct request_queue *q = iopmem->queue;
> +
> +	blk_queue_write_cache(q, true, true);

You don't handle flush commands or the fua bit in make_request, so
this setting seems wrong.

> +	int err = 0;
> +	int nid = dev_to_node(&pdev->dev);
> +
> +	if (pci_enable_device_mem(pdev) < 0) {

propagate the actual error code, please.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
