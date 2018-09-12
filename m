Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x244.google.com (mail-oi0-x244.google.com
 [IPv6:2607:f8b0:4003:c06::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 179A72110A3CC
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 12:11:52 -0700 (PDT)
Received: by mail-oi0-x244.google.com with SMTP id p84-v6so5973687oic.4
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 12:11:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <fac5a6f4-3dda-2ec4-81ec-4a4a7ad2a571@microsoft.com>
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
 <20180910234354.4068.65260.stgit@localhost.localdomain>
 <7b96298e-9590-befd-0670-ed0c9fcf53d5@microsoft.com>
 <CAKgT0UdKZVUPBk=rg5kfUuFBpuZQEKPuGw31x5O2nMyuULgi0g@mail.gmail.com>
 <CAPcyv4gEDwp8Xh4_E8RNBC_OqstwhqxkZOpvYjWd_siB4C=BEQ@mail.gmail.com>
 <fac5a6f4-3dda-2ec4-81ec-4a4a7ad2a571@microsoft.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 12 Sep 2018 12:11:51 -0700
Message-ID: <CAPcyv4j5mHT8OrHkGdDeCCc30pF8z8ZD0f6p7T5KDd2ejmUetw@mail.gmail.com>
Subject: Re: [PATCH 3/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
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
To: Pasha Tatashin <Pavel.Tatashin@microsoft.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Sep 12, 2018 at 10:46 AM, Pasha Tatashin
<Pavel.Tatashin@microsoft.com> wrote:
>
>
> On 9/12/18 12:50 PM, Dan Williams wrote:
>> On Wed, Sep 12, 2018 at 8:48 AM, Alexander Duyck
>> <alexander.duyck@gmail.com> wrote:
>>> On Wed, Sep 12, 2018 at 6:59 AM Pasha Tatashin
>>> <Pavel.Tatashin@microsoft.com> wrote:
>>>>
>>>> Hi Alex,
>>>
>>> Hi Pavel,
>>>
>>>> Please re-base on linux-next,  memmap_init_zone() has been updated there
>>>> compared to mainline. You might even find a way to unify some parts of
>>>> memmap_init_zone and memmap_init_zone_device as memmap_init_zone() is a
>>>> lot simpler now.
>>>
>>> This patch applied to the linux-next tree with only a little bit of
>>> fuzz. It looks like it is mostly due to some code you had added above
>>> the function as well. I have updated this patch so that it will apply
>>> to both linux and linux-next by just moving the new function to
>>> underneath memmap_init_zone instead of above it.
>>>
>>>> I think __init_single_page() should stay local to page_alloc.c to keep
>>>> the inlining optimization.
>>>
>>> I agree. In addition it will make pulling common init together into
>>> one space easier. I would rather not have us create an opportunity for
>>> things to further diverge by making it available for anybody to use.
>>
>> I'll buy the inline argument for keeping the new routine in
>> page_alloc.c, but I otherwise do not see the divergence danger or
>> "making __init_single_page() available for anybody" given the the
>> declaration is limited in scope to a mm/ local header file.
>>
>
> Hi Dan,
>
> It is much harder for compiler to decide that function can be inlined
> once it is non-static. Of course, we can simply move this function to a
> header file, and declare it inline to begin with.
>
> But, still __init_single_page() is so performance sensitive, that I'd
> like to reduce number of callers to this function, and keep it in .c file.

Yes, agree, inline considerations win the day. I was just objecting to
the "make it available for anybody" assertion.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
