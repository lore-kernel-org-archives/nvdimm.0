Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5D32F222A334D
 for <linux-nvdimm@lists.01.org>; Wed, 31 Jan 2018 09:26:37 -0800 (PST)
Date: Wed, 31 Jan 2018 10:32:12 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v4 4/4] nfit-test: Add platform cap support from ACPI
 6.2a to test
Message-ID: <20180131173212.GA20346@linux.intel.com>
References: <151735800899.47256.2204307128644539213.stgit@djiang5-desk3.ch.intel.com>
 <151735809953.47256.4760206674183250692.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151735809953.47256.4760206674183250692.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jan 30, 2018 at 05:21:39PM -0700, Dave Jiang wrote:
> Adding NFIT platform capabilities sub table in nfit_test simulated ACPI
> NFIT table. Only the first NFIT table is added with the capability
> sub-table.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  tools/testing/nvdimm/test/nfit.c |   14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/nvdimm/test/nfit.c b/tools/testing/nvdimm/test/nfit.c
> index 7217b2b953b5..f4791e6e70cf 100644
> --- a/tools/testing/nvdimm/test/nfit.c
> +++ b/tools/testing/nvdimm/test/nfit.c
> @@ -881,7 +881,8 @@ static int nfit_test0_alloc(struct nfit_test *t)
>  					window_size) * NUM_DCR
>  			+ sizeof(struct acpi_nfit_data_region) * NUM_BDW
>  			+ (sizeof(struct acpi_nfit_flush_address)
> -					+ sizeof(u64) * NUM_HINTS) * NUM_DCR;
> +					+ sizeof(u64) * NUM_HINTS) * NUM_DCR
> +			+ sizeof(struct acpi_nfit_capabilities);
>  	int i;
>  
>  	t->nfit_buf = test_alloc(t, nfit_size, &t->nfit_dma);
> @@ -993,6 +994,7 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	struct acpi_nfit_control_region *dcr;
>  	struct acpi_nfit_data_region *bdw;
>  	struct acpi_nfit_flush_address *flush;
> +	struct acpi_nfit_capabilities *pcap;
>  	unsigned int offset, i;
>  
>  	/*
> @@ -1500,8 +1502,16 @@ static void nfit_test0_setup(struct nfit_test *t)
>  	for (i = 0; i < NUM_HINTS; i++)
>  		flush->hint_address[i] = t->flush_dma[3] + i * sizeof(u64);
>  
> +	/* platform capabilities */
> +	pcap = nfit_buf + offset + flush_hint_size * 4;
> +	pcap->header.type = ACPI_NFIT_TYPE_CAPABILITIES;
> +	pcap->header.length = sizeof(*pcap);
> +	pcap->highest_capability = BIT(2);

One last thing I noticed: I'm pretty sure this needs to be 
	pcap->highest_capability = 1;

The way I read the spec, this is the value of the highest bit index which is
valid.  We define bits 0 and 1, so this should be 1.  BIT(2) = 0x4, which
gives us a mask of 0x1f for bits 0, 1, 2, 3, and 4.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
