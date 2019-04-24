Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C708E211F9D7B
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 11:13:59 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id a6so15071191oie.5
 for <linux-nvdimm@lists.01.org>; Wed, 24 Apr 2019 11:13:59 -0700 (PDT)
MIME-Version: 1.0
References: <20190402115125.18803-1-aneesh.kumar@linux.ibm.com>
 <CAPcyv4hzRj5yxVJ5-7AZgzzBxEL02xf2xwhDv-U9_osWFm9kiA@mail.gmail.com>
 <20190424173833.GE19031@bombadil.infradead.org>
In-Reply-To: <20190424173833.GE19031@bombadil.infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Apr 2019 11:13:48 -0700
Message-ID: <CAPcyv4gLGUa69svQnwjvruALZ0ChqUJZHQJ1Mt_Cjr1Jh_6vbQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: Fix modifying of page protection by
 insert_pfn_pmd()
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
To: Matthew Wilcox <willy@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm <linux-nvdimm@lists.01.org>, "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>, stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Chandan Rajendra <chandan@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 24, 2019 at 10:38 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> On Wed, Apr 24, 2019 at 10:13:15AM -0700, Dan Williams wrote:
> > I think unaligned addresses have always been passed to
> > vmf_insert_pfn_pmd(), but nothing cared until this patch. I *think*
> > the only change needed is the following, thoughts?
> >
> > diff --git a/fs/dax.c b/fs/dax.c
> > index ca0671d55aa6..82aee9a87efa 100644
> > --- a/fs/dax.c
> > +++ b/fs/dax.c
> > @@ -1560,7 +1560,7 @@ static vm_fault_t dax_iomap_pmd_fault(struct
> > vm_fault *vmf, pfn_t *pfnp,
> >                 }
> >
> >                 trace_dax_pmd_insert_mapping(inode, vmf, PMD_SIZE, pfn, entry);
> > -               result = vmf_insert_pfn_pmd(vma, vmf->address, vmf->pmd, pfn,
> > +               result = vmf_insert_pfn_pmd(vma, pmd_addr, vmf->pmd, pfn,
> >                                             write);
>
> We also call vmf_insert_pfn_pmd() in dax_insert_pfn_mkwrite() -- does
> that need to change too?

It wasn't clear to me that it was a problem. I think that one already
happens to be pmd-aligned.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
