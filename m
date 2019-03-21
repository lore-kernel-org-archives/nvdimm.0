Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D5911211E2BE5
 for <linux-nvdimm@lists.01.org>; Wed, 20 Mar 2019 17:23:02 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH v2 1/4] libndctl: add support for
 NVDIMM_FAMILY_HYPERV's _DSM Function 1
Date: Thu, 21 Mar 2019 00:22:59 +0000
Message-ID: <b883122b7bbbe46d4895136ebac7305defb03e91.camel@intel.com>
References: <PU1P153MB016988DC99DD57082BEC6006BF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB016988DC99DD57082BEC6006BF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
Content-Language: en-US
Content-ID: <0007F59577E0F947B3DCF68A5AA11C36@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "decui@microsoft.com" <decui@microsoft.com>, "Jiang, Dave" <dave.jiang@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "jthumshirn@suse.de" <jthumshirn@suse.de>, "mikelley@microsoft.com" <mikelley@microsoft.com>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dexuan,

Thanks for these patches - I had a few comments below.

Also on a more general note, the patches in this series don't appear to
be correctly threaded. Normally, patch emails in a series are replies to
the first patch (either 1/N or the cover letter), and this allows for
easier review as all related emails can be found in a single top-level
thread. It would be nice if you can fix this for the future - git send-
email should do this correctly automatically, if you use it for sending
the patches.


On Wed, 2019-02-20 at 05:10 +0000, Dexuan Cui wrote:
> This patch retrieves the health info by Hyper-V _DSM method Function 1:
> 

We should never use "This patch.." in a commit message. See 4.c in [1].

[1]: https://www.ozlabs.org/~akpm/stuff/tpp.txt


> Get Health Information (Function Index 1)
> See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901").
> 
> Now "ndctl list --dimms --health --idle" can show a line "health_state":"ok",
> e.g.
> 
>   {
>     "dev":"nmem0",
>     "id":"04d5-01-1701-00000000",
>     "handle":0,
>     "phys_id":0,
>     "health":{
>       "health_state":"ok"
>     }
>   }
> 
> If there is an error with the NVDIMM, the "ok" will be replaced with "unknown",
> "fatal", "critical", or "non-critical".
> 
> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> ---
>  ndctl/lib/Makefile.am |   1 +
>  ndctl/lib/hyperv.c    | 129 ++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/hyperv.h    |  51 +++++++++++++++++
>  ndctl/lib/libndctl.c  |   2 +
>  ndctl/lib/private.h   |   3 +
>  ndctl/ndctl.h         |   1 +
>  6 files changed, 187 insertions(+)
>  create mode 100644 ndctl/lib/hyperv.c
>  create mode 100644 ndctl/lib/hyperv.h
> 
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index 7797039..fb75fda 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -20,6 +20,7 @@ libndctl_la_SOURCES =\
>  	intel.c \
>  	hpe1.c \
>  	msft.c \
> +	hyperv.c \
>  	ars.c \
>  	firmware.c \
>  	libndctl.c
> diff --git a/ndctl/lib/hyperv.c b/ndctl/lib/hyperv.c
> new file mode 100644
> index 0000000..b303d50
> --- /dev/null
> +++ b/ndctl/lib/hyperv.c
> @@ -0,0 +1,129 @@
> +/*
> + * Copyright (c) 2019, Microsoft Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU Lesser General Public License,
> + * version 2.1, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
> + * more details.
> + */

For new files, use the SPDX license identifiers, for an example, see:
https://github.com/pmem/ndctl/blob/master/ndctl/load-keys.c#L1

> +#include <stdlib.h>
> +#include <limits.h>
> +#include <util/bitmap.h>
> +#include <util/log.h>
> +#include <ndctl/libndctl.h>
> +#include "private.h"
> +#include "hyperv.h"
> +
> +#define CMD_HYPERV(_c) ((_c)->hyperv)

I'm not sure this macro improves readability, in fact I think it rather
detracts from it in many cases - see further below.
Additionally, no need for the preceeding underscore in the macro
arguments - the rest of the code base doesn't do this, and I'm not sure
what value it provides.

> +#define CMD_HYPERV_STATUS(_c) (CMD_HYPERV(_c)->u.status)
> +#define CMD_HYPERV_SMART_DATA(_c) (CMD_HYPERV(_c)->u.smart.data)

> +
> +static struct ndctl_cmd *hyperv_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
> +{
> +	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
> +	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
> +	struct ndctl_cmd *cmd;
> +	size_t size;
> +	struct nd_pkg_hyperv *hyperv;
> +
> +	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
> +		dbg(ctx, "unsupported cmd\n");
> +		return NULL;
> +	}
> +
> +	if (test_dimm_dsm(dimm, ND_HYPERV_CMD_GET_HEALTH_INFO) ==
> +			  DIMM_DSM_UNSUPPORTED) {
> +		dbg(ctx, "unsupported function\n");
> +		return NULL;
> +	}
> +
> +	size = sizeof(*cmd) + sizeof(struct nd_pkg_hyperv);
> +	cmd = calloc(1, size);
> +	if (!cmd)
> +		return NULL;
> +
> +	cmd->dimm = dimm;
> +	ndctl_cmd_ref(cmd);
> +	cmd->type = ND_CMD_CALL;
> +	cmd->size = size;
> +	cmd->status = 1;
> +
> +	hyperv = CMD_HYPERV(cmd);
> +	hyperv->gen.nd_family = NVDIMM_FAMILY_HYPERV;
> +	hyperv->gen.nd_command = ND_HYPERV_CMD_GET_HEALTH_INFO;
> +	hyperv->gen.nd_fw_size = 0;
> +	hyperv->gen.nd_size_in = offsetof(struct nd_hyperv_smart, status);
> +	hyperv->gen.nd_size_out = sizeof(hyperv->u.smart);
> +	hyperv->u.smart.status = 0;

