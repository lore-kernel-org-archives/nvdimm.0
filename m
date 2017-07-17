Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x22b.google.com (mail-yw0-x22b.google.com
 [IPv6:2607:f8b0:4002:c05::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E8862193B801
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jul 2017 15:30:18 -0700 (PDT)
Received: by mail-yw0-x22b.google.com with SMTP id a12so881971ywh.3
 for <linux-nvdimm@lists.01.org>; Mon, 17 Jul 2017 15:32:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1500329958.6401.56.camel@intel.com>
References: <20170717212739.5411-1-vishal.l.verma@intel.com>
 <20170717212739.5411-6-vishal.l.verma@intel.com>
 <CAPcyv4jcy1VN4O9fSy-mDgnxYtWWiVOqDaGqbqFYt7_5TX=hsw@mail.gmail.com>
 <1500329958.6401.56.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Jul 2017 15:32:09 -0700
Message-ID: <CAPcyv4jE3YfOjUVbMAJ2n83YaMRQR5H3L4Xx=ijVioZ1pBN9kA@mail.gmail.com>
Subject: Re: [PATCH v2 5/6] libnvdimm, btt: rework error clearing
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 17, 2017 at 3:20 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
> On Mon, 2017-07-17 at 15:00 -0700, Dan Williams wrote:
>> On Mon, Jul 17, 2017 at 2:27 PM, Vishal Verma <vishal.l.verma@intel.co
>> m> wrote:
>> > Clearing errors or badblocks during a BTT write requires sending an
>> > ACPI
>> > DSM, which means potentially sleeping. Since a BTT IO happens in
>> > atomic
>> > context (preemption disabled, spinlocks may be held), we cannot
>> > perform
>> > error clearing in the course of an IO. Due to this error clearing
>> > for
>> > BTT IOs has hitherto been disabled.
>> >
>> > In this patch we move error clearing out of the atomic section, and
>> > thus
>> > re-enable error clearing with BTTs. When we are about to add a block
>> > to
>> > the free list, we check if it was previously marked as an error, and
>> > if
>> > it was, we add it to the freelist, but also set a flag that says
>> > error
>> > clearing will be required. We then drop the lane (ending the atomic
>> > context), and send a zero buffer so that the error can be cleared.
>> > The
>> > error flag in the free list is protected by the nd 'lane', and is
>> > set
>> > only be a thread while it holds that lane. When the error is
>> > cleared,
>> > the flag is cleared, but while holding a mutex for that freelist
>> > index.
>> >
>> > When writing, we check for two things -
>> > 1/ If the freelist mutex is held or if the error flag is set. If so,
>> > this is an error block that is being (or about to be) cleared.
>> > 2/ If the block is a known badblock based on nsio->bb
>> >
>> > The second check is required because the BTT map error flag for a
>> > map
>> > entry only gets set when an error LBA is read. If we write to a new
>> > location that may not have the map error flag set, but still might
>> > be in
>> > the region's badblock list, we can trigger an EIO on the write,
>> > which is
>> > undesirable and completely avoidable.
>> >
>> > Cc: Jeff Moyer <jmoyer@redhat.com>
>> > Cc: Toshi Kani <toshi.kani@hpe.com>
>> > Cc: Dan Williams <dan.j.williams@intel.com>
>> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>> > ---
>> >  drivers/nvdimm/btt.c   | 89
>> > +++++++++++++++++++++++++++++++++++++++++++++-----
>> >  drivers/nvdimm/btt.h   |  5 +++
>> >  drivers/nvdimm/claim.c |  8 -----
>> >  3 files changed, 85 insertions(+), 17 deletions(-)
>> >
>
> <>
>
>> > +static int arena_clear_freelist_error(struct arena_info *arena, u32
>> > lane)
>> > +{
>> > +       int ret = 0;
>> > +
>> > +       if (arena->freelist[lane].has_err) {
>> > +               u32 lba = arena->freelist[lane].block;
>> > +               u64 nsoff = to_namespace_offset(arena, lba);
>> > +               void *zerobuf;
>> > +
>> > +               zerobuf = kzalloc(arena->sector_size, GFP_KERNEL);
>> > +               if (!zerobuf)
>> > +                       return -ENOMEM;
>>
>> Hmm, can this just use the system zero page (empty_zero_page)? Also,
>> even if it can't, I'd prefer the NOIO fix for this case be folded into
>> this patch. The NOIO fixup for the acpi dsm path should be separate.
>>
>> Another consideration if we can't use the system zero page, do we need
>> to allocate this on demand? Seems like something we could just
>> pre-allocate at init time.
>
> I had started out using the empty_zero_page, but to use that you have to
> kmap_atomic the page, which ends up creating an atomic section again :)

I think it is safe to assume that the zero page is never in highmem.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
