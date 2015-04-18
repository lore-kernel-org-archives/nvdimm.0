Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1429386063.16771.157.camel@x220>
Subject: Re: [PATCH 03/21] nd_acpi: initial core implementation and nfit
 skeleton
From: Paul Bolle <pebolle@tiscali.nl>
Date: Sat, 18 Apr 2015 21:41:03 +0200
In-Reply-To: <20150418013530.25237.28383.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150418013530.25237.28383.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-acpi@vger.kernel.org, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-04-17 at 21:35 -0400, Dan Williams wrote:
> --- /dev/null
> +++ b/drivers/block/nd/Kconfig

> +	depends on (X86 || IA64 || ARM || ARM64 || SH || XTENSA)

I've only skimmed this series. I still noticed this patch contains the
only Kconfig typo I know by heart. Because I think you meant to say:
	depends on (X86 || IA64 || ARM || ARM64 || SUPERH || XTENSA)

Is that right?


Paul Bolle

