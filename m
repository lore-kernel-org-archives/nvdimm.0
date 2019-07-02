Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: dev_pagemap related cleanups v4
Date: Tue, 2 Jul 2019 18:42:07 +0000
Message-ID: <20190702184201.GO31718@mellanox.com>
References: <20190701062020.19239-1-hch@lst.de>
 <20190701082517.GA22461@lst.de>
In-Reply-To: <20190701082517.GA22461@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <ADE83ECAC2BC474EA837455494A5DDBE@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, Ira Weiny <ira.weiny@intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 01, 2019 at 10:25:17AM +0200, Christoph Hellwig wrote:
> And I've demonstrated that I can't send patch series..  While this
> has all the right patches, it also has the extra patches already
> in the hmm tree, and four extra patches I wanted to send once
> this series is merged.  I'll give up for now, please use the git
> url for anything serious, as it contains the right thing.

Okay, I sorted it all out and temporarily put it here:

https://github.com/jgunthorpe/linux/commits/hmm

Bit involved job:
- Took Ira's v4 patch into hmm.git and confirmed it matches what
  Andrew has in linux-next after all the fixups
- Checked your github v4 and the v3 that hit the mailing list were
  substantially similar (I never did get a clean v4) and largely
  went with the github version
- Based CH's v4 series on -rc7 and put back the removal hunk in swap.c
  so it compiles
- Merge'd CH's series to hmm.git and fixed all the conflicts with Ira
  and Ralph's patches (such that swap.c remains unchanged)
- Added Dan's ack's and tested-by's

I think this fairly closely follows what was posted to the mailing
list.

As it was more than a simple 'git am', I'll let it sit on github until
I hear OK's then I'll move it to kernel.org's hmm.git and it will hit
linux-next. 0-day should also run on this whole thing from my github.

What I know is outstanding:
 - The conflicting ARM patches, I understand Andrew will handle these
   post-linux-next
 - The conflict with AMD GPU in -next, I am waiting to hear from AMD

Otherwise I think we are done with hmm.git for this
cycle.

Unfortunately this is still not enough to progress rdma's ODP, so we
will need to do this again next cycle :( I'll be working on patches
once I get all the merge window prep I have to do done.

Regards,
Jason
