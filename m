Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9A82A2063D743
 for <linux-nvdimm@lists.01.org>; Tue, 22 May 2018 15:53:45 -0700 (PDT)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [dm-devel] [patch 4/4] dm-writecache: use new API for flushing
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm>
 <20180522063946.GB8054@infradead.org>
 <20180522184103.GA25826@redhat.com>
 <CAPcyv4g395RccdEPF=sCu5RdCH9zwD+GvOfSp7-F0Oh64CeDgA@mail.gmail.com>
 <20180522191942.GB25904@redhat.com>
 <CAPcyv4hWswV=VCfB7KatoW_zc-kUUju2jD45N-Gsg4sW-XFe-A@mail.gmail.com>
 <20180522205214.GA26259@redhat.com>
Date: Tue, 22 May 2018 18:53:39 -0400
In-Reply-To: <20180522205214.GA26259@redhat.com> (Mike Snitzer's message of
 "Tue, 22 May 2018 16:52:17 -0400")
Message-ID: <x49r2m3nvyk.fsf@segfault.boston.devel.redhat.com>
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
To: Mike Snitzer <snitzer@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi, Mike,

Mike Snitzer <snitzer@redhat.com> writes:

> Looking at Mikulas' wrapper API that you and hch are calling into
> question:
>
> For ARM it is using arch/arm64/mm/flush.c:arch_wb_cache_pmem().
> (And ARM does seem to be providing CONFIG_ARCH_HAS_PMEM_API.)
>
> Whereas x86_64 is using memcpy_flushcache() as provided by
> CONFIG_ARCH_HAS_UACCESS_FLUSHCACHE.
> (Yet ARM does provide arch/arm64/lib/uaccess_flushcache.c:memcpy_flushcache)
>
> Just seems this isn't purely about ARM lacking on an API level (given on
> x86_64 Mikulas isn't only using CONFIG_ARCH_HAS_PMEM_API).
>
> Seems this is more to do with x86_64 having efficient Non-temporal
> stores?

Yeah, I think you've got that all right.

> Anyway, I'm still trying to appreciate the details here before I can
> make any forward progress.

Making data persistent on x64 requires 3 steps:
1) copy the data into pmem   (store instructions)
2) flush the cache lines associated with the data (clflush, clflush_opt, clwb)
3) wait on the flush to complete (sfence)

I'm not sure if other architectures require step 3.  Mikulas'
implementation seems to imply that arm64 doesn't require the fence.

The current pmem api provides:

memcpy*           -- step 1
memcpy_flushcache -- this combines steps 1 and 2
dax_flush         -- step 2
wmb*              -- step 3

* not strictly part of the pmem api

So, if you didn't care about performance, you could write generic code
that only used memcpy, dax_flush, and wmb (assuming other arches
actually need the wmb).  What Mikulas did was to abstract out an API
that could be called by generic code that would work optimally on all
architectures.

This looks like a worth-while addition to the PMEM API, to me.  Mikulas,
what do you think about refactoring the code as Christoph suggested?

Cheers,
Jeff
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
