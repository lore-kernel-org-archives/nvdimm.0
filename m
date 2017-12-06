Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 24D6A2217CE2B
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 08:48:33 -0800 (PST)
Received: by mail-ot0-x242.google.com with SMTP id i1so3901852oth.9
 for <linux-nvdimm@lists.01.org>; Wed, 06 Dec 2017 08:53:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <445e8b8d-3584-b0c5-3a0c-cab269e42684@jp.fujitsu.com>
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
 <20171114074704.3446-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4j0jhb28ihCwWyC-pjSFSsaW02Lf_Gt_7XH3MPWMMn+qg@mail.gmail.com>
 <445e8b8d-3584-b0c5-3a0c-cab269e42684@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 6 Dec 2017 08:53:04 -0800
Message-ID: <CAPcyv4hW5vTDj3w1xJ9w6DzQcYM0tMyExMthMTbZWGhPhG=3mw@mail.gmail.com>
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
To: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 5, 2017 at 11:14 PM, Qi, Fuli <qi.fuli@jp.fujitsu.com> wrote:
> On 2017/11/21 6:19, Dan Williams wrote:
>>
>> On Mon, Nov 13, 2017 at 11:46 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
>>>
>>> This patch is used to provide helper functions needed for nvdimm daemon.
>>> These util functions can be used by other features as well in the future.
>>>
>>> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
>>> ---
>>>   nvdimmd/util.c | 80
>>> ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>   nvdimmd/util.h | 33 ++++++++++++++++++++++++
>>>   2 files changed, 113 insertions(+)
>>>   create mode 100644 nvdimmd/util.c
>>>   create mode 100644 nvdimmd/util.h
>>>
>>> diff --git a/nvdimmd/util.c b/nvdimmd/util.c
>>> new file mode 100644
>>> index 0000000..ef6819e
>>> --- /dev/null
>>> +++ b/nvdimmd/util.c
>>> @@ -0,0 +1,80 @@
>>> +/*
>>> + * Copyright (c) 2017, FUJITSU LIMITED. All rights reserved.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> it
>>> + * under the terms and conditions of the GNU Lesser General Public
>>> License,
>>> + * version 2.1, as published by the Free Software Foundation.
>>> + *
>>> + * This program is distributed in the hope it will be useful, but
>>> WITHOUT ANY
>>> + * WARRANTY; without even the implied warranty of MERCHANTABILITY or
>>> FITNESS
>>> + * FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
>>> for
>>> + * more details.
>>> + */
>>> +
>>> +#include <stdlib.h>
>>> +#include <string.h>
>>> +#include <time.h>
>>> +#include "util.h"
>>> +
>>> +void logrotate(char *file)
>>> +{
>>> +       time_t c_time;
>>> +       char buf[4096], tstamp[32];
>>> +
>>> +       c_time = time(NULL);
>>> +       strftime(tstamp, sizeof(tstamp), ".%Y%m%d%H%M%S",
>>> localtime(&c_time));
>>> +       strcpy(buf, file);
>>> +       strcat(buf, tstamp);
>>> +       rename(file, buf);
>>> +}
>>
>> Why does the monitor need to rotate logs? This should be the
>> responsibility of whatever is consuming  the nvdimmd events.
>
> When I wrote it, I thought that users can rotate nvdimmd logs without using
> other tools.
> If you think it is not necessary, I will remove it in next version.
>

In general we should let other system components handle the mechanics
they are responsible to handle. In this case as long as nvdimmd
reports the log message to the systemd-journal or the platform's
syslog facility then it has done its job and the log machinery is
responsible for rotation.

I've also been giving more thought about the command line interface
for the monitor. I think it should reuse the "ndctl list"
infrastructure for selecting and filtering devices so the user can
launch monitors like this:

        ndctl monitor --dimms --namespace=namespace0.0 --action=page_admin.sh
        ndctl monitor -BDRN --action=log

Where those commands would  run the 'page admin' script if any DIMM
event happens on any DIMM associated with namespace0.0, and log
everything else" that happens on any other device. We likely also need
"--event=" to control the events to filter, and a --list-events option
to enumerate all the possible events.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
