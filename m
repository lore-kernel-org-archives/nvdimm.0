Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150609063418.GB9804@lst.de>
References: <20150602001134.4506.45867.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150602001435.4506.42614.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20150609063418.GB9804@lst.de>
Date: Mon, 8 Jun 2015 23:57:42 -0700
Message-ID: <CAPcyv4jmHpg4YrseBWH-k=achv4N-V8n2X0CkFw+-AFsiRuH8A@mail.gmail.com>
Subject: Re: [PATCH v5 05/21] libnvdimm: control (ioctl) messages for
 libnvdimm bus and dimm devices
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@kernel.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, "Rafael J. Wysocki" <rafael@kernel.org>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, jmoyer <jmoyer@redhat.com>, linux-api@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 8, 2015 at 11:34 PM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jun 01, 2015 at 08:14:35PM -0400, Dan Williams wrote:
>> Most discovery/configuration of the libnvdimm-subsystem is done via
>> sysfs attributes.  However, some libnvdimm buses, particularly the
>> ACPI.NFIT bus, define a small set of messages that can be passed to the
>> platform.  For convenience we derive the initial libnvdimm-ioctl command
>> formats directly from the NFIT DSM Interface Example formats.
>
> Why not merge these into the extensive sysfs interface?

Data payload size for one, these commands transfer more than a page
worth of data at a time.

Even if we killed the ioctl interface to userspace we still need all
the ugly data marshaling code in the kernel to craft properly
formatted ACPI _DSM messages.  I try to share as much common
infrastructure from the ACPI _DSM implementation to the ioctl
interface (nd_cmd_dimm_desc() + nd_cmd_bus_desc()).
