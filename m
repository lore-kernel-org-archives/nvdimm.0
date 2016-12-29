Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F31268194A
 for <linux-nvdimm@lists.01.org>; Thu, 29 Dec 2016 10:23:16 -0800 (PST)
Received: by mail-oi0-x229.google.com with SMTP id 128so209651843oig.0
 for <linux-nvdimm@lists.01.org>; Thu, 29 Dec 2016 10:23:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20161228234321.GA27417@ZenIV.linux.org.uk>
References: <20161026155021.20892-1-brian.boylston@hpe.com>
 <20161026155021.20892-2-brian.boylston@hpe.com> <58110959.90901@plexistor.com>
 <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com> <20161228234321.GA27417@ZenIV.linux.org.uk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Dec 2016 10:23:15 -0800
Message-ID: <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] introduce memcpy_nocache()
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
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Dec 28, 2016 at 3:43 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Nov 01, 2016 at 04:25:12PM +0200, Boaz Harrosh wrote:
>
>> >> What about memcpy_to_pmem() in linux/pmem.h it already has all the arch switches.
>> >>
>> >> Feels bad to add yet just another arch switch over __copy_user_nocache
>> >>
>> >> Just feels like too many things that do the same thing. Sigh
>> >
>> > I agree that this looks like a nicer path.
>> >
>> > I had considered adjusting copy_from_iter_nocache() to use memcpy_to_pmem(),
>> > but lib/iov_iter.c doesn't currently #include linux/pmem.h.  Would it be
>> > acceptable to add it?  Also, I wasn't sure if memcpy_to_pmem() would always
>> > mean exactly "memcpy nocache".
>> >
>>
>> I think this is the way to go. In my opinion there is no reason why not to include
>> pmem.h into lib/iov_iter.c.
>>
>> And I think memcpy_to_pmem() would always be the fastest arch way to bypass cache
>> so it should be safe to use this for all cases. It is so in the arches that support
>> this now, and I cannot imagine a theoretical arch that would differ. But let the
>> specific arch people holler if this steps on their tows, later when they care about
>> this at all.
>
> First of all, if it's the fastest arch way to bypass cache, why the hell
> is it sitting in pmem-related areas?

Agreed, pmem has little to do with a cache avoiding memcpy. I believe
there are embedded platforms in the field that have system wide
batteries and arrange for cpu caches to be flushed on power loss. So a
cache avoiding memory copy may not always be the best choice for pmem.

> More to the point, x86 implementation of that thing is tied to uaccess API
> for no damn reason whatsoever.  Let's add a real memcpy_nocache() and
> be done with that.  I mean, this
>         if (WARN(rem, "%s: fault copying %p <- %p unwritten: %d\n",
>                                 __func__, dst, src, rem))
>                 BUG();
> is *screaming* "API misused here".  And let's stay away from the STAC et.al. -
> it's pointless for kernel-to-kernel copies.

Yes, that's my turd and I agree we should opt for a generic cache
bypassing copy.

> BTW, your "it's iovec, only non-temporal stores there" logics in
> arch_copy_from_iter_pmem() is simply wrong - for one thing, unaligned
> copies will have parts done via normal stores, for another 32bit will
> _not_ go for non-caching codepath for short copies.  What semantics do
> we really need there?

For typical pmem platforms we need to make sure all the writes are on
the way to memory such than a later sfence can guarantee that all
previous writes are visible to the platform "ADR" logic.  ADR handles
flushing memory controller write buffers to media. At a minimum
arch_copy_from_iter_pmem() needs to trigger a clwb (unordered cache
line writeback) of each touched cache line if it is not using a cache
bypassing store.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
