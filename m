Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 43DFE2096DCEE
 for <linux-nvdimm@lists.01.org>; Thu, 31 May 2018 08:31:14 -0700 (PDT)
Date: Thu, 31 May 2018 11:31:08 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [patch 4/4] dm-writecache: use new API for flushing
In-Reply-To: <CAPcyv4gzFbdBbUhPJ6W4mTJWAkvqVw_4FVhVdePEJzc28Sg-Sg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1805311127001.31059@file01.intranet.prod.int.rdu2.redhat.com>
References: <20180519052503.325953342@debian.vm>
 <CAPcyv4iEtfuVGPR0QMKcafv2XFwSj3nzxjX8cuXpXe00akAvYA@mail.gmail.com>
 <alpine.LRH.2.02.1805250213270.13894@file01.intranet.prod.int.rdu2.redhat.com>
 <20180525125126.GA9275@redhat.com>
 <CAPcyv4j-v5HGBg9JMBXt7UUyw=K_bGC7t5tQGfXM9G4qjOpFjQ@mail.gmail.com>
 <alpine.LRH.2.02.1805260246250.15978@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jwLsCNvNhgvv2DDSZuQsQXYEpKUU_5w1pTnyKj-uDBbQ@mail.gmail.com>
 <alpine.LRH.2.02.1805280922190.13486@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4jXV4aZ6wqqjVPL8J4LxwTtXnzQCLZ0Wk5oB4_0uxpg7g@mail.gmail.com>
 <alpine.LRH.2.02.1805300903220.1090@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4j3pDQ3YMK5Eije0dgGw+1CQYazPJ-zvqfvGF-9O_gVJw@mail.gmail.com>
 <CAPcyv4gD-ZaXyV1SFAndobUYJOGLkx9rOyb5zNbzJXB_kVCzoA@mail.gmail.com>
 <alpine.LRH.2.02.1805310416540.30096@file01.intranet.prod.int.rdu2.redhat.com>
 <CAPcyv4gzFbdBbUhPJ6W4mTJWAkvqVw_4FVhVdePEJzc28Sg-Sg@mail.gmail.com>
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



On Thu, 31 May 2018, Dan Williams wrote:

> On Thu, May 31, 2018 at 1:19 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
> >
> >
> > On Wed, 30 May 2018, Dan Williams wrote:
> >
> >> > Great find! Thanks for the due diligence. Feel free to add:
> >> >
> >> >     Acked-by: Dan Williams <dan.j.williams@intel.com>
> >> >
> >> > ...on the reworks to unify ARM and x86.
> >>
> >> One more note. The side effect of not using dax_flush() is that you
> >> may end up flushing caches on systems where the platform has asserted
> >> it will take responsibility for flushing caches at power loss. If /
> >> when those systems become more prevalent we may want to think of a way
> >> to combine the non-temporal optimization and the cache-flush-bypass
> >> optimizations. However that is something that can wait for a later
> >> change beyond 4.18.
> >
> > We could define memcpy_flushpmem, that falls back to memcpy or
> > memcpy_flushcache, depending on whether the platform flushes the caches at
> > power loss or not.
> 
> The problem is that some platforms only power fail protect a subset of
> the physical address range,

How can this be? A psysical address may be cached on any CPU, so either 
there is enough power to flush all the CPUs' caches or there isn't.

How does the CPU design that protects only a part of physical addresses 
look like?

> but yes, if the platform makes a global
> assertion we can globally replace memcpy_flushpmem() with plain
> memcpy.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
