Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v6 04/21] libnvdimm, nfit: dimm/memory-devices
Date: Thu, 18 Jun 2015 00:02:36 +0200
Message-ID: <5712483.M5Qq03eyr9@vostro.rjw.lan>
In-Reply-To: <20150611201029.25175.58115.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201029.25175.58115.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, mingo@kernel.org, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, jmoyer@redhat.com, axboe@kernel.dk, linux-api@vger.kernel.org, akpm@linux-foundation.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, June 11, 2015 04:10:29 PM Dan Williams wrote:
> Enable nvdimm devices to be registered on a nvdimm_bus.  The kernel
> assigned device id for nvdimm devicesis dynamic.  If userspace needs a
> more static identifier it should consult a provider-specific attribute.
> In the case where NFIT is the provider, the 'nmemX/nfit/handle' or
> 'nmemX/nfit/serial' attributes may be used for this purpose.
> 
> Cc: Neil Brown <neilb@suse.de>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

For the ACPI part:

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

