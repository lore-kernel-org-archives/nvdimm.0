Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v6 19/21] libnvdimm, nfit, nd_blk: driver for BLK-mode access persistent memory
Date: Thu, 18 Jun 2015 00:09:14 +0200
Message-ID: <1633410.TKJVXEEQrM@vostro.rjw.lan>
In-Reply-To: <20150611201153.25175.83474.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201153.25175.83474.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, Boaz Harrosh <boaz@plexistor.com>, akpm@linux-foundation.org, sfr@canb.auug.org.au, neilb@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, linux-acpi@vger.kernel.org, jmoyer@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, Ross Zwisler <ross.zwisler@linux.intel.com>, linux-api@vger.kernel.org, hch@lst.de, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, June 11, 2015 04:11:53 PM Dan Williams wrote:
> From: Ross Zwisler <ross.zwisler@linux.intel.com>
> 
> The libnvdimm implementation handles allocating dimm address space (DPA)
> between PMEM and BLK mode interfaces.  After DPA has been allocated from
> a BLK-region to a BLK-namespace the nd_blk driver attaches to handle I/O
> as a struct bio based block device. Unlike PMEM, BLK is required to
> handle platform specific details like mmio register formats and memory
> controller interleave.  For this reason the libnvdimm generic nd_blk
> driver calls back into the bus provider to carry out the I/O.
> 
> This initial implementation handles the BLK interface defined by the
> ACPI 6 NFIT [1] and the NVDIMM DSM Interface Example [2] composed from
> DCR (dimm control region), BDW (block data window), IDT (interleave
> descriptor) NFIT structures and the hardware register format.
> [1]: http://www.uefi.org/sites/default/files/resources/ACPI_6.0.pdf
> [2]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> 
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

