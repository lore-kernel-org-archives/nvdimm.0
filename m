Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x242.google.com (mail-qk0-x242.google.com
 [IPv6:2607:f8b0:400d:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F1707210C2D92
 for <linux-nvdimm@lists.01.org>; Thu,  2 Aug 2018 13:42:19 -0700 (PDT)
Received: by mail-qk0-x242.google.com with SMTP id 191-v6so2529563qki.13
 for <linux-nvdimm@lists.01.org>; Thu, 02 Aug 2018 13:42:19 -0700 (PDT)
Subject: Re: [ndctl PATCHv4] ndctl: Use max_available_extent for namespace
References: <20180724223125.14288-1-keith.busch@intel.com>
 <8f57ae0d-3ab0-f3ce-160c-9d02cf9fe062@gmail.com>
 <1533239603.8557.64.camel@intel.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <50ef3aee-097a-d9f2-cc2a-1c8773106073@gmail.com>
Date: Thu, 2 Aug 2018 16:42:16 -0400
MIME-Version: 1.0
In-Reply-To: <1533239603.8557.64.camel@intel.com>
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
To: vishal.l.verma@intel.com, keith.busch@intel.com, dave.jiang@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

On 08/02/2018 03:53 PM, Verma, Vishal L wrote:
> 
> On Thu, 2018-08-02 at 15:49 -0400, Masayoshi Mizuma wrote:
>> Hi Keith,
>>
>> I tested your patch with the following test script.
>> The result is good to me. 
>>
>> Please feel free to add:
>>
>>    Tested-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>>
>> Test script:
>> ---
>> #!/bin/bash -Ex
>>
>> NDCTL=./ndctl/ndctl
>>
>> modprobe nfit_test
>> region=$($NDCTL list -b nfit_test.0 -R -t pmem | jq -r .[].dev | head
>> -1)
>>
>> available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
>> size=$(( available_sz/4 ))
>>
>> NS1=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r
>> .dev)
>> NS2=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r
>> .dev)
>> NS3=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r
>> .dev)
>>
>> $NDCTL disable-namespace $NS2
>> $NDCTL destroy-namespace $NS2
>>
>> $NDCTL list -r $region
>>
>> $NDCTL create-namespace -r $region -t pmem 
>> ret=$?
>>
>> $NDCTL disable-region all
>> modprobe -r nfit_test
>>
>> exit $ret
> 
> Hi Masa,
> 
> Thanks for the testing, I will add the Tested-by.
> 
> If you also wanted to package up this script as a unit test, I'd be
> happy to include it. Would be gated on KVER=4.19

Sounds great :-) 
Here is the patch for unit test:

--------
From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Date: Thu, 2 Aug 2018 16:20:45 -0400
Subject: [PATCH] ndctl, test: add a new unit test for max_available_extent
 namespace

Add a new unit test to test max_available_extent namespace.
This function is implemented by the following patches.

  kernel side:
    https://lists.01.org/pipermail/linux-nvdimm/2018-July/016731.html
    https://lists.01.org/pipermail/linux-nvdimm/2018-July/016732.html

  ndctl side:
    https://lists.01.org/pipermail/linux-nvdimm/2018-July/017176.html

Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
---
 test/Makefile.am                |  3 ++-
 test/max_available_extent_ns.sh | 43 +++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+), 1 deletion(-)
 create mode 100755 test/max_available_extent_ns.sh

diff --git a/test/Makefile.am b/test/Makefile.am
index 8c55056..9af2464 100644
--- a/test/Makefile.am
+++ b/test/Makefile.am
@@ -22,7 +22,8 @@ TESTS =\
 	firmware-update.sh \
 	ack-shutdown-count-set \
 	rescan-partitions.sh \
-	monitor.sh
+	monitor.sh \
+	max_available_extent_ns.sh
 
 check_PROGRAMS =\
 	libndctl \
diff --git a/test/max_available_extent_ns.sh b/test/max_available_extent_ns.sh
new file mode 100755
index 0000000..4a44625
--- /dev/null
+++ b/test/max_available_extent_ns.sh
@@ -0,0 +1,43 @@
+#!/bin/bash -Ex
+
+# SPDX-License-Identifier: GPL-2.0
+# Copyright(c) 2018, FUJITSU LIMITED. All rights reserved.
+
+rc=77
+
+. ./common
+
+trap 'err $LINENO' ERR
+
+check_min_kver "4.19" || do_skip "kernel $KVER may not support max_available_size"
+
+init()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+}
+
+do_test()
+{
+	region=$($NDCTL list -b nfit_test.0 -R -t pmem | jq -r .[].dev | head -1)
+
+	available_sz=$($NDCTL list -r $region | jq -r .[].available_size)
+	size=$(( available_sz/4 ))
+
+	NS1=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
+	NS2=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
+	NS3=$($NDCTL create-namespace -r $region -t pmem -s $size | jq -r .dev)
+
+	$NDCTL disable-namespace $NS2
+	$NDCTL destroy-namespace $NS2
+
+	$NDCTL create-namespace -r $region -t pmem
+}
+
+modprobe nfit_test
+rc=1
+init
+do_test
+_cleanup
+exit 0
-- 
2.18.0

Thanks,
Masa

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
