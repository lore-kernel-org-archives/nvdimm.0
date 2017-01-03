Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A632F8190C
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jan 2017 13:14:12 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id 128so327425122oig.0
 for <linux-nvdimm@lists.01.org>; Tue, 03 Jan 2017 13:14:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170102050927.GY1555@ZenIV.linux.org.uk>
References: <20161026155021.20892-2-brian.boylston@hpe.com>
 <58110959.90901@plexistor.com>
 <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com> <20161228234321.GA27417@ZenIV.linux.org.uk>
 <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
 <20161230035252.GV1555@ZenIV.linux.org.uk>
 <CAPcyv4gC0gaT7csVb=CbwhVNxGePDcSzOMZ_RXu+Q55uY3ScnA@mail.gmail.com>
 <20161231022558.GW1555@ZenIV.linux.org.uk>
 <DF4PR84MB016972BE1CA018A9AC4BE592AB6F0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <20170102050927.GY1555@ZenIV.linux.org.uk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Jan 2017 13:14:11 -0800
Message-ID: <CAPcyv4hCwH=-O0hed8kxigTvMGekBdJumXtLrZddgCXEUkrW2g@mail.gmail.com>
Subject: Re: [RFC] memcpy_nocache() and memcpy_writethrough()
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 1, 2017 at 9:09 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Mon, Jan 02, 2017 at 02:35:36AM +0000, Elliott, Robert (Persistent Memory) wrote:
>> > -----Original Message-----
>> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
>> > owner@vger.kernel.org] On Behalf Of Al Viro
>> > Sent: Friday, December 30, 2016 8:26 PM
>> > Subject: [RFC] memcpy_nocache() and memcpy_writethrough()
>> >
>> ...
>> > Why does pmem need writethrough warranties, anyway?
>>
>> Using either
>> * nontemporal store instructions; or
>> * following regular store instructions with a sequence of cache flush
>> and store fence instructions (e.g., clflushopt or clwb + sfence)
>>
>> ensures that write data has reached an "ADR-safe zone" that the system
>> promises will be persistent even if there is a surprise power loss or
>> a CPU suffers from an error that isn't totally catastrophic (e.g., the
>> CPU getting disconnected from the SDRAM will always lose data on an
>> NVDIMM-N).
>
> Wait a sec...  In which places do you need sfence in all that?  movnt*
> itself can be reordered, right?  So using that for copying and storing
> the pointer afterwards would still need sfence inbetween, unless I'm
> seriously misunderstanding the situation...

Robert was describing the overall flow / mechanics, but I think it is
easier to visualize the sfence as a flush command sent to a disk
device with a volatile cache. In fact, that's how we implemented it in
the pmem block device driver. The pmem block device registers itself
as requiring REQ_FLUSH to be sent to persist writes. The driver issues
sfence on the assumption that all writes to pmem have either bypassed
the cache with movnt, or are scheduled for write-back via one of the
flush instructions (clflush, clwb, or clflushopt).

>> Newly written data becomes globally visible before it becomes ADR-safe.
>> This means software could act on the new data before a power loss, then
>> see the old data reappear after the power loss - not good.  Software
>> needs to understand that any data in the process of being written is
>> indeterminate until the persistence guarantee is met.  The BTT shows
>> one way that software can avoid that problem.
>
> Joy.  What happens in terms of latency?  I.e. how much of a stall does
> clwb inflict?

Unlike clflush, clwb is unordered, so it has lower overhead. It
schedules writeback, but does not wait for it to complete. The
clflushopt instruction is also unordered, but in addition to writeback
it also invalidates the line.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
