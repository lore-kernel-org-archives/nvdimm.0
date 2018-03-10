Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAA73223DB0F8
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 16:14:02 -0800 (PST)
Received: by mail-ot0-x243.google.com with SMTP id r30so10314844otr.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Mar 2018 16:20:20 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1520639241.6316.59.camel@intel.com>
References: <20180309233416.13243-1-ross.zwisler@linux.intel.com>
 <1520639241.6316.59.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Mar 2018 16:20:18 -0800
Message-ID: <CAPcyv4jgaUvxX-7n5xwtrO5iCWnY-q8mLC=UAGh+8KOWTCSMvw@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl: fail NUMA filtering when unsupported
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 9, 2018 at 3:47 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Fri, 2018-03-09 at 16:34 -0700, Ross Zwisler wrote:
>> For systems that don't support NUMA, numactl gives a loud and fatal
>> error:
>>
>>   # numactl -N 0 ls
>>   numactl: This system does not support NUMA policy
>>
>> Follow this model in ndctl for NUMA based filtering:
>>
>>   # ./ndctl/ndctl list --numa-node=0
>>     Error: This system does not support NUMA
>>
>> This is done instead of just quietly filtering out all dimms, regions
>> and
>> namespaces because the NUMA node they were trying to match didn't
>> exist in
>> the system.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>> Suggested-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  util/filter.c | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/util/filter.c b/util/filter.c
>> index 291d7ed..fdc46a3 100644
>> --- a/util/filter.c
>> +++ b/util/filter.c
>> @@ -14,7 +14,10 @@
>>  #include <string.h>
>>  #include <stdlib.h>
>>  #include <limits.h>
>> +#include <unistd.h>
>> +#include <sys/stat.h>
>>  #include <util/util.h>
>> +#include <sys/types.h>
>>  #include <ndctl/ndctl.h>
>>  #include <util/filter.h>
>>  #include <ndctl/libndctl.h>
>> @@ -328,6 +331,13 @@ int util_filter_walk(struct ndctl_ctx *ctx,
>> struct util_filter_ctx *fctx,
>>       }
>>
>>       if (param->numa_node && strcmp(param->numa_node, "all") !=
>> 0) {
>> +             struct stat st;
>> +
>> +             if (stat("/sys/devices/system/node", &st)) {
>> +                     error("This system does not support
>> NUMA\n");
>> +                     return -EINVAL;
>> +             }
>
> Is it ok to just directly read sysfs here? Alternatively we could use
> the get_mempolicy syscall (like libnuma does) but that requires linking
> with -lnuma..
>
> https://github.com/numactl/numactl/blob/master/libnuma.c#L800

I don't mind linking against libnuma if the goal is to mimic the
behavior of numactl.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
