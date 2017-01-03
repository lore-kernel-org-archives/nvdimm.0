Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6EA47817DF
 for <linux-nvdimm@lists.01.org>; Tue,  3 Jan 2017 15:22:18 -0800 (PST)
Date: Tue, 3 Jan 2017 23:22:06 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC] memcpy_nocache() and memcpy_writethrough()
Message-ID: <20170103232206.GD1555@ZenIV.linux.org.uk>
References: <CS1PR84MB011975E5DCF3B091E53A3FB38EAD0@CS1PR84MB0119.NAMPRD84.PROD.OUTLOOK.COM>
 <5818A5C8.6040300@plexistor.com>
 <20161228234321.GA27417@ZenIV.linux.org.uk>
 <CAPcyv4gg1XNJ3E=+0HDZnx08_dvvX+Prj-rLOsXcuHHO1pBLzg@mail.gmail.com>
 <20161230035252.GV1555@ZenIV.linux.org.uk>
 <CAPcyv4gC0gaT7csVb=CbwhVNxGePDcSzOMZ_RXu+Q55uY3ScnA@mail.gmail.com>
 <20161231022558.GW1555@ZenIV.linux.org.uk>
 <DF4PR84MB016972BE1CA018A9AC4BE592AB6F0@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
 <20170102050927.GY1555@ZenIV.linux.org.uk>
 <CAPcyv4hCwH=-O0hed8kxigTvMGekBdJumXtLrZddgCXEUkrW2g@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4hCwH=-O0hed8kxigTvMGekBdJumXtLrZddgCXEUkrW2g@mail.gmail.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Moreno," Oliver" <oliver.moreno@hpe.com>, "x86@kernel.org, " <x86@kernel.org>, linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, "boylston@burromesa.net" <boylston@burromesa.net>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 03, 2017 at 01:14:11PM -0800, Dan Williams wrote:

> Robert was describing the overall flow / mechanics, but I think it is
> easier to visualize the sfence as a flush command sent to a disk
> device with a volatile cache. In fact, that's how we implemented it in
> the pmem block device driver. The pmem block device registers itself
> as requiring REQ_FLUSH to be sent to persist writes. The driver issues
> sfence on the assumption that all writes to pmem have either bypassed
> the cache with movnt, or are scheduled for write-back via one of the
> flush instructions (clflush, clwb, or clflushopt).

*blink*

1) memcpy_to_pmem() seems to rely upon the __copy_from_user_nocache()
having only used movnt; it does not attempt clwb at all.

2) __copy_from_user_nocache() for short copies does not use movnt at all.
In that case neither sfence nor clwb is issued.

3) it uses movnt only for part of copying in case of misaligned copy;
No clwb is issued, but sfence *is* - at the very end in 64bit case,
between movnt and copying the tail - in 32bit one.  Incidentally,
while 64bit case takes care to align the destination for movnt part,
32bit one does not.

How much of the above is broken and what do the callers rely upon?  In
particular, is that sfence the right thing for pmem usecases?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
