Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C84552034D8E6
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 04:58:29 -0800 (PST)
Date: Wed, 28 Feb 2018 14:04:10 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 0/5] Teach EDAC about non-volatile DIMMs and add partial
 support to skx_edac
Message-ID: <20180228130410.GC3769@pd.tnic>
References: <20180222195811.27237-1-tony.luck@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180222195811.27237-1-tony.luck@intel.com>
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
To: Tony Luck <tony.luck@intel.com>, Dan Williams <dan.j.williams@intel.com>, Jean Delvare <jdelvare@suse.com>
Cc: Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-nvdimm@lists.01.org, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 22, 2018 at 11:58:06AM -0800, Tony Luck wrote:
> This series was posted as RFC and got some review back in December:
> 
>    https://marc.info/?l=linux-edac&m=151257213825419&w=2
> 
> It couldn't go upstream back then because I was waiting for some updates
> to the ACPICA headers for NFIT support.  Those patches are complete now,
> so here is the series again.
> 
> The "partial support" part is that the changes here only do the detection of
> the non-volatile DIMMs. Coming later will be another patch/series to teach
> skx_edac how to decode system addresses to NVDIMM addresses. But this part
> stands on its own and is a useful first step.
> 
> Tony Luck (5):
>   EDAC: Drop duplicated array of strings for memory type names
>   edac: Add new memory type for non-volatile DIMMs
>   acpi, nfit: Add function to look up nvdimm device and provide SMBIOS
>     handle
>   firmware: dmi: Add function to look up a handle and return DIMM size
>   EDAC, skx_edac: Detect non-volatile DIMMs
> 
>  drivers/acpi/nfit/core.c     | 27 ++++++++++++++++++
>  drivers/edac/Kconfig         |  5 +++-
>  drivers/edac/edac_mc.c       | 41 +++++++++++++-------------
>  drivers/edac/edac_mc_sysfs.c | 26 ++---------------
>  drivers/edac/skx_edac.c      | 68 ++++++++++++++++++++++++++++++++++++++++----
>  drivers/firmware/dmi_scan.c  | 31 ++++++++++++++++++++
>  include/acpi/nfit.h          | 26 +++++++++++++++++
>  include/linux/dmi.h          |  2 ++
>  include/linux/edac.h         |  3 ++
>  9 files changed, 178 insertions(+), 51 deletions(-)
>  create mode 100644 include/acpi/nfit.h

Series looks ok to me.

Dan, I could route patch 3 through the EDAC tree if you'd prefer.

Jean, ditto for patch 4.

Thanks.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
