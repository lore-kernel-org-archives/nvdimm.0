Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 90B062193DFA6
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 13:19:17 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id s131so24502417oia.3
 for <linux-nvdimm@lists.01.org>; Fri, 21 Apr 2017 13:19:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F6127653B@ORSMSX114.amr.corp.intel.com>
References: <20170420221818.23522-1-vishal.l.verma@intel.com>
 <CAPcyv4ijU2V-4WOPysL12ByOovAXDO=Mci1D4wNDFqxRjdvT2w@mail.gmail.com>
 <1492804517.2738.25.camel@intel.com>
 <3908561D78D1C84285E8C5FCA982C28F6127653B@ORSMSX114.amr.corp.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 21 Apr 2017 13:19:16 -0700
Message-ID: <CAPcyv4jAkCE2QBuxfxxmZfQZLCVOGLrLXqDu5TyGCVA+xJMEVg@mail.gmail.com>
Subject: Re: [PATCH] acpi, nfit: fix the memory error check in nfit_handle_mce
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 21, 2017 at 1:16 PM, Luck, Tony <tony.luck@intel.com> wrote:
>>> > +       if (!(mce->status & 0xef80) == BIT(7))
>>>
>>> Can we get a define for this, or a comment explaining all the magic
>>> that's happening on that one line?
>>
>> Yes - also like lkp pointed out, the check isn't correct at all. Let me
>> figure out what really needs to be done, and I will resend with a better
>> comment.
>
> Needs extra parentheses to make it right. Vishal, sorry I led you astray.
>
>         if (!((mce->status & 0xef80) == BIT(7)))
>
> The magic is shown in table 15-9 of the Intel Software Developers Manual
> (but perhaps not well explained there).
>
> mce->status in the above code is a value plucked from a machine check
> bank status register. See figure 15-6 in the SDM.  The important bits for this
> are {15:0} which are the "MCA Error code".  Table 15-9 shows how these
> are grouped into types, where the type is defined by the most significant '1'
> bit in the field (excluding bit 12 which is the Correction Report Filtering bit,
> see section 15.9.2.1).
>
> So if BIT(3) is the most significant bit, the this is a "Generic Cache Hierarchy"
> error, BIT(4) denotes a TLB error, BIT(7) a Memory error, and so on.

Ah, ok.

> Maybe we should have defines in mce.h for them?  It gets a bit more complicated
> as all the above only applies to Intel branded X86 CPUs ... on AMD different
> decoding rules apply.

Yeah, this code is x86_64 generic so should call into helpers that do
the right thing per cpu type.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
