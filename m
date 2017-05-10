Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7C36C21A18AAB
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 14:13:46 -0700 (PDT)
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
 <1494441822.30303.77.camel@hpe.com>
 <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
 <1494449841.30303.80.camel@hpe.com>
From: Dave Jiang <dave.jiang@intel.com>
Message-ID: <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
Date: Wed, 10 May 2017 14:13:45 -0700
MIME-Version: 1.0
In-Reply-To: <1494449841.30303.80.camel@hpe.com>
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



On 05/10/2017 01:57 PM, Kani, Toshimitsu wrote:
> On Wed, 2017-05-10 at 12:56 -0700, Dave Jiang wrote:
>>
>> On 05/10/2017 11:43 AM, Kani, Toshimitsu wrote:
>>> On Wed, 2017-05-10 at 11:03 -0700, Dave Jiang wrote:
>>>> ACPI NFIT enabled platforms provide media errors as absolute
>>>> phyiscal
>>>> address offsets. Add an option to ndctl to display those media
>>>> errors
>>>> tranlsated to region and namespace device level offsets in an
>>>> "ndctl
>>>> list" listing.
>>>>
>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> ---
>>>>
>>>> v2: added fix to badblocks display from Toshi's testing result.
>>>> v3: fixed naming issues from Dan's comments.
>>>>     fixed badblocks boundary offset calculations from Toshi's
>>>> testing.
>>>
>>> Thanks for the quick update.  This version works nicely for dax and
>>> memory modes.  Is there particular reason why it does not list
>>> errors for raw and sector modes?
>>
>> So it should work for raw AFAICT. Dan said the BTT ones don't make
>> sense because the namespace relative offset is dynamic.
>>
>>
>> # ./ndctl/ndctl list -NM
>> [
>>   {
>>     "dev":"namespace5.0",
>>     "mode":"raw",
>>     "size":33554432,
>>     "uuid":"bb3539dd-065c-41bd-8bcc-dc3bbc3317a5",
>>     "badblocks":[
>>       {
>>         "offset":4,
>>         "length":1
>>       },
>>       {
>>         "offset":32768,
>>         "length":8
>>       },
>>       {
>>         "offset":65528,
>>         "length":8
>>       }
>>     ],
>>     "blockdev":"pmem5"
>>   },
> 
> Attached "strace.log".  Note, there is no reference to "badblocks"
> files in the log.

Hmmm....is there any reason my raw namespace is different type than
yours? Do you know if yours hit the else branch on util/json.c:516 in
util_namespace_to_json()? That is the only thing I can think of that
would show no badblocks in the strace.

> 
> I agree that offsets do not make sense for BTT, but it leads to a false
> impression that there is no error.  Perhaps, we can remove "offset" or
> put "n/a" for BTT.

I'm ok with that if Dan has no problem with it.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
