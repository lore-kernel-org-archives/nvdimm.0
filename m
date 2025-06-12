Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0C217AE1D
	for <nvdimm@lists.linux.dev>; Thu, 12 Jun 2025 16:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749747467; cv=none; b=n4lIjHFY8DgRHqg4d4ePY+h7Q1jZ8ZVAr08vowbvriou2iRTo7mGXySC4pRRsS934OP4TJGkFkuhzD+YSUKp4OTbxp56M+BbDvB6F9J5jdstaJcxnBglh+tqZFS3QXvDn17t87uhOZ5qapp4ewS6tCV7fJVLRDqGFsNaRiJWZ0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749747467; c=relaxed/simple;
	bh=QSG7D5Ee+lqB7uIngTksC2+r3e40S16X7xs0+Vyolpw=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=EVlpZE+rHgAL+jNfSjkicUo1hzJgQK6jeRiLvU+ZvBZXyNx4A+Rn473cqXSaXRSEMy2085QwM0rhxF3Ycrho47O5tIQfV9dTiKCpt89o2Q/pnxw4M8JxmjkdD1HbO94AnbijkbMpzhxm/o0MKJPo11f37McoX5wCJ2M0+LZv0Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a5NHpwFB; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a5NHpwFB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749747463;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=O8RJTG+npCgJlg7Z/HdtOQxD67RTMJOSk9i98l6Xl/c=;
	b=a5NHpwFB8iZ/0nhnqvWHX+LNVZf2bD0eGNqMoKH9XwWLquYdcbH4WopAgBK0YbDMb8R7eT
	XI7gbf7U3D2mAHRQhvIqp9YszLZyOFvdBc8+9ETItTS15Ti009TDRQjlrC+N/5jbMCMIp2
	4CrvOqgHvY3n3icZ7jmr785wj6rLjD0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-670-OAXpt8UsPryVjKMYBUTIOA-1; Thu,
 12 Jun 2025 12:57:40 -0400
X-MC-Unique: OAXpt8UsPryVjKMYBUTIOA-1
X-Mimecast-MFC-AGG-ID: OAXpt8UsPryVjKMYBUTIOA_1749747458
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 528EF19560B3;
	Thu, 12 Jun 2025 16:57:37 +0000 (UTC)
Received: from [10.22.80.249] (unknown [10.22.80.249])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2875E180045C;
	Thu, 12 Jun 2025 16:57:31 +0000 (UTC)
Date: Thu, 12 Jun 2025 18:57:26 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Dongsheng Yang <dongsheng.yang@linux.dev>
cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de, 
    dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com, 
    linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
    linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
    dm-devel@lists.linux.dev
Subject: =?UTF-8?Q?Re=3A_=5BRFC_v2_00=2F11=5D_dm-pcache_=E2=80=93_pers?=
 =?UTF-8?Q?istent-memory_cache_for_block_devices?=
In-Reply-To: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
Message-ID: <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com>
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Hi


On Thu, 5 Jun 2025, Dongsheng Yang wrote:

> Hi Mikulas and all,
> 
> This is *RFC v2* of the *pcache* series, a persistent-memory backed cache.
> Compared with *RFC v1* 
> <https://lore.kernel.org/lkml/20250414014505.20477-1-dongsheng.yang@linux.dev/>  
> the most important change is that the whole cache has been *ported to
> the Device-Mapper framework* and is now exposed as a regular DM target.
> 
> Code:
>     https://github.com/DataTravelGuide/linux/tree/dm-pcache
> 
> Full RFC v2 test results:
>     https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/results.html
> 
>     All 962 xfstests cases passed successfully under four different
> pcache configurations.
> 
>     One of the detailed xfstests run:
>         https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/test-results/02-._pcache.py_PcacheTest.test_run-crc-enable-gc-gc0-test_script-xfstests-a515/debug.log
> 
> Below is a quick tour through the three layers of the implementation,
> followed by an example invocation.
> 
> ----------------------------------------------------------------------
> 1. pmem access layer
> ----------------------------------------------------------------------
> 
> * All reads use *copy_mc_to_kernel()* so that uncorrectable media
>   errors are detected and reported.
> * All writes go through *memcpy_flushcache()* to guarantee durability
>   on real persistent memory.

You could also try to use normal write and clflushopt for big writes - I 
found out that for larger regions it is better - see the function 
memcpy_flushcache_optimized in dm-writecache. Test, which way is better.

> ----------------------------------------------------------------------
> 2. cache-logic layer (segments / keys / workers)
> ----------------------------------------------------------------------
> 
> Main features
>   - 16 MiB pmem segments, log-structured allocation.
>   - Multi-subtree RB-tree index for high parallelism.
>   - Optional per-entry *CRC32* on cached data.

Would it be better to use crc32c because it has hardware support in the 
SSE4.2 instruction set?

>   - Background *write-back* worker and watermark-driven *GC*.
>   - Crash-safe replay: key-sets are scanned from *key_tail* on start-up.
> 
> Current limitations
>   - Only *write-back* mode implemented.
>   - Only FIFO cache invalidate; other (LRU, ARC...) planned.
> 
> ----------------------------------------------------------------------
> 3. dm-pcache target integration
> ----------------------------------------------------------------------
> 
> * Table line  
>     `pcache <pmem_dev> <origin_dev> writeback <true|false>`
> * Features advertised to DM:
>   - `ti->flush_supported = true`, so *PREFLUSH* and *FUA* are honoured
>     (they force all open key-sets to close and data to be durable).
> * Not yet supported:
>   - Discard / TRIM.
>   - dynamic `dmsetup reload`.

