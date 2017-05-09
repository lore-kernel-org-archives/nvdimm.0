Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4239221A13493
 for <linux-nvdimm@lists.01.org>; Tue,  9 May 2017 16:25:59 -0700 (PDT)
Subject: Re: [PATCH 2/2] ndctl: add list --media-errors support
References: <149428467512.44955.4085670669863366983.stgit@djiang5-desk3.ch.intel.com>
 <149428468046.44955.6721097374196988691.stgit@djiang5-desk3.ch.intel.com>
 <1494348939.30303.73.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <7ae56996-8717-66fe-9c79-78be3b065567@intel.com>
Date: Tue, 9 May 2017 16:25:56 -0700
MIME-Version: 1.0
In-Reply-To: <1494348939.30303.73.camel@hpe.com>
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



On 05/09/2017 09:55 AM, Kani, Toshimitsu wrote:
> On Mon, 2017-05-08 at 16:04 -0700, Dave Jiang wrote:
>> Adding option for ndctl list command to show badblocks for region and
>> device. The device badblocks are calculated from the region
>> badblocks. This allows the user to provide the proper badblock offset
>> and length for clearing later on.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  ndctl/list.c      |   17 ++++++++++++++---
>>  ndctl/namespace.c |    2 +-
>>  2 files changed, 15 insertions(+), 4 deletions(-)
> 
> Hi Dave,
> 
> It shows the same badblock offset twice.  The value is correct for
> 1572864.  strace.log is attached for more info.
> 
> # cat /sys/bus/nd/devices/region0/size
> 17179869184
> 
> # cat /sys/class/dax/dax0.0/size
> 16909336576
> 
> # cat /sys/bus/nd/devices/region0/badblocks
> 1048576 1
> 1572864 1
> 
> # ndctl list --media-errors --mode=dax
> {
>   "dev":"namespace0.0",
>   "mode":"dax",
>   "size":16909336576,
>   "uuid":"8c71811f-260d-4788-8487-db88d829d393",
>   "badblocks":[
>     {
>       "offset":1044480,
>       "length":1
>     },
>     {
>       "offset":1044480,
>       "length":1
>     }
>   ]
> }

Apparently I wasn't allocating a new json object every time I added to
the json array, so the first element got added each time. I'll have a
fix out soon.




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
