Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B444721DFA7BA
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 15:01:48 -0700 (PDT)
Subject: Re: [PATCH v2] libndctl: add support for the MSFT family of DSM
 functions
References: <20170326201753.1522-1-lijunpan2000@gmail.com>
From: Linda Knippers <linda.knippers@hpe.com>
Message-ID: <58DADD44.1040403@hpe.com>
Date: Tue, 28 Mar 2017 18:01:40 -0400
MIME-Version: 1.0
In-Reply-To: <20170326201753.1522-1-lijunpan2000@gmail.com>
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
To: Lijun Pan <lijunpan2000@gmail.com>, linux-nvdimm@lists.01.org
Cc: Lijun Pan <Lijun.Pan@dell.com>, Stuart Hayes <Stuart.Hayes@dell.com>
List-ID: <linux-nvdimm@lists.01.org>

On 03/26/2017 04:17 PM, Lijun Pan wrote:
> From: Lijun Pan <Lijun.Pan@dell.com>
> 
> This patch retrieves the health data from NVDIMM-N via
> the MSFT _DSM function[1], following JESD245A[2] standards.
> Now 'ndctl list --dimms --health --idle' could work
> on MSFT type NVDIMM-N, but limited to health_state,
> temperature_celsius, and life_used_percentage.
> 
> [1]. https://msdn.microsoft.com/library/windows/hardware/mt604741
> [2]. https://www.jedec.org/sites/default/files/docs/JESD245A.pdf

