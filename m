Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hMfTD9eEVD9NSG3DDT-_5d+BZHL=RHNMR8kh+iBd6FuQ@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
 <CALCETrV0gE7j+OaJ+UrV=rANrTpALKX6MXFQs6GKAMe0rSxRRw@mail.gmail.com> <CAPcyv4hMfTD9eEVD9NSG3DDT-_5d+BZHL=RHNMR8kh+iBd6FuQ@mail.gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Apr 2015 14:06:15 -0700
Message-ID: <CALCETrVJafaxJwZi1C8cAsQs51nvGFywAkNTNbc=BjE+bjBgnQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/20] libnd: non-volatile memory device support
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Christoph Hellwig <hch@lst.de>, Linux ACPI <linux-acpi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 1:59 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Apr 28, 2015 at 1:52 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> On Tue, Apr 28, 2015 at 11:24 AM, Dan Williams <dan.j.williams@intel.com> wrote:
>>> Changes since v1 [1]: Incorporates feedback received prior to April 24.
>>>
>>> 1/ Ingo said [2]:
>>>
>>>        "So why on earth is this whole concept and the naming itself
>>>        ('drivers/block/nd/' stands for 'NFIT Defined', apparently)
>>>        revolving around a specific 'firmware' mindset and revolving
>>>        around specific, weirdly named, overly complicated looking
>>>        firmware interfaces that come with their own new weird
>>>        glossary??"
>>>
>>>    Indeed, we of course consulted the NFIT specification to determine
>>>    the shape of the sub-system, but then let its terms and data
>>>    structures permeate too deep into the implementation.  That is fixed
>>>    now with all NFIT specifics factored out into acpi.c.  The NFIT is no
>>>    longer required reading to review libnd.  Only three concepts are
>>>    needed:
>>>
>>>       i/ PMEM - contiguous memory range where cpu stores are
>>>          persistent once they are flushed through the memory
>>>          controller.
>>>
>>>      ii/ BLK - mmio apertures (sliding windows) that can be
>>>          programmed to access an aperture's-worth of persistent
>>>          media at a time.
>>>
>>>     iii/ DPA - "dimm-physical-address", address space local to a
>>>          dimm.  A dimm may provide both PMEM-mode and BLK-mode
>>>          access to a range of DPA.  libnd manages allocation of DPA
>>>          to either PMEM or BLK-namespaces to resolve this aliasing.
>>
>> Mostly for my understanding: is there a name for "address relative to
>> the address lines on the DIMM"?  That is, a DIMM that exposes 8 GB of
>> apparent physical memory, possibly interleaved, broken up, or weirdly
>> remapped by the memory controller, would still have addresses between
>> 0 and 8 GB.  Some of those might be PMEM windows, some might be MMIO,
>> some might be BLK apertures, etc.
>>
>> IIUC "DPA" refers to actual addressable storage, not this type of address?
>
> No, DPA is exactly as you describe above.  You can't directly access
> it except through a PMEM mapping (possibly interleaved with DPA from
> other DIMMs) or a BLK aperture (mmio window into DPA).

So the thing I'm describing has no name, then?  Oh, well.

--Andy
