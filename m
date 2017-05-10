Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3318A21A0BAA8
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 10:37:25 -0700 (PDT)
Subject: Re: [PATCH v2 2/2] ndctl: add list --media-errors support
References: <149437257526.67960.3751792583137095911.stgit@djiang5-desk3.ch.intel.com>
 <149437264268.67960.7347964981686229026.stgit@djiang5-desk3.ch.intel.com>
 <1494427797.30303.75.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <6001d85d-444d-9e04-e78d-cefa49ebc5a3@intel.com>
Date: Wed, 10 May 2017 10:37:22 -0700
MIME-Version: 1.0
In-Reply-To: <1494427797.30303.75.camel@hpe.com>
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

On 05/10/2017 07:50 AM, Kani, Toshimitsu wrote:
> On Tue, 2017-05-09 at 16:31 -0700, Dave Jiang wrote:
>> Adding option for ndctl list command to show badblocks for region and
>> device. The device badblocks are calculated from the region
>> badblocks.
>> This allows the user to provide the proper badblock offset and length
>> for clearing later on.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> 
> Hi Dave,
> 
> A badblock in metadata is shown as offset 0 with a negative length.
> Perhaps, you may want to add more test cases.

Yeah the offset calculation code was total garbage. I rewrote it and
made it much simpler. Will look to add additional badblocks in nfit_test
soon. Thanks for testing!

> 
> # cat /sys/bus/nd/devices/region0/badblocks
> 2048 1
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
>       "offset":0,
>       "length":-526335
>     },
>     {
>       "offset":520192,
>       "length":1
>     },
>     {
>       "offset":1044480,
>       "length":1
>     }
>   ]
> }
> 
> Thanks,
> -Toshi
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
