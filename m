Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AEC4F22402E17
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 09:30:15 -0800 (PST)
Date: Wed, 28 Feb 2018 10:36:21 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH 3/5] acpi, nfit: Add function to look up nvdimm device
 and provide SMBIOS handle
Message-ID: <20180228173621.GA12883@linux.intel.com>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180222195811.27237-4-tony.luck@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180222195811.27237-4-tony.luck@intel.com>
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
To: Tony Luck <tony.luck@intel.com>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>, Borislav Petkov <bp@suse.de>, Len Brown <lenb@kernel.org>, Lv Zheng <lv.zheng@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 22, 2018 at 11:58:09AM -0800, Tony Luck wrote:
> EDAC driver needs to look up attributes of NVDIMMs provided in SMBIOS.
> 
> Provide a function that looks up an acpi_nfit_memory_map from a device
> handle (node/socket/mc/channel/dimm) and returns the SMBIOS handle.
> Also pass back the "flags" so we can see if the NVDIMM is OK.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
<>
> diff --git a/include/acpi/nfit.h b/include/acpi/nfit.h
> new file mode 100644
> index 000000000000..6ccc6eacd855
> --- /dev/null
> +++ b/include/acpi/nfit.h
> @@ -0,0 +1,26 @@
> +/*
> + * Copyright(c) 2017 Intel Corporation. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of version 2 of the GNU General Public License as
> + * published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope that it will be useful, but
> + * WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + */

Just a quick nit - I think we're supposed to use SPDX license identifiers for
new files?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
