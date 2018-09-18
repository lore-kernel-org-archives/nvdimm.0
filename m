Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D0CF921A07A82
 for <linux-nvdimm@lists.01.org>; Mon, 17 Sep 2018 22:53:31 -0700 (PDT)
Date: Tue, 18 Sep 2018 22:31:49 +0800
From: Yi Zhang <yi.z.zhang@linux.intel.com>
Subject: Re: [PATCH V5 0/4] Fix kvm misconceives NVDIMM pages as reserved mmio
Message-ID: <20180918143148.GB70800@tiger-server>
References: <cover.1536342881.git.yi.z.zhang@linux.intel.com>
 <20180907170451.GA5771@darwi-kernel>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180907170451.GA5771@darwi-kernel>
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
To: "Ahmed S. Darwish" <darwish.07@gmail.com>
Cc: jglisse@redhat.com, yu.c.zhang@intel.com, kvm@vger.kernel.org, linux-nvdimm@lists.01.org, jack@suse.cz, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, rkrcmar@redhat.com, pbonzini@redhat.com, hch@lst.de, yi.z.zhang@intel.com
List-ID: <linux-nvdimm@lists.01.org>

Thanks Darwi's remind, Will follow that next time.

Thanks.
Yi

On 2018-09-07 at 17:04:51 +0000, Ahmed S. Darwish wrote:
> Hi!
> 
> On Sat, Sep 08, 2018 at 02:03:02AM +0800, Zhang Yi wrote:
> [...]
> >
> > V1:
> > https://lkml.org/lkml/2018/7/4/91
> >
> > V2:
> > https://lkml.org/lkml/2018/7/10/135
> >
> > V3:
> > https://lkml.org/lkml/2018/8/9/17
> >
> > V4:
> > https://lkml.org/lkml/2018/8/22/17
> >
> 
> Can we please avoid referencing "lkml.org"?
> 
> It's just an unreliable broken website. [1][2] Much more important
> though is that its URLs _hide_ the Message-Id field; running the
> threat of losing the e-mail reference forever at some point in the
> future.
> 
> From Documentation/process/submitting-patches.rst:
> 
>     If the patch follows from a mailing list discussion, give a
>     URL to the mailing list archive; use the https://lkml.kernel.org/
>     redirector with a ``Message-Id``, to ensure that the links
>     cannot become stale.
> 
> So the V1 link above should've been either:
> 
>     https://lore.kernel.org/lkml/cover.1530716899.git.yi.z.zhang@linux.intel.com
> 
> or:
> 
>     https://lkml.kernel.org/r/cover.1530716899.git.yi.z.zhang@linux.intel.com
> 
> and so on..
> 
> Thanks,
> 
> [1] https://www.theregister.co.uk/2018/01/14/linux_kernel_mailing_list_archives_will_return_soon
> [2] The threading interface is also broken and in a lot of cases
>     does not show all messages in a thread
> 
> --
> Darwi
> http://darwish.chasingpointers.com
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
