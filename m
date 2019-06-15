Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F140621289DB8
 for <linux-nvdimm@lists.01.org>; Sat, 15 Jun 2019 11:09:21 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id x21so5640487otq.12
 for <linux-nvdimm@lists.01.org>; Sat, 15 Jun 2019 11:09:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190613094326.24093-1-hch@lst.de>
 <CAPcyv4jBdwYaiVwkhy6kP78OBAs+vJme1UTm47dX4Eq_5=JgSg@mail.gmail.com>
 <20190614061333.GC7246@lst.de>
 <CAPcyv4jmk6OBpXkuwjMn0Ovtv__2LBNMyEOWx9j5LWvWnr8f_A@mail.gmail.com>
 <20190615083356.GB23406@lst.de>
In-Reply-To: <20190615083356.GB23406@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 15 Jun 2019 11:09:09 -0700
Message-ID: <CAPcyv4jkDC3hRt_pj1e8j_OmzJ-wdumy-o1bN0ab=JVE_gfKdg@mail.gmail.com>
Subject: Re: dev_pagemap related cleanups
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, nouveau@lists.freedesktop.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, linux-pci@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 15, 2019 at 1:34 AM Christoph Hellwig <hch@lst.de> wrote:
>
> On Fri, Jun 14, 2019 at 06:14:45PM -0700, Dan Williams wrote:
> > On Thu, Jun 13, 2019 at 11:14 PM Christoph Hellwig <hch@lst.de> wrote:
> > >
> > > On Thu, Jun 13, 2019 at 11:27:39AM -0700, Dan Williams wrote:
> > > > It also turns out the nvdimm unit tests crash with this signature on
> > > > that branch where base v5.2-rc3 passes:
> > >
> > > How do you run that test?
> >
> > This is the unit test suite that gets kicked off by running "make
> > check" from the ndctl source repository. In this case it requires the
> > nfit_test set of modules to create a fake nvdimm environment.
> >
> > The setup instructions are in the README, but feel free to send me
> > branches and I can kick off a test. One of these we'll get around to
> > making it automated for patch submissions to the linux-nvdimm mailing
> > list.
>
> Oh, now I remember, and that was the bummer as anything requiring modules
> just does not fit at all into my normal test flows that just inject
> kernel images and use otherwise static images.

Yeah... although we do have some changes being proposed from non-x86
devs to allow a subset of the tests to run without the nfit_test
modules: https://patchwork.kernel.org/patch/10980779/

...so this prompts me to go review that patch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
