Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22a.google.com (mail-ot0-x22a.google.com
 [IPv6:2607:f8b0:4003:c0f::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 121762034D802
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 07:37:24 -0800 (PST)
Received: by mail-ot0-x22a.google.com with SMTP id q99so2639066ota.2
 for <linux-nvdimm@lists.01.org>; Wed, 08 Nov 2017 07:41:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171108153522.GB24548@infradead.org>
References: <alpine.LRH.2.02.1711071645240.1339@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108095909.GA7390@infradead.org>
 <alpine.LRH.2.02.1711080725490.12294@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108150447.GA10374@infradead.org>
 <alpine.LRH.2.02.1711081007570.8618@file01.intranet.prod.int.rdu2.redhat.com>
 <20171108153522.GB24548@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Nov 2017 07:41:23 -0800
Message-ID: <CAPcyv4jw5CDJYo-uhxq1hWJo90R87m0qju-k8WKgyd34QKnz0Q@mail.gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@lst.de>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 8, 2017 at 7:35 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Nov 08, 2017 at 10:21:38AM -0500, Mikulas Patocka wrote:
>> > And what do you do for an architecture with virtuall indexed caches?
>>
>> Persistent memory is not supported on such architectures - it is only
>> supported on x86-64 and arm64.
>
> For now.  But once support is added your driver will just corrupt data
> unless you have the right API in place.

I'm also in the process of ripping out page-less dax support. With
pages we can potentially leverage the VIVT-cache support in some
architectures, likely with more supporting infrastructure for
dax_flush().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
