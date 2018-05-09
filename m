Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A046820965DCC
 for <linux-nvdimm@lists.01.org>; Wed,  9 May 2018 15:49:08 -0700 (PDT)
Subject: Re: [PATCH v5 2/4] ndctl: convert namespace actions to use
 util_filter_walk()
References: <152486678857.66587.12260245215754521561.stgit@djiang5-desk3.ch.intel.com>
 <152486690348.66587.15082403237213429099.stgit@djiang5-desk3.ch.intel.com>
 <1525906020.4429.1.camel@intel.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <3834ebd2-55aa-3a36-9ed7-0d942e007db8@intel.com>
Date: Wed, 9 May 2018 15:49:07 -0700
MIME-Version: 1.0
In-Reply-To: <1525906020.4429.1.camel@intel.com>
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On 05/09/2018 03:47 PM, Verma, Vishal L wrote:
> On Fri, 2018-04-27 at 15:08 -0700, Dave Jiang wrote:
>> util_filter_walk() does the looping through of busses and regions.
>> Removing
>> duplicate code in namespace ops and provide filter functions so we can
>> utilize util_filter_walk() and share common code.
>>
>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>> ---
>>  ndctl/namespace.c |  163 ++++++++++++++++++++++++++++++-----------------
>> ------
>>  test/btt-check.sh |    2 -
>>  util/filter.c     |    5 +-
>>  util/filter.h     |    8 +++
>>  4 files changed, 104 insertions(+), 74 deletions(-)
>>
> 
> [...]
> 
>>  
>> diff --git a/test/btt-check.sh b/test/btt-check.sh
>> index 353d4375..50c1b592 100755
>> --- a/test/btt-check.sh
>> +++ b/test/btt-check.sh
>> @@ -1,4 +1,4 @@
>> -#!/bin/bash -E
>> +#!/bin/bash -Ex
> 
> Did you mean to add this hunk?

No, must be accident from debug.

> 
>>  
>>  # Copyright(c) 2015-2017 Intel Corporation. All rights reserved.
>>  # 
>> diff --git a/util/filter.c b/util/filter.c
>> index 0d3cc02f..b7a4fbd6 100644
>> --- a/util/filter.c
>> +++ b/util/filter.c
>>
> [...]
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
