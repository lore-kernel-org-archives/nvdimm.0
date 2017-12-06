Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E7D26220FB335
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 23:10:12 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 4BA48AC026D
 for <linux-nvdimm@lists.01.org>; Wed,  6 Dec 2017 16:14:34 +0900 (JST)
Subject: Re: [RFC PATCH v2 2/7] ndctl: nvdimmd: add nvdimmd necessary util
 functions
References: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
 <20171114074704.3446-3-qi.fuli@jp.fujitsu.com>
 <CAPcyv4j0jhb28ihCwWyC-pjSFSsaW02Lf_Gt_7XH3MPWMMn+qg@mail.gmail.com>
From: "Qi, Fuli" <qi.fuli@jp.fujitsu.com>
Message-ID: <445e8b8d-3584-b0c5-3a0c-cab269e42684@jp.fujitsu.com>
Date: Wed, 6 Dec 2017 16:14:20 +0900
MIME-Version: 1.0
In-Reply-To: <CAPcyv4j0jhb28ihCwWyC-pjSFSsaW02Lf_Gt_7XH3MPWMMn+qg@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 2017/11/21 6:19, Dan Williams wrote:
> On Mon, Nov 13, 2017 at 11:46 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
>> This patch is used to provide helper functions needed for nvdimm daemon.
>> These util functions can be used by other features as well in the future.
>>
>> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
>> ---
>>   nvdimmd/util.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>>   nvdimmd/util.h | 33 ++++++++++++++++++++++++
>>   2 files changed, 113 insertions(+)
>>   create mode 100644 nvdimmd/util.c
>>   create mode 100644 nvdimmd/util.h
>>
>> diff --git a/nvdimmd/util.c b/nvdimmd/util.c
>> new file mode 100644
>> index 0000000..ef6819e
>> --- /dev/null
>> +++ b/nvdimmd/util.c
>> @@ -0,0 +1,80 @@
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
>> +#include <stdlib.h>
>> +#include <string.h>
>> +#include <time.h>
>> +#include "util.h"
>> +
>> +void logrotate(char *file)
>> +{
>> +       time_t c_time;
>> +       char buf[4096], tstamp[32];
>> +
>> +       c_time = time(NULL);
>> +       strftime(tstamp, sizeof(tstamp), ".%Y%m%d%H%M%S", localtime(&c_time));
>> +       strcpy(buf, file);
>> +       strcat(buf, tstamp);
>> +       rename(file, buf);
>> +}
> Why does the monitor need to rotate logs? This should be the
> responsibility of whatever is consuming  the nvdimmd events.
When I wrote it, I thought that users can rotate nvdimmd logs without 
using other tools.
If you think it is not necessary, I will remove it in next version.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
