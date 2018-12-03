From: Barret Rhoden <brho@google.com>
Subject: Re: [PATCH v2 0/3] kvm: Use huge pages for DAX-backed files
Date: Mon, 3 Dec 2018 12:40:51 -0500
Message-ID: <20181203124051.05c1d2ce@gnomeregan.cam.corp.google.com>
References: <20181109203921.178363-1-brho@google.com>
        <20181114215155.259978-1-brho@google.com>
        <CAPcyv4jga=HnsfHffWoo+JjRUBf3stD4VP3B5X5xSOZb=yh+Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4jga=HnsfHffWoo+JjRUBf3stD4VP3B5X5xSOZb=yh+Mw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, zwisler@kernel.org, Vishal L Verma <vishal.l.verma@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, rkrcmar@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, KVM list <kvm@vger.kernel.org>, "Zhang, Yu C" <yu.c.zhang@intel.com>, "Zhang, Yi Z" <yi.z.zhang@intel.com>, alexander.h.duyck@linux.intel.com
List-Id: linux-nvdimm@lists.01.org

On 2018-11-14 at 16:55 Dan Williams <dan.j.williams@intel.com> wrote:
> [ add Alex who is looking into removing PageReserved for DAX pages. ]

Thanks.  I can keep my eye out for his patches and repost once that's
done.  

Alternatively, if you all want to merge this before the PageReserved /
DAX changes, then I can repost - just Ack/Review tags.  It's harmless
with the existing PageReserved behavior.

Thanks,

Barret


> On Wed, Nov 14, 2018 at 1:53 PM Barret Rhoden <brho@google.com> wrote:
> >
> > This patch series depends on dax pages not being PageReserved.  Once
> > that is in place, these changes will let KVM use huge pages with
> > dax-backed files.  Without the PageReserved change, KVM and DAX still
> > work with these patches, simply without huge pages - which is the
> > current situation.
> >
> > RFC/discussion thread:
> > https://lore.kernel.org/lkml/20181029210716.212159-1-brho@google.com/
> >
> > v1 -> v2:
> > https://lore.kernel.org/lkml/20181109203921.178363-1-brho@google.com/
> >
> > - Updated Acks/Reviewed-by
> > - Minor touchups
> > - Added patch to remove redundant PageReserved() check
> > - Rebased onto linux-next
> >
> >
> > Barret Rhoden (3):
> >   mm: make dev_pagemap_mapping_shift() externally visible
> >   kvm: Use huge pages for DAX-backed files
> >   kvm: remove redundant PageReserved() check
> >
> >  arch/x86/kvm/mmu.c  | 33 +++++++++++++++++++++++++++++++--
> >  include/linux/mm.h  |  3 +++
> >  mm/memory-failure.c | 38 +++-----------------------------------
> >  mm/util.c           | 34 ++++++++++++++++++++++++++++++++++
> >  virt/kvm/kvm_main.c |  8 ++------
> >  5 files changed, 73 insertions(+), 43 deletions(-)
> >
> > --
> > 2.19.1.1215.g8438c0b245-goog
> >  
