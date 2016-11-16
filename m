Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B65DF81ECB
 for <linux-nvdimm@lists.01.org>; Tue, 15 Nov 2016 16:48:54 -0800 (PST)
Received: by mail-oi0-x231.google.com with SMTP id 128so44751502oih.0
 for <linux-nvdimm@lists.01.org>; Tue, 15 Nov 2016 16:48:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1c6d61ef-2331-e517-d0d8-d4eefea8b18a@intel.com>
References: <147881591739.39198.1358237993213024627.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1c6d61ef-2331-e517-d0d8-d4eefea8b18a@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 15 Nov 2016 16:48:58 -0800
Message-ID: <CAPcyv4gGWxpntc141nDJ6Lwg=17e30O8=xDTpHBpJ=79+fT=VQ@mail.gmail.com>
Subject: Re: [PATCH] mm: add ZONE_DEVICE statistics to smaps
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
To: Dave Hansen <dave.hansen@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 15, 2016 at 4:15 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 11/10/2016 02:11 PM, Dan Williams wrote:
>> @@ -774,6 +778,8 @@ static int show_smap(struct seq_file *m, void *v, int is_pid)
>>                  "ShmemPmdMapped: %8lu kB\n"
>>                  "Shared_Hugetlb: %8lu kB\n"
>>                  "Private_Hugetlb: %7lu kB\n"
>> +                "Device:         %8lu kB\n"
>> +                "DeviceHugePages: %7lu kB\n"
>>                  "Swap:           %8lu kB\n"
>>                  "SwapPss:        %8lu kB\n"
>>                  "KernelPageSize: %8lu kB\n"
>
> So, a couple of nits...
>
> smaps is getting a bit big, and the fields that get added in this patch
> are going to be pretty infrequently used.  Is it OK if smaps grows
> forever, even if most of them items are "0 kB"?
>
> IOW, Could we make it output Device* only for DAX VMAs?  All the parsers
> have to handle that field being there or not (for old kernels).

How about just hiding the field if it is zero?  That way it's not an
backdoor way to leak vma_is_dax() which was Christoph's concern.

> The other thing missing for DAX is the page size.  DAX mappings support
> mixed page sizes, so MMUPageSize in this context is pretty worthless.
> What will we do in here for 1GB DAX pages?

I was thinking that would be yet another field "DeviceGiganticPages?"
when we eventually add 1GB support (not there today).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
