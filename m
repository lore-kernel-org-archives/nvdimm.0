Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3A8E21959CB2
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 10:32:01 -0800 (PST)
Message-ID: <714716fde90865e195848f1a9a38e9134e75ad29.camel@linux.intel.com>
Subject: Re: [PATCH v2 0/3] kvm: Use huge pages for DAX-backed files
From: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date: Mon, 03 Dec 2018 10:32:00 -0800
In-Reply-To: <20181203124051.05c1d2ce@gnomeregan.cam.corp.google.com>
References: <20181109203921.178363-1-brho@google.com>
 <20181114215155.259978-1-brho@google.com>
 <CAPcyv4jga=HnsfHffWoo+JjRUBf3stD4VP3B5X5xSOZb=yh+Mw@mail.gmail.com>
 <20181203124051.05c1d2ce@gnomeregan.cam.corp.google.com>
Mime-Version: 1.0
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
To: Barret Rhoden <brho@google.com>, Dan Williams <dan.j.williams@intel.com>
Cc: X86 ML <x86@kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, KVM list <kvm@vger.kernel.org>, rkrcmar@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, zwisler@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>Zhang,
List-ID: <linux-nvdimm@lists.01.org>

On Mon, 2018-12-03 at 12:40 -0500, Barret Rhoden wrote:
> On 2018-11-14 at 16:55 Dan Williams <dan.j.williams@intel.com> wrote:
> > [ add Alex who is looking into removing PageReserved for DAX pages. ]
> 
> Thanks.  I can keep my eye out for his patches and repost once that's
> done.  
> 
> Alternatively, if you all want to merge this before the PageReserved /
> DAX changes, then I can repost - just Ack/Review tags.  It's harmless
> with the existing PageReserved behavior.
> 
> Thanks,
> 
> Barret

So the latest version of my generic memory init patches are up at:

https://lore.kernel.org/lkml/154361452447.7497.1348692079883153517.stgit@ahduyck-desk1.amr.corp.intel.com/

To be honest I am not entirely convinced that dropping PageReserved is
the right thing to do for DAX pages. I've been trying to work out a few
different issues but not having much luck. It seems like the main issue
is that the PageReserved bit is being used to indicate 2 different
things in a few spots throughout the kernel.

The definition of the PG_reserved flag reads like it should apply to
DAX pages:
  PG_reserved is set for special pages, which can never be swapped out.
  Some of them might not even exist...

PageReserved essentially means you aren't supposed to be migrating or
swapping the page. The problem here is that I believe this logic should
apply to DAX pages and so in many cases it makes sense to leave the
flag set for DAX pages. Otherwise you have to go through and start
special casing all the spots where normal memory falls through and add
a check to see if we have a DAX page.

The second use for the PG_reserved flag is to test for if you can pin
the page or not. This I think is the reason why many are just assuming
PageReserved == MMIO like KVM does. However this is a bad assumption to
be making since the introduction of DAX, HMM, and P2PDMA allows MMIO
memory to start doing different things like supporting pinning. I also
believe it would be a bad reason to clear the flag for DAX pages.

Thanks.

- Alex

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
