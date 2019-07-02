Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 52CE7212AC46C
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jul 2019 15:45:37 -0700 (PDT)
From: "Weiny, Ira" <ira.weiny@intel.com>
Subject: RE: dev_pagemap related cleanups v4
Date: Tue, 2 Jul 2019 22:45:34 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E79DEA747@CRSMSX101.amr.corp.intel.com>
References: <20190701062020.19239-1-hch@lst.de>
 <20190701082517.GA22461@lst.de> <20190702184201.GO31718@mellanox.com>
In-Reply-To: <20190702184201.GO31718@mellanox.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Jason Gunthorpe <jgg@mellanox.com>, Christoph Hellwig <hch@lst.de>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?iso-8859-1?Q?J=E9r=F4me_Glisse?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

> 
> On Mon, Jul 01, 2019 at 10:25:17AM +0200, Christoph Hellwig wrote:
> > And I've demonstrated that I can't send patch series..  While this has
> > all the right patches, it also has the extra patches already in the
> > hmm tree, and four extra patches I wanted to send once this series is
> > merged.  I'll give up for now, please use the git url for anything
> > serious, as it contains the right thing.
> 
> Okay, I sorted it all out and temporarily put it here:
> 
> https://github.com/jgunthorpe/linux/commits/hmm
> 
> Bit involved job:
> - Took Ira's v4 patch into hmm.git and confirmed it matches what
>   Andrew has in linux-next after all the fixups

Looking at the final branch seems good.

Ira

> - Checked your github v4 and the v3 that hit the mailing list were
>   substantially similar (I never did get a clean v4) and largely
>   went with the github version
> - Based CH's v4 series on -rc7 and put back the removal hunk in swap.c
>   so it compiles
> - Merge'd CH's series to hmm.git and fixed all the conflicts with Ira
>   and Ralph's patches (such that swap.c remains unchanged)
> - Added Dan's ack's and tested-by's
> 
> I think this fairly closely follows what was posted to the mailing list.
> 
> As it was more than a simple 'git am', I'll let it sit on github until I hear OK's
> then I'll move it to kernel.org's hmm.git and it will hit linux-next. 0-day
> should also run on this whole thing from my github.
> 
> What I know is outstanding:
>  - The conflicting ARM patches, I understand Andrew will handle these
>    post-linux-next
>  - The conflict with AMD GPU in -next, I am waiting to hear from AMD
> 
> Otherwise I think we are done with hmm.git for this cycle.
> 
> Unfortunately this is still not enough to progress rdma's ODP, so we will need
> to do this again next cycle :( I'll be working on patches once I get all the
> merge window prep I have to do done.
> 
> Regards,
> Jason
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
