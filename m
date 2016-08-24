Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x234.google.com (mail-oi0-x234.google.com
 [IPv6:2607:f8b0:4003:c06::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 96D421A1E27
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 21:48:14 -0700 (PDT)
Received: by mail-oi0-x234.google.com with SMTP id f189so7655216oig.3
 for <linux-nvdimm@lists.01.org>; Tue, 23 Aug 2016 21:48:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DF4PR84MB0010039BC15DFF7538D46A6682EA0@DF4PR84MB0010.NAMPRD84.PROD.OUTLOOK.COM>
References: <1471977800-12688-1-git-send-email-toshi.kani@hpe.com>
 <CAPcyv4g8y4P02wm6Fx5Cx1zX6_xysdYg7jG6jjz6GTX7KqCkvA@mail.gmail.com>
 <1471996023.1532.6.camel@hpe.com>
 <CAPcyv4gJtTj8chX_eTNhs1PJ=D3X7USuDXwFSWSEZt1cUAXpUw@mail.gmail.com>
 <CS1PR84MB0005F40F71804F3988DD23CB82EA0@CS1PR84MB0005.NAMPRD84.PROD.OUTLOOK.COM>
 <CAPcyv4jH+R0vPyMvDhNmrQ-DjvMe_KW9SxPoQCdX8Zbgd3KESA@mail.gmail.com>
 <CAPcyv4g1ULSDXzp5ufpXzp5JB3z1TN_za=_AqUC8E6f2FNsycw@mail.gmail.com>
 <DF4PR84MB0010039BC15DFF7538D46A6682EA0@DF4PR84MB0010.NAMPRD84.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 23 Aug 2016 21:48:13 -0700
Message-ID: <CAPcyv4hZEU3bnpiSCr3KFxF+MiGDGzB5NdopWkFB5CWazD1pkw@mail.gmail.com>
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

On Tue, Aug 23, 2016 at 9:28 PM, Kani, Toshimitsu <toshi.kani@hpe.com> wrote:
>> On Tue, Aug 23, 2016 at 7:53 PM, Dan Williams <dan.j.williams@intel.com>
>> wrote:
>> > On Tue, Aug 23, 2016 at 6:29 PM, Kani, Toshimitsu <toshi.kani@hpe.com>
>> wrote:
>> >>> On Tue, Aug 23, 2016 at 4:47 PM, Kani, Toshimitsu
>> <toshi.kani@hpe.com>
>> >>> wrote:
>  :
>> >>
>> >> crash> p {struct vmem_altmap} 0xffff88046d045410
>> >> $6 = {
>> >>   base_pfn = 0x480000,
>> >>   reserve = 0x2,        // PHYS_PFN(SZ_8K)
>> >>   free = 0x101fe,
>> >>   align = 0x1fe,
>> >>   alloc = 0x10000
>> >> }
>> >
>> > Ah, so, on second look the 0x490200000 data offset looks correct.  The
>> > total size of the address range is 16GB which equates to 256MB needed
>> > for struct page, plus 2MB more to re-align the data on the next 2MB
>> > boundary.
>> >
>> > The question now is why is the guest faulting on an access to an
>> > address less than 0x490200000?
>>
>> Does the attached patch fix this for you?
>
> Yeah, that makes sense.  I will test it tomorrow.
>
> BTW, why does devm_memremap_pages() put a whole range to pgmap_radix
> as device memory, but only initialize page->pgmap for its data range?  Is there
> particular reason for this inconsistency?
>

The radix tree is indexed by section number, but we don't always
initialize a full section.  The cases when we don't use a full section
is when it overlaps device metadata, or if a platform multiplexes the
device memory range with another resource within the same section.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
