Return-Path: <linux-kernel-owner@vger.kernel.org>
Message-ID: <1429644912.17259.31.camel@misato.fc.hp.com>
Subject: Re: [Linux-nvdimm] [PATCH 04/21] nd: create an 'nd_bus' from an
 'nfit_desc'
From: Toshi Kani <toshi.kani@hp.com>
Date: Tue, 21 Apr 2015 13:35:12 -0600
In-Reply-To: <20150418013535.25237.4770.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20150418013535.25237.4770.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2015-04-17 at 21:35 -0400, Dan Williams wrote:
 :
> +
> +static int nd_mem_init(struct nd_bus *nd_bus)
> +{
> +	struct nd_spa *nd_spa;
> +
> +	/*
> +	 * For each SPA-DCR address range find its corresponding
> +	 * MEMDEV(s).  From each MEMDEV find the corresponding DCR.
> +	 * Then, try to find a SPA-BDW and a corresponding BDW that
> +	 * references the DCR.  Throw it all into an nd_mem object.
> +	 * Note, that BDWs are optional.
> +	 */
> +	list_for_each_entry(nd_spa, &nd_bus->spas, list) {
> +		u16 spa_index = readw(&nd_spa->nfit_spa->spa_index);
> +		int type = nfit_spa_type(nd_spa->nfit_spa);
> +		struct nd_mem *nd_mem, *found;
> +		struct nd_memdev *nd_memdev;
> +		u16 dcr_index;
> +
> +		if (type != NFIT_SPA_DCR)
> +			continue;

This function requires NFIT_SPA_DCR, SPA Range Structure with NVDIMM
Control Region GUID, for initializing an nd_mem object.  However,
battery-backed DIMMs do not have such control region SPA.  IIUC, the
NFIT spec does not require NFIT_SPA_DCR.

Can you change this function to work with NFIT_SPA_PM as well?

Thanks,
-Toshi      


