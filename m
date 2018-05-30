Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 67D26203BEA49
 for <linux-nvdimm@lists.01.org>; Wed, 30 May 2018 06:51:21 -0700 (PDT)
Date: Wed, 30 May 2018 09:51:16 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [patch 4/4] dm-writecache: use new API for flushing
In-Reply-To: <x49h8mpmf8v.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LRH.2.02.1805300949220.16696@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm>
 <20180519052635.567438191@debian.vm> <20180522063946.GB8054@infradead.org>
 <20180522184103.GA25826@redhat.com>
 <CAPcyv4g395RccdEPF=sCu5RdCH9zwD+GvOfSp7-F0Oh64CeDgA@mail.gmail.com>
 <20180522191942.GB25904@redhat.com>
 <CAPcyv4hWswV=VCfB7KatoW_zc-kUUju2jD45N-Gsg4sW-XFe-A@mail.gmail.com>
 <alpine.LRH.2.02.1805280943460.16538@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gxCNqqG2G3R6f=kH3zNbByhgE2R-trJWurH49-p+51Gg@mail.gmail.com>
 <x49h8mpmf8v.fsf@segfault.boston.devel.redhat.com>
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
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On Wed, 30 May 2018, Jeff Moyer wrote:

> Dan Williams <dan.j.williams@intel.com> writes:
> 
> > When I read your patch I came away with the impression that ARM had
> > not added memcpy_flushcache() yet and you were working around that
> > fact. Now that I look, ARM *does* define memcpy_flushcache() and
> > you're avoiding it. You use memcpy+arch_wb_pmem where arch_wb_pmem on
> > ARM64 is defined as __clean_dcache_area_pop(dst, cnt). The ARM
> > memcpy_flushcache() implementation is:
> >
> >     memcpy(dst, src, cnt);
> >     __clean_dcache_area_pop(dst, cnt);
> >
> > So, I do not see how what you're doing is any less work unless you are
> > flushing less than you copy?
> >
> > If memcpy_flushcache() is slower than memcpy + arch_wb_pmem then the
> > ARM implementation is broken and that needs to be addressed not worked
> > around in a driver.
> 
> I think Mikulas wanted to batch up multiple copies and flush at the
> end.  According to his commit message, that batching gained him 2%
> performance.
> 
> -Jeff

No - this 2% difference is inlined memcpy_flushcache() vs out-of-line 
memcpy_flushcache().

I thought that dax_flush() performed 12% better memcpy_flushcache() - but 
the reason why it performed better was - that it was not flushing the 
cache at all.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
