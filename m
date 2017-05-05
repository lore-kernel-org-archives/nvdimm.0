Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22f.google.com (mail-it0-x22f.google.com
 [IPv6:2607:f8b0:4001:c0b::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A212B21A1348D
 for <linux-nvdimm@lists.01.org>; Fri,  5 May 2017 13:01:32 -0700 (PDT)
Received: by mail-it0-x22f.google.com with SMTP id x188so14883752itb.0
 for <linux-nvdimm@lists.01.org>; Fri, 05 May 2017 13:01:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <590CD566.6090307@hpe.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
 <149393454140.2642.16610436149753296619.stgit@djiang5-desk3.ch.intel.com>
 <CAPcyv4j0DKBBfjybWmkqNByJqL4VA_fw-0myLggBYiScvkMc2g@mail.gmail.com>
 <590CD566.6090307@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 5 May 2017 13:01:30 -0700
Message-ID: <CAPcyv4h9NfpF_n376u69FK5ddfJELBNhSaGFDrD5ku0LcMaxvw@mail.gmail.com>
Subject: Re: [PATCH v6 1/3] ndctl: add clear-error to ndctl for device dax
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 5, 2017 at 12:41 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 05/05/2017 03:14 PM, Dan Williams wrote:
>> On Thu, May 4, 2017 at 2:49 PM, Dave Jiang <dave.jiang@intel.com> wrote:
>>> Adding ndctl support that will allow clearing of bad blocks for a device.
>>> Initial implementation will only support device dax devices. The ndctl
>>> takes a device path and parameters of the starting bad block, and the number
>>> of bad blocks to clear.
>>>
>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>> ---
>>>  Documentation/ndctl-clear-error.txt |   38 ++++++
>>>  builtin.h                           |    1
>>>  ndctl/Makefile.am                   |    1
>>>  ndctl/clear-error.c                 |  239 +++++++++++++++++++++++++++++++++++
>>>  ndctl/lib/libndctl.c                |   72 +++++++++++
>>>  ndctl/lib/libndctl.sym              |    2
>>>  ndctl/libndctl.h.in                 |   10 +
>>>  ndctl/ndctl.c                       |    1
>>>  8 files changed, 364 insertions(+)
>>>  create mode 100644 Documentation/ndctl-clear-error.txt
>>>  create mode 100644 ndctl/clear-error.c
>>>
>>> diff --git a/Documentation/ndctl-clear-error.txt b/Documentation/ndctl-clear-error.txt
>>> new file mode 100644
>>> index 0000000..b14521a
>>> --- /dev/null
>>> +++ b/Documentation/ndctl-clear-error.txt
>>> @@ -0,0 +1,38 @@
>>> +ndctl-clear-error(1)
>>> +====================
>>> +
>>> +NAME
>>> +----
>>> +ndctl-clear-error - clear badblocks for a device
>>
>> I think "clear-error" is too ambiguous of a name, lets call the
>> commands repair-media-errors and list-media-errors.
>>
>> I'd also like to see the list-media-errors patch first in the series
>> since repairing is just an incremental step on top of listing. I don't
>> think the word "badblocks" should appear anywhere in this document.
>> That's a kernel implementation detail.
>
> Is this just for device dax?  If so, that should be more clear in the text,
> rather than just used in the example.  If it's for other types of pmem devices,
> then badblocks would make sense to keep, assuming it relates to the
> badblocks information exposed in /sys.

It's not necessarily just for device-dax, that's just a starting
point. The tool could gather errors some other way, so I don't think
we want to leak the "badblocks" name to this interface.

>> The other benefit of "repair" vs "clear" is communicating that the
>> data may be indeterminate after repair.
>
> For me, repair means you fixed it. If you want to communicate that the
> data is indeterminate, I think you should say that in the doc rather
> than assuming people interpret the word the same way you do.

True, and I think this aligns with another discomfort that we're
trying to define an explicit error clearing interface when it really
should an interface that writes data with error clearing as a side
effect. Just like the block device error clearing case. I think we
should abandon this command and jsut go create a command that just
knows how to clear errors while writing, then a lot of these
interpretation problems go away.


>> Hopefully in the future we'll
>> get a standard mechanism to determine if the platform supports atomic
>> error clearing with a determinate value.
>>
>>> +
>>> +SYNOPSIS
>>> +--------
>>> +[verse]
>>> +'ndctl clear-error' [<options>]
>>> +
>>> +EXAMPLES
>>> +--------
>>> +
>>> +Clear poison (bad blocks) for the provided device
>>> +[verse]
>>> +ndctl clear-error -f /dev/dax0.0 -s 0 -l 8
>>> +
>>> +Clear poison (bad blocks) at block offset 0 for 8 blocks on device /dev/dax0.0
>>
>> The "poison" term is x86 specific. Lets just use "media error" everywhere.
>
> If you really mean uncorrectable error reported by an Address Range Scrub, you
> could say that too.  Or are there other types of media errors that this could
> work with?

I'm thinking about other architectures outside of x86 + ACPI that may
have different terminology. So, the intent was to have something
generic, but this concern also goes away if we just move to a model
where the tool writes new data to clear errors.

>>> +
>>> +-l::
>>> +--len::
>>> +       The number of badblocks to clear in size of 512 bytes increments. The
>>> +       length must fit within the badblocks range. If the length exceeds the
>>> +       badblock range or is 0, the command will fail. Not providing a len
>>> +       will result in a single block being cleared.
>>
>> s/badblocks/media error/
>
> If it's really not a badblock, does the 512 byte increment still make sense?
> There's a DSM to get the unit size for what can be cleared which may not
> be 512.  If the clearable unit is smaller, we're clearing too much.  If the unit
> is larger, then we can't clear less than that.

Hopefully the units never get larger than 512. Since we can't address
smaller than 512 bytes for block devices, I'd rather not expose the
smaller than 512-byte error clearing support with this interface.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
