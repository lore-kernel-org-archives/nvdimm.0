Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 13 Jun 2019 23:21:01 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: dev_pagemap related cleanups
Message-ID: <20190613212101.GA27174@lst.de>
References: <20190613094326.24093-1-hch@lst.de> <CAPcyv4jBdwYaiVwkhy6kP78OBAs+vJme1UTm47dX4Eq_5=JgSg@mail.gmail.com> <20190613204043.GD22062@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190613204043.GD22062@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@lst.de>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, Linux MM <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 08:40:46PM +0000, Jason Gunthorpe wrote:
> > Perhaps we should pull those out and resend them through hmm.git?
> 
> It could be done - but how bad is the conflict resolution?

Trivial.  All but one patch just apply using git-am, and the other one
just has a few lines of offsets.

I've also done a preliminary rebase of my series on top of those
patches, and it really nicely helps making the drivers even simpler
and allows using the internal refcount in p2pdma.c as well.
