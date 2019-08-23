Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3B2FF21959CB2
 for <linux-nvdimm@lists.01.org>; Fri, 23 Aug 2019 11:14:37 -0700 (PDT)
Subject: Re: [PATCH 0/3] libnvdimm/security: Enumerate the frozen state and
 other cleanups
References: <156583201347.2815870.4687949334637966672.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <20fe41f4-80d7-521b-0517-267e3754c372@intel.com>
Date: Fri, 23 Aug 2019 11:11:56 -0700
MIME-Version: 1.0
In-Reply-To: <156583201347.2815870.4687949334637966672.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>



On 8/14/19 6:20 PM, Dan Williams wrote:
> Jeff reported a scenario where ndctl was failing to unlock DIMMs [1].
> Through the course of debug it was discovered that the security
> interface on the DIMMs was in the 'frozen' state disallowing unlock, or
> any security operation.  Unfortunately the kernel only showed that the
> DIMMs were 'locked', not 'locked' and 'frozen'.
> 
> Introduce a new sysfs 'frozen' attribute so that ndctl can reflect the
> "security-operations-allowed" state independently of the lock status.
> Then, followup with cleanups related to replacing a security-state-enum
> with a set of flags.
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2019-August/022856.html
> ---
> 
> Dan Williams (3):
>       libnvdimm/security: Introduce a 'frozen' attribute
>       libnvdimm/security: Tighten scope of nvdimm->busy vs security operations
>       libnvdimm/security: Consolidate 'security' operations
> 
> 
>  drivers/acpi/nfit/intel.c        |   65 +++++++-----
>  drivers/nvdimm/bus.c             |    2 
>  drivers/nvdimm/dimm_devs.c       |  134 ++++++--------------------
>  drivers/nvdimm/nd-core.h         |   51 ++++------
>  drivers/nvdimm/security.c        |  199 +++++++++++++++++++++++++-------------
>  include/linux/libnvdimm.h        |    9 +-
>  tools/testing/nvdimm/dimm_devs.c |   19 +---
>  7 files changed, 231 insertions(+), 248 deletions(-)
> 

For the series
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Thanks.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
