Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9884921A13493
 for <linux-nvdimm@lists.01.org>; Thu, 11 May 2017 10:52:56 -0700 (PDT)
Subject: Re: [PATCH v5 2/2] ndctl: add list --media-errors support
References: <149452421176.25868.9410889126303443053.stgit@djiang5-desk3.ch.intel.com>
 <149452423401.25868.12072221454250478213.stgit@djiang5-desk3.ch.intel.com>
 <1494524875.30303.92.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <f32a0671-926f-04be-210e-bccd0bd4f1b7@intel.com>
Date: Thu, 11 May 2017 10:52:53 -0700
MIME-Version: 1.0
In-Reply-To: <1494524875.30303.92.camel@hpe.com>
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



On 05/11/2017 10:48 AM, Kani, Toshimitsu wrote:
> On Thu, 2017-05-11 at 10:37 -0700, Dave Jiang wrote:
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
>> v5: Add BTT badblock_count from Toshi and Dan's comments.
> 
> Thanks Dave for the quick update.  Sorry, but I expected
> "badblock_count" to be a number of badblock sectors, not a number of
> badblock ranges.

Ah! I'll fix that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
