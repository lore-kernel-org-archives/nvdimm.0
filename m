Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <1557417933-15701-1-git-send-email-larry.bassel@oracle.com>
 <1557417933-15701-3-git-send-email-larry.bassel@oracle.com>
 <20190514130147.2pk2xx32aiomm57b@box> <20190524160711.GF19025@ubuette>
In-Reply-To: <20190524160711.GF19025@ubuette>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 24 May 2019 10:02:04 -0700
Message-ID: <CAPcyv4hkocsPQLQ6sfF8SuwVoot_uXge_bTZtuM-6f4XxwFVhg@mail.gmail.com>
Subject: Re: [PATCH, RFC 2/2] Implement sharing/unsharing of PMDs for FS/DAX
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Larry Bassel <larry.bassel@oracle.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, Mike Kravetz <mike.kravetz@oracle.com>, Matthew Wilcox <willy@infradead.org>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 24, 2019 at 9:07 AM Larry Bassel <larry.bassel@oracle.com> wrote:
> On 14 May 19 16:01, Kirill A. Shutemov wrote:
> > On Thu, May 09, 2019 at 09:05:33AM -0700, Larry Bassel wrote:
[..]
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index f7d962d..4c1814c 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -3845,6 +3845,109 @@ static vm_fault_t handle_pte_fault(struct vm_fault *vmf)
> > >     return 0;
> > >  }
> > >
> > > +#ifdef CONFIG_MAY_SHARE_FSDAX_PMD
> > > +static pmd_t *huge_pmd_offset(struct mm_struct *mm,
> > > +                         unsigned long addr, unsigned long sz)
> >
> > Could you explain what this function suppose to do?
> >
> > As far as I can see vma_mmu_pagesize() is always PAGE_SIZE of DAX
> > filesystem. So we have 'sz' == PAGE_SIZE here.
>
> I thought so too, but in my testing I found that vma_mmu_pagesize() returns
> 4KiB, which differs from the DAX filesystem's 2MiB pagesize.

A given filesystem-dax vma is allowed to support both 4K and 2M
mappings, so the vma_mmu_pagesize() is not granular enough to describe
the capabilities of a filesystem-dax vma. In the device-dax case,
where there are mapping guarantees, the implementation does arrange
for vma_mmu_pagesize() to reflect the right page size.
