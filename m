Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5653F21A16E26
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 15:24:58 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id b204so11166101oii.1
 for <linux-nvdimm@lists.01.org>; Wed, 10 May 2017 15:24:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
References: <149443923101.16024.9360569471346131929.stgit@djiang5-desk3.ch.intel.com>
 <149443929943.16024.5561881574160309534.stgit@djiang5-desk3.ch.intel.com>
 <1494441822.30303.77.camel@hpe.com>
 <e2873152-d765-4bcd-40c8-2f8caaa72803@intel.com>
 <1494449841.30303.80.camel@hpe.com>
 <c3b83dd6-e45a-82b5-92f9-c49e9d80ba3d@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 10 May 2017 15:24:56 -0700
Message-ID: <CAPcyv4jL-5sOVSm8+E_drQdOw-UQ3owajuJfBdTAhYxy97130Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ndctl: add list --media-errors support
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 10, 2017 at 2:13 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>
>
> On 05/10/2017 01:57 PM, Kani, Toshimitsu wrote:
>> On Wed, 2017-05-10 at 12:56 -0700, Dave Jiang wrote:
>>>
>>> On 05/10/2017 11:43 AM, Kani, Toshimitsu wrote:
>>>> On Wed, 2017-05-10 at 11:03 -0700, Dave Jiang wrote:
>>>>> ACPI NFIT enabled platforms provide media errors as absolute
>>>>> phyiscal
>>>>> address offsets. Add an option to ndctl to display those media
>>>>> errors
>>>>> tranlsated to region and namespace device level offsets in an
>>>>> "ndctl
>>>>> list" listing.
>>>>>
>>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>>> ---
>>>>>
>>>>> v2: added fix to badblocks display from Toshi's testing result.
>>>>> v3: fixed naming issues from Dan's comments.
>>>>>     fixed badblocks boundary offset calculations from Toshi's
>>>>> testing.
>>>>
>>>> Thanks for the quick update.  This version works nicely for dax and
>>>> memory modes.  Is there particular reason why it does not list
>>>> errors for raw and sector modes?
>>>
>>> So it should work for raw AFAICT. Dan said the BTT ones don't make
>>> sense because the namespace relative offset is dynamic.
>>>
>>>
>>> # ./ndctl/ndctl list -NM
>>> [
>>>   {
>>>     "dev":"namespace5.0",
>>>     "mode":"raw",
>>>     "size":33554432,
>>>     "uuid":"bb3539dd-065c-41bd-8bcc-dc3bbc3317a5",
>>>     "badblocks":[
>>>       {
>>>         "offset":4,
>>>         "length":1
>>>       },
>>>       {
>>>         "offset":32768,
>>>         "length":8
>>>       },
>>>       {
>>>         "offset":65528,
>>>         "length":8
>>>       }
>>>     ],
>>>     "blockdev":"pmem5"
>>>   },
>>
>> Attached "strace.log".  Note, there is no reference to "badblocks"
>> files in the log.
>
> Hmmm....is there any reason my raw namespace is different type than
> yours? Do you know if yours hit the else branch on util/json.c:516 in
> util_namespace_to_json()? That is the only thing I can think of that
> would show no badblocks in the strace.
>
>>
>> I agree that offsets do not make sense for BTT, but it leads to a false
>> impression that there is no error.  Perhaps, we can remove "offset" or
>> put "n/a" for BTT.
>
> I'm ok with that if Dan has no problem with it.
>

It doesn't strike me as the best path forward. Ideally what we need is
a customized btt badblocks interface that knows how to reverse lookup
media errors into active / btt relative sector offsets. Until we have
that, to list the errors that are associated with the btt namespace
you need to reload it in raw mode or just relay on the parent region
media error list. Now, that said I wouldn't mind if we had a flag that
indicates whether badblocks are present or not by default, and then -M
tries to list them. Something like this where we have 2 namespaces in
the same region that has badblocks:

# ndctl list
[
  {
    "dev":"namespace0.0",
    "mode":"sector",
    "size":4294967296,
    "uuid":"3f45c754-5e8e-4d3e-89db-53ae5cc5a9bd",
    "blockdev":"pmem0s",
    "has_badblocks":true,
  },
  {
    "dev":"namespace0.1",
    "mode":"memory",
    "size":15852371968,
    "uuid":"6446b3bd-b64a-4163-b542-d82ed557fb78",
    "blockdev":"pmem0.1"
    "has_badblocks":true,
 },
]

# ndctl list -M
[
  {
    "dev":"namespace0.0",
    "mode":"sector",
    "size":4294967296,
    "uuid":"3f45c754-5e8e-4d3e-89db-53ae5cc5a9bd",
    "blockdev":"pmem0s",
    "has_badblocks":true,
  },
  {
    "dev":"namespace0.1",
    "mode":"memory",
    "size":15852371968,
    "uuid":"6446b3bd-b64a-4163-b542-d82ed557fb78",
    "blockdev":"pmem0.1"
    "has_badblocks":true,
    "badblocks":[
      {
        "offset":4,
        "length":1
      },
 },
]

In the common case where there are no badblocks we can just had the
"has_badblocks" boolean.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
