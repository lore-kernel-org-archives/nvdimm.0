Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x241.google.com (mail-qk0-x241.google.com
 [IPv6:2607:f8b0:400d:c09::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A68E8210DA790
 for <linux-nvdimm@lists.01.org>; Mon,  6 Aug 2018 05:59:59 -0700 (PDT)
Received: by mail-qk0-x241.google.com with SMTP id t79-v6so8771065qke.4
 for <linux-nvdimm@lists.01.org>; Mon, 06 Aug 2018 05:59:59 -0700 (PDT)
Subject: Re: [PATCH v2] ndctl, test: add a new unit test for
 max_available_extent namespace
References: <20180803185219.16242-1-msys.mizuma@gmail.com>
 <1533332112.8557.98.camel@intel.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <2ed0a001-7edb-87a9-aa7c-cebed87e0684@gmail.com>
Date: Mon, 6 Aug 2018 08:59:56 -0400
MIME-Version: 1.0
In-Reply-To: <1533332112.8557.98.camel@intel.com>
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
To: vishal.l.verma@intel.com, linux-nvdimm@lists.01.org
Cc: m.mizuma@jp.fujitsu.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

Thank you for your review! I'll fix and send v3.

Thanks,
Masa

On 08/03/2018 05:35 PM, Verma, Vishal L wrote:
> 
> On Fri, 2018-08-03 at 14:52 -0400, Masayoshi Mizuma wrote:
>> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>>
>> Add a new unit test to test max_available_extent namespace.
>> This feature is implemented by the following patches.
>>
>>   kernel side:
>>     https://lists.01.org/pipermail/linux-nvdimm/2018-July/016731.html
>>     https://lists.01.org/pipermail/linux-nvdimm/2018-July/016732.html
>>
>>   ndctl side:
>>     https://lists.01.org/pipermail/linux-nvdimm/2018-July/017176.html
>>
>> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>> ---
>>  test/Makefile.am                |  3 ++-
>>  test/max_available_extent_ns.sh | 43 +++++++++++++++++++++++++++++++++
>>  2 files changed, 45 insertions(+), 1 deletion(-)
>>  create mode 100755 test/max_available_extent_ns.sh
>>
>> diff --git a/test/Makefile.am b/test/Makefile.am
>> index 8c55056..9af2464 100644
>> --- a/test/Makefile.am
>> +++ b/test/Makefile.am
>> @@ -22,7 +22,8 @@ TESTS =\
>>  	firmware-update.sh \
>>  	ack-shutdown-count-set \
>>  	rescan-partitions.sh \
>> -	monitor.sh
>> +	monitor.sh \
>> +	max_available_extent_ns.sh
>>  
>>  check_PROGRAMS =\
>>  	libndctl \
>> diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
>> new file mode 100755
>> index 0000000..beea3bd
>> --- /dev/null
>> +++ b/test/max_available_extent_ns.sh
>> @@ -0,0 +1,43 @@
>> +#!/bin/bash -Ex
>> +
>> +# SPDX-License-Identifier: GPL-2.0
>> +# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
>> +
>> +rc=77
>> +
>> +. ./common
>> +
>> +trap 'err $LINENO' ERR
>> +
>> +check_min_kver "4.19" || do_skip "kernel $KVER may not support max_available_size"
>> +
>> +init()
>> +{
>> +	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
>> +	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
>> +	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
>> +}
>> +
>> +do_test()
>> +{
>> +	region=$($NDCTL list -b $NFIT_TEST_BUS0 -R -t pmem | jq -r .[].dev | head -1)
> 
> On my test setup, this fails because the region returned is the 32M
> one. This causes the namespaces requested to be 8M sized, which is too
> small, and hence rejected (16M minimum).
> 
> The following jq query sorts it in descending size order and lets it
> choose the 64M region:
> 
> 	jq -r 'sort_by(-.size) | .[].dev'
> 
>> +
>> +	available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
>> +	size=$(( available_sz/4 ))
>> +
>> +	NS1=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
>> +	NS2=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
>> +	NS3=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
> 
> Since these happen in a subshell, errors are lost.
> Running in a subshell is fine, but we should test that the variables
> weren't blank:
> 
> 	test -n "$NS1"
> 
> And so on.
> 
>> +
>> +	$NDCTL disable-namespace $NS2
>> +	$NDCTL destroy-namespace $NS2
>> +
>> +	$NDCTL create-namespace -r $region -t pmem
>> +}
>> +
>> +modprobe nfit_test
>> +rc=1
>> +init
>> +do_test
>> +_cleanup
>> +exit 0
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
