Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6EAA8211AF9E8
 for <linux-nvdimm@lists.01.org>; Thu, 17 Jan 2019 17:05:23 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [daxctl PATCH v2 2/2] daxctl: Opt-in to /sys/bus/dax ABI
Date: Fri, 18 Jan 2019 01:05:21 +0000
Message-ID: <f7484c8accd4d36b0ed070e167144eb9d967ea4a.camel@intel.com>
References: <154752627111.1710673.1469336464670065810.stgit@dwillia2-desk3.amr.corp.intel.com>
 <154752628167.1710673.10834552344037521034.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154752628167.1710673.10834552344037521034.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <AF378D09940B4140850FBD44CDEE2A95@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan,

These mostly look good, just a few minor comments below -

On Mon, 2019-01-14 at 20:24 -0800, Dan Williams wrote:
> The kernel is implementing a '/sys/bus/dax' ABI to allow for alternate
> device-DAX drivers to be bound to device instances. While the kernel
> conversion to '/sys/bus/dax' does not effect the primary ndctl use case

"kernel's conversion" or "kernel converting to"
s/effect/affect/

> of putting namespaces into 'devdax' mode since that uses libnvdimm
> namespace device relative paths, it does break current implementations
> of 'ndctl list -X' and 'daxctl list'.  It is also known to break fio and
> some pmdk versions that explicitly reference "/sys/class/dax".
> 
> In order to avoid userspace regressions the kernel can be configured to
> maintain '/sys/class/dax' as the default ABI. However, once all
> '/sys/class/dax' users have been converted, or removed from the
> installation, an administrator can opt-in to the new '/sys/bus/dax' ABI.
> The 'dax migrate-device-model' command installs a modprobe rule to
> blacklist the dax_pmem_compat module and arrange for the dax_pmem module
> to auto-load in response to the detection of device-DAX instances
> emitted from the libnvdimm subsystem.
> 
> Reported-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  .gitignore                                         |    1 
>  Documentation/daxctl/Makefile.am                   |    3 +
>  .../daxctl/daxctl-migrate-device-model.txt         |   47 ++++++++++++++++++++
>  configure.ac                                       |    5 ++
>  daxctl/Makefile.am                                 |   10 ++++
>  daxctl/builtin.h                                   |    1 
>  daxctl/daxctl.c                                    |    1 
>  daxctl/lib/Makefile.am                             |    2 +
>  daxctl/lib/daxctl.conf                             |    2 +
>  daxctl/migrate.c                                   |   41 +++++++++++++++++
>  ndctl.spec.in                                      |    1 
>  11 files changed, 113 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/daxctl/daxctl-migrate-device-model.txt
>  create mode 100644 daxctl/lib/daxctl.conf
>  create mode 100644 daxctl/migrate.c
> 

[..]

> --- /dev/null
> +++ b/daxctl/migrate.c
> @@ -0,0 +1,41 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright(c) 2015-2018 Intel Corporation. All rights reserved. */

Copyright notice can be updated to 2019. This applies the one included
by man pages as well, but that is unrelated and I can take care of that
separately.

> +#include <sys/types.h>
> +#include <sys/stat.h>
> +#include <stdio.h>
> +#include <errno.h>
> +#include <fcntl.h>
> +#include <daxctl/config.h>
> +#include <daxctl/libdaxctl.h>
> +#include <util/parse-options.h>
> +#include <ccan/array_size/array_size.h>
> +
> +int cmd_migrate(int argc, const char **argv, struct daxctl_ctx *ctx)
> +{
> +	int i;
> +	static const struct option options[] = {
> +		OPT_END(),
> +	};
> +	const char * const u[] = {
> +		"daxctl migrate-device-model",
> +		NULL
> +	};
> +
> +	argc = parse_options(argc, argv, options, u, 0);
> +	for (i = 0; i < argc; i++)
> +		error("unknown parameter \"%s\"\n", argv[i]);
> +
> +	if (argc)
> +		usage_with_options(u, options);
> +
> +	if (symlink(DAXCTL_MODPROBE_DATA, DAXCTL_MODPROBE_INSTALL) == 0) {
> +		fprintf(stderr, " Success: installed %s\n",
> +				DAXCTL_MODPROBE_INSTALL);
> +		return EXIT_SUCCESS;
> +	}
> +
> +	error("failed to install %s: %s\n", DAXCTL_MODPROBE_INSTALL,
> +			strerror(errno));

'Success' is capitalized, but 'failed' is lower case, could make them
consistent. Most other messages seem to be lowercase, including the
'unknown parameter' one above.

> +
> +	return EXIT_FAILURE;
> +}
> diff --git a/ndctl.spec.in b/ndctl.spec.in
> index bc4d65c1f988..bc65a471a6d2 100644
> --- a/ndctl.spec.in
> +++ b/ndctl.spec.in
> @@ -126,6 +126,7 @@ make check
>  %license util/COPYING licenses/BSD-MIT licenses/CC0
>  %{_bindir}/daxctl
>  %{_mandir}/man1/daxctl*
> +%{_datadir}/daxctl/daxctl.conf
>  
>  %files -n LNAME
>  %defattr(-,root,root)
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
