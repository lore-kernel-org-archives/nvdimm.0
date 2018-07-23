Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B17F21B02845
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jul 2018 09:23:14 -0700 (PDT)
Date: Mon, 23 Jul 2018 12:23:08 -0400
From: Jerome Glisse <jglisse@redhat.com>
Subject: Re: [PATCH v6 06/13] mm, dev_pagemap: Do not clear ->mapping on
 final put
Message-ID: <20180723162308.GA4704@redhat.com>
References: <153154376846.34503.15480221419473501643.stgit@dwillia2-desk3.amr.corp.intel.com>
 <153154380137.34503.3754023882460956800.stgit@dwillia2-desk3.amr.corp.intel.com>
 <3fcb3c8a-2a41-7c78-edde-066c10110d34@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <3fcb3c8a-2a41-7c78-edde-066c10110d34@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jul 23, 2018 at 09:12:06AM -0700, Dave Jiang wrote:
> Jerome,
> Is it possible to get an ack for this? Thanks!
> =

> On 07/13/2018 09:50 PM, Dan Williams wrote:
> > MEMORY_DEVICE_FS_DAX relies on typical page semantics whereby ->mapping
> > is only ever cleared by truncation, not final put.
> > =

> > Without this fix dax pages may forget their mapping association at the
> > end of every page pin event.
> > =

> > Move this atypical behavior that HMM wants into the HMM ->page_free()
> > callback.
> > =

> > Cc: <stable@vger.kernel.org>
> > Cc: Jan Kara <jack@suse.cz>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Fixes: d2c997c0f145 ("fs, dax: use page->mapping...")
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: J=E9r=F4me Glisse <jglisse@redhat.com>

> > ---
> >  kernel/memremap.c |    1 -
> >  mm/hmm.c          |    2 ++
> >  2 files changed, 2 insertions(+), 1 deletion(-)
> > =

> > diff --git a/kernel/memremap.c b/kernel/memremap.c
> > index 5857267a4af5..62603634a1d2 100644
> > --- a/kernel/memremap.c
> > +++ b/kernel/memremap.c
> > @@ -339,7 +339,6 @@ void __put_devmap_managed_page(struct page *page)
> >  		__ClearPageActive(page);
> >  		__ClearPageWaiters(page);
> >  =

> > -		page->mapping =3D NULL;
> >  		mem_cgroup_uncharge(page);
> >  =

> >  		page->pgmap->page_free(page, page->pgmap->data);
> > diff --git a/mm/hmm.c b/mm/hmm.c
> > index de7b6bf77201..f9d1d89dec4d 100644
> > --- a/mm/hmm.c
> > +++ b/mm/hmm.c
> > @@ -963,6 +963,8 @@ static void hmm_devmem_free(struct page *page, void=
 *data)
> >  {
> >  	struct hmm_devmem *devmem =3D data;
> >  =

> > +	page->mapping =3D NULL;
> > +
> >  	devmem->ops->free(devmem, page);
> >  }
> >  =

> > =

> > _______________________________________________
> > Linux-nvdimm mailing list
> > Linux-nvdimm@lists.01.org
> > https://lists.01.org/mailman/listinfo/linux-nvdimm
> > =

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
