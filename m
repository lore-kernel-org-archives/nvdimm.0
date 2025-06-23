Received: from out-172.mta1.migadu.com (out-172.mta1.migadu.com [95.215.58.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020E11C2DB2
	for <nvdimm@lists.linux.dev>; Mon, 23 Jun 2025 03:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750648408; cv=none; b=lfUb1q9DoUSLeirByeeChspcsDmLHNVRSffall+olNVVqoS5/GH9LVS0FDNtm2cLFz6zKoSCbK3xdvaicmD3CgI3n8DzMN5yPddnu3CXTtg0rdlLrzPk7NLQJfZoWrirGvh7htntqnAmKORoEqavaEqJGZmjdZiSTwl5vxy5k8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750648408; c=relaxed/simple;
	bh=AoERW9q//7gZjLW4FikHdXW/WHcpKddLdd+/THRibm4=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=F6haAn6fu7zozyEg+rnBfTi2vfmn6PVrGSjcYo2G9yWaW9qTqjrr13NH2pKGWMW+Mtry1r8sFJ26X8HLZjfjbOyuvK0PhG0xVtOZDTCIOQ0PGCXVw9TEPVXWxxI+uat/DmqHF1OgBFqaxR1YB5qQNrh+TlvaSDzd98BLPYwN3wM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ej+zeCQv; arc=none smtp.client-ip=95.215.58.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ej+zeCQv"
Content-Type: multipart/mixed; boundary="------------f6yEcQN9bfuEx8vW3yg03FzF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1750648393;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=WNcVc/8gbZ3qjMYHP0ffM2LCTBOqe/mtoZBwQP+s1p0=;
	b=Ej+zeCQvi93Ez+qYt145koIzwhBtGLOrhJryKoty9Y/KSr2LOV6oPc+THkv/8K1UCWh1V5
	jOLIjLtuyNLYGnW16NsFzWgF+iVcJ8WaL0JQmZUQ4Pi6bS0DED2dQ6YHfIQ6m1vNya1+9Z
	ip1GAFKfSBJsu/WHa56t7Sloj/Cj+KQ=
Message-ID: <3c9f304a-b830-4242-8e01-04efab4e0eaa@linux.dev>
Date: Mon, 23 Jun 2025 11:13:04 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: =?UTF-8?Q?Re=3A_=5BRFC_v2_00/11=5D_dm-pcache_=E2=80=93_persistent-m?=
 =?UTF-8?Q?emory_cache_for_block_devices?=
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: agk@redhat.com, snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
 dan.j.williams@intel.com, Jonathan.Cameron@Huawei.com,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, dm-devel@lists.linux.dev
References: <20250605142306.1930831-1-dongsheng.yang@linux.dev>
 <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Dongsheng Yang <dongsheng.yang@linux.dev>
In-Reply-To: <dc019764-5128-526e-d8ea-effa78e37b39@redhat.com>
X-Migadu-Flow: FLOW_OUT

This is a multi-part message in MIME format.
--------------f6yEcQN9bfuEx8vW3yg03FzF
Content-Type: multipart/alternative;
 boundary="------------vr3vSDl9nGurANl7EDaKM3T0"

--------------vr3vSDl9nGurANl7EDaKM3T0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Mikulas:

      I will send dm-pcache V1 soon, below is my response to your comments.

在 6/13/2025 12:57 AM, Mikulas Patocka 写道:
> Hi
>
>
> On Thu, 5 Jun 2025, Dongsheng Yang wrote:
>
>> Hi Mikulas and all,
>>
>> This is *RFC v2* of the *pcache* series, a persistent-memory backed cache.
>> Compared with *RFC v1*
>> <https://lore.kernel.org/lkml/20250414014505.20477-1-dongsheng.yang@linux.dev/>  
>> the most important change is that the whole cache has been *ported to
>> the Device-Mapper framework* and is now exposed as a regular DM target.
>>
>> Code:
>>      https://github.com/DataTravelGuide/linux/tree/dm-pcache
>>
>> Full RFC v2 test results:
>>      https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/results.html
>>
>>      All 962 xfstests cases passed successfully under four different
>> pcache configurations.
>>
>>      One of the detailed xfstests run:
>>          https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/test-results/02-._pcache.py_PcacheTest.test_run-crc-enable-gc-gc0-test_script-xfstests-a515/debug.log
>>
>> Below is a quick tour through the three layers of the implementation,
>> followed by an example invocation.
>>
>> ----------------------------------------------------------------------
>> 1. pmem access layer
>> ----------------------------------------------------------------------
>>
>> * All reads use *copy_mc_to_kernel()* so that uncorrectable media
>>    errors are detected and reported.
>> * All writes go through *memcpy_flushcache()* to guarantee durability
>>    on real persistent memory.
> You could also try to use normal write and clflushopt for big writes - I
> found out that for larger regions it is better - see the function
> memcpy_flushcache_optimized in dm-writecache. Test, which way is better.

I did a test with fio on /dev/pmem0, with an attached patch on nd_pmem.ko:

when I use memmap pmem device, I got a similar result with the comment 
in memcpy_flushcache_optimized():

Test (memmap pmem) clflushopt flushcache 
------------------------------------------------- test_randwrite_512 200 
MiB/s 228 MiB/s test_randwrite_1024 378 MiB/s 431 MiB/s 
test_randwrite_2K 773 MiB/s 769 MiB/s test_randwrite_4K 1364 MiB/s 1272 
MiB/s test_randwrite_8K 2078 MiB/s 1817 MiB/s test_randwrite_16K 2745 
MiB/s 2098 MiB/s test_randwrite_32K 3232 MiB/s 2231 MiB/s 
test_randwrite_64K 3660 MiB/s 2411 MiB/s test_randwrite_128K 3922 MiB/s 
2513 MiB/s test_randwrite_1M 3824 MiB/s 2537 MiB/s test_write_512 228 
MiB/s 228 MiB/s test_write_1024 439 MiB/s 423 MiB/s test_write_2K 841 
MiB/s 800 MiB/s test_write_4K 1364 MiB/s 1308 MiB/s test_write_8K 2107 
MiB/s 1838 MiB/s test_write_16K 2752 MiB/s 2166 MiB/s test_write_32K 
3213 MiB/s 2247 MiB/s test_write_64K 3661 MiB/s 2415 MiB/s 
test_write_128K 3902 MiB/s 2514 MiB/s test_write_1M 3808 MiB/s 2529 MiB/s

But I got a different result when I use Optane pmem100:

Test (Optane pmem100) clflushopt flushcache 
------------------------------------------------- test_randwrite_512 167 
MiB/s 226 MiB/s test_randwrite_1024 301 MiB/s 420 MiB/s 
test_randwrite_2K 615 MiB/s 639 MiB/s test_randwrite_4K 967 MiB/s 1024 
MiB/s test_randwrite_8K 1047 MiB/s 1314 MiB/s test_randwrite_16K 1096 
MiB/s 1377 MiB/s test_randwrite_32K 1155 MiB/s 1382 MiB/s 
test_randwrite_64K 1184 MiB/s 1452 MiB/s test_randwrite_128K 1199 MiB/s 
1488 MiB/s test_randwrite_1M 1178 MiB/s 1499 MiB/s test_write_512 233 
MiB/s 233 MiB/s test_write_1024 424 MiB/s 391 MiB/s test_write_2K 706 
MiB/s 760 MiB/s test_write_4K 978 MiB/s 1076 MiB/s test_write_8K 1059 
MiB/s 1296 MiB/s test_write_16K 1119 MiB/s 1380 MiB/s test_write_32K 
1158 MiB/s 1387 MiB/s test_write_64K 1184 MiB/s 1448 MiB/s 
test_write_128K 1198 MiB/s 1481 MiB/s test_write_1M 1178 MiB/s 1486 MiB/s


So for now I’d rather keep using flushcache in pcache. In future, once 
we’ve come up with a general-purpose optimization, we can switch to that.

>
>> ----------------------------------------------------------------------
>> 2. cache-logic layer (segments / keys / workers)
>> ----------------------------------------------------------------------
>>
>> Main features
>>    - 16 MiB pmem segments, log-structured allocation.
>>    - Multi-subtree RB-tree index for high parallelism.
>>    - Optional per-entry *CRC32* on cached data.
> Would it be better to use crc32c because it has hardware support in the
> SSE4.2 instruction set?

Good suggestion, thanx.

>
>>    - Background *write-back* worker and watermark-driven *GC*.
>>    - Crash-safe replay: key-sets are scanned from *key_tail* on start-up.
>>
>> Current limitations
>>    - Only *write-back* mode implemented.
>>    - Only FIFO cache invalidate; other (LRU, ARC...) planned.
>>
>> ----------------------------------------------------------------------
>> 3. dm-pcache target integration
>> ----------------------------------------------------------------------
>>
>> * Table line
>>      `pcache <pmem_dev> <origin_dev> writeback <true|false>`
>> * Features advertised to DM:
>>    - `ti->flush_supported = true`, so *PREFLUSH* and *FUA* are honoured
>>      (they force all open key-sets to close and data to be durable).
>> * Not yet supported:
>>    - Discard / TRIM.
>>    - dynamic `dmsetup reload`.
> If you don't support it, you should at least try to detect that the user
> did reload and return error - so that there won't be data corruption in
> this case.

Yes, actually It did return -EOPNOTSUPP。

static int dm_pcache_ctr(struct dm_target *ti, unsigned int argc, char 
**argv)
{
         struct mapped_device *md = ti->table->md;
         struct dm_pcache *pcache;
         int ret;

         if (md->map) {
                 ti->error = "Don't support table loading for live md";
                 return -EOPNOTSUPP;
         }

>
> But it would be better to support table reload. You can support it by a
> similar mechanism to "__handover_exceptions" in the dm-snap.c driver.


Of course, that's planned but we think that's not necessary in initial 
version of it.

>
>> Runtime controls
>>    - `dmsetup message <dev> 0 gc_percent <0-90>` adjusts the GC trigger.
>>
>> Status line reports super-block flags, segment counts, GC threshold and
>> the three tail/head pointers (see the RST document for details).
> Perhaps these are not real bugs (I didn't analyze it thoroughly), but
> there are some GFP_NOWAIT and GFP_KERNEL allocations.
>
> GFP_NOWAIT can fail anytime (for example, if the machine receives too many
> network packets), so you must handle the error gracefully.
>
> GFP_KERNEL allocation may recurse back into the I/O path through swapping
> or file writeback, thus they may cause deadlocks. You should use
> GFP_KERNEL in the target constructor or destructor because there is no I/O
> to be processed in this time, but they shouldn't be used in the I/O
> processing path.


**Yes**, I'm using the approach I described above.

- **GFP_KERNEL** is only used on the constructor path.
- **GFP_NOWAIT** is used in two cases: one for allocating `cache_key`, 
and another for allocating `backing_dev_req` on a cache miss.

Both of these NOWAIT allocations happen while traversing the 
`cache_subtree` under the `subtree_lock` spinlock—i.e., in contexts 
where scheduling isn't allowed. That’s why we use `GFP_NOWAIT`.


>
> I see that when you get ENOMEM, you retry the request in 100ms - putting
> arbitrary waits in the code is generally bad practice - this won't work if
> the user is swapping to the dm-pcache device. It may be possible that
> there is no memory free, thus retrying won't help and it will deadlock.


In **V1**, I removed the retry-on-ENOMEM mechanism to make pcache more 
coherent. Now it only retries when the cache is actually full.

- When the cache is full, the `pcache_req` is added to a `defer_list`.
- When cache invalidation occurs, we kick off all deferred requests to 
retry.

This eliminates arbitrary waits.

>
> I suggest to use mempools to guarantee forward progress in out-of-memory
> situation. A mempool_alloc(GFP_IO) will never return NULL, it will just
> wait until some other process frees some entry into the mempool.

Both `cache_key` and `backing_dev_req` now use **mempools**, but—as 
explained—they may still be allocated under a spinlock, so they use 
**GFP_NOWAIT**.

>
> Generally, a convention among device mapper targets is that the have a few
> fixed parameters first, then there is a number of optional parameters and
> then there are optional parameters (either in "parameter:123" or
> "parameter 123" format). You should follow this convention, so that it can
> be easily extended with new parameters later.
Thanks, that's a good suggestion.

In **V1**, we changed the parameter format to:

  pcache <cache_dev> <backing_dev> [<number_of_optional_arguments> 
<cache_mode writeback> <data_crc true|false>]

>
> The __packed attribute causes performance degradation on risc machines
> without hardware support for unaligned accesses - the compiled will
> generate byte-by-byte accesses - I suggest to not use it and instead make
> sure that the members in the structures are naturally aligned (and
> inserting explicit padding if needed).


Thanks — we removed `__packed` in V1.

>
> The function "memcpy_flushcache" in arch/x86/include/asm/string_64.h is
> optimized for 4, 8 and 16-byte accesess (because that's what dm-writecache
> uses) - I suggest to add more optimizations to it for constant sizes that
> fit the usage pattern of dm-pcache,

Thanks again — as mentioned above, we plan to optimize later, possibly 
with a more generic solution.

>
> I see that you are using "queue_delayed_work(cache_get_wq(cache),
> &cache->writeback_work, 0);" and "queue_delayed_work(cache_get_wq(cache),
> &cache->writeback_work, delay);" - the problem here is that if the entry
> is already queued with a delay and you attempt to queue it again with zero
> again, this new queue attempt will be ignored - I'm not sure if this is
> intended behavior or not.

Yes, in simple terms:
1. If after writeback completes the cache is clean, we should delay.
2. If it's not clean, set delay = 0 so the next writeback cycle can 
begin immediately.

In theory these are two separate branches, even if a zero delay might be 
ignored. Since writeback work isn't highly time-sensitive, I believe 
this is harmless.

>
> req_complete_fn: this will never run with interrupts disabled, so you can
> replace spin_lock_irqsave/spin_unlock_irqrestore with
> spin_lock_irq/spin_unlock_irq.

thanx  Fixed in V1

>
> backing_dev_bio_end: there's a bug in this function - it may be called
> both with interrupts disabled and interrupts enabled, so you should not
> use spin_lock/spin_unlock. You should be called
> spin_lock_irqsave/spin_unlock_irqrestore.

Good catch，it's fixed in V1

>
> queue_work(BACKING_DEV_TO_PCACHE - i would move it inside the spinlock -
> see the commit 829451beaed6165eb11d7a9fb4e28eb17f489980 for a similar
> problem.

Thanx, Fixed in V1

>
> bio_map - bio vectors can hold arbitrarily long entries - if the "base"
> variable is not from vmalloc, you can just add it one bvec entry.


Good idea — in V1 we introduced `inline_bvecs`, and when `base` isn’t 
vmalloc, we use a single bvec entry.

> "backing_req->kmem.bvecs = kcalloc" - you can use kmalloc_array instead of
> kcalloc, there's no need to zero the value.
Fixed in V1
>
>> +                if (++wait_count >= PCACHE_WAIT_NEW_CACHE_COUNT)
>> +                        return NULL;
>> +
>> +                udelay(PCACHE_WAIT_NEW_CACHE_INTERVAL);
>> +                goto again;
> This is not good practice to insert arbitrary waits (here, the wait is
> burning CPU power, which makes it even worse). You should add the process
> to a wait queue and wake up the queue.
>
> See the functions writecache_wait_on_freelist and writecache_free_entry
> for an example, how to wait correctly.


`get_cache_segment()` may be called under a spinlock, so I originally 
designed a “short-busy-wait” to wait for a free segment,

If wait_count >= PCACHE_WAIT_NEW_CACHE_COUNT, then return -EBUSY to let 
dm-pcache defer_list to retry.

However, I later discovered that when the cache is full, there's rarely 
enough time during that brief short-busy-wait to free a segment.

Therefore in V1 I removed it and instead return `-EBUSY`, allowing 
dm-pcache’s retry mechanism to wait for a cache invalidation before 
retrying.

>
>> +static int dm_pcache_map_bio(struct dm_target *ti, struct bio *bio)
>> +{
>> +     struct pcache_request *pcache_req = dm_per_bio_data(bio, sizeof(struct pcache_request));
>> +     struct dm_pcache *pcache = ti->private;
>> +     int ret;
>> +
>> +     pcache_req->pcache = pcache;
>> +     kref_init(&pcache_req->ref);
>> +     pcache_req->ret = 0;
>> +     pcache_req->bio = bio;
>> +     pcache_req->off = (u64)bio->bi_iter.bi_sector << SECTOR_SHIFT;
>> +     pcache_req->data_len = bio->bi_iter.bi_size;
>> +     INIT_LIST_HEAD(&pcache_req->list_node);
>> +     bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
> This looks suspicious because you store the original bi_sector to
> pcache_req->off and then subtract the target offset from it. Shouldn't
> "bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);"
> be before "pcache_req->off = (u64)bio->bi_iter.bi_sector <<
> SECTOR_SHIFT;"?


Yes, that logic is indeed questionable, but it works in testing.

Since we define dm-pcache as a **singleton**, both behaviors should 
effectively be equivalent, IIUC. Also, in V1 I moved the call to 
`dm_target_offset()` so it runs before setting up `pcache_req->off`, 
making the code logic correct.

Thanx

Dongsheng

>
> Generally, the code doesn't seem bad. After reworking the out-of-memory
> handling and replacing arbitrary waits with wait queues, I can merge it.
>
> Mikulas
>
--------------vr3vSDl9nGurANl7EDaKM3T0
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p>Hi Mikulas:</p>
    <p>     I will send dm-pcache V1 soon, below is my response to your
      comments.</p>
    <div class="moz-cite-prefix">在 6/13/2025 12:57 AM, Mikulas Patocka
      写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">Hi


On Thu, 5 Jun 2025, Dongsheng Yang wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Hi Mikulas and all,

This is *RFC v2* of the *pcache* series, a persistent-memory backed cache.
Compared with *RFC v1* 
<a class="moz-txt-link-rfc2396E" href="https://lore.kernel.org/lkml/20250414014505.20477-1-dongsheng.yang@linux.dev/">&lt;https://lore.kernel.org/lkml/20250414014505.20477-1-dongsheng.yang@linux.dev/&gt;</a>  
the most important change is that the whole cache has been *ported to
the Device-Mapper framework* and is now exposed as a regular DM target.

Code:
    <a class="moz-txt-link-freetext" href="https://github.com/DataTravelGuide/linux/tree/dm-pcache">https://github.com/DataTravelGuide/linux/tree/dm-pcache</a>

Full RFC v2 test results:
    <a class="moz-txt-link-freetext" href="https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/results.html">https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/results.html</a>

    All 962 xfstests cases passed successfully under four different
pcache configurations.

    One of the detailed xfstests run:
        <a class="moz-txt-link-freetext" href="https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/test-results/02-._pcache.py_PcacheTest.test_run-crc-enable-gc-gc0-test_script-xfstests-a515/debug.log">https://datatravelguide.github.io/dtg-blog/pcache/pcache_rfc_v2_result/test-results/02-._pcache.py_PcacheTest.test_run-crc-enable-gc-gc0-test_script-xfstests-a515/debug.log</a>

Below is a quick tour through the three layers of the implementation,
followed by an example invocation.

----------------------------------------------------------------------
1. pmem access layer
----------------------------------------------------------------------

* All reads use *copy_mc_to_kernel()* so that uncorrectable media
  errors are detected and reported.
* All writes go through *memcpy_flushcache()* to guarantee durability
  on real persistent memory.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
You could also try to use normal write and clflushopt for big writes - I 
found out that for larger regions it is better - see the function 
memcpy_flushcache_optimized in dm-writecache. Test, which way is better.</pre>
    </blockquote>
    <p>I did a test with fio on /dev/pmem0, with an attached patch on
      nd_pmem.ko:</p>
    <p>when I use memmap pmem device, I got a similar result with the
      comment in <span style="white-space: pre-wrap">memcpy_flushcache_optimized():</span></p>
    <p><span style="white-space: pre-wrap">Test (memmap pmem)                      clflushopt   flushcache
-------------------------------------------------
test_randwrite_512             200 MiB/s      228 MiB/s
test_randwrite_1024            378 MiB/s      431 MiB/s
test_randwrite_2K              773 MiB/s      769 MiB/s
test_randwrite_4K             1364 MiB/s     1272 MiB/s
test_randwrite_8K             2078 MiB/s     1817 MiB/s
test_randwrite_16K            2745 MiB/s     2098 MiB/s
test_randwrite_32K            3232 MiB/s     2231 MiB/s
test_randwrite_64K            3660 MiB/s     2411 MiB/s
test_randwrite_128K           3922 MiB/s     2513 MiB/s
test_randwrite_1M             3824 MiB/s     2537 MiB/s
test_write_512                 228 MiB/s      228 MiB/s
test_write_1024                439 MiB/s      423 MiB/s
test_write_2K                  841 MiB/s      800 MiB/s
test_write_4K                 1364 MiB/s     1308 MiB/s
test_write_8K                 2107 MiB/s     1838 MiB/s
test_write_16K                2752 MiB/s     2166 MiB/s
test_write_32K                3213 MiB/s     2247 MiB/s
test_write_64K                3661 MiB/s     2415 MiB/s
test_write_128K               3902 MiB/s     2514 MiB/s
test_write_1M                 3808 MiB/s     2529 MiB/s</span></p>
    <p><span style="white-space: pre-wrap">But I got a different result when I use Optane pmem100:</span></p>
    <p><span style="white-space: pre-wrap">Test (Optane pmem100)                     clflushopt   flushcache
-------------------------------------------------
test_randwrite_512             167 MiB/s      226 MiB/s
test_randwrite_1024            301 MiB/s      420 MiB/s
test_randwrite_2K              615 MiB/s      639 MiB/s
test_randwrite_4K              967 MiB/s     1024 MiB/s
test_randwrite_8K             1047 MiB/s     1314 MiB/s
test_randwrite_16K            1096 MiB/s     1377 MiB/s
test_randwrite_32K            1155 MiB/s     1382 MiB/s
test_randwrite_64K            1184 MiB/s     1452 MiB/s
test_randwrite_128K           1199 MiB/s     1488 MiB/s
test_randwrite_1M             1178 MiB/s     1499 MiB/s
test_write_512                 233 MiB/s      233 MiB/s
test_write_1024                424 MiB/s      391 MiB/s
test_write_2K                  706 MiB/s      760 MiB/s
test_write_4K                  978 MiB/s     1076 MiB/s
test_write_8K                 1059 MiB/s     1296 MiB/s
test_write_16K                1119 MiB/s     1380 MiB/s
test_write_32K                1158 MiB/s     1387 MiB/s
test_write_64K                1184 MiB/s     1448 MiB/s
test_write_128K               1198 MiB/s     1481 MiB/s
test_write_1M                 1178 MiB/s     1486 MiB/s</span></p>
    <p><br>
    </p>
    <p>So for now I’d rather keep using flushcache in pcache. In future,
      once we’ve come up with a general-purpose optimization, we can
      switch to that.</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">----------------------------------------------------------------------
2. cache-logic layer (segments / keys / workers)
----------------------------------------------------------------------

Main features
  - 16 MiB pmem segments, log-structured allocation.
  - Multi-subtree RB-tree index for high parallelism.
  - Optional per-entry *CRC32* on cached data.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Would it be better to use crc32c because it has hardware support in the 
SSE4.2 instruction set?</pre>
    </blockquote>
    <p>Good suggestion, thanx.</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">  - Background *write-back* worker and watermark-driven *GC*.
  - Crash-safe replay: key-sets are scanned from *key_tail* on start-up.

Current limitations
  - Only *write-back* mode implemented.
  - Only FIFO cache invalidate; other (LRU, ARC...) planned.

----------------------------------------------------------------------
3. dm-pcache target integration
----------------------------------------------------------------------

* Table line  
    `pcache &lt;pmem_dev&gt; &lt;origin_dev&gt; writeback &lt;true|false&gt;`
* Features advertised to DM:
  - `ti-&gt;flush_supported = true`, so *PREFLUSH* and *FUA* are honoured
    (they force all open key-sets to close and data to be durable).
* Not yet supported:
  - Discard / TRIM.
  - dynamic `dmsetup reload`.
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
If you don't support it, you should at least try to detect that the user 
did reload and return error - so that there won't be data corruption in 
this case.</pre>
    </blockquote>
    <p>Yes, actually It did return -EOPNOTSUPP。</p>
    <p>static int dm_pcache_ctr(struct dm_target *ti, unsigned int argc,
      char **argv)<br>
      {<br>
              struct mapped_device *md = ti-&gt;table-&gt;md;<br>
              struct dm_pcache *pcache;<br>
              int ret;<br>
      <br>
              if (md-&gt;map) {<br>
                      ti-&gt;error = "Don't support table loading for
      live md";<br>
                      return -EOPNOTSUPP;<br>
              }</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

But it would be better to support table reload. You can support it by a 
similar mechanism to "__handover_exceptions" in the dm-snap.c driver.</pre>
    </blockquote>
    <p><br>
    </p>
    <p>Of course, that's planned but we think that's not necessary in
      initial version of it.</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">Runtime controls
  - `dmsetup message &lt;dev&gt; 0 gc_percent &lt;0-90&gt;` adjusts the GC trigger.

Status line reports super-block flags, segment counts, GC threshold and
the three tail/head pointers (see the RST document for details).
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
Perhaps these are not real bugs (I didn't analyze it thoroughly), but 
there are some GFP_NOWAIT and GFP_KERNEL allocations.

GFP_NOWAIT can fail anytime (for example, if the machine receives too many 
network packets), so you must handle the error gracefully.

GFP_KERNEL allocation may recurse back into the I/O path through swapping 
or file writeback, thus they may cause deadlocks. You should use 
GFP_KERNEL in the target constructor or destructor because there is no I/O 
to be processed in this time, but they shouldn't be used in the I/O 
processing path.</pre>
    </blockquote>
    <p><br>
    </p>
    <p>**Yes**, I'm using the approach I described above.<br>
      <br>
      - **GFP_KERNEL** is only used on the constructor path.  <br>
      - **GFP_NOWAIT** is used in two cases: one for allocating
      `cache_key`, and another for allocating `backing_dev_req` on a
      cache miss.<br>
      <br>
      Both of these NOWAIT allocations happen while traversing the
      `cache_subtree` under the `subtree_lock` spinlock—i.e., in
      contexts where scheduling isn't allowed. That’s why we use
      `GFP_NOWAIT`.<br>
      <br>
      <br>
    </p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

I see that when you get ENOMEM, you retry the request in 100ms - putting 
arbitrary waits in the code is generally bad practice - this won't work if 
the user is swapping to the dm-pcache device. It may be possible that 
there is no memory free, thus retrying won't help and it will deadlock.</pre>
    </blockquote>
    <p><br>
    </p>
    <p>In **V1**, I removed the retry-on-ENOMEM mechanism to make pcache
      more coherent. Now it only retries when the cache is actually
      full.<br>
      <br>
      - When the cache is full, the `pcache_req` is added to a
      `defer_list`.  <br>
      - When cache invalidation occurs, we kick off all deferred
      requests to retry.<br>
      <br>
      This eliminates arbitrary waits.</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

I suggest to use mempools to guarantee forward progress in out-of-memory 
situation. A mempool_alloc(GFP_IO) will never return NULL, it will just 
wait until some other process frees some entry into the mempool.</pre>
    </blockquote>
    <br>
    <p>Both `cache_key` and `backing_dev_req` now use **mempools**,
      but—as explained—they may still be allocated under a spinlock, so
      they use **GFP_NOWAIT**.</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

Generally, a convention among device mapper targets is that the have a few 
fixed parameters first, then there is a number of optional parameters and 
then there are optional parameters (either in "parameter:123" or 
"parameter 123" format). You should follow this convention, so that it can 
be easily extended with new parameters later.</pre>
    </blockquote>
    Thanks, that's a good suggestion.<br>
    <br>
    In **V1**, we changed the parameter format to:
    <p> pcache &lt;cache_dev&gt; &lt;backing_dev&gt;
      [&lt;number_of_optional_arguments&gt; &lt;cache_mode writeback&gt;
      &lt;data_crc true|false&gt;]</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

The __packed attribute causes performance degradation on risc machines 
without hardware support for unaligned accesses - the compiled will 
generate byte-by-byte accesses - I suggest to not use it and instead make 
sure that the members in the structures are naturally aligned (and 
inserting explicit padding if needed).</pre>
    </blockquote>
    <p><br>
    </p>
    <p>Thanks — we removed `__packed` in V1.<br>
      <br>
    </p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

The function "memcpy_flushcache" in arch/x86/include/asm/string_64.h is 
optimized for 4, 8 and 16-byte accesess (because that's what dm-writecache 
uses) - I suggest to add more optimizations to it for constant sizes that 
fit the usage pattern of dm-pcache,</pre>
    </blockquote>
    <br>
    Thanks again — as mentioned above, we plan to optimize later,
    possibly with a more generic solution.<br>
    <br>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

I see that you are using "queue_delayed_work(cache_get_wq(cache), 
&amp;cache-&gt;writeback_work, 0);" and "queue_delayed_work(cache_get_wq(cache), 
&amp;cache-&gt;writeback_work, delay);" - the problem here is that if the entry 
is already queued with a delay and you attempt to queue it again with zero 
again, this new queue attempt will be ignored - I'm not sure if this is 
intended behavior or not.</pre>
    </blockquote>
    <br>
    <p>Yes, in simple terms:<br>
      1. If after writeback completes the cache is clean, we should
      delay.<br>
      2. If it's not clean, set delay = 0 so the next writeback cycle
      can begin immediately.<br>
      <br>
      In theory these are two separate branches, even if a zero delay
      might be ignored. Since writeback work isn't highly
      time-sensitive, I believe this is harmless.<br>
      <br>
    </p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

req_complete_fn: this will never run with interrupts disabled, so you can 
replace spin_lock_irqsave/spin_unlock_irqrestore with 
spin_lock_irq/spin_unlock_irq.</pre>
    </blockquote>
    <p>thanx  Fixed in V1</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

backing_dev_bio_end: there's a bug in this function - it may be called 
both with interrupts disabled and interrupts enabled, so you should not 
use spin_lock/spin_unlock. You should be called 
spin_lock_irqsave/spin_unlock_irqrestore.</pre>
    </blockquote>
    <p>Good catch，it's fixed in V1</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

queue_work(BACKING_DEV_TO_PCACHE - i would move it inside the spinlock - 
see the commit 829451beaed6165eb11d7a9fb4e28eb17f489980 for a similar 
problem.</pre>
    </blockquote>
    <p>Thanx, Fixed in V1</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

bio_map - bio vectors can hold arbitrarily long entries - if the "base" 
variable is not from vmalloc, you can just add it one bvec entry.</pre>
    </blockquote>
    <p><br>
    </p>
    <p>Good idea — in V1 we introduced `inline_bvecs`, and when `base`
      isn’t vmalloc, we use a single bvec entry.<br>
      <br>
    </p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">
"backing_req-&gt;kmem.bvecs = kcalloc" - you can use kmalloc_array instead of 
kcalloc, there's no need to zero the value.</pre>
    </blockquote>
    Fixed in V1
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">+                if (++wait_count &gt;= PCACHE_WAIT_NEW_CACHE_COUNT)
+                        return NULL;
+
+                udelay(PCACHE_WAIT_NEW_CACHE_INTERVAL);
+                goto again;
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
This is not good practice to insert arbitrary waits (here, the wait is 
burning CPU power, which makes it even worse). You should add the process 
to a wait queue and wake up the queue.

See the functions writecache_wait_on_freelist and writecache_free_entry 
for an example, how to wait correctly.</pre>
    </blockquote>
    <p><br>
    </p>
    <p>`get_cache_segment()` may be called under a spinlock, so I
      originally designed a “short-busy-wait” to wait for a free
      segment,</p>
    <p>If wait_count &gt;= <span style="white-space: pre-wrap">PCACHE_WAIT_NEW_CACHE_COUNT, then return -EBUSY to let dm-pcache defer_list to retry.</span></p>
    <p><span style="white-space: pre-wrap">
</span></p>
    <p>However, I later discovered that when the cache is full, there's
      rarely enough time during that brief short-busy-wait to free a
      segment.</p>
    <p>Therefore in V1 I removed it and instead return `-EBUSY`,
      allowing dm-pcache’s retry mechanism to wait for a cache
      invalidation before retrying.</p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

</pre>
      <blockquote type="cite">
        <pre wrap="" class="moz-quote-pre">+static int dm_pcache_map_bio(struct dm_target *ti, struct bio *bio)
+{
+     struct pcache_request *pcache_req = dm_per_bio_data(bio, sizeof(struct pcache_request));
+     struct dm_pcache *pcache = ti-&gt;private;
+     int ret;
+
+     pcache_req-&gt;pcache = pcache;
+     kref_init(&amp;pcache_req-&gt;ref);
+     pcache_req-&gt;ret = 0;
+     pcache_req-&gt;bio = bio;
+     pcache_req-&gt;off = (u64)bio-&gt;bi_iter.bi_sector &lt;&lt; SECTOR_SHIFT;
+     pcache_req-&gt;data_len = bio-&gt;bi_iter.bi_size;
+     INIT_LIST_HEAD(&amp;pcache_req-&gt;list_node);
+     bio-&gt;bi_iter.bi_sector = dm_target_offset(ti, bio-&gt;bi_iter.bi_sector);
</pre>
      </blockquote>
      <pre wrap="" class="moz-quote-pre">
This looks suspicious because you store the original bi_sector to
pcache_req-&gt;off and then subtract the target offset from it. Shouldn't
"bio-&gt;bi_iter.bi_sector = dm_target_offset(ti, bio-&gt;bi_iter.bi_sector);"
be before "pcache_req-&gt;off = (u64)bio-&gt;bi_iter.bi_sector &lt;&lt; 
SECTOR_SHIFT;"?</pre>
    </blockquote>
    <p><br>
    </p>
    <p><span style="white-space: pre-wrap">Yes, that logic is indeed questionable, but it works in testing. </span></p>
    <p><span style="white-space: pre-wrap">Since we define dm-pcache as a **singleton**, both behaviors should effectively be equivalent, IIUC.

Also, in V1 I moved the call to `dm_target_offset()` so it runs before setting up `pcache_req-&gt;off`, making the code logic correct.</span></p>
    <p><span style="white-space: pre-wrap">
</span></p>
    <p><span style="white-space: pre-wrap">Thanx</span></p>
    <p><span style="white-space: pre-wrap">Dongsheng</span></p>
    <blockquote type="cite"
      cite="mid:dc019764-5128-526e-d8ea-effa78e37b39@redhat.com">
      <pre wrap="" class="moz-quote-pre">

Generally, the code doesn't seem bad. After reworking the out-of-memory 
handling and replacing arbitrary waits with wait queues, I can merge it.

Mikulas

</pre>
    </blockquote>
  </body>
</html>

--------------vr3vSDl9nGurANl7EDaKM3T0--
--------------f6yEcQN9bfuEx8vW3yg03FzF
Content-Type: text/plain; charset=UTF-8;
 name="0001-memcpy_flushcache_optimized-on-nd_pmem.ko.patch"
Content-Disposition: attachment;
 filename="0001-memcpy_flushcache_optimized-on-nd_pmem.ko.patch"
Content-Transfer-Encoding: base64

RnJvbSA4ODQ3NmY5NTgwMWY3MTc3YzNhOGMzMGM2NjNjZGQ3ODhmNzNhM2I1IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBEb25nc2hlbmcgWWFuZyA8ZG9uZ3NoZW5nLnlhbmdA
bGludXguZGV2PgpEYXRlOiBNb24sIDIzIEp1biAyMDI1IDEwOjEwOjM3ICswODAwClN1Ympl
Y3Q6IFtQQVRDSF0gbWVtY3B5X2ZsdXNoY2FjaGVfb3B0aW1pemVkIG9uIG5kX3BtZW0ua28K
ClNpZ25lZC1vZmYtYnk6IERvbmdzaGVuZyBZYW5nIDxkb25nc2hlbmcueWFuZ0BsaW51eC5k
ZXY+Ci0tLQogZHJpdmVycy9udmRpbW0vcG1lbS5jIHwgMzkgKysrKysrKysrKysrKysrKysr
KysrKysrKysrKysrKysrKysrKystCiAxIGZpbGUgY2hhbmdlZCwgMzggaW5zZXJ0aW9ucygr
KSwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbnZkaW1tL3BtZW0uYyBi
L2RyaXZlcnMvbnZkaW1tL3BtZW0uYwppbmRleCBhYTUwMDA2Yjc2MTYuLjc4YzJlODQ4MTYz
MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9udmRpbW0vcG1lbS5jCisrKyBiL2RyaXZlcnMvbnZk
aW1tL3BtZW0uYwpAQCAtMTIyLDYgKzEyMiw0MiBAQCBzdGF0aWMgYmxrX3N0YXR1c190IHBt
ZW1fY2xlYXJfcG9pc29uKHN0cnVjdCBwbWVtX2RldmljZSAqcG1lbSwKIAlyZXR1cm4gQkxL
X1NUU19PSzsKIH0KIAorc3RhdGljIHZvaWQgbWVtY3B5X2ZsdXNoY2FjaGVfb3B0aW1pemVk
KHZvaWQgKmRlc3QsIHZvaWQgKnNvdXJjZSwgc2l6ZV90IHNpemUpCit7CisJLyoKKwkgKiBj
bGZsdXNob3B0IHBlcmZvcm1zIGJldHRlciB3aXRoIGJsb2NrIHNpemUgMTAyNCwgMjA0OCwg
NDA5NgorCSAqIG5vbi10ZW1wb3JhbCBzdG9yZXMgcGVyZm9ybSBiZXR0ZXIgd2l0aCBibG9j
ayBzaXplIDUxMgorCSAqCisJICogYmxvY2sgc2l6ZSAgIDUxMiAgICAgICAgICAgICAxMDI0
ICAgICAgICAgICAgMjA0OCAgICAgICAgICAgIDQwOTYKKwkgKiBtb3ZudGkgICAgICAgNDk2
IE1CL3MgICAgICAgIDY0MiBNQi9zICAgICAgICA3MjUgTUIvcyAgICAgICAgNzQ0IE1CL3MK
KwkgKiBjbGZsdXNob3B0ICAgMzczIE1CL3MgICAgICAgIDY4OCBNQi9zICAgICAgICAxLjEg
R0IvcyAgICAgICAgMS4yIEdCL3MKKwkgKgorCSAqIFdlIHNlZSB0aGF0IG1vdm50aSBwZXJm
b3JtcyBiZXR0ZXIgZm9yIDUxMi1ieXRlIGJsb2NrcywgYW5kCisJICogY2xmbHVzaG9wdCBw
ZXJmb3JtcyBiZXR0ZXIgZm9yIDEwMjQtYnl0ZSBhbmQgbGFyZ2VyIGJsb2Nrcy4gU28sIHdl
CisJICogcHJlZmVyIGNsZmx1c2hvcHQgZm9yIHNpemVzID49IDc2OC4KKwkgKgorCSAqIE5P
VEU6IHRoaXMgaGFwcGVucyB0byBiZSB0aGUgY2FzZSBub3cgKHdpdGggZG0td3JpdGVjYWNo
ZSdzIHNpbmdsZQorCSAqIHRocmVhZGVkIG1vZGVsKSBidXQgcmUtZXZhbHVhdGUgdGhpcyBv
bmNlIG1lbWNweV9mbHVzaGNhY2hlKCkgaXMKKwkgKiBlbmFibGVkIHRvIHVzZSBtb3ZkaXI2
NGIgd2hpY2ggbWlnaHQgaW52YWxpZGF0ZSB0aGlzIHBlcmZvcm1hbmNlCisJICogYWR2YW50
YWdlIHNlZW4gd2l0aCBjYWNoZS1hbGxvY2F0aW5nLXdyaXRlcyBwbHVzIGZsdXNoaW5nLgor
CSAqLworI2lmZGVmIENPTkZJR19YODYKKwlpZiAoc3RhdGljX2NwdV9oYXMoWDg2X0ZFQVRV
UkVfQ0xGTFVTSE9QVCkgJiYKKwkgICAgbGlrZWx5KGJvb3RfY3B1X2RhdGEueDg2X2NsZmx1
c2hfc2l6ZSA9PSA2NCkgJiYKKwkgICAgbGlrZWx5KHNpemUgPj0gMCkpIHsKKwkJZG8gewor
CQkJbWVtY3B5KCh2b2lkICopZGVzdCwgKHZvaWQgKilzb3VyY2UsIDY0KTsKKwkJCWNsZmx1
c2hvcHQoKHZvaWQgKilkZXN0KTsKKwkJCWRlc3QgKz0gNjQ7CisJCQlzb3VyY2UgKz0gNjQ7
CisJCQlzaXplIC09IDY0OworCQl9IHdoaWxlIChzaXplID49IDY0KTsKKwkJcmV0dXJuOwor
CX0KKyNlbmRpZgorCW1lbWNweV9mbHVzaGNhY2hlKGRlc3QsIHNvdXJjZSwgc2l6ZSk7Cit9
CisKIHN0YXRpYyB2b2lkIHdyaXRlX3BtZW0odm9pZCAqcG1lbV9hZGRyLCBzdHJ1Y3QgcGFn
ZSAqcGFnZSwKIAkJdW5zaWduZWQgaW50IG9mZiwgdW5zaWduZWQgaW50IGxlbikKIHsKQEAg
LTEzMSw3ICsxNjcsOCBAQCBzdGF0aWMgdm9pZCB3cml0ZV9wbWVtKHZvaWQgKnBtZW1fYWRk
ciwgc3RydWN0IHBhZ2UgKnBhZ2UsCiAJd2hpbGUgKGxlbikgewogCQltZW0gPSBrbWFwX2F0
b21pYyhwYWdlKTsKIAkJY2h1bmsgPSBtaW5fdCh1bnNpZ25lZCBpbnQsIGxlbiwgUEFHRV9T
SVpFIC0gb2ZmKTsKLQkJbWVtY3B5X2ZsdXNoY2FjaGUocG1lbV9hZGRyLCBtZW0gKyBvZmYs
IGNodW5rKTsKKwkJLy9tZW1jcHlfZmx1c2hjYWNoZShwbWVtX2FkZHIsIG1lbSArIG9mZiwg
Y2h1bmspOworCQltZW1jcHlfZmx1c2hjYWNoZV9vcHRpbWl6ZWQocG1lbV9hZGRyLCBtZW0g
KyBvZmYsIGNodW5rKTsKIAkJa3VubWFwX2F0b21pYyhtZW0pOwogCQlsZW4gLT0gY2h1bms7
CiAJCW9mZiA9IDA7Ci0tIAoyLjQzLjAKCg==

--------------f6yEcQN9bfuEx8vW3yg03FzF--
