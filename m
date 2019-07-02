Return-Path: <owner-linux-mm@kvack.org>
Date: Wed, 3 Jul 2019 00:47:31 +0200
From: Christoph Hellwig <hch@lst.de>
Subject: Re: dev_pagemap related cleanups v4
Message-ID: <20190702224731.GA23841@lst.de>
References: <20190701062020.19239-1-hch@lst.de> <20190701082517.GA22461@lst.de> <20190702184201.GO31718@mellanox.com> <2807E5FD2F6FDA4886F6618EAC48510E79DEA747@CRSMSX101.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E79DEA747@CRSMSX101.amr.corp.intel.com>
Sender: owner-linux-mm@kvack.org
To: "Weiny, Ira" <ira.weiny@intel.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>, "Williams, Dan J" <dan.j.williams@intel.com>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 02, 2019 at 10:45:34PM +0000, Weiny, Ira wrote:
> > 
> > On Mon, Jul 01, 2019 at 10:25:17AM +0200, Christoph Hellwig wrote:
> > > And I've demonstrated that I can't send patch series..  While this has
> > > all the right patches, it also has the extra patches already in the
> > > hmm tree, and four extra patches I wanted to send once this series is
> > > merged.  I'll give up for now, please use the git url for anything
> > > serious, as it contains the right thing.
> > 
> > Okay, I sorted it all out and temporarily put it here:
> > 
> > https://github.com/jgunthorpe/linux/commits/hmm
> > 
> > Bit involved job:
> > - Took Ira's v4 patch into hmm.git and confirmed it matches what
> >   Andrew has in linux-next after all the fixups
> 
> Looking at the final branch seems good.

Looks good to me as well.
