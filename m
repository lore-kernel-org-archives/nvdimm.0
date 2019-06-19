Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B53D2128A631
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jun 2019 09:27:48 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id z23so19884431ote.13
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jun 2019 09:27:48 -0700 (PDT)
MIME-Version: 1.0
References: <156080474760.3765313.13075804303259765566.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190619112302.GA10534@lst.de>
In-Reply-To: <20190619112302.GA10534@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jun 2019 09:27:36 -0700
Message-ID: <CAPcyv4gLOqgRLiVoVJiSaY=QE=yOO0mg04oDFe+jXRj=G2xJRA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Enable unit test infrastructure compile checks
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
To: Christoph Hellwig <hch@lst.de>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 19, 2019 at 4:23 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jun 17, 2019 at 01:52:27PM -0700, Dan Williams wrote:
> > The infrastructure to mock core libnvdimm routines for unit testing
> > purposes is prone to bitrot relative to refactoring of that core.
> > Arrange for the unit test core to be built when CONFIG_COMPILE_TEST=y.
> > This does not result in a functional unit test environment, it is only a
> > helper for 0day to catch unit test build regressions.
>
> Looks fine:
>
> Reviewed-by: Christoph Hellwig <hch@lst.de>
>
> I'm still curious what the point of hiding kernel code in tools/
> is vs fully integrating it with the build system.

The separation of tools/ is due to way the "--wrap=" ldflag behaves.
It can only wrap symbols across a module linking boundary. So to
produce a setup where libnvdimm is ingesting faked responses it all
needs to be built as external modules and relinked.

It's an inelegant way to get some test coverage beyond what qemu-kvm
can do, my hope is that down the road I can use the new Kunit
infrastructure to do something similar in a cleaner / more formal way.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
