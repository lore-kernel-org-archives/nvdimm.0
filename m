Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x244.google.com (mail-ot0-x244.google.com
 [IPv6:2607:f8b0:4003:c0f::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D01D202E5E5A
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 12:21:50 -0800 (PST)
Received: by mail-ot0-x244.google.com with SMTP id n19so3046619ote.10
 for <linux-nvdimm@lists.01.org>; Wed, 08 Nov 2017 12:25:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.02.1711081514320.29922@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108095909.GA7390@infradead.org>
 <alpine.LRH.2.02.1711080725490.12294@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108150447.GA10374@infradead.org>
 <alpine.LRH.2.02.1711081007570.8618@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108153522.GB24548@infradead.org>
 <CAPcyv4jw5CDJYo-uhxq1hWJo90R87m0qju-k8WKgyd34QKnz0Q@mail.gmail.com>
 <alpine.LRH.2.02.1711081514320.29922@file01.intranet.prod.int.rdu2.redhat.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Nov 2017 12:25:49 -0800
Message-ID: <CAPcyv4imHXhcd8WgW5ygrKKNiVr0cDZLi2Ue5WDy=_RmqECnvw@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH] vmalloc: introduce vmap_pfn for persistent
 memory
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
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, Linux MM <linux-mm@kvack.org>, dm-devel@redhat.com, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 8, 2017 at 12:15 PM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Wed, 8 Nov 2017, Dan Williams wrote:
>
>> On Wed, Nov 8, 2017 at 7:35 AM, Christoph Hellwig <hch@infradead.org> wrote:
>> > On Wed, Nov 08, 2017 at 10:21:38AM -0500, Mikulas Patocka wrote:
>> >> > And what do you do for an architecture with virtuall indexed caches?
>> >>
>> >> Persistent memory is not supported on such architectures - it is only
>> >> supported on x86-64 and arm64.
>> >
>> > For now.  But once support is added your driver will just corrupt data
>> > unless you have the right API in place.
>>
>> I'm also in the process of ripping out page-less dax support. With
>> pages we can potentially leverage the VIVT-cache support in some
>> architectures, likely with more supporting infrastructure for
>> dax_flush().
>
> Should I remove all the code for page-less persistent memory from my
> driver?
>

Yes, that would be my recommendation. You can see that filesystem-dax
is on its way to dropping page-less support in this series:

   https://lists.01.org/pipermail/linux-nvdimm/2017-October/013125.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
