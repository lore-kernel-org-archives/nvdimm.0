Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 034D8211E094D
 for <linux-nvdimm@lists.01.org>; Tue,  2 Jul 2019 16:18:00 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w196so431252oie.7
 for <linux-nvdimm@lists.01.org>; Tue, 02 Jul 2019 16:18:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190701062020.19239-1-hch@lst.de> <20190701082517.GA22461@lst.de>
 <20190702184201.GO31718@mellanox.com>
In-Reply-To: <20190702184201.GO31718@mellanox.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 2 Jul 2019 16:17:48 -0700
Message-ID: <CAPcyv4iWXJ-c7LahPD=Qt4RuDNTU7w_8HjsitDuj3cxngzb56g@mail.gmail.com>
Subject: Re: dev_pagemap related cleanups v4
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
To: Jason Gunthorpe <jgg@mellanox.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Ben Skeggs <bskeggs@redhat.com>, "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jul 2, 2019 at 11:42 AM Jason Gunthorpe <jgg@mellanox.com> wrote:
>
> On Mon, Jul 01, 2019 at 10:25:17AM +0200, Christoph Hellwig wrote:
> > And I've demonstrated that I can't send patch series..  While this
> > has all the right patches, it also has the extra patches already
> > in the hmm tree, and four extra patches I wanted to send once
> > this series is merged.  I'll give up for now, please use the git
> > url for anything serious, as it contains the right thing.
>
> Okay, I sorted it all out and temporarily put it here:
>
> https://github.com/jgunthorpe/linux/commits/hmm
>
> Bit involved job:
> - Took Ira's v4 patch into hmm.git and confirmed it matches what
>   Andrew has in linux-next after all the fixups
> - Checked your github v4 and the v3 that hit the mailing list were
>   substantially similar (I never did get a clean v4) and largely
>   went with the github version
> - Based CH's v4 series on -rc7 and put back the removal hunk in swap.c
>   so it compiles
> - Merge'd CH's series to hmm.git and fixed all the conflicts with Ira
>   and Ralph's patches (such that swap.c remains unchanged)
> - Added Dan's ack's and tested-by's

Looks good. Test merge (with some collisions, see below) also passes
my test suite.

>
> I think this fairly closely follows what was posted to the mailing
> list.
>
> As it was more than a simple 'git am', I'll let it sit on github until
> I hear OK's then I'll move it to kernel.org's hmm.git and it will hit
> linux-next. 0-day should also run on this whole thing from my github.
>
> What I know is outstanding:
>  - The conflicting ARM patches, I understand Andrew will handle these
>    post-linux-next
>  - The conflict with AMD GPU in -next, I am waiting to hear from AMD

Just a heads up that this also collides with the "sub-section" patches
in Andrew's tree. The resolution is straightforward, mostly just
colliding updates to arch_{add,remove}_memory() call sites in
kernel/memremap.c and collisions with pgmap_altmap() usage.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
