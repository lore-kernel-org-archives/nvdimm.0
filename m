Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Sat, 18 Apr 2015 12:29:33 -0700
Message-ID: <CAPcyv4jaYZXxOps=rv5nyD_WN9Oi6o1+Ufi8Buucs597=xWYHA@mail.gmail.com>
Subject: Re: [PATCH 00/21] ND: NFIT-Defined / NVDIMM Subsystem
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Boaz Harrosh <boaz@plexistor.com>, Vishal Verma <vishal.l.verma@linux.intel.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Dave Chinner <david@fromorbit.com>, Robert Moore <robert.moore@intel.com>, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>, Nicholas Moulin <nicholas.w.moulin@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 17, 2015 at 6:35 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Since 2010 Intel has included non-volatile memory support on a few
> storage-focused platforms with a feature named ADR (Asynchronous DRAM
> Refresh).  These platforms were mostly targeted at custom applications
> and never enjoyed standard discovery mechanisms for platform firmware
> to advertise non-volatile memory capabilities.  This now changes with
> the publication of version 6 of the ACPI specification [1] and its
> inclusion of a new table for describing platform memory capabilities.
> The NVDIMM Firmware Interface Table (NFIT), along with new EFI and E820
> memory types, enumerates persistent memory ranges, memory-mapped-I/O
> apertures, physical memory devices (DIMMs), and their associated
> properties.
>
> The ND-subsystem wraps a Linux device driver model around the objects
> and address boundaries defined in the specification and introduces 3 new
> drivers.
>
>   nd_pmem: NFIT enabled version of the existing 'pmem' driver [2]
>   nd_blk: mmio aperture method for accessing persistent storage
>   nd_btt: give persistent memory disk semantics (atomic sector update)
>
> See the documentation in patch2 for more details, and there is
> supplemental documentation on pmem.io [4].  Please review, and
> patches welcome...
>
> For kicking the tires, this release is accompanied by a userspace
> management library 'ndctl' that includes unit tests (make check) for all
> of the kernel ABIs.  The nfit_test.ko module can be used to explore a
> sample NFIT topology.
>
> [1]: http://www.uefi.org/sites/default/files/resources/ACPI_6.0.pdf
> [2]: https://git.kernel.org/cgit/linux/kernel/git/tip/tip.git/log/?h=x86/pmem
> [3]: https://github.com/pmem/ndctl
> [4]: http://pmem.io/documents/

nd.git and ndctl.git trees are now up to date.  I'll aim to keep
nd.git non-rebasing, but what eventually goes upstream is likely to be
a re-flowed patch set.  ndctl.git won't rebase.

nd.git: git://git.kernel.org/pub/scm/linux/kernel/git/djbw/nvdimm.git nd
ndctl.git: https://github.com/pmem/ndctl.git
