Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 68A402034C5FB
 for <linux-nvdimm@lists.01.org>; Mon, 20 Nov 2017 13:15:30 -0800 (PST)
Received: by mail-oi0-x244.google.com with SMTP id h81so7114628oib.8
 for <linux-nvdimm@lists.01.org>; Mon, 20 Nov 2017 13:19:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171114074704.3446-3-qi.fuli@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
 <20171114074704.3446-3-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 20 Nov 2017 13:19:43 -0800
Message-ID: <CAPcyv4j0jhb28ihCwWyC-pjSFSsaW02Lf_Gt_7XH3MPWMMn+qg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/7] ndctl: nvdimmd: add nvdimmd necessary util
 functions
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 13, 2017 at 11:46 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch is used to provide helper functions needed for nvdimm daemon.
> These util functions can be used by other features as well in the future.
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
> ---
>  nvdimmd/util.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  nvdimmd/util.h | 33 ++++++++++++++++++++++++
>  2 files changed, 113 insertions(+)
>  create mode 100644 nvdimmd/util.c
>  create mode 100644 nvdimmd/util.h
>
> diff --git a/nvdimmd/util.c b/nvdimmd/util.c
> new file mode 100644
> index 0000000..ef6819e
> --- /dev/null
> +++ b/nvdimmd/util.c
> @@ -0,0 +1,80 @@
> +/*
> + * Copyright (c) 2017, FUJITSU LIMITED. All rights reserved.
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU Lesser General Public License,
> + * version 2.1, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
> + * more details.
> + */
> +
> +#include <stdlib.h>
> +#include <string.h>
> +#include <time.h>
> +#include "util.h"
> +
> +void logrotate(char *file)
> +{
> +       time_t c_time;
> +       char buf[4096], tstamp[32];
> +
> +       c_time = time(NULL);
> +       strftime(tstamp, sizeof(tstamp), ".%Y%m%d%H%M%S", localtime(&c_time));
> +       strcpy(buf, file);
> +       strcat(buf, tstamp);
> +       rename(file, buf);
> +}

Why does the monitor need to rotate logs? This should be the
responsibility of whatever is consuming  the nvdimmd events.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
