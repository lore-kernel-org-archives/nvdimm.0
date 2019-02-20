Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-002e3701.pphosted.com (mx0a-002e3701.pphosted.com
 [148.163.147.86])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 16751201B042A
 for <linux-nvdimm@lists.01.org>; Tue, 19 Feb 2019 16:07:19 -0800 (PST)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [PATCH v2 0/6] nfit/ars: Improve polling and short-ARS execution
Date: Wed, 20 Feb 2019 00:06:40 +0000
Message-ID: <c22589614fa279421b77163aeddeea99fa23be05.camel@hpe.com>
References: <155025982726.1043225.15436410616433285475.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155025982726.1043225.15436410616433285475.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <1F0D99A0D997CE40AC55572585945C39@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "erwin.tsaur@oracle.com" <erwin.tsaur@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "krzysztof.rusocki@intel.com" <krzysztof.rusocki@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2019-02-15 at 11:43 -0800, Dan Williams wrote:
> Changes since v1: [1]
> * Fix the root poll interval support to avoid a infinite loop condition
>   when the polling is faster than the ARS completion.
> * Move the introduction of scrub_flags earlier in the series and
>   introduce ARS_POLL to fix the above issue.
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2019-February/019964.html
> 
> ---
> 
> Here is a small pile of updates to better coordinate the Linux ARS state
> machine with platform-BIOS implementations. Specifically, take advantage
> of opportunities to run short-ARS whenever the ARS interface is found to
> be idle at init, always run short-ARS even if no_init_ars is specified,
> allow root to reset the exponential backoff polling interval for ARS
> completion, and protect the kernel against the consumption of stale ARS
> results.
> 
> ---
> 
> Dan Williams (6):
>       nfit/ars: Attempt a short-ARS whenever the ARS state is idle at boot
>       nfit/ars: Attempt short-ARS even in the no_init_ars case
>       nfit/ars: Remove ars_start_flags
>       nfit/ars: Introduce scrub_flags
>       nfit/ars: Allow root to busy-poll the ARS state machine
>       nfit/ars: Avoid stale ARS results
> 
> 
>  drivers/acpi/nfit/core.c |   70 ++++++++++++++++++++++++++++++++--------------
>  drivers/acpi/nfit/nfit.h |   11 +++++--
>  2 files changed, 57 insertions(+), 24 deletions(-)

The changes look good to me.  For the series:

Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks,
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
