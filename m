Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x242.google.com (mail-oi0-x242.google.com
 [IPv6:2607:f8b0:4003:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2082C211F8895
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 13:30:32 -0700 (PDT)
Received: by mail-oi0-x242.google.com with SMTP id k81-v6so25710420oib.4
 for <linux-nvdimm@lists.01.org>; Fri, 06 Jul 2018 13:30:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1530908758.7574.40.camel@intel.com>
References: <153073826178.9647.3462886609135347418.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1530908758.7574.40.camel@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Jul 2018 13:30:30 -0700
Message-ID: <CAPcyv4hCTXSodetks8xxrwSnErw42-RBJhHGDaLOTso2a2xEhA@mail.gmail.com>
Subject: Re: [ndctl PATCH] ndctl, test: Fix dax.sh return code
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 6, 2018 at 1:26 PM, Verma, Vishal L
<vishal.l.verma@intel.com> wrote:
>
> On Wed, 2018-07-04 at 14:04 -0700, Dan Williams wrote:
>> Commit 11b349b5236e "ndctl, test: Disable poison tests for now"
>> inadvertently prevented the dax.sh test from ever succeeding. Revert
>> the
>> change to return $rc instead of 0.
>>
>> Fixes: 11b349b5236e ("ndctl, test: Disable poison tests for now")
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  test/dax.sh |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/test/dax.sh b/test/dax.sh
>> index 30fe16721935..2a82281edb35 100755
>> --- a/test/dax.sh
>> +++ b/test/dax.sh
>> @@ -90,4 +90,4 @@ json=$($NDCTL create-namespace -m raw -f -e $dev)
>>  eval $(echo $json | sed -e "$json2var")
>>  [ $mode != "fsdax" ] && echo "fail: $LINENO" &&  exit 1
>>
>> -exit $rc
>> +exit 0
>
> I'm not sure I understand why this will cause it to always fail. rc is
> set in run_test, and that takes care of erroring out when the test
> returns anything other than 0 or 77. In case of 0 or 77, it falls
> through. So in the end here, we do want 'exit $rc' so we propagate the
> 77 correctly. Am I missing something?

rc=1

https://github.com/pmem/ndctl/blob/master/test/dax.sh#L47
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
