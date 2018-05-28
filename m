Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EF68203B8CDB
 for <linux-nvdimm@lists.01.org>; Mon, 28 May 2018 06:32:13 -0700 (PDT)
Date: Mon, 28 May 2018 09:32:12 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
In-Reply-To: <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm>
 <CAPcyv4iEtfuVGPR0QMKcafv2XFwSj3nzxjX8cuXpXe00akAvYA@mail.gmail.com>
 <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
 <20180525125126.GA9275@redhat.com>
 <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
 <alpine.LRH.2.02.1805260246250.15978@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
MIME-Version: 1.0
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
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On Sat, 26 May 2018, Dan Williams wrote:

> On Sat, May 26, 2018 at 12:02 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> > On Fri, 25 May 2018, Dan Williams wrote:
> >
> >> On Fri, May 25, 2018 at 5:51 AM, Mike Snitzer <snitzer@redhat.com> wrote:
> >> > On Fri, May 25 2018 at  2:17am -0400,
> >> > Mikulas Patocka <mpatocka@redhat.com> wrote:
> >> >
> >> >> On Thu, 24 May 2018, Dan Williams wrote:
> >> >>
> >> >> > I don't want to grow driver-local wrappers for pmem. You should use
> >> >> > memcpy_flushcache directly() and if an architecture does not define
> >> >> > memcpy_flushcache() then don't allow building dm-writecache, i.e. this
> >> >> > driver should 'depends on CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE'. I don't
> >> >> > see a need to add a standalone flush operation if all relevant archs
> >> >> > provide memcpy_flushcache(). As for commit, I'd say just use wmb()
> >> >> > directly since all archs define it. Alternatively we could introduce
> >> >> > memcpy_flushcache_relaxed() to be the un-ordered version of the copy
> >> >> > routine and memcpy_flushcache() would imply a wmb().
> >> >>
> >> >> But memcpy_flushcache() on ARM64 is slow.
> >>
> >> Right, so again, what is wrong with memcpy_flushcache_relaxed() +
> >> wmb() or otherwise making memcpy_flushcache() ordered. I do not see
> >> that as a trailblazing requirement, I see that as typical review and a
> >> reduction of the operation space that you are proposing.
> >
> > memcpy_flushcache on ARM64 is generally wrong thing to do, because it is
> > slower than memcpy and explicit cache flush.
> >
> > Suppose that you want to write data to a block device and make it
> > persistent. So you send a WRITE bio and then a FLUSH bio.
> >
> > Now - how to implement these two bios on persistent memory:
> >
> > On X86, the WRITE bio does memcpy_flushcache() and the FLUSH bio does
> > wmb() - this is the optimal implementation.
> >
> > But on ARM64, memcpy_flushcache() is suboptimal. On ARM64, the optimal
> > implementation is that the WRITE bio does just memcpy() and the FLUSH bio
> > does arch_wb_cache_pmem() on the affected range.
> >
> > Why is memcpy_flushcache() is suboptimal on ARM? The ARM architecture
> > doesn't have non-temporal stores. So, memcpy_flushcache() is implemented
> > as memcpy() followed by a cache flush.
> >
> > Now - if you flush the cache immediatelly after memcpy, the cache is full
> > of dirty lines and the cache-flushing code has to write these lines back
> > and that is slow.
> >
> > If you flush the cache some time after memcpy (i.e. when the FLUSH bio is
> > received), the processor already flushed some part of the cache on its
> > own, so the cache-flushing function has less work to do and it is faster.
> >
> > So the conclusion is - don't use memcpy_flushcache on ARM. This problem
> > cannot be fixed by a better implementation of memcpy_flushcache.
> 
> It sounds like ARM might be better off with mapping its pmem as
> write-through rather than write-back, and skip the explicit cache

I doubt it would perform well - write combining combines the writes into a 
larger segments - and write-through doesn't.

> management altogether. You speak of "optimal" and "sub-optimal", but
> what would be more clear is fio measurements of the relative IOPs and
> latency profiles of the different approaches. The reason I am
> continuing to push here is that reducing the operation space from
> 'copy-flush-commit' to just 'copy' or 'copy-commit' simplifies the
> maintenance long term.

I measured it (with nvme backing store) and late cache flushing has 12% 
better performance than eager flushing with memcpy_flushcache().

131836 4k iops - vs - 117016.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
