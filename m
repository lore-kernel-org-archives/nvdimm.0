Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B74C02095E504
 for <linux-nvdimm@lists.01.org>; Sun, 24 Sep 2017 09:18:31 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id l74so4066455oih.1
 for <linux-nvdimm@lists.01.org>; Sun, 24 Sep 2017 09:21:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4g2zz8nUN8otuVNrk4VQxeQmmVcr9HsQ3CO5bFHHhNymQ@mail.gmail.com>
References: <0DEDF3B159719A448A49EF0E7B11E3222756C8E1@g01jpexmbkw01>
 <CAPcyv4g2zz8nUN8otuVNrk4VQxeQmmVcr9HsQ3CO5bFHHhNymQ@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 24 Sep 2017 09:21:40 -0700
Message-ID: <CAPcyv4iuKecnMGJG__8GCM-ONxM18cMfaGUqjXPyjuLDtXNi6Q@mail.gmail.com>
Subject: Re: [RFC patch 1/4]ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Sep 23, 2017 at 10:17 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Thu, Aug 31, 2017 at 6:45 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> Libnvdimmd.c provides functions which are used by nvdimm daemon, and
>> currently it just supports for logging.
>> Libnvdimmd.h is a head file of libnvdimmd.c.
>> Since I do not use automake, I defined gentenv.h to compile instead of it temporarily.
>> So I suppose more good way is necessary.
>>
>> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
>>
>> ---
>> nvdimmd/Makefile     |   7 +++
>> nvdimmd/getenv.h     |   1 +
>> nvdimmd/libnvdimmd.c | 141 +++++++++++++++++++++++++++++++++++++++++++++++++++
>> nvdimmd/libnvdimmd.h |  31 +++++++++++
>> 4 files changed, 180 insertions(+)
>> diff --git a/nvdimmd/Makefile b/nvdimmd/Makefile
>> new file mode 100644
>> index 0000000..a20a747
>> --- /dev/null
>> +++ b/nvdimmd/Makefile
>> @@ -0,0 +1,7 @@
>> +CC             = gcc
>> +IDIR           = -I../ -I../ndctl
>> +
>> +libnvdimmd.o:  libnvdimmd.c
>> +                       $(CC) -o libnvdimmd.o $(IDIR) -c libnvdimmd.c
>> +clean:
>> +                       rm -rf *.o
>> diff --git a/nvdimmd/getenv.h b/nvdimmd/getenv.h
>> new file mode 100644
>> index 0000000..45747b4
>> --- /dev/null
>> +++ b/nvdimmd/getenv.h
>> @@ -0,0 +1 @@
>> +#define HAVE_SECURE_GETENV 1
>> diff --git a/nvdimmd/libnvdimmd.c b/nvdimmd/libnvdimmd.c
>> new file mode 100644
>> index 0000000..89ff701
>> --- /dev/null
>> +++ b/nvdimmd/libnvdimmd.c
>
> This doesn't need to be a separate library, just roll it into nvdimmd directly.
>
>> @@ -0,0 +1,141 @@
>> +/*
>> + * Copyright (c) 2017, FUJITSU LIMITED. All rights reserved.
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms and conditions of the GNU Lesser General Public License,
>> + * version 2.1, as published by the Free Software Foundation.
>> + *
>> + * This program is distributed in the hope it will be useful, but WITHOUT ANY
>> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
>> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for
>> + * more details.
>> + */
>> +
>> +/*
>> + * This program is used to provide nvdimm daemon necessary functions.
>> + */
>> +
>> +#include "getenv.h"
>> +#include <stdio.h>
>> +#include <stdlib.h>
>> +#include <unistd.h>
>> +#include <string.h>
>> +#include <sys/stat.h>
>> +#include <syslog.h>
>> +#include <ndctl/libndctl.h>
>> +#include <ndctl/lib/libndctl-private.h>
>> +#include "libnvdimmd.h"
>> +#define BUF_SIZE 4096
>> +
>> +static int get_health_info(threshold_dimm *t_dimm)
>> +{
>> +       struct ndctl_cmd *cmd;
>> +       int rc;
>> +       unsigned int flags;
>> +       char *msg = "nvdimm warning: dimm over threshold notify";
>> +       char *err_msg;
>> +
>> +       cmd = ndctl_dimm_cmd_new_smart(t_dimm->dimm);
>> +       if (!cmd) {
>> +               err_msg = "failed to prepare command to get health info";
>> +               syslog(LOG_WARNING, "%s [%s], %s\n", msg, t_dimm->devname, err_msg);
>> +               return -1;
>
> Let's use the same logging scheme as libndctl where we have 'struct
> log_ctx' and the the log function can be set to a custom routine. That
> way we can redirect log messages to syslog or structured json output
> simply by changing log_ctx.log_fn.

Thinking further about this, using log_ctx is probably not sufficient
either. We'll also need metadata with each event message, see the
extra fields that the systemd journal tracks for inspiration:

    https://www.freedesktop.org/software/systemd/man/systemd.journal-fields.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
