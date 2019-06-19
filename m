Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 19 Jun 2019 11:40:32 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: dev_pagemap related cleanups v2
Message-ID: <20190619094032.GA8928@lst.de>
References: <20190617122733.22432-1-hch@lst.de> <CAPcyv4hBUJB2RxkDqHkfEGCupDdXfQSrEJmAdhLFwnDOwt8Lig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4hBUJB2RxkDqHkfEGCupDdXfQSrEJmAdhLFwnDOwt8Lig@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, Linux MM <linux-mm@kvack.org>, nouveau@lists.freedesktop.org, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 18, 2019 at 12:47:10PM -0700, Dan Williams wrote:
> > Git tree:
> >
> >     git://git.infradead.org/users/hch/misc.git hmm-devmem-cleanup.2
> >
> > Gitweb:
> >
> >     http://git.infradead.org/users/hch/misc.git/shortlog/refs/heads/hmm-devmem-cleanup.2

> 
> Attached is my incremental fixups on top of this series, with those
> integrated you can add:

I've folded your incremental bits in and pushed out a new
hmm-devmem-cleanup.3 to the repo above.  Let me know if I didn't mess
up anything else.  I'll wait for a few more comments and Jason's
planned rebase of the hmm branch before reposting.
