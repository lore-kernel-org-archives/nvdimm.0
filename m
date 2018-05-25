Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B21A120965DEA
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 08:57:28 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id n3-v6so6597149ota.5
 for <linux-nvdimm@lists.01.org>; Fri, 25 May 2018 08:57:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180525125126.GA9275@redhat.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm>
 <CAPcyv4iEtfuVGPR0QMKcafv2XFwSj3nzxjX8cuXpXe00akAvYA@mail.gmail.com>
 <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
 <20180525125126.GA9275@redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 25 May 2018 08:57:27 -0700
Message-ID: <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
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
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 25, 2018 at 5:51 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> On Fri, May 25 2018 at  2:17am -0400,
> Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>>
>>
>> On Thu, 24 May 2018, Dan Williams wrote:
>>
>> > On Fri, May 18, 2018 at 10:25 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>> > > Use new API for flushing persistent memory.
>> > >
>> > > The problem is this:
>> > > * on X86-64, non-temporal stores have the best performance
>> > > * ARM64 doesn't have non-temporal stores, so we must flush cache. We
>> > >   should flush cache as late as possible, because it performs better this
>> > >   way.
>> > >
>> > > We introduce functions pmem_memcpy, pmem_flush and pmem_commit. To commit
>> > > data persistently, all three functions must be called.
>> > >
>> > > The macro pmem_assign may be used instead of pmem_memcpy. pmem_assign
>> > > (unlike pmem_memcpy) guarantees that 8-byte values are written atomically.
>> > >
>> > > On X86, pmem_memcpy is memcpy_flushcache, pmem_flush is empty and
>> > > pmem_commit is wmb.
>> > >
>> > > On ARM64, pmem_memcpy is memcpy, pmem_flush is arch_wb_cache_pmem and
>> > > pmem_commit is empty.
>> >
>> > I don't want to grow driver-local wrappers for pmem. You should use
>> > memcpy_flushcache directly() and if an architecture does not define
>> > memcpy_flushcache() then don't allow building dm-writecache, i.e. this
>> > driver should 'depends on CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE'. I don't
>> > see a need to add a standalone flush operation if all relevant archs
>> > provide memcpy_flushcache(). As for commit, I'd say just use wmb()
>> > directly since all archs define it. Alternatively we could introduce
>> > memcpy_flushcache_relaxed() to be the un-ordered version of the copy
>> > routine and memcpy_flushcache() would imply a wmb().
>>
>> But memcpy_flushcache() on ARM64 is slow.
>
> Yes, Dan can you please take some time to fully appreciate what this
> small wrapper API is providing (maybe you've done that, but your recent
> reply is mixed-message).  Seems you're keeping the innovation it
> provides at arms-length.  Basically the PMEM APIs you've helped
> construct are lacking, forcing DM developers to own fixing them is an
> inversion that only serves to stonewall.
>
> Please, less time on stonewalling and more time lifting this wrapper
> API; otherwise the dm-writecache local wrapper API is a near-term means
> to an end.
>
> I revised the dm-writecache patch header yesterday, please review:
> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=2105231db61b08752bc4247d2fe7838657700b0d
> (the last paragraph in particular, I intend to move forward with this
> wrapper unless someone on the PMEM side of the house steps up and lifts
> it up between now and when the 4.18 merge window opens)
>
> dm: add writecache target
> The writecache target caches writes on persistent memory or SSD.
> It is intended for databases or other programs that need extremely low
> commit latency.
>
> The writecache target doesn't cache reads because reads are supposed to
> be cached in page cache in normal RAM.
>
> The following describes the approach used to provide the most efficient
> flushing of persistent memory on X86_64 vs ARM64:
>
> * On X86_64 non-temporal stores (i.e. memcpy_flushcache) are faster
>   than cached writes and cache flushing.
>
> * The ARM64 architecture doesn't have non-temporal stores. So,
>   memcpy_flushcache on ARM does memcpy (that writes data to the cache)
>   and then flushes the cache.  But this eager cache flushig is slower
>   than late cache flushing.
>
> The optimal code sequence on ARM to write to persistent memory is to
> call memcpy, then do something else, and then call arch_wb_cache_pmem as
> late as possible. And this ARM-optimized code sequence is just horribly
> slow on X86.
>
> This issue can't be "fixed" in ARM-specific source code. The ARM
> processor have characteristics such that eager cache flushing is slower
> than late cache flushing - and that's it - you can't change processor
> behavior.
>
> We introduce a wrapper API for flushing persistent memory with functions
> pmem_memcpy, pmem_flush and pmem_commit. To commit data persistently,
> all three functions must be called.
>
> The macro pmem_assign may be used instead of pmem_memcpy.  pmem_assign
> (unlike pmem_memcpy) guarantees that 8-byte values are written
> atomically.
>
> On X86_64, pmem_memcpy is memcpy_flushcache, pmem_flush is empty and
> pmem_commit is wmb.
>
> On ARM64, pmem_memcpy is memcpy, pmem_flush is arch_wb_cache_pmem and
> pmem_commit is empty.
>
> It is clear that this wrapper API for flushing persistent memory needs
> to be elevated out of this dm-writecache driver.  But that can happen
> later without requiring DM developers to blaze new trails on pmem
> specific implementation details/quirks (pmem developers need to clean up
> their APIs given they are already spread across CONFIG_ARCH_HAS_PMEM_API
> and CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE and they absolutely don't take
> into account the duality of the different programming models needed to
> achieve optimal cross-architecture use of persistent memory).

Right, so again, what is wrong with memcpy_flushcache_relaxed() +
wmb() or otherwise making memcpy_flushcache() ordered. I do not see
that as a trailblazing requirement, I see that as typical review and a
reduction of the operation space that you are proposing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
