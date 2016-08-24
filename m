Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E55F21A1E1B
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 18:00:31 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id l203so2458801oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 18:00:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471996023.1532.6.camel@hpe.com>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
 <1471996023.1532.6.camel@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 18:00:30 -0700
Message-ID: <CAPcyv4g==6zCOO2nr4CV8r8cDe11KCfCrq5MQiUgNapmLey9Pw@mail.gmail.com>
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

On Tue, Aug 23, 2016 at 4:47 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
> On Tue, 2016-08-23 at 15:32 -0700, Dan Williams wrote:
>> On Tue, Aug 23, 2016 at 11:43 AM, Toshi Kani <toshi.kani@hpe.com>
>> wrote:
>  :
>> I'm not sure about this fix.  The point of honoring
>> vmem_altmap_offset() is because a portion of the resource that is
>> passed to devm_memremap_pages() also contains the metadata info block
>> for the device.  The offset says "use everything past this point for
>> pages".  This may work for avoiding a crash, but it may corrupt info
>> block metadata in the process.  Can you provide more information
>> about the failing scenario to be sure that we are not triggering a
>> fault on an address that is not meant to have a page mapping?  I.e.
>> what is the host physical address of the page that caused this fault,
>> and is it valid?
>
> The fault address in question was the 2nd page of an NVDIMM range.  I
> assumed this fault address was valid and needed to be handled.  Here is
> some info about the base and patched cases.  Let me know if you need
> more info.
>
> Base
> ====
>
> The following NVDIMM range was set to /dev/dax.
>
> /proc/iomem
> 480000000-87fffffff : Persistent Memory
>
> devm_memremap_pages() initialized struct page from 0x490200-0x87ffff.

This seems like the start of the trouble.  What happened to the first
1GB of the address range?  I'm assuming the 'align' attribute is set
to 2MB because we start at a pfn offset of 0x200, but this should be
starting at 0x480200.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
