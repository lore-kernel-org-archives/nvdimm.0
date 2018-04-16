Return-Path: <owner-linux-mm@kvack.org>
Date: Mon, 16 Apr 2018 10:47:40 -0700
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Change return type to vm_fault_t
Message-ID: <20180416174740.GA12686@bombadil.infradead.org>
References: <20180414155059.GA18015@jordon-HP-15-Notebook-PC>
 <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPcyv4g+Gdc2tJ1qrM5Xn9vtARw-ZqFXaMbiaBKJJsYDtSNBig@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 16, 2018 at 09:14:48AM -0700, Dan Williams wrote:
> > -       rc = vm_insert_mixed(vmf->vma, vmf->address, pfn);
> > -
> > -       if (rc == -ENOMEM)
> > -               return VM_FAULT_OOM;
> > -       if (rc < 0 && rc != -EBUSY)
> > -               return VM_FAULT_SIGBUS;
> > -
> > -       return VM_FAULT_NOPAGE;
> > +       return vmf_insert_mixed(vmf->vma, vmf->address, pfn);
> 
> Ugh, so this change to vmf_insert_mixed() went upstream without fixing
> the users? This changelog is now misleading as it does not mention
> that is now an urgent standalone fix. On first read I assumed this was
> part of a wider effort for 4.18.

You read too quickly.  vmf_insert_mixed() is a *new* function which
*replaces* vm_insert_mixed() and
awful-mangling-of-return-values-done-per-driver.

Eventually vm_insert_mixed() will be deleted.  But today is not that day.
