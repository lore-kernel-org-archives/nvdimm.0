Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 95AB7221F93A2
 for <linux-nvdimm@lists.01.org>; Mon, 29 Jan 2018 14:44:02 -0800 (PST)
Date: Mon, 29 Jan 2018 15:49:35 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v3 3/4] ndctl: add firmware update command option for ndctl
Message-ID: <20180129224935.GA22201@vverma7-desk1.amr.corp.intel.com>
References: <151338007905.4485.4189717376304274611.stgit@djiang5-desk3.ch.intel.com>
 <151338025633.4485.1543749099277549305.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <151338025633.4485.1543749099277549305.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 12/15, Dave Jiang wrote:
> Adding option "update-firmware" to ndctl for update firmware support from
> Intel DSM v1.6. ndctl update-firmware takes an option of -f for a firmware
> binary and a -d for the DIMM name:
> ndctl update-firmware -d nmem0 -f new_firmware.bin
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  ndctl/Makefile.am |    3 
>  ndctl/ndctl.c     |    1 
>  ndctl/update.c    |  554 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 557 insertions(+), 1 deletion(-)
>  create mode 100644 ndctl/update.c
> 

This mostly looks fine, a few comments below:

<..>

> diff --git a/ndctl/update.c b/ndctl/update.c
> new file mode 100644
> index 0000000..8d33b6a
> --- /dev/null
> +++ b/ndctl/update.c
> @@ -0,0 +1,554 @@
> +/*
> + * Copyright (c) 2017, Intel Corporation.
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

It looks like we are switching to SPDK license identifiers for new
files, similar to the kernel. So perhaps this can be replaced with:
/* SPDX-License-Identifier: GPL-2.0 */
/* Copyright(c) 2018 Intel Corporation. All rights reserved. */

<..>

> +
> +static int verify_fw_size(struct update_context *uctx)
> +{
> +	struct fw_info *fw = &uctx->dimm_fw;
> +
> +	if (uctx->fw_size > fw->store_size) {
> +		error("Firmware file size greater than DIMM store\n");
> +		return -E2BIG;

E2BIG seems to be "argument list too long". Perhaps ENOSPC is a better
choice here?

> +	}
> +
> +	return 0;
> +}
> +
> 

<..>

> +static int query_fw_finish_status(struct update_context *uctx)
> +{
> +	struct ndctl_cmd *cmd;
> +	int rc;
> +	enum ND_FW_STATUS status;
> +	struct fw_info *fw = &uctx->dimm_fw;
> +	bool done = false;
> +	struct timeval before, after;
> +	struct timespec now;
> +	uint64_t ver;
> +
> +	cmd = ndctl_dimm_cmd_new_fw_finish_query(uctx->start);
> +	if (!cmd)
> +		return -ENXIO;
> +
> +	rc = gettimeofday(&before, NULL);
> +	if (rc < 0)
> +		goto out;
> +

I think using gettimeofday is generally discouraged; we should use
clock_gettime instead for this sort of thing.

> +	now.tv_nsec = fw->query_interval / 1000;
> +	now.tv_sec = 0;
> +
> +	do {
> +		rc = ndctl_cmd_submit(cmd);
> +		if (rc < 0)
> +			break;
> +
> +		status = ndctl_cmd_fw_xlat_firmware_status(cmd);
> +		switch (status) {
> +		case FW_SUCCESS:
> +			ver = ndctl_cmd_fw_fquery_get_fw_rev(cmd);
> +			if (ver == 0) {
> +				printf("No firmware updated\n");
> +				rc = -ENXIO;
> +				goto out;
> +			}
> +
> +			printf("Image %s updated successfully to DIMM %s\n",
> +					uctx->fw_path, uctx->dimm_id);
> +			printf("Firmware version %#lx.\n", ver);
> +			printf("Reboot to activate.\n");
> +			done = true;
> +			rc = 0;
> +			break;
> +		case FW_EBUSY:
> +			/* Still on going, continue */
> +			rc = gettimeofday(&after, NULL);
> +			if (rc < 0) {
> +				rc = -errno;
> +				goto out;
> +			}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
