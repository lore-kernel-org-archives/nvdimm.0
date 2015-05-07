Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Thu, 7 May 2015 09:29:13 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [Linux-nvdimm] [PATCH v2 00/20] libnd: non-volatile memory
	device support
Message-ID: <20150507072913.GB23239@lst.de>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com> <94D0CD8314A33A4D9D801C0FE68B40295A8C934B@G9W0745.americas.hpqcorp.net> <CAPcyv4g-M6NPVV4C3nB7DebhwuuzNKbNyYGDPKh_3N54P2b4Cw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g-M6NPVV4C3nB7DebhwuuzNKbNyYGDPKh_3N54P2b4Cw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Neil Brown <neilb@suse.de>, Dave Chinner <david@fromorbit.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>, "Moore, Robert" <robert.moore@intel.com>, Ingo Molnar <mingo@kernel.org>, "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 03:15:54PM -0700, Dan Williams wrote:
> > lsblk's blkdev_scsi_type_to_name() considers 4 to mean
> > SCSI_TYPE_WORM (write once read many ... used for certain optical
> > and tape drives).
> 
> Why is lsblk assuming these are scsi devices?  I'll need to go check that out.

It's a very common assumption unfortunately.  I rember fixing it in
various in-house tools at customers and stumbled over it in targetcli
recently.

Please use a prefix for your type attribute to avoid this problem.
