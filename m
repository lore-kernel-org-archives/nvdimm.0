Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C29C211CACAD
 for <linux-nvdimm@lists.01.org>; Thu,  7 Feb 2019 16:41:11 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] acpi/nfit: Fix bus command validation
Date: Fri, 8 Feb 2019 00:41:09 +0000
Message-ID: <df5958d2e4f94e1a898d53761ac13dc543a8b577.camel@intel.com>
References: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154958385172.3932544.193235520333886200.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <B19C8DBDAEA5F94DB27A3C30DB33F08D@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Verma,
List-ID: <linux-nvdimm@lists.01.org>


On Thu, 2019-02-07 at 15:57 -0800, Dan Williams wrote:
> Commit 11189c1089da "acpi/nfit: Fix command-supported detection" broke
> ND_CMD_CALL for bus-level commands. The "func = cmd" assumption is only
> valid for:
> 
>     ND_CMD_ARS_CAP
>     ND_CMD_ARS_START
>     ND_CMD_ARS_STATUS
>     ND_CMD_CLEAR_ERROR
> 
> The function number otherwise needs to be pulled from the command
> payload for:
> 
>     NFIT_CMD_TRANSLATE_SPA
>     NFIT_CMD_ARS_INJECT_SET
>     NFIT_CMD_ARS_INJECT_CLEAR
>     NFIT_CMD_ARS_INJECT_GET
> 
> Update cmd_to_func() for the bus case and call it in the common path.
> 
> Fixes: 11189c1089da ("acpi/nfit: Fix command-supported detection")
> Cc: <stable@vger.kernel.org>
> Cc: Vishal Verma <vishal.verma@intel.com>
> Reported-by: Grzegorz Burzynski <grzegorz.burzynski@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/acpi/nfit/core.c |   22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)

Looks good,
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
