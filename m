Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM03-DM3-obe.outbound.protection.outlook.com
 (mail-dm3nam03on071b.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe49::71b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27FC481F28
 for <linux-nvdimm@lists.01.org>; Mon,  5 Dec 2016 13:54:58 -0800 (PST)
Message-ID: <5845E22A.7070801@hpe.com>
Date: Mon, 5 Dec 2016 16:54:50 -0500
From: Linda Knippers <linda.knippers@hpe.com>
MIME-Version: 1.0
Subject: Re: [PATCH] nfit: Fix extended status translations for ACPI DSMs
References: <1480973246-32078-1-git-send-email-vishal.l.verma@intel.com>
 <CAPcyv4hMB3GnphdfRqmoda6ZuxtPvPZM65ksM6tHc-WVBkwDSw@mail.gmail.com>
 <1480974124.2586.0.camel@intel.com>
In-Reply-To: <1480974124.2586.0.camel@intel.com>
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

On 12/05/2016 04:43 PM, Verma, Vishal L wrote:
> On Mon, 2016-12-05 at 13:37 -0800, Dan Williams wrote:
>> On Mon, Dec 5, 2016 at 1:27 PM, Vishal Verma <vishal.l.verma@intel.com
>>> wrote:
>>>
>>> ACPI DSMs can have an 'extended' status which can be non-zero to
>>> convey
>>> additional information about the command. In the xlat_status
>>> routine,
>>> where we translate the command statuses, we were returning an error
>>> for
>>> a non-zero extended status, even if the primary status indicated
>>> success.
>>>
>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
>>> ---
>>>  drivers/acpi/nfit/core.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
>>> index 71a7d07..d14f09b 100644
>>> --- a/drivers/acpi/nfit/core.c
>>> +++ b/drivers/acpi/nfit/core.c
>>> @@ -169,7 +169,7 @@ static int xlat_status(void *buf, unsigned int
>>> cmd, u32 status)
>>>         }
>>>
>>>         /* all other non-zero status results in an error */
>>> -       if (status)
>>> +       if (status & 0xffff)
>>>                 return -EIO;
>>
>> I don't think this is right, because we have no idea at this point
>> whether extended status is fatal or not.
>>
>> Each 'case' statement in that 'switch' should be returning 0 if it
>> does not see any errors. Because that's the only part of the function
>> with per-command knowledge of extended being benign / informational vs
>> fatal.
> 
> Good point - I was wondering just that.. I'll resend.

But can't that function be called with the status for DSMs that aren't in switch
statement?

All the DSM specs I've seen separate the status into status and extended or function-specific
status,  which is either defined or reserved. If the 2 bytes of status don't indicate
a failure, I don't think you should return EIO just because there may be
something set in a reserved bit.

-- ljk

> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