calloc() zeroes the newly allocated memory - no need to set any of the
fields in the struct to '0' manually.

> +
> +	cmd->firmware_status = &hyperv->u.smart.status;
> +
> +	return cmd;
> +}
> +
> +static int hyperv_smart_valid(struct ndctl_cmd *cmd)
> +{
> +	if (cmd->type != ND_CMD_CALL ||
> +	    cmd->size != sizeof(*cmd) + sizeof(struct nd_pkg_hyperv) ||
> +	    CMD_HYPERV(cmd)->gen.nd_family != NVDIMM_FAMILY_HYPERV ||
> +	    CMD_HYPERV(cmd)->gen.nd_command != ND_HYPERV_CMD_GET_HEALTH_INFO ||

I feel in these cases, cmd->hyperv->stuff is /much/ more readable than
CMD_HYPERV(cmd)->stuff - and shorter as well as easier to type :)


> +	    cmd->status != 0 ||
> +	    CMD_HYPERV_STATUS(cmd) != 0)
> +		return cmd->status < 0 ? cmd->status : -EINVAL;
> +	return 0;
> +}
> +
> +static int hyperv_cmd_xlat_firmware_status(struct ndctl_cmd *cmd)
> +{
> +	return CMD_HYPERV_STATUS(cmd) == 0 ? 0 : -EINVAL;
> +}
> +
> +static unsigned int hyperv_cmd_smart_get_flags(struct ndctl_cmd *cmd)
> +{
> +	int rc;
> +
> +	rc = hyperv_smart_valid(cmd);
> +	if (rc < 0) {
> +		errno = -rc;
> +		return 0;
> +	}
> +
> +	return ND_SMART_HEALTH_VALID;
> +}
> +
> +static unsigned int hyperv_cmd_smart_get_health(struct ndctl_cmd *cmd)
> +{
> +	unsigned int health = 0;
> +	__u32 num;
> +	int rc;
> +
> +	rc = hyperv_smart_valid(cmd);
> +	if (rc < 0) {
> +		errno = -rc;
> +		return UINT_MAX;
> +	}
> +
> +	num = CMD_HYPERV_SMART_DATA(cmd)->health & 0x3F;
> +
> +	if (num & (BIT(0) | BIT(1)))
> +		health |= ND_SMART_CRITICAL_HEALTH;
> +
> +	if (num & BIT(2))
> +		health |= ND_SMART_FATAL_HEALTH;
> +
> +	if (num & (BIT(3) | BIT(4) | BIT(5)))
> +		health |= ND_SMART_NON_CRITICAL_HEALTH;
> +
> +	return health;
> +}
> +
> +struct ndctl_dimm_ops * const hyperv_dimm_ops = &(struct ndctl_dimm_ops) {
> +	.new_smart = hyperv_dimm_cmd_new_smart,
> +	.smart_get_flags = hyperv_cmd_smart_get_flags,
> +	.smart_get_health = hyperv_cmd_smart_get_health,
> +	.xlat_firmware_status = hyperv_cmd_xlat_firmware_status,
> +};
> diff --git a/ndctl/lib/hyperv.h b/ndctl/lib/hyperv.h
> new file mode 100644
> index 0000000..8e55a97
> --- /dev/null
> +++ b/ndctl/lib/hyperv.h
> @@ -0,0 +1,51 @@
> +/*
> + * Copyright (c) 2019, Microsoft Corporation.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU Lesser General Public License,
> + * version 2.1, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
> + * more details.
> + */

Same comment about SPDX License format as above.

> +#ifndef __NDCTL_HYPERV_H__
> +#define __NDCTL_HYPERV_H__
> +
> +/* See http://www.uefi.org/RFIC_LIST ("Virtual NVDIMM 0x1901") */
> +enum {
> +	ND_HYPERV_CMD_QUERY = 0,

It sounds like the intention for this function index 0 was to function
as a supported DSM mask, but the spec says it just returns a static
value. Nonetheless, should we not include some "_cmd_is_supported"
helpers, and test them before submitting the smart command in this patch
for example?

Also the name of this enum field can be a bit ambiguous - query /what/?
(In other DSM families, there are functions to query ARS status,
firmware update status, etc.). It might be better to name it something
like "ND_HYPERV_CMD_QUERY_SUPPORTED_FUNCTIONS"

> +
> +	/* non-root commands */
> +	ND_HYPERV_CMD_GET_HEALTH_INFO = 1,
> +};
> +
> +/*
> + * This is actually Function 1's data,
> + * This is the closest I can find to match the "smart".
> + * Hyper-V _DSM methods don't have a smart function.
> + */
> +struct nd_hyperv_smart_data {
> +	__u32	health;
> +} __attribute__((packed));

I'm not sure I fully understand the comment above. Generally speaking,
we should avoid comments in the first person - i.e. instead of "This is
the closest thing I found..", it should simply be "X is the closest
thing to Y".

But I think you were trying to say:

/*
 * This corresponds to 'function 1' (Get Health Information) in the
 * HYPERV DSM spec referenced above
 */


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
