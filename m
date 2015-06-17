Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150617112654.GA9246@lst.de>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150617112654.GA9246@lst.de>
Date: Wed, 17 Jun 2015 10:28:07 -0700
Message-ID: <CAPcyv4j-f+vSF5QXNy5RrqW-pXNg1dKeusGvcBFhz8ygLnSFig@mail.gmail.com>
Subject: Re: [PATCH v6 00/21] libnvdimm: non-volatile memory devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, Lv Zheng <lv.zheng@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Jens Axboe <axboe@kernel.dk>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 17, 2015 at 4:26 AM, Christoph Hellwig <hch@lst.de> wrote:
> Still not a big fan of the spec, but I guess this is a mosly reasonable
> implementation now.
>
> So for patches 1-16:
>
> Acked-by: Christoph Hellwig <hch@lst.de>

Thanks Christoph!

> The btt integration still needs a proper patch split and review, and

Ok, I'll split all the patches that are dependent on ->rw_bytes() to
their own series, and break out the introduction of ->rw_bytes() to be
patch1 of that series.

> I still detest the mess with the test moduly by heart.

The only remaining risk I see of merging this is that it requires
someone making changes to either the libnvdimm implementation or the
routines being mocked (ioremap, __request_region, etc...) to think
through the implications to the unit test.  That's a maintenance
burden given that mocked interfaces are deliberately working around
base assumptions.  At a minimum I need to document what rules the
__wrap_* routines in tools/testing/nvdimm/test/iomap.c are violating
and why.

I'm not convinced that the maintenance burden overshadows the benefit
of having this infrastructure readily available.  It is the primary
reason we've been able to iterate the code with confidence at this
velocity and magnitude of feedback.
