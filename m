Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F6BC21A070BA
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 10:27:48 -0700 (PDT)
Subject: Re: [PATCH v6 2/3] ndctl: add list-errors support
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454673.2642.10490569511477839936.stgit@djiang5-desk3.ch.intel.com>
 <1494004041.30303.59.camel@hpe.com>
 <caa48123-9daa-4ca6-2110-ef7e2a409ca3@intel.com>
 <1494004877.30303.61.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <92151b8e-8121-2b28-cc2d-c9f19bf9b5ef@intel.com>
Date: Fri, 5 May 2017 10:27:46 -0700
MIME-Version: 1.0
In-Reply-To: <1494004877.30303.61.camel@hpe.com>
Content-Language: en-US
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 05/05/2017 10:21 AM, Kani, Toshimitsu wrote:
> On Fri, 2017-05-05 at 10:14 -0700, Dave Jiang wrote:
>>
>> On 05/05/2017 10:07 AM, Kani, Toshimitsu wrote:
>>> On Thu, 2017-05-04 at 14:49 -0700, Dave Jiang wrote:
>>>> Adding list-errors command to support displaying of all badblocks
>>>> in relation to the device rather than the region. This allows the
>>>> user to know what badblocks to pass in when doing clear-error
>>>> calls.
>>>>
>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> ---
>>>>  Documentation/ndctl-list-errors.txt |   26 +++++++
>>>>  builtin.h                           |    1
>>>>  ndctl/clear-error.c                 |  133
>>>> ++++++++++++++++++++++++++++++++---
>>>>  ndctl/ndctl.c                       |    1
>>>>  4 files changed, 151 insertions(+), 10 deletions(-)
>>>>  create mode 100644 Documentation/ndctl-list-errors.txt
>>>>
>>>> diff --git a/Documentation/ndctl-list-errors.txt
>>>> b/Documentation/ndctl-list-errors.txt
>>>> new file mode 100644
>>>> index 0000000..f831ba0
>>>> --- /dev/null
>>>> +++ b/Documentation/ndctl-list-errors.txt
>>>> @@ -0,0 +1,26 @@
>>>> +ndctl-list-errors(1)
>>>> +====================
>>>> +
>>>> +NAME
>>>> +----
>>>> +ndctl-list-errors - list badblocks specifically in relation to a
>>>> device
>>>> +
>>>> +SYNOPSIS
>>>> +--------
>>>> +[verse]
>>>> +'ndctl list-errors' [<options>]
>>>> +
>>>> +EXAMPLES
>>>> +--------
>>>> +
>>>> +List bad blocks for the provided device
>>>> +[verse]
>>>> +ndctl list-errors -f /dev/dax0.0
>>>> +
>>>> +List all badblocks for device /dev/dax0.0.
>>>
>>> Hi Dave,
>>>
>>> I am not getting sensible values from list-errors.  Also, please
>>> describe the output format of this command in the document.
>>>
>>> # cat /sys/bus/nd/devices/region0/size
>>> 17179869184
>>>
>>> # cat /sys/class/dax/dax0.0/size
>>> 16909336576
>>>
>>> # cat /sys/bus/nd/devices/region0/badblocks
>>> 1048576 1
>>> 1572864 1
>>>
>>> # ndctl list-errors -f /dev/dax0.0
>>> 0 3145729
>>> 0 3670017
>>
>> That is very strange. It looks correct with nfit_test for me. How do
>> I reproduce your case or do I actually need actual hardware?
> 
> Yes, my steps need a hardware, but this badblocks handling itself
> should be platform-independent.  I will check to see why I got these
> values.

Thanks! what is your region/resource and dax/resource?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
