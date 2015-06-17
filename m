Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v6 03/21] libnvdimm: control character device and nvdimm_bus sysfs attributes
Date: Thu, 18 Jun 2015 00:00:24 +0200
Message-ID: <55195804.2G24WjSeEI@vostro.rjw.lan>
In-Reply-To: <20150611201024.25175.7686.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201024.25175.7686.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, mingo@kernel.org, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, axboe@kernel.dk, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, June 11, 2015 04:10:24 PM Dan Williams wrote:
> The control device for a nvdimm_bus is registered as an "nd" class
> device.  The expectation is that there will usually only be one "nd" bus
> registered under /sys/class/nd.  However, we allow for the possibility
> of multiple buses and they will listed in discovery order as
> ndctl0...ndctlN.  This character device hosts the ioctl for passing
> control messages.  The initial command set has a 1:1 correlation with
> the commands listed in the by the "NFIT DSM Example" document [1], but
> this scheme is extensible to future command sets.
> 
> Note, nd_ioctl() and the backing ->ndctl() implementation are defined in
> a subsequent patch.  This is simply the initial registrations and sysfs
> attributes.
> 
> [1]: http://pmem.io/documents/NVDIMM_DSM_Interface_Example.pdf
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

