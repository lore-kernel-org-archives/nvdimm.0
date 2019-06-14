Return-Path: <owner-linux-mm@kvack.org>
Date: Fri, 14 Jun 2019 08:12:47 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: dev_pagemap related cleanups
Message-ID: <20190614061247.GB7246@lst.de>
References: <20190613094326.24093-1-hch@lst.de> <20190613141622.GE22062@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190613141622.GE22062@mellanox.com>
Sender: owner-linux-mm@kvack.org
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 13, 2019 at 02:16:27PM +0000, Jason Gunthorpe wrote:
> On Thu, Jun 13, 2019 at 11:43:03AM +0200, Christoph Hellwig wrote:
> > Hi Dan, J�r�me and Jason,
> > 
> > below is a series that cleans up the dev_pagemap interface so that
> > it is more easily usable, which removes the need to wrap it in hmm
> > and thus allowing to kill a lot of code
> 
> Do you want some of this to run through hmm.git? I see many patches
> that don't seem to have inter-dependencies..

I think running it through hmm.git makes sense.  While there are not
actual functional dependency and just a few cosmetic conflicts keeping
the hmm stuff together makes a lot of sense.
