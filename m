Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150428182514.35812.12126.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150428182514.35812.12126.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 28 Apr 2015 14:04:06 -0700
Message-ID: <CALCETrVLoJj6f72MraEZ3dUA9Mgr8fK17Yw-ACT7pvfB9nZ4MA@mail.gmail.com>
Subject: Re: [PATCH v2 11/20] libnd, nd_pmem: add libnd support to the pmem driver
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, Ingo Molnar <mingo@kernel.org>, Boaz Harrosh <boaz@plexistor.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 28, 2015 at 11:25 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> nd_pmem attaches to persistent memory regions and namespaces emitted by
> the nd subsystem, and, same as the original pmem driver, presents the
> system-physical-address range as a block device.
>
> The existing e820-type-12 to pmem setup is converted to a full libnd bus
> that emits an nd_namespace_io device.

Now that I think I understand what's going on, can I propose alternate
help-text wording?



[reordered the quotes]

> +config BLK_DEV_PMEM
> +       tristate "PMEM: Persistent memory block device support"
> +       depends on LIBND
> +       default LIBND
> +       help
> +         Memory ranges for PMEM are described by either an NFIT
> +         (NVDIMM Firmware Interface Table, see CONFIG_NFIT_ACPI), a
> +         non-standard OEM-specific E820 memory type (type-12, see
> +         CONFIG_X86_PMEM_LEGACY), or it is manually specified by the
> +         'memmap=nn[KMG]!ss[KMG]' kernel command line (see
> +         Documentation/kernel-parameters.txt).  This driver converts
> +         these persistent memory ranges into block devices that are
> +         capable of DAX (direct-access) file system mappings.  See
> +         Documentation/blockdev/nd.txt for more details.

How about something like:

"This driver exposes memory devices that expose byte-addressable
nonvolatile storage as block devices.  This type of block device
supports direct access (i.e. DAX) if an appropriate filesystem is
used.

This driver requires a libnd driver that supports the memory device being used."

Then there would be a sub-menu with the legacy and NFIT drivers.  (Or,
if this isn't actually configurable that way, then there could be a
reference to what needs to be configured to make this work.)

> +config ND_E820
> +       tristate "E820: Support the E820-type-12 PMEM convention"
> +       depends on X86_PMEM_LEGACY
> +       default m if X86_PMEM_LEGACY
> +       select LIBND
> +       help
> +         Prior to ACPI 6 some platforms advertised peristent memory
> +         via type-12 e820 memory ranges.  Create a libnd bus and
> +         attach an instance of the pmem driver to these ranges.
> +

How about something like:

"This driver allows libnd to work with legacy, pre-ACPI 6 NVDIMMs.
This enables such devices to be exposed as block devices using PMEM.

The legacy NVDIMM interface is problematic.  This driver will not work
if you boot using UEFI, and some NVDIMMs and motherboards that work
with this driver may require proprietary code in order to work
reliably."

--Andy
