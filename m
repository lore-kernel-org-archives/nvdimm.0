Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v6 11/21] libnvdimm, nfit: add interleave-set state-tracking infrastructure
Date: Thu, 18 Jun 2015 00:06:39 +0200
Message-ID: <1495615.0cZhPQCH7Y@vostro.rjw.lan>
In-Reply-To: <20150611201109.25175.32607.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201109.25175.32607.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, mingo@kernel.org, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, axboe@kernel.dk, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, June 11, 2015 04:11:09 PM Dan Williams wrote:
> On platforms that have firmware support for reading/writing per-dimm
> label space, a portion of the dimm may be accessible via an interleave
> set PMEM mapping in addition to the dimm's BLK (block-data-window
> aperture(s)) interface.  A label, stored in a "configuration data
> region" on the dimm, disambiguates which dimm addresses are accessed
> through which exclusive interface.
> 
> Add infrastructure that allows the kernel to block modifications to a
> label in the set while any member dimm is active.  Note that this is
> meant only for enforcing "no modifications of active labels" via the
> coarse ioctl command.  Adding/deleting namespaces from an active
> interleave set is always possible via sysfs.
> 
> Another aspect of tracking interleave sets is tracking their integrity
> when DIMMs in a set are physically re-ordered.  For this purpose we
> generate an "interleave-set cookie" that can be recorded in a label and
> validated against the current configuration.  It is the bus provider
> implementation's responsibility to calculate the interleave set cookie
> and attach it to a given region.
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