If you don't support it, you should at least try to detect that the user 
did reload and return error - so that there won't be data corruption in 
this case.

But it would be better to support table reload. You can support it by a 
similar mechanism to "__handover_exceptions" in the dm-snap.c driver.

> Runtime controls
>   - `dmsetup message <dev> 0 gc_percent <0-90>` adjusts the GC trigger.
> 
> Status line reports super-block flags, segment counts, GC threshold and
> the three tail/head pointers (see the RST document for details).

Perhaps these are not real bugs (I didn't analyze it thoroughly), but 
there are some GFP_NOWAIT and GFP_KERNEL allocations.

GFP_NOWAIT can fail anytime (for example, if the machine receives too many 
network packets), so you must handle the error gracefully.

GFP_KERNEL allocation may recurse back into the I/O path through swapping 
or file writeback, thus they may cause deadlocks. You should use 
GFP_KERNEL in the target constructor or destructor because there is no I/O 
to be processed in this time, but they shouldn't be used in the I/O 
processing path.

I see that when you get ENOMEM, you retry the request in 100ms - putting 
arbitrary waits in the code is generally bad practice - this won't work if 
the user is swapping to the dm-pcache device. It may be possible that 
there is no memory free, thus retrying won't help and it will deadlock.

I suggest to use mempools to guarantee forward progress in out-of-memory 
situation. A mempool_alloc(GFP_IO) will never return NULL, it will just 
wait until some other process frees some entry into the mempool.

Generally, a convention among device mapper targets is that the have a few 
fixed parameters first, then there is a number of optional parameters and 
then there are optional parameters (either in "parameter:123" or 
"parameter 123" format). You should follow this convention, so that it can 
be easily extended with new parameters later.

The __packed attribute causes performance degradation on risc machines 
without hardware support for unaligned accesses - the compiled will 
generate byte-by-byte accesses - I suggest to not use it and instead make 
sure that the members in the structures are naturally aligned (and 
inserting explicit padding if needed).

The function "memcpy_flushcache" in arch/x86/include/asm/string_64.h is 
optimized for 4, 8 and 16-byte accesess (because that's what dm-writecache 
uses) - I suggest to add more optimizations to it for constant sizes that 
fit the usage pattern of dm-pcache,

I see that you are using "queue_delayed_work(cache_get_wq(cache), 
&cache->writeback_work, 0);" and "queue_delayed_work(cache_get_wq(cache), 
&cache->writeback_work, delay);" - the problem here is that if the entry 
is already queued with a delay and you attempt to queue it again with zero 
again, this new queue attempt will be ignored - I'm not sure if this is 
intended behavior or not.

req_complete_fn: this will never run with interrupts disabled, so you can 
replace spin_lock_irqsave/spin_unlock_irqrestore with 
spin_lock_irq/spin_unlock_irq.

backing_dev_bio_end: there's a bug in this function - it may be called 
both with interrupts disabled and interrupts enabled, so you should not 
use spin_lock/spin_unlock. You should be called 
spin_lock_irqsave/spin_unlock_irqrestore.

queue_work(BACKING_DEV_TO_PCACHE - i would move it inside the spinlock - 
see the commit 829451beaed6165eb11d7a9fb4e28eb17f489980 for a similar 
problem.

bio_map - bio vectors can hold arbitrarily long entries - if the "base" 
variable is not from vmalloc, you can just add it one bvec entry.
"backing_req->kmem.bvecs = kcalloc" - you can use kmalloc_array instead of 
kcalloc, there's no need to zero the value.

> +                if (++wait_count >= PCACHE_WAIT_NEW_CACHE_COUNT)
> +                        return NULL;
> +
> +                udelay(PCACHE_WAIT_NEW_CACHE_INTERVAL);
> +                goto again;

This is not good practice to insert arbitrary waits (here, the wait is 
burning CPU power, which makes it even worse). You should add the process 
to a wait queue and wake up the queue.

See the functions writecache_wait_on_freelist and writecache_free_entry 
for an example, how to wait correctly.

> +static int dm_pcache_map_bio(struct dm_target *ti, struct bio *bio)
> +{
> +     struct pcache_request *pcache_req = dm_per_bio_data(bio, sizeof(struct pcache_request));
> +     struct dm_pcache *pcache = ti->private;
> +     int ret;
> +
> +     pcache_req->pcache = pcache;
> +     kref_init(&pcache_req->ref);
> +     pcache_req->ret = 0;
> +     pcache_req->bio = bio;
> +     pcache_req->off = (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
> +     pcache_req->data_len = bio->bi_iter.bi_size;
> +     INIT_LIST_HEAD(&pcache_req->list_node);
> +     bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);

This looks suspicious because you store the original bi_sector to
pcache_req->off and then subtract the target offset from it. Shouldn't
"bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);"
be before "pcache_req->off = (u64)bio->bi_iter.bi_sector << 
SECTOR_SHIFT;"?

Generally, the code doesn't seem bad. After reworking the out-of-memory 
handling and replacing arbitrary waits with wait queues, I can merge it.

Mikulas

