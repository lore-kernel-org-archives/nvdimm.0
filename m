Return-Path: <linux-kernel-owner@vger.kernel.org>
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH 03/21] nd_acpi: initial core implementation and nfit skeleton
Date: Sun, 19 Apr 2015 21:12:32 +0200
Message-ID: <3621753.cpAhpD8DHH@vostro.rjw.lan>
In-Reply-To: <20150418013530.25237.28383.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com> <20150418013530.25237.28383.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.orgACPI Devel Maling List <linux-acpi@vger.kernel.org>, David Box <david.e.box@linux.intel.com>, Lv Zheng <lv.zheng@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Friday, April 17, 2015 09:35:30 PM Dan Williams wrote:
> 1/ Autodetect an NFIT table for the ACPI namespace device with _HID of
>    "ACPI0012"
> 
> 2/ Skeleton implementation to register an NFIT bus.
> 
> The NFIT provided by ACPI is the primary method by which platforms will
> discover NVDIMM resources.  However, the intent of the
> nfit_bus_descriptor abstraction is to contain "provider" specific
> details, leaving the nd core to be NFIT-provider agnostic.  This
> flexibility is exploited in later patches to implement special purpose
> providers of test and custom-defined NFITs.
> 
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Robert Moore <robert.moore@intel.com>
> Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

So as discussed internally, nfit.h will have to wait for the ACPICA's
NFIT support to prevent clashes from happening.

Also please CC *all* *patches* with "ACPI" (or "acpi" etc) anywhere in the
subject/changelog/body to linux-acpi@vger.kernel.org.

More comments likely to follow.

Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
