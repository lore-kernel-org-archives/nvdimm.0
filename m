Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD8FF80348
 for <linux-nvdimm@lists.01.org>; Wed,  8 Mar 2017 09:10:04 -0800 (PST)
Received: by mail-oi0-x22d.google.com with SMTP id 126so22837945oig.3
 for <linux-nvdimm@lists.01.org>; Wed, 08 Mar 2017 09:10:04 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <58C0369C.9060100@hpe.com>
References: <148883211285.49239.17952572594430933942.stgit@djiang5-desk3.ch.intel.com>
 <148883236278.49239.9457895421265109054.stgit@djiang5-desk3.ch.intel.com>
 <58BF4E4D.8000406@hpe.com> <e565aec9-b400-6712-25b2-904a64b87dc4@intel.com>
 <58C0369C.9060100@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Mar 2017 09:10:03 -0800
Message-ID: <CAPcyv4jPGJ+C+HRJMhNBH6aHoqj4CyazXU+9Yv1pwuBQEkuSdw@mail.gmail.com>
Subject: Re: [PATCH 3/5] acpi: cleanup acpi_nfit_ctl calling xlat_status
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

On Wed, Mar 8, 2017 at 8:51 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 03/08/2017 11:29 AM, Dave Jiang wrote:
>> On 03/07/2017 05:20 PM, Linda Knippers wrote:
>>> On 03/06/2017 03:32 PM, Dave Jiang wrote:
>>>> Make sure that xlat_status is unconditionally called.
>>>
>>> Is this just code cleanup or is it fixing something?
>>
>> This is code clean up requested by Dan.
>
> Ok, then it seems like the commit message above should match
> the subject.  As it is, it makes it sound like it's important
> to call xlat_status unconditionally, but I still have a question
> about that below.
>
>>
>>>
>>>>
>>>> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>>>> ---
>>>>  drivers/acpi/nfit/core.c |   15 +++++++--------
>>>>  1 file changed, 7 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>>>> index 7361d00..9d4f461 100644
>>>> --- a/drivers/acpi/nfit/core.c
>>>> +++ b/drivers/acpi/nfit/core.c
>>>> @@ -199,7 +199,7 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>>>     acpi_handle handle;
>>>>     unsigned int func;
>>>>     const u8 *uuid;
>>>> -   int rc, i;
>>>> +   int rc = 0, xlat_rc, i;
>>>>
>>>>     func = cmd;
>>>>     if (cmd == ND_CMD_CALL) {
>>>> @@ -343,21 +343,20 @@ int acpi_nfit_ctl(struct nvdimm_bus_descriptor *nd_desc, struct nvdimm *nvdimm,
>>>>                      * unfilled in the output buffer
>>>>                      */
>>>>                     rc = buf_len - offset - in_buf.buffer.length;
>>>> -                   if (cmd_rc)
>>>> -                           *cmd_rc = xlat_status(nvdimm, buf, cmd,
>>>> -                                           fw_status);
>>>>             } else {
>>>>                     dev_err(dev, "%s:%s underrun cmd: %s buf_len: %d out_len: %d\n",
>>>>                                     __func__, dimm_name, cmd_name, buf_len,
>>>>                                     offset);
>>>>                     rc = -ENXIO;
>>>> +                   goto out;
>>>>             }
>>>> -   } else {
>>>> -           rc = 0;
>>>> -           if (cmd_rc)
>>>> -                   *cmd_rc = xlat_status(nvdimm, buf, cmd, fw_status);
>>>>     }
>>>>
>>>> +   xlat_rc = xlat_status(nvdimm, buf, cmd, fw_status);
>>>> +
>>>> +   if (cmd_rc)
>>>> +           *cmd_rc = xlat_rc;
>>>
>>> Is there some benefit of calling xlat_status and then throwing away the result?
>>
>> It's not exactly thrown away. I tried to preserve the original code path
>> as much as possible.
>
> The original code only calls xlat_status if cmd_rc is set, but you call it,
> then don't use the result if cmd_rc isn't set.  Why call it if you know
> ahead of time you're not going to use the result?  That's what I don't
> understand.  Why isn't the call made only 'if (cmd_rc)', like the original
> code?
>

In a following patch we use the xlat_rc result even in cases when
cmd_rc is NULL.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
