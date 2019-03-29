Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 864E2211EC695
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 12:32:57 -0700 (PDT)
Received: by mail-ot1-x343.google.com with SMTP id m10so3183220otp.2
 for <linux-nvdimm@lists.01.org>; Fri, 29 Mar 2019 12:32:57 -0700 (PDT)
MIME-Version: 1.0
References: <155387324370.2443841.574715745262628837.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155387327020.2443841.6446837127378298192.stgit@dwillia2-desk3.amr.corp.intel.com>
 <cfda881b-d99c-7c53-64cb-745ff4b257b0@deltatee.com>
In-Reply-To: <cfda881b-d99c-7c53-64cb-745ff4b257b0@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Mar 2019 12:32:44 -0700
Message-ID: <CAPcyv4jZiK+OHjwNqDARv4g326AQZx7N_Lmxj1Zux_bX1T2CLQ@mail.gmail.com>
Subject: Re: [PATCH 5/6] pci/p2pdma: Track pgmap references per resource,
 not globally
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Bjorn Helgaas <bhelgaas@google.com>, Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 29, 2019 at 10:50 AM Logan Gunthorpe <logang@deltatee.com> wrote:
>
> Thanks Dan, this is great. I think the changes in this series are
> cleaner and more understandable than the patch set I had sent earlier.
>
> However, I found a couple minor issues with this patch:
>
> On 2019-03-29 9:27 a.m., Dan Williams wrote:
> >  static void pci_p2pdma_release(void *data)
> >  {
> >       struct pci_dev *pdev = data;
> > @@ -103,12 +110,12 @@ static void pci_p2pdma_release(void *data)
> >       if (!pdev->p2pdma)
> >               return;
> >
> > -     wait_for_completion(&pdev->p2pdma->devmap_ref_done);
> > -     percpu_ref_exit(&pdev->p2pdma->devmap_ref);
> > +     /* Flush and disable pci_alloc_p2p_mem() */
> > +     pdev->p2pdma = NULL;
> > +     synchronize_rcu();
> >
> >       gen_pool_destroy(pdev->p2pdma->pool);
>
> I missed this on my initial review, but it became obvious when I tried
> to test the series: this is a NULL dereference seeing pdev->p2pdma was
> set to NULL a few lines up.

Ah, yup.

> When I fix this by storing p2pdma in a local variable, the patch set
> works and never seems to crash when I hot remove p2pdma memory.

Great!

>
> >  void *pci_alloc_p2pmem(struct pci_dev *pdev, size_t size)
> >  {
> > -     void *ret;
> > +     void *ret = NULL;
> > +     struct percpu_ref *ref;
> >
> > +     rcu_read_lock();
> >       if (unlikely(!pdev->p2pdma))
> > -             return NULL;
>
> Using RCU here makes sense to me, however I expect we should be using
> the proper rcu_assign_pointer(), rcu_dereference() and __rcu tag with
> pdev->p2pdma. If only to better document what's being protected with the
> new RCU calls.

I think just add a comment because those helpers are for cases where
the rcu protected pointer is allowed to race the teardown. In this
case we're using rcu just as a barrier to force the NULL check to
resolve.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
