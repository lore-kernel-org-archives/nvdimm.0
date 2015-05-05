Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v2 00/20] libnd: non-volatile memory device support
Date: Tue, 05 May 2015 02:06:40 +0200
Message-ID: <9076255.5kM0LKa3dN@vostro.rjw.lan>
In-Reply-To: <CAPcyv4hT0DGOd8Fqs7eLqJG1hrFVgAWozuY3o5oucTYv+22Sog@mail.gmail.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com> <2127273.OhQ7MIpEUu@vostro.rjw.lan> <CAPcyv4hT0DGOd8Fqs7eLqJG1hrFVgAWozuY3o5oucTYv+22Sog@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, Christoph Hellwig <hch@lst.de>, Linux ACPI <linux-acpi@vger.kernel.org>, Jeff Moyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, Matthew Wilcox <willy@linux.intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tuesday, April 28, 2015 06:22:05 PM Dan Williams wrote:
> On Tue, Apr 28, 2015 at 5:25 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > On Tuesday, April 28, 2015 02:24:12 PM Dan Williams wrote:
> >> Changes since v1 [1]: Incorporates feedback received prior to April 24.
> >>

[cut]

> >
> > I'm wondering what's wrong with CCing all of the series to linux-acpi?
> >
> > Is there anything in it that the people on that list should not see, by any
> > chance?
> 
> linux-acpi may not care about the dimm-metadata labeling patches that
> are completely independent of ACPI, but might as well include
> linux-acpi on the whole series at this point.

I've gone through the ACPI-related patches in this series (other than [2/20]
that I've commented directly) and while I haven't found anything horrible in
them, I don't quite feel confident enough to ACK them.

What I'm really missing in this series is a design document describing all that
from a high-level perspective and making it clear where all of the pieces go
and what their respective roles are.  Also reordering the series to introduce
the nd subsystem to start with and then its users might help here.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
