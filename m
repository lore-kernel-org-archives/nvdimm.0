Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4153081929
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jan 2017 17:38:56 -0800 (PST)
Received: by mail-oi0-x235.google.com with SMTP id b126so528586724oia.2
 for <linux-nvdimm@lists.01.org>; Tue, 03 Jan 2017 17:38:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170103232206.GD1555@ZenIV.linux.org.uk>
References: <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com> <20161228234321.GA27417@ZenIV.linux.org.uk>
 <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
 <20161230035252.GV1555@ZenIV.linux.org.uk>
 <CAPcyv4gC0gaT7csVb=CbwhVNxGePDcSzOMZ_RXu+Q55uY3ScnA@mail.gmail.com>
 <20161231022558.GW1555@ZenIV.linux.org.uk>
 <DF4PR84MB016972BE1CA018A9AC4BE592AB6F0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <20170102050927.GY1555@ZenIV.linux.org.uk>
 <CAPcyv4hCwH=-O0hed8kxigTvMGekBdJumXtLrZddgCXEUkrW2g@mail.gmail.com>
 <20170103232206.GD1555@ZenIV.linux.org.uk>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Jan 2017 17:38:54 -0800
Message-ID: <CAPcyv4hQ=pb=F+UUrgUZ2p2T47i6VJ+PjKTMu-Le2-mm1LEnLA@mail.gmail.com>
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

On Tue, Jan 3, 2017 at 3:22 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> On Tue, Jan 03, 2017 at 01:14:11PM -0800, Dan Williams wrote:
>
>> Robert was describing the overall flow / mechanics, but I think it is
>> easier to visualize the sfence as a flush command sent to a disk
>> device with a volatile cache. In fact, that's how we implemented it in
>> the pmem block device driver. The pmem block device registers itself
>> as requiring REQ_FLUSH to be sent to persist writes. The driver issues
>> sfence on the assumption that all writes to pmem have either bypassed
>> the cache with movnt, or are scheduled for write-back via one of the
>> flush instructions (clflush, clwb, or clflushopt).
>
> *blink*
>
> 1) memcpy_to_pmem() seems to rely upon the __copy_from_user_nocache()
> having only used movnt; it does not attempt clwb at all.

Yes, and there was a fix a while back to make sure it always used
movnt so clwb after the fact is not required:

a82eee742452 x86/uaccess/64: Handle the caching of 4-byte nocache
copies properly in __copy_user_nocache()

> 2) __copy_from_user_nocache() for short copies does not use movnt at all.
> In that case neither sfence nor clwb is issued.

For the 32bit case, yes, but the pmem driver should warn about this
when it checks platform persistent memory capabilities (i.e. x86 32bit
not supported). Ugh, we may have lost that warning for this specific
case recently, I'll go double check and fix it up.

> 3) it uses movnt only for part of copying in case of misaligned copy;
> No clwb is issued, but sfence *is* - at the very end in 64bit case,
> between movnt and copying the tail - in 32bit one.  Incidentally,
> while 64bit case takes care to align the destination for movnt part,
> 32bit one does not.
>
> How much of the above is broken and what do the callers rely upon?

32bit issues are known, but 64bit path is ok since that fix above.

> In particular, is that sfence the right thing for pmem usecases?

That sfence is not there for pmem purposes. The dax / pmem usage does
not expect memcpy_to_pmem() to fence as it may have more writes to
queue up and amortize all the writes with a later fence. This seems to
be even more evidence for moving this functionality away from the
uaccess routines to somewhere more pmem specific.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
