Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Tue, 9 Jun 2015 08:42:00 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 17/21] libnvdimm: infrastructure for btt devices
Message-ID: <20150609064200.GE9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001541.4506.90125.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150602001541.4506.90125.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, axboe@kernel.dk, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 01, 2015 at 08:15:41PM -0400, Dan Williams wrote:
> Block devices from an nd bus, in addition to accepting "struct bio"
> based requests, also have the capability to perform byte-aligned
> accesses.  By default only the bio/block interface is used.  However, if
> another driver can make effective use of the byte-aligned capability it
> can claim/disable the block interface and use the byte-aligned "nd_io"
> interface.
> 
> The BTT driver is the initial first consumer of this mechanism to allow
> layering atomic sector update guarantees on top of nd_io capable
> libnvdimm-block-devices, or their partitions.

As mentioned during the last time of the review the layering here
is complete broken.  If you expose additional capabilities from a block
device do it at the block device level.  That is enhance the rw_page
callback to allo byte sized access, add a capability flag on the queue,
etc.
