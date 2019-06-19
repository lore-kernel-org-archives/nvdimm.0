Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190617122733.22432-1-hch@lst.de> <CAPcyv4hBUJB2RxkDqHkfEGCupDdXfQSrEJmAdhLFwnDOwt8Lig@mail.gmail.com>
 <20190619094032.GA8928@lst.de> <20190619163655.GG9360@ziepe.ca>
In-Reply-To: <20190619163655.GG9360@ziepe.ca>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jun 2019 09:46:23 -0700
Message-ID: <CAPcyv4hYtQdg0DTYjrJxCNXNjadBSWQ5QaMJYsA-QSribKuwrQ@mail.gmail.com>
Subject: Re: dev_pagemap related cleanups v2
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Christoph Hellwig <hch@lst.de>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, Linux MM <linux-mm@kvack.org>, nouveau@lists.freedesktop.org, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 19, 2019 at 9:37 AM Jason Gunthorpe <jgg@ziepe.ca> wrote:
>
> On Wed, Jun 19, 2019 at 11:40:32AM +0200, Christoph Hellwig wrote:
> > On Tue, Jun 18, 2019 at 12:47:10PM -0700, Dan Williams wrote:
> > > > Git tree:
> > > >
> > > >     git://git.infradead.org/users/hch/misc.git hmm-devmem-cleanup.2
> > > >
> > > > Gitweb:
> > > >
> > > >     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/hmm-devmem-cleanup.2
> >
> > >
> > > Attached is my incremental fixups on top of this series, with those
> > > integrated you can add:
> >
> > I've folded your incremental bits in and pushed out a new
> > hmm-devmem-cleanup.3 to the repo above.  Let me know if I didn't mess
> > up anything else.  I'll wait for a few more comments and Jason's
> > planned rebase of the hmm branch before reposting.
>
> I said I wouldn't rebase the hmm.git (as it needs to go to DRM, AMD
> and RDMA git trees)..
>
> Instead I will merge v5.2-rc5 to the tree before applying this series.
>
> I've understood this to be Linus's prefered workflow.
>
> So, please send the next iteration of this against either
> plainv5.2-rc5 or v5.2-rc5 merged with hmm.git and I'll sort it out.

Just make sure that when you backmerge v5.2-rc5 you have a clear
reason in the merge commit message about why you needed to do it.
While needless rebasing is top of the pet peeve list, second place, as
I found out, is mystery merges without explanations.
