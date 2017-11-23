Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7FD82034C5FE
 for <linux-nvdimm@lists.01.org>; Thu, 23 Nov 2017 13:18:19 -0800 (PST)
Date: Thu, 23 Nov 2017 16:22:30 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] dm-writecache
In-Reply-To: <CAA9_cmcBk8AMU=dc3A2fv2oS7Drk_a1iBQAxJRDrqLV0k=rLWg@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1711231618550.2217@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711222135371.2330@file01.intranet.prod.int.rdu2.redhat.com>
 <20171123082946.GB17859@infradead.org>
 <CAA9_cmcBk8AMU=dc3A2fv2oS7Drk_a1iBQAxJRDrqLV0k=rLWg@mail.gmail.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On Thu, 23 Nov 2017, Dan Williams wrote:

> On Thu, Nov 23, 2017 at 12:29 AM, Christoph Hellwig <hch@infradead.org> wrote:
> >> +/*
> >> + * The clflushopt instruction is very slow on Broadwell, so we use non-temporal
> >> + * stores instead.
> >> + */
> >> +#ifdef CONFIG_X86_64
> >> +#define NT_STORE(dest, src)  asm ("movnti %1, %0" : "=m"(dest) : "r"(src))
> >> +#define FLUSH_RANGE(dax, ptr, size)  do { } while (0)
> >> +#define COMMIT_FLUSHED()     wmb()
> >> +#else
> >> +#define NT_STORE(dest, src)  ACCESS_ONCE(dest) = (src)
> >> +#define FLUSH_RANGE          dax_flush
> >> +#define COMMIT_FLUSHED()     do { } while (0)
> >> +#endif
> >
> > Please go through the proper pmem APIs.
> 
> Yes, see _copy_from_iter_flushcache() and all its related apis.
> Drivers shouldn't be doing anything different than what fs/dax.c is
> using.

There is not any arch-independent API that abstracts over a single movnti 
instruction.

Do you want to add it?

memcpy_flushcache is overkill for one or two 8-byte stores. And - on 
non-x86 architectures memcpy_flushcache doesn't flush cache at all.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
