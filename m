Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hpe.com (g4t3426.houston.hpe.com
 [15.241.140.75])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DB29B21CB74A7
 for <linux-nvdimm@lists.01.org>; Thu, 25 Oct 2018 11:54:16 -0700 (PDT)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH v2] nfit, mce: only handle uncorrectable machine checks
Date: Thu, 25 Oct 2018 18:54:12 +0000
Message-ID: <AT5PR8401MB116947C32809FB0C5802BC97ABF70@AT5PR8401MB1169.NAMPRD84.PROD.OUTLOOK.COM>
References: <20181025180605.27022-1-vishal.l.verma@intel.com>
In-Reply-To: <20181025180605.27022-1-vishal.l.verma@intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: 'Vishal Verma' <vishal.l.verma@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: Tony Luck <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On Behalf Of Vishal Verma
> Sent: Thursday, October 25, 2018 1:06 PM
...
> +++ b/drivers/acpi/nfit/mce.c
> @@ -25,8 +25,8 @@ static int nfit_handle_mce(struct notifier_block *nb, unsigned long val,
>  	struct acpi_nfit_desc *acpi_desc;
>  	struct nfit_spa *nfit_spa;
> 
> -	/* We only care about memory errors */
> -	if (!mce_is_memory_error(mce))
> +	/* We only care about uncorrectable memory errors */
> +	if (!mce_is_memory_error(mce) || mce_is_correctable(mce))
>  		return NOTIFY_DONE;

Another function that calls those functions, cec_add_mce(), also calls 
mce_usable_address() to ensure the address valid bit is set.  It doesn't
look like nfit_handle_mce() ever confirms that before proceeding to
use mce->addr (if it gets through that if statement).

---
Robert Elliott, HPE Persistent Memory


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
