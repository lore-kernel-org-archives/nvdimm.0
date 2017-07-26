Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 681192095DB95
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 13:51:01 -0700 (PDT)
Date: Wed, 26 Jul 2017 14:51:17 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 5/6] libnvdimm, btt: rework error clearing
Message-ID: <20170726205117.GA18006@omniknight.lm.intel.com>
References: <20170717235655.26424-1-vishal.l.verma@intel.com>
 <20170717235655.26424-6-vishal.l.verma@intel.com>
 <CAPcyv4i6yjNz6xMSnq2zE5sw2sGqE4BzjyP9c1JVBDwFhu_iuA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4i6yjNz6xMSnq2zE5sw2sGqE4BzjyP9c1JVBDwFhu_iuA@mail.gmail.com>
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
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 07/20, Dan Williams wrote:
> On Mon, Jul 17, 2017 at 4:56 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> > Clearing errors or badblocks during a BTT write requires sending an ACPI
> > DSM, which means potentially sleeping. Since a BTT IO happens in atomic
> > context (preemption disabled, spinlocks may be held), we cannot perform
> > error clearing in the course of an IO. Due to this error clearing for
> > BTT IOs has hitherto been disabled.
> >
> > In this patch we move error clearing out of the atomic section, and thus
> > re-enable error clearing with BTTs. When we are about to add a block to
> > the free list, we check if it was previously marked as an error, and if
> > it was, we add it to the freelist, but also set a flag that says error
> > clearing will be required. We then drop the lane (ending the atomic
> > context), and send a zero buffer so that the error can be cleared. The
> > error flag in the free list is protected by the nd 'lane', and is set
> > only be a thread while it holds that lane. When the error is cleared,
> > the flag is cleared, but while holding a mutex for that freelist index.
> >
> > When writing, we check for two things -
> > 1/ If the freelist mutex is held or if the error flag is set. If so,
> > this is an error block that is being (or about to be) cleared.
> > 2/ If the block is a known badblock based on nsio->bb
> >
> > The second check is required because the BTT map error flag for a map
> > entry only gets set when an error LBA is read. If we write to a new
> > location that may not have the map error flag set, but still might be in
> > the region's badblock list, we can trigger an EIO on the write, which is
> > undesirable and completely avoidable.
> >
> > Cc: Jeff Moyer <jmoyer@redhat.com>
> > Cc: Toshi Kani <toshi.kani@hpe.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> [..]
> > diff --git a/drivers/nvdimm/btt.h b/drivers/nvdimm/btt.h
> > index 2bc0d10b..69c1f90 100644
> > --- a/drivers/nvdimm/btt.h
> > +++ b/drivers/nvdimm/btt.h
> > @@ -15,6 +15,7 @@
> >  #ifndef _LINUX_BTT_H
> >  #define _LINUX_BTT_H
> >
> > +#include <linux/badblocks.h>
> >  #include <linux/types.h>
> >
> >  #define BTT_SIG_LEN 16
> > @@ -41,6 +42,7 @@
> >  #define ent_lba(ent) (ent & MAP_LBA_MASK)
> >  #define ent_e_flag(ent) (!!(ent & MAP_ERR_MASK))
> >  #define ent_z_flag(ent) (!!(ent & MAP_TRIM_MASK))
> > +#define set_e_flag(ent) (ent |= MAP_ERR_MASK)
> >
> >  enum btt_init_state {
> >         INIT_UNCHECKED = 0,
> > @@ -82,6 +84,8 @@ struct free_entry {
> >         u32 block;
> >         u8 sub;
> >         u8 seq;
> > +       struct mutex err_lock;
> > +       u8 has_err;
> 
> Do we really need an error lock per lane? Given the rarity of lock
> contention I think we can save this memory and just have one error
> handling lock per-btt.

Yes, I could make it per arena, that makes more sense - but the only
downside might be all writes to that arena get blocked behind the error
clear instead of just the one(s) that pick that free block. That said,
it shouldn't be a big deal as errors should be rare..

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
