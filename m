Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2FA9C21281EE5
 for <linux-nvdimm@lists.01.org>; Thu, 30 May 2019 21:17:21 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id y6so3116954oix.2
 for <linux-nvdimm@lists.01.org>; Thu, 30 May 2019 21:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <155727335978.292046.12068191395005445711.stgit@dwillia2-desk3.amr.corp.intel.com>
 <059859ca-3cc8-e3ff-f797-1b386931c41e@deltatee.com>
 <17ada515-f488-d153-90ef-7a5cc5fefb0f@deltatee.com>
In-Reply-To: <17ada515-f488-d153-90ef-7a5cc5fefb0f@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 30 May 2019 21:17:09 -0700
Message-ID: <CAPcyv4jJjCwbWJH648x04Cms1kXY2Cd36bxpgmDGRh+5Van1fQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] mm/devm_memremap_pages: Fix page release race
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, May 13, 2019 at 12:22 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>
>
>
> On 2019-05-08 11:05 a.m., Logan Gunthorpe wrote:
> >
> >
> > On 2019-05-07 5:55 p.m., Dan Williams wrote:
> >> Changes since v1 [1]:
> >> - Fix a NULL-pointer deref crash in pci_p2pdma_release() (Logan)
> >>
> >> - Refresh the p2pdma patch headers to match the format of other p2pdma
> >>    patches (Bjorn)
> >>
> >> - Collect Ira's reviewed-by
> >>
> >> [1]: https://lore.kernel.org/lkml/155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com/
> >
> > This series looks good to me:
> >
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> >
> > However, I haven't tested it yet but I intend to later this week.
>
> I've tested libnvdimm-pending which includes this series on my setup and
> everything works great.

Hi Andrew,

With this tested-by can we move forward on this fix set? I'm not aware
of any other remaining comments. Greg had a question about
"drivers/base/devres: Introduce devm_release_action()" that I
answered, but otherwise the feedback has gone silent.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