Is there a public version of the JEDEC spec?  When I go there, I get
a login screen.  If it's not public, then perhaps you can extract whatever
the  interesting parts are.  Or is the reference even needed if the
MSFT DSM spec describes the fields you're exposing?
> 
> Cc: Stuart Hayes <Stuart.Hayes@dell.com>
> Signed-off-by: Lijun Pan <Lijun.Pan@dell.com>
> ---
> v2:
>  - v2 combines v1's 1/2 and 2/2
>  - reuse the existing libndctl abstraction (suggested by Dan)
>  - move the MSFT _DSM code under ndctl/lib/
>  - the closet common field we can have between MSFT _DSM and smart is
>    health_state, temperature_celsius, and life_used_percentage.
> 
> 
>  ndctl/lib/Makefile.am        |   1 +
>  ndctl/lib/libndctl-msft.c    | 143 +++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl-private.h |   4 ++
>  ndctl/lib/libndctl.c         |   2 +
>  ndctl/lib/ndctl-msft.h       |  63 +++++++++++++++++++
>  5 files changed, 213 insertions(+)
>  create mode 100644 ndctl/lib/libndctl-msft.c
>  create mode 100644 ndctl/lib/ndctl-msft.h
> 
> diff --git a/ndctl/lib/Makefile.am b/ndctl/lib/Makefile.am
> index 58a0bb3..7a446be 100644
> --- a/ndctl/lib/Makefile.am
> +++ b/ndctl/lib/Makefile.am
> @@ -32,6 +32,7 @@ endif
>  if ENABLE_SMART
>  libndctl_la_SOURCES += libndctl-smart.c
>  libndctl_la_SOURCES += libndctl-hpe1.c
> +libndctl_la_SOURCES += libndctl-msft.c
>  endif
>  
>  EXTRA_DIST += libndctl.sym
> diff --git a/ndctl/lib/libndctl-msft.c b/ndctl/lib/libndctl-msft.c
> new file mode 100644
> index 0000000..868e5c0
> --- /dev/null
> +++ b/ndctl/lib/libndctl-msft.c
> @@ -0,0 +1,143 @@
> +/*
> + * Copyright (C) 2016-2017 Dell, Inc.
> + * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
> + * Copyright (c) 2016, Intel Corporation.
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
> +#include <stdlib.h>
> +#include <limits.h>
> +#include <util/log.h>
> +#include <ndctl/libndctl.h>
> +#include "libndctl-private.h"
> +#include "ndctl-msft.h"
> +
> +#define CMD_MSFT(_c) ((_c)->msft)
> +#define CMD_MSFT_SMART(_c) (CMD_MSFT(_c)->u.smart.data)
> +
> +static struct ndctl_cmd *msft_dimm_cmd_new_smart(struct ndctl_dimm *dimm)
> +{
> +	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
> +	struct ndctl_ctx *ctx = ndctl_bus_get_ctx(bus);
> +	struct ndctl_cmd *cmd;
> +	size_t size;
> +	struct ndn_pkg_msft *msft;
> +
> +	if (!ndctl_dimm_is_cmd_supported(dimm, ND_CMD_CALL)) {
> +		dbg(ctx, "unsupported cmd\n");
> +		return NULL;
> +	}
> +
> +	size = sizeof(*cmd) + sizeof(struct ndn_pkg_msft);
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
> +	msft = CMD_MSFT(cmd);
> +	msft->gen.nd_family = NVDIMM_FAMILY_MSFT;
> +	msft->gen.nd_command = NDN_MSFT_CMD_SMART;
> +	msft->gen.nd_fw_size = 0;
> +	msft->gen.nd_size_in = offsetof(struct ndn_msft_smart, status);
> +	msft->gen.nd_size_out = sizeof(msft->u.smart);
> +	msft->u.smart.status = 0;
> +
> +	cmd->firmware_status = &msft->u.smart.status;
> +
> +	return cmd;
> +}
> +
> +static int msft_smart_valid(struct ndctl_cmd *cmd)
> +{
> +	if (cmd->type != ND_CMD_CALL ||
> +	    cmd->size != sizeof(*cmd) + sizeof(struct ndn_pkg_msft) ||
> +	    CMD_MSFT(cmd)->gen.nd_family != NVDIMM_FAMILY_MSFT ||
> +	    CMD_MSFT(cmd)->gen.nd_command != NDN_MSFT_CMD_SMART ||
> +	    cmd->status != 0)
> +		return cmd->status < 0 ? cmd->status : -EINVAL;
> +	return 0;
> +}
> +
> +static unsigned int msft_cmd_smart_get_flags(struct ndctl_cmd *cmd)
> +{
> +	if (msft_smart_valid(cmd) < 0)
> +		return UINT_MAX;
> +
> +	/* below health data can be retrieved via MSFT _DSM function 11 */
> +	return NDN_MSFT_SMART_HEALTH_VALID |
> +		NDN_MSFT_SMART_TEMP_VALID |
> +		NDN_MSFT_SMART_USED_VALID;
> +}
> +
> +static unsigned int num_set_bit_health(__u16 num)
> +{
> +	int i;
> +	__u16 n = num & 0x7FFF;
> +	unsigned int count = 0;
> +
> +	for (i = 0; i < 15; i++)
> +		if (!!(n & (1 << i)))
> +			count++;
> +
> +	return count;
> +}
> +
> +static unsigned int msft_cmd_smart_get_health(struct ndctl_cmd *cmd)
> +{
> +	unsigned int health;
> +	unsigned int num;
> +
> +	if (msft_smart_valid(cmd) < 0)
> +		return UINT_MAX;
> +
> +	num = num_set_bit_health(CMD_MSFT_SMART(cmd)->health);
> +	if (num == 0)
> +		health = 0;
> +	else if (num < 2)
> +		health = ND_SMART_NON_CRITICAL_HEALTH;
> +	else if (num < 3)
> +		health = ND_SMART_CRITICAL_HEALTH;
> +	else
> +		health = ND_SMART_FATAL_HEALTH;
> +
> +	return health;
> +}
> +
> +static unsigned int msft_cmd_smart_get_temperature(struct ndctl_cmd *cmd)
> +{
> +	if (msft_smart_valid(cmd) < 0)
> +		return UINT_MAX;
> +	/*
> +	 * refer to JESD245 spec section 7.8 to calculate the temperature
> +	 * then convert to 1/16 Celsius granularity.
> +	 */

I'm confused by this comment because the Microsoft DSM spec says this value
is in degrees C.  Regardless of what the JEDAC spec says, wouldn't the
platform FW convert to degrees C?  And then this function needs to convert
to 1/16th of a degree?

> +	return CMD_MSFT_SMART(cmd)->temp & 0x0FFC;

> +}
> +
> +static unsigned int msft_cmd_smart_get_life_used(struct ndctl_cmd *cmd)
> +{
> +	if (msft_smart_valid(cmd) < 0)
> +		return UINT_MAX;
> +
> +	return 100 - CMD_MSFT_SMART(cmd)->nvm_lifetime;
> +}
> +
> +struct ndctl_smart_ops * const msft_smart_ops = &(struct ndctl_smart_ops) {
> +	.new_smart = msft_dimm_cmd_new_smart,
> +	.smart_get_flags = msft_cmd_smart_get_flags,
> +	.smart_get_health = msft_cmd_smart_get_health,
> +	.smart_get_temperature = msft_cmd_smart_get_temperature,
> +	.smart_get_life_used = msft_cmd_smart_get_life_used,
> +};
> diff --git a/ndctl/lib/libndctl-private.h b/ndctl/lib/libndctl-private.h
> index 3e67db0..8f10fbc 100644
> --- a/ndctl/lib/libndctl-private.h
> +++ b/ndctl/lib/libndctl-private.h
> @@ -32,6 +32,7 @@
>  #include <ccan/endian/endian.h>
>  #include <ccan/short_types/short_types.h>
>  #include "ndctl-hpe1.h"
> +#include "ndctl-msft.h"
>  
>  #define SZ_16M 0x01000000
>  
> @@ -196,6 +197,7 @@ struct ndctl_cmd {
>  		struct nd_cmd_clear_error clear_err[0];
>  #endif
>  		struct ndn_pkg_hpe1 hpe1[0];
> +		struct ndn_pkg_msft msft[0];
>  		struct nd_cmd_smart smart[0];
>  		struct nd_cmd_smart_threshold smart_t[0];
>  		struct nd_cmd_get_config_size get_size[0];
> @@ -226,9 +228,11 @@ struct ndctl_smart_ops {
>  #if HAS_SMART == 1
>  struct ndctl_smart_ops * const intel_smart_ops;
>  struct ndctl_smart_ops * const hpe1_smart_ops;
> +struct ndctl_smart_ops * const msft_smart_ops;
>  #else
>  static struct ndctl_smart_ops * const intel_smart_ops = NULL;
>  static struct ndctl_smart_ops * const hpe1_smart_ops = NULL;
> +static struct ndctl_smart_ops * const msft_smart_ops = NULL;
>  #endif
>  
>  /* internal library helpers for conditionally defined command numbers */
> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
> index 565c969..e5e027a 100644
> --- a/ndctl/lib/libndctl.c
> +++ b/ndctl/lib/libndctl.c
> @@ -1254,6 +1254,8 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
>  		dimm->dsm_family = strtoul(buf, NULL, 0);
>  	if (dimm->dsm_family == NVDIMM_FAMILY_HPE1)
>  		dimm->smart_ops = hpe1_smart_ops;
> +	if (dimm->dsm_family == NVDIMM_FAMILY_MSFT)
> +		dimm->smart_ops = msft_smart_ops;
>  
>  	dimm->formats = formats;
>  	sprintf(path, "%s/nfit/format", dimm_base);
> diff --git a/ndctl/lib/ndctl-msft.h b/ndctl/lib/ndctl-msft.h
> new file mode 100644
> index 0000000..0a1c7c6
> --- /dev/null
> +++ b/ndctl/lib/ndctl-msft.h
> @@ -0,0 +1,63 @@
> +/*
> + * Copyright (C) 2016-2017 Dell, Inc.
> + * Copyright (C) 2016 Hewlett Packard Enterprise Development LP
> + * Copyright (c) 2014-2015, Intel Corporation.
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
> +#ifndef __NDCTL_MSFT_H__
> +#define __NDCTL_MSFT_H__
> +
> +enum {
> +	NDN_MSFT_CMD_QUERY = 0,
> +
> +	/* non-root commands */
> +	NDN_MSFT_CMD_SMART = 11,
> +};
> +
> +/* NDN_MSFT_CMD_SMART */
> +#define NDN_MSFT_SMART_HEALTH_VALID	ND_SMART_HEALTH_VALID
> +#define NDN_MSFT_SMART_TEMP_VALID	ND_SMART_TEMP_VALID
> +#define NDN_MSFT_SMART_USED_VALID	ND_SMART_USED_VALID
> +
> +/*
> + * This is actually function 11 data,
> + * This is the closest I can find to match smart
> + * Microsoft _DSM does not have smart function
> + */
> +struct ndn_msft_smart_data {
> +	__u16	health;
> +	__u16	temp;
> +	__u8	err_thresh_stat;
> +	__u8	warn_thresh_stat;
> +	__u8	nvm_lifetime;
> +	__u8	count_dram_uncorr_err;
> +	__u8	count_dram_corr_err;
> +} __attribute__((packed));
> +
> +struct ndn_msft_smart {
> +	__u32	status;
> +	union {
> +		__u8 buf[9];
> +		struct ndn_msft_smart_data data[0];
> +	};
> +} __attribute__((packed));
> +
> +union ndn_msft_cmd {
> +	__u32			query;
> +	struct ndn_msft_smart	smart;
> +} __attribute__((packed));
> +
> +struct ndn_pkg_msft {
> +	struct nd_cmd_pkg	gen;
> +	union ndn_msft_cmd	u;
> +} __attribute__((packed));
> +
> +#endif /* __NDCTL_MSFT_H__ */
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
