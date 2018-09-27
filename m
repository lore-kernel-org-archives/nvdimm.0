Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 137B8211350E1
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 12:35:03 -0700 (PDT)
Date: Thu, 27 Sep 2018 13:37:12 -0600
From: Keith Busch <keith.busch@linux.intel.com>
Subject: Re: [PATCH 3/3] tools/testing/nvdimm: Populate dirty shutdown data
Message-ID: <20180927193711.GF19589@localhost.localdomain>
References: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153802227683.833068.14067072355792705345.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <153802227683.833068.14067072355792705345.stgit@dwillia2-desk3.amr.corp.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 26, 2018 at 09:24:36PM -0700, Dan Williams wrote:
> +/* strong / override definition of nfit_intel_shutdown_status */
> +void nfit_intel_shutdown_status(struct nfit_mem *nfit_mem)
> +{
> +	set_bit(NFIT_MEM_DIRTY_COUNT, &nfit_mem->flags);
> +	nfit_mem->dirty_shutdown = 42;
> +}

That's a lot of dirty shutdowns! Better bring a towel.

Reviewed-by: Keith Busch <keith.busch@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
