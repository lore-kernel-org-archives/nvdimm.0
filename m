Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B115E21A16E49
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 09:09:26 -0700 (PDT)
Subject: Re: [PATCH v4 2/2] ndctl: add list --media-errors support
References: <149446050265.19998.6594654322891878230.stgit@djiang5-desk3.ch.intel.com>
 <149446059426.19998.8536490603388756669.stgit@djiang5-desk3.ch.intel.com>
 <1494516683.30303.88.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c6378b13-b919-598f-eeb6-cf383f739548@intel.com>
Date: Thu, 11 May 2017 09:09:22 -0700
MIME-Version: 1.0
In-Reply-To: <1494516683.30303.88.camel@hpe.com>
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



On 05/11/2017 08:31 AM, Kani, Toshimitsu wrote:
> On Wed, 2017-05-10 at 16:57 -0700, Dave Jiang wrote:
>> ACPI NFIT enabled platforms provide media errors as absolute phyiscal
>> address offsets. Add an option to ndctl to display those media errors
>> tranlsated to region and namespace device level offsets in an "ndctl
>> list" listing. BTT badblocks show is not supported in this iteration
>> and will come later.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>
>> v2: added fix to badblocks display from Toshi's testing result.
>> v3: fixed naming issues from Dan's comments.
>>     fixed badblocks boundary offset calculations from Toshi's
>> testing.
>> v4: Add indicator to show badblocks exist or not, per Toshi's
>> comments.
> 
> This version works pretty good, except that it does not show
> "has_badblocks" for sector mode.

Yes I intentionally left it out. I was going to add sector mode support
as follow on after Dan accepts these patches as it required additional
support code to read the btt badblocks file etc. If you'd rather
everything in right now I can try to get sector mode support in now.

> 
> # ndctl list -M -m sector
> {
>   "dev":"namespace0.0",
>   "mode":"sector",
>   "size":17162027008,
>   "uuid":"7742dff3-3edd-4a28-894d-9ac1aede6b2c",
>   "sector_size":4096,
>   "blockdev":"pmem0s"
> }
> 
> Thanks,
> -Toshi
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
