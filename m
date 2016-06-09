Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD1FD1A1DFB
 for <linux-nvdimm@lists.01.org>; Thu,  9 Jun 2016 15:35:14 -0700 (PDT)
Received: by mail-oi0-x232.google.com with SMTP id p204so86335802oih.3
 for <linux-nvdimm@lists.01.org>; Thu, 09 Jun 2016 15:34:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <888aeb53-69b4-652b-8f89-822af4622acf@hpe.com>
References: <1464938015-5489-1-git-send-email-jlee@suse.com>
 <CAPcyv4iLb9qzXZTLL5z-RH_CRObnRfzx=vGTvVvieJUEwNvtRw@mail.gmail.com>
 <20160604110156.GA4558@linux-rxt1.site>
 <888aeb53-69b4-652b-8f89-822af4622acf@hpe.com>
Date: Thu, 9 Jun 2016 15:34:52 -0700
Message-ID: <CAPcyv4jxq3XME9a7Upv0BvuaFvULCtqa9=L6L29nOeBGPiZZsA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm, nfit: treat volatile virtual CD region as
 read-only pmem
From: Dan Williams <dan.j.williams@intel.com>
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, joeyli <jlee@suse.com>, Linux ACPI <linux-acpi@vger.kernel.org>, Lee,
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 9, 2016 at 3:08 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 6/4/2016 7:01 AM, joeyli wrote:
>> Hi Dan,
>>
>> Thanks for your review.
>>
>> On Fri, Jun 03, 2016 at 12:27:34PM -0700, Dan Williams wrote:
>>> On Fri, Jun 3, 2016 at 12:13 AM, Lee, Chun-Yi <joeyli.kernel@gmail.com> wrote:
>>>> This patch adds codes to treat a volatile virtual CD region as a
>>>> read-only pmem region, then read-only /dev/pmem* device can be mounted
>>>> with iso9660.
>>>>
>>>> It's useful to work with the httpboot in EFI firmware to pull a remote
>>>> ISO file to the local memory region for booting and installation.
>>>>
>>>> Wiki page of UEFI HTTPBoot with OVMF:
>>>>         https://en.opensuse.org/UEFI_HTTPBoot_with_OVMF
>>>>
>>>> Signed-off-by: Lee, Chun-Yi <jlee@suse.com>
>>>> Cc: Gary Lin <GLin@suse.com>
>>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>>> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
>>>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>>>> ---
>>>>  drivers/acpi/nfit.c          |  8 +++++++-
>>>>  drivers/nvdimm/region_devs.c | 26 +++++++++++++++++++++++++-
>>>>  include/linux/libnvdimm.h    |  2 ++
>>>>  3 files changed, 34 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/nfit.c b/drivers/acpi/nfit.c
>>>> index 2215fc8..b100a17 100644
>>>> --- a/drivers/acpi/nfit.c
>>>> +++ b/drivers/acpi/nfit.c
>>>> @@ -1949,6 +1949,7 @@ static int acpi_nfit_init_mapping(struct acpi_nfit_desc *acpi_desc,
>>>>         switch (nfit_spa_type(spa)) {
>>>>         case NFIT_SPA_PM:
>>>>         case NFIT_SPA_VOLATILE:
>>>> +       case NFIT_SPA_VCD:
>>>>                 nd_mapping->start = memdev->address;
>>>>                 nd_mapping->size = memdev->region_size;
>>>>                 break;
>>>
>>> Why do we need to distinguish NFIT_SPA_VOLATILE vs NFIT_SPA_VCD, i.e.
>>> what happens if something writes to a VCD device?
>>
>> Actually I didn't try to write SPA-VCD device before. Every time I mount it
>> that the system responses read-only:
>>
>> # mount /dev/pmem0 /mnt/
>> mount: /dev/pmem0 is write-protected, mounting read-only
>>
>> If it can be written, then I think there have no difference between
>> NFIT_SPA_VOLATILE with NFIT_SPA_VCD region.
>
> It's not clear to me what the expectations for this type of device are, or
> whether they should be read-only.  The ACPI spec is not helpful here.
> The other Disk Region and CD Region types are also unclear.  Anyone
> care to define them?
>
>> I implemented this patch to treat VCD region as read-only pmem because the
>> pmem region generates /dev/pmem* device that it can be mounted.
>
> I'm a bit worried about this type of device showing up as a "pmem" device.
> I realize they're described in the NFIT (not sure why but they are) but do
> any of the operations that we support for other pmem devices work on these?

It would be just another pmem device, so it would support all of them.

> Do root device DSMs make any sense?

Root device DSMs take a physical address so they could apply, but I
assume a firmware could simply refuse to run any operations against
them.

> Are there other DSMs?

Not that I can think of...

> What will happen if someone uses ndctl to reconfigure the device?

It won't know or care about the difference.  Unless there's a negative
side effect of allowing writes to a "volatile cd" it would be yet
another pmem device.

> I'm especially concerned on systems that might have one of these devices
> and also have NVDIMMs.  Do all the pmem devices get numbered different if
> this device comes and goes across reboots?  (I know, we shouldn't rely on
> those names but it will still confuse people.)  Can they be some other name
> that better represents what they're trying to be?

If they all go through the same driver they should have the same
naming scheme.  Software should be identifying the block device via
blkid, not kernel device name.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
