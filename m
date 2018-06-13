Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qt0-x244.google.com (mail-qt0-x244.google.com
 [IPv6:2607:f8b0:400d:c0d::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22CE82116DA35
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:42:48 -0700 (PDT)
Received: by mail-qt0-x244.google.com with SMTP id o9-v6so997263qtp.3
 for <linux-nvdimm@lists.01.org>; Tue, 12 Jun 2018 18:42:48 -0700 (PDT)
Subject: Re: [PATCH 2/2] test: cleanup test scripts
References: <20180611164531.8242-1-msys.mizuma@gmail.com>
 <20180611164531.8242-3-msys.mizuma@gmail.com>
 <1528846089.4998.15.camel@intel.com>
From: Masayoshi Mizuma <msys.mizuma@gmail.com>
Message-ID: <3dcfea10-cab9-16d4-736e-306355b62933@gmail.com>
Date: Tue, 12 Jun 2018 21:42:46 -0400
MIME-Version: 1.0
In-Reply-To: <1528846089.4998.15.camel@intel.com>
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

Thank you for your review! I'll send v2 patch.

- Masa

On 06/12/2018 07:28 PM, Verma, Vishal L wrote:
> On Mon, 2018-06-11 at 12:45 -0400, Masayoshi Mizuma wrote:
>> From: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>>
>> Include 'common' file to use some fucntions for test scripts.
>>
>> Signed-off-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
>> ---
>>  test/blk-exhaust.sh       | 21 +++-------------
>>  test/btt-check.sh         | 35 ++++++++------------------
>>  test/btt-errors.sh        | 20 ++++-----------
>>  test/btt-pad-compat.sh    | 52 ++++++++++++++-------------------------
>>  test/clear.sh             | 21 +++-------------
>>  test/create.sh            | 21 +++-------------
>>  test/daxdev-errors.sh     | 19 +++-----------
>>  test/firmware-update.sh   | 25 ++++---------------
>>  test/inject-error.sh      | 31 ++++++-----------------
>>  test/label-compat.sh      | 21 +++-------------
>>  test/multi-dax.sh         | 19 +++-----------
>>  test/pmem-errors.sh       | 20 +++++----------
>>  test/rescan-partitions.sh | 44 +++++++++------------------------
>>  test/sector-mode.sh       |  5 +---
>>  14 files changed, 89 insertions(+), 265 deletions(-)
> 
> Hi Masayoshi,
> 
> This is a welcome cleanup. It looks good except for a couple of nits.
> First, can you add a SPDX style license header to the new test/common file?
> Second, see below -
> 
> [..]
> 
>>
>> diff --git a/test/firmware-update.sh b/test/firmware-update.sh
>> index c2cf578..1ed60b1 100755
>> --- a/test/firmware-update.sh
>> +++ b/test/firmware-update.sh
>> @@ -12,25 +12,9 @@ rc=77
>>  dev=""
>>  image="update-fw.img"
>>  
>> -trap 'err $LINENO' ERR
>> +. ./common
>>  
>> -# $1: Line number
>> -# $2: exit code
>> -err()
>> -{
>> -	[ -n "$2" ] && rc="$2"
>> -	echo "test/firmware-update.sh: failed at line $1"
>> -	exit "$rc"
>> -}
>> -
>> -check_min_kver()
>> -{
>> -	local ver="$1"
>> -	: "${KVER:=$(uname -r)}"
>> -
>> -	[ -n "$ver" ] || return 1
>> -	[[ "$ver" == "$(echo -e "$ver\n$KVER" | sort -V | head -1)" ]]
>> -}
>> +trap 'err $LINENO' ERR
>>  
>>  reset()
>>  {
>> @@ -52,7 +36,7 @@ cleanup()
>>  detect()
>>  {
>>  	dev=$($ndctl list -b "$bus" -D | jq .[0].dev | tr -d '"')
>> -	[ -n "$dev" ] || err "$LINENO" 2
>> +	[ -n "$dev" ] || rc=2 && err "$LINENO"
> 
> This || .. && will not work as expected. If $dev is null it will set rc to
> 2, and if it exists, then it will err(). What we want is 
> 
> [ -n "$dev" ] || { rc=2 && err "$LINENO"; }
> Or even better,
> 
>    @@ -36,7 +36,7 @@ cleanup()
>     detect()
>     {
>            dev=$($ndctl list -b "$bus" -D | jq .[0].dev | tr -d '"')
>    -   [ -n "$dev" ] || rc=2 && err "$LINENO"
>    + [ -n "$dev" ] || err "$LINENO"
>     }
>     
>     do_tests()
>    @@ -50,6 +50,7 @@ check_min_kver "4.16" || do_skip "may lack firmware update test handling"
>     modprobe nfit_test
>     rc=1
>     reset
>    +rc=2
>     detect
>     do_tests
> 
> The rest looks good.
> 
> Thanks,
> 	-Vishal
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
