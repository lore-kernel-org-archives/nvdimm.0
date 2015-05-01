Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1430502493.23761.145.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH v2 05/20] libnd, nd_acpi:
 dimm/memory-devices
From: Toshi Kani <toshi.kani@hp.com>
Date: Fri, 01 May 2015 11:48:13 -0600
In-Reply-To: <20150428182439.35812.81191.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150428181203.35812.60474.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150428182439.35812.81191.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Robert Moore <robert.moore@intel.com>, linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2015-04-28 at 14:24 -0400, Dan Williams wrote:
> Register the memory devices described in the nfit as libnd 'dimm'
> devices on an nd bus.  The kernel assigned device id for dimms is
> dynamic.  If userspace needs a more static identifier it should consult
> a provider-specific attribute.  In the case where NFIT is the provider,
> the 'nmemX/nfit/handle' or 'nmemX/nfit/serial' attributes may be used
> for this purpose.
 :
> +
> +static int nd_acpi_register_dimms(struct acpi_nfit_desc *acpi_desc)
> +{
> +	struct nfit_mem *nfit_mem;
> +
> +	list_for_each_entry(nfit_mem, &acpi_desc->dimms, list) {
> +		struct nd_dimm *nd_dimm;
> +		unsigned long flags = 0;
> +		u32 nfit_handle;
> +
> +		nfit_handle = __to_nfit_memdev(nfit_mem)->nfit_handle;
> +		nd_dimm = nd_acpi_dimm_by_handle(acpi_desc, nfit_handle);
> +		if (nd_dimm) {
> +			/*
> +			 * If for some reason we find multiple DCRs the
> +			 * first one wins
> +			 */
> +			dev_err(acpi_desc->dev, "duplicate DCR detected: %s\n",
> +					nd_dimm_name(nd_dimm));
> +			continue;
> +		}
> +
> +		if (nfit_mem->bdw && nfit_mem->memdev_pmem)
> +			flags |= NDD_ALIASING;

Does this check work for a NVDIMM card which has multiple pmem regions
with label info, but does not have any bdw region configured?

The code assumes that namespace_pmem (NDD_ALIASING) and namespace_blk
have label info.  There may be an NVDIMM card with a single blk region
without label info.

Instead of using the namespace types to assume the label info, how about
adding a flag to indicate the presence of the label info?  This avoids
the separation of namespace_io and namespace_pmem for the same pmem
driver.

Thanks,
-Toshi


