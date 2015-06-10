Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Wed, 10 Jun 2015 09:33:16 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v5 05/21] libnvdimm: control (ioctl) messages for
	libnvdimm bus and dimm devices
Message-ID: <20150610073316.GB3369@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com> <20150602001435.4506.42614.stgit@dwillia2-desk3.amr.corp.intel.com> <20150609063418.GB9804@lst.de> <CAPcyv4jmHpg4YrseBWH-k=achv4N-V8n2X0CkFw+-AFsiRuH8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4jmHpg4YrseBWH-k=achv4N-V8n2X0CkFw+-AFsiRuH8A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 08, 2015 at 11:57:42PM -0700, Dan Williams wrote:
> Data payload size for one, these commands transfer more than a page
> worth of data at a time.
> 
> Even if we killed the ioctl interface to userspace we still need all
> the ugly data marshaling code in the kernel to craft properly
> formatted ACPI _DSM messages.  I try to share as much common
> infrastructure from the ACPI _DSM implementation to the ioctl
> interface (nd_cmd_dimm_desc() + nd_cmd_bus_desc()).

Ok.  Not a fan of these dual interfaces but in this case they might be
justified.
