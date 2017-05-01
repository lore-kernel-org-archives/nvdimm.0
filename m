Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 763BB21A04823
 for <linux-nvdimm@lists.01.org>; Mon,  1 May 2017 14:20:09 -0700 (PDT)
Subject: Re: [PATCH v2] ndctl: add clear error support for ndctl
References: <149333241780.23371.243937948027874332.stgit@djiang5-desk3.ch.intel.com>
 <1493670342.30303.24.camel@hpe.com>
 <20170501210241.GA11607@djiang5-desk3.ch.intel.com>
 <1493673137.30303.26.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <9ae03073-b6f9-5595-5758-aa29e9a6d7cc@intel.com>
Date: Mon, 1 May 2017 14:20:08 -0700
MIME-Version: 1.0
In-Reply-To: <1493673137.30303.26.camel@hpe.com>
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 05/01/2017 02:12 PM, Kani, Toshimitsu wrote:
> On Mon, 2017-05-01 at 14:02 -0700, Jiang, Dave wrote:
>> On Mon, May 01, 2017 at 01:25:45PM -0700, Kani, Toshimitsu wrote:
>>> On Thu, 2017-04-27 at 15:38 -0700, Dave Jiang wrote:
>  :
>>
>> Toshi,
>> Can you please try this and see if that fixes the issue? Thanks!
>>
>> diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
>> index 7399729..44fc2f3 100644
>> --- a/ndctl/lib/libndctl.c
>> +++ b/ndctl/lib/libndctl.c
>> @@ -1882,10 +1882,8 @@ static int regions_badblocks_init(struct
>> ndctl_region *region)
>>  region->badblocks = NULL;
>>  }
>>
>> -if (asprintf(&bb_path,
>> "/sys/devices/platform/%s/%s/%s/badblocks",
>> -ndctl_bus_get_provider(bus),
>> -ndctl_bus_get_devname(bus),
>> -ndctl_region_get_devname(region)) <
>> 0) {
>> +if (asprintf(&bb_path, "%s/badblocks",
>> +region->region_path) < 0) {
>>  rc = -errno;
>>  err(ctx, "region badblocks path allocation
>> failure\n");
>>  return rc;
> 
> Yes, this fixes the issue. :-)  Noticed that there is a warning.
> 
>   CC       libndctl.lo
> libndctl.c: In function 'regions_badblocks_init':
> libndctl.c:1875:20: warning: unused variable 'bus' [-Wunused-variable]
>   struct ndctl_bus *bus = ndctl_region_get_bus(region);

Thanks! I'll spin v3 with the fixes.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
