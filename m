Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v6 02/21] libnvdimm, nfit: initial libnvdimm infrastructure and NFIT support
Date: Wed, 17 Jun 2015 23:59:29 +0200
Message-ID: <1863642.qegEO3HtMW@vostro.rjw.lan>
In-Reply-To: <20150611201018.25175.78715.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150611183830.25175.51256.stgit@dwillia2-desk3.amr.corp.intel.com> <20150611201018.25175.78715.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, mingo@kernel.org, sfr@canb.auug.org.au, rafael@kernel.org, neilb@suse.de, gregkh@linuxfoundation.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, linux-kernel@vger.kernel.org, Robert Moore <robert.moore@intel.com>, linux-acpi@vger.kernel.org, jmoyer@redhat.com, Lv Zheng <lv.zheng@intel.com>, linux-api@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

On Thursday, June 11, 2015 04:10:18 PM Dan Williams wrote:
> A struct nvdimm_bus is the anchor device for registering nvdimm
> resources and interfaces, for example, a character control device,
> nvdimm devices, and I/O region devices.  The ACPI NFIT (NVDIMM Firmware
> Interface Table) is one possible platform description for such
> non-volatile memory resources in a system.  The nfit.ko driver attaches
> to the "ACPI0012" device that indicates the presence of the NFIT and
> parses the table to register a struct nvdimm_bus instance.
> 
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Lv Zheng <lv.zheng@intel.com>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[cut]

> +
> +static struct acpi_driver acpi_nfit_driver = {
> +	.name = KBUILD_MODNAME,
> +	.ids = acpi_nfit_ids,
> +	.flags = ACPI_DRIVER_ALL_NOTIFY_EVENTS,

But this flag is not needed for now IMO.

> +	.ops = {
> +		.add = acpi_nfit_add,
> +		.remove = acpi_nfit_remove,
> +	},
> +};
> +

