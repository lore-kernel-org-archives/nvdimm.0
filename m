Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F5721A1E1F
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 19:53:45 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id 4so5172332oih.2
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 19:53:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CS1PR84MB0005F40F71804F3988DD23CB82EA0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
 <1471996023.1532.6.camel@hpe.com>
 <CAPcyv4gJtTj8chX_eTNhs1PJ=D3X7USuDXwFSWSEZt1cUAXpUw@mail.gmail.com>
 <CS1PR84MB0005F40F71804F3988DD23CB82EA0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 19:53:28 -0700
Message-ID: <CAPcyv4jH+R0vPyMvDhNmrQ-DjvMe_KW9SxPoQCdX8Zbgd3KESA@mail.gmail.com>
Subject: Re: [PATCH] memremap: Fix NULL pointer BUG in get_zone_device_page()
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
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "ard.biesheuvel@linaro.org" <ard.biesheuvel@linaro.org>, "Mulumudi, Abhilash Kumar  <m.abhilash-kumar@hpe.com>, linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "brian.starkey@arm.com" <brian.starkey@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 23, 2016 at 6:29 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> On Tue, Aug 23, 2016 at 4:47 PM, Kani, Toshimitsu <toshi.kani@hpe.com>
>> wrote:
>> > On Tue, 2016-08-23 at 15:32 -0700, Dan Williams wrote:
>> >> On Tue, Aug 23, 2016 at 11:43 AM, Toshi Kani <toshi.kani@hpe.com>
>> >> wrote:
>> >  :
>> >> I'm not sure about this fix.  The point of honoring
>> >> vmem_altmap_offset() is because a portion of the resource that is
>> >> passed to devm_memremap_pages() also contains the metadata info
>> block
>> >> for the device.  The offset says "use everything past this point for
>> >> pages".  This may work for avoiding a crash, but it may corrupt info
>> >> block metadata in the process.  Can you provide more information
>> >> about the failing scenario to be sure that we are not triggering a
>> >> fault on an address that is not meant to have a page mapping?  I.e.
>> >> what is the host physical address of the page that caused this fault,
>> >> and is it valid?
>> >
>> > The fault address in question was the 2nd page of an NVDIMM range.  I
>> > assumed this fault address was valid and needed to be handled.  Here is
>> > some info about the base and patched cases.  Let me know if you need
>> > more info.
>> >
>> > Base
>> > ====
>> >
>> > The following NVDIMM range was set to /dev/dax.
>>
>> With ndctl create-namespace or manually via sysfs?  Specifically I'm
>> looking for what the 'align' attribute was set to when the
>> configuration was established.  Can you provide a dump of the sysfs
>> attributes for the /dev/dax parent device?
>
> I used the ndctl command below.
> ndctl create-namespace -f -e namespace0.0 -m dax
>
> Here is additional info from my note for the base case.
>
> p {struct dev_pagemap} 0xffff88046d0453f0
> $3 = {
>   altmap = 0xffff88046d045410,
>   res = 0xffff88046d0453a8,
>   ref = 0xffff88046d0452f0,
>   dev = 0xffff880464790410
> }
>
> crash> p {struct vmem_altmap} 0xffff88046d045410
> $6 = {
>   base_pfn = 0x480000,
>   reserve = 0x2,        // PHYS_PFN(SZ_8K)
>   free = 0x101fe,
>   align = 0x1fe,
>   alloc = 0x10000
> }

Ah, so, on second look the 0x490200000 data offset looks correct.  The
total size of the address range is 16GB which equates to 256MB needed
for struct page, plus 2MB more to re-align the data on the next 2MB
boundary.

The question now is why is the guest faulting on an access to an
address less than 0x490200000?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
