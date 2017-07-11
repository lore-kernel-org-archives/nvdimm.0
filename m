Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x242.google.com (mail-qk0-x242.google.com
 [IPv6:2607:f8b0:400d:c09::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F176A21D147AB
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 22:08:07 -0700 (PDT)
Received: by mail-qk0-x242.google.com with SMTP id 16so15607976qkg.2
 for <linux-nvdimm@lists.01.org>; Mon, 10 Jul 2017 22:09:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gJ0yF8OfeadW+em-O81zFNTDvSn7r97mjEQt7HkGAFRg@mail.gmail.com>
References: <20170627095633.6508-1-oohall@gmail.com>
 <CAPcyv4gJ0yF8OfeadW+em-O81zFNTDvSn7r97mjEQt7HkGAFRg@mail.gmail.com>
From: Oliver <oohall@gmail.com>
Date: Tue, 11 Jul 2017 15:09:52 +1000
Message-ID: <CAOSf1CEyV0KAVgSjO+Zmk3BrroMqmGRfZ4ONvV0dSfy=2+tecQ@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Stop using HPAGE_SIZE
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 11, 2017 at 9:44 AM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Tue, Jun 27, 2017 at 2:56 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
>> Currently libnvdimm uses HPAGE_SIZE as the default alignment for DAX and
>> PFN devices. HPAGE_SIZE is the default hugetlbfs page size and when
>> hugetlbfs is disabled it defaults to PAGE_SIZE. Given DAX has more
>> in common with THP than hugetlbfs we should proably be using
>> HPAGE_PMD_SIZE, but this is undefined when THP is disabled so lets just
>> give it a new name.
>>
>> The other usage of HPAGE_SIZE in libnvdimm is when determining how large
>> the altmap should be. For the reasons mentioned above it doesn't really
>> make sense to use HPAGE_SIZE here either. PMD_SIZE seems to be safe to
>> use in generic code and it happens to match the vmemmap allocation block
>> on x86 and Power. It's still a hack, but it's a slightly nicer hack.
>
> Looks ok, but I seem to remember some 0day kbuild robot reports the
> last time I tried to use PMD_SIZE. I'll give this a spin in my tree
> and see if that's the still the case or I'm mis-remembering.

If PMD_SIZE is causing issues we should probably look at fixing the
arch that provides it rather than trying to work around it. The kernel
expects a three level page table structure to be provided by the arch
even if the HW doesn't provide one so it *should* be well defined
everywhere.

That said, pfn_devs.c is only built when ZONE_DEVICE is enabled. So in
practice we only really need to make sure it works on x86 and power.
If another arch wants to support it then the onus is on them to make
sure PMD_SIZE exists.

Oliver
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
