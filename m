Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190502184337.20538-1-pasha.tatashin@soleen.com>
 <20190502184337.20538-3-pasha.tatashin@soleen.com> <cac721ed-c404-19d1-71d1-37c66df9b2a8@intel.com>
 <CAPcyv4greisKBSorzQWebcVOf2AqUH6DwbvNKMW0MQ5bCwYZrw@mail.gmail.com>
In-Reply-To: <CAPcyv4greisKBSorzQWebcVOf2AqUH6DwbvNKMW0MQ5bCwYZrw@mail.gmail.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 17 May 2019 14:10:04 -0400
Message-ID: <CA+CK2bAeLJFRDTNnUrz_JCP5DVqM2N8+09q1TX7+OCE7b5v+1A@mail.gmail.com>
Subject: Re: [v5 2/3] mm/hotplug: make remove_memory() interface useable
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, James Morris <jmorris@namei.org>, Sasha Levin <sashal@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@linux.intel.com>, Keith Busch <keith.busch@intel.com>, Vishal L Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Ross Zwisler <zwisler@kernel.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Huang, Ying" <ying.huang@intel.com>, Fengguang Wu <fengguang.wu@intel.com>, Borislav Petkov <bp@suse.de>, Bjorn Helgaas <bhelgaas@google.com>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Takashi Iwai <tiwai@suse.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, David Hildenbrand <david@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

Thank you very much for your review, my comments below:

On Mon, May 6, 2019 at 2:01 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> On Mon, May 6, 2019 at 10:57 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > > -static inline void remove_memory(int nid, u64 start, u64 size) {}
> > > +static inline bool remove_memory(int nid, u64 start, u64 size)
> > > +{
> > > +     return -EBUSY;
> > > +}
> >
> > This seems like an appropriate place for a WARN_ONCE(), if someone
> > manages to call remove_memory() with hotplug disabled.

I decided not to do WARN_ONCE(), in all likelihood compiler will
simply optimize this function out, but with WARN_ONCE() some traces of
it will remain.

> >
> > BTW, I looked and can't think of a better errno, but -EBUSY probably
> > isn't the best error code, right?

-EBUSY is the only error that is returned in case of error by real
remove_memory(), so I think it is OK to keep it here.

> >
> > > -void remove_memory(int nid, u64 start, u64 size)
> > > +/**
> > > + * remove_memory
> > > + * @nid: the node ID
> > > + * @start: physical address of the region to remove
> > > + * @size: size of the region to remove
> > > + *
> > > + * NOTE: The caller must call lock_device_hotplug() to serialize hotplug
> > > + * and online/offline operations before this call, as required by
> > > + * try_offline_node().
> > > + */
> > > +void __remove_memory(int nid, u64 start, u64 size)
> > >  {
> > > +
> > > +     /*
> > > +      * trigger BUG() is some memory is not offlined prior to calling this
> > > +      * function
> > > +      */
> > > +     if (try_remove_memory(nid, start, size))
> > > +             BUG();
> > > +}
> >
> > Could we call this remove_offline_memory()?  That way, it makes _some_
> > sense why we would BUG() if the memory isn't offline.

It is this particular code path, the second one: remove_memory(),
actually tries to remove memory and returns failure if it can't. So, I
think the current name is OK.

>
> Please WARN() instead of BUG() because failing to remove memory should
> not be system fatal.

As mentioned earlier, I will keep BUG(), because existing code does
that, and there is no good handling of this code to return on error.

Thank you,
Pavel
