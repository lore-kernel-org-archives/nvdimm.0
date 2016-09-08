Return-Path: <owner-linux-mm@kvack.org>
Date: Thu, 8 Sep 2016 13:57:07 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH v4 RESEND 0/2] Align mmap address for DAX pmd mappings
Message-ID: <20160908105707.GA17331@node>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
 <20160829204842.GA27286@node.shutemov.name>
 <1472506310.1532.47.camel@hpe.com>
 <1472508000.1532.59.camel@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1472508000.1532.59.camel@hpe.com>
Sender: owner-linux-mm@kvack.org
To: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Cc: "hughd@google.com" <hughd@google.com>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>, "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "mawilcox@microsoft.com" <mawilcox@microsoft.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "tytso@mit.edu" <tytso@mit.edu>, "david@fromorbit.com" <david@fromorbit.com>, "jack@suse.cz" <jack@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 29, 2016 at 10:00:43PM +0000, Kani, Toshimitsu wrote:
> On Mon, 2016-08-29 at 15:31 -0600, Kani, Toshimitsu wrote:
> > On Mon, 2016-08-29 at 23:48 +0300, Kirill A. Shutemov wrote:
> > > 
> > > On Mon, Aug 29, 2016 at 01:11:19PM -0600, Toshi Kani wrote:
> > > > 
> > > > 
> > > > When CONFIG_FS_DAX_PMD is set, DAX supports mmap() using pmd page
> > > > size.��This feature relies on both mmap virtual address and FS
> > > > block (i.e. physical address) to be aligned by the pmd page size.
> > > > Users can use mkfs options to specify FS to align block
> > > > allocations. However, aligning mmap address requires code changes
> > > > to existing applications for providing a pmd-aligned address to
> > > > mmap().
> > > > 
> > > > For instance, fio with "ioengine=mmap" performs I/Os with mmap()
> > > > [1]. It calls mmap() with a NULL address, which needs to be
> > > > changed to provide a pmd-aligned address for testing with DAX pmd
> > > > mappings. Changing all applications that call mmap() with NULL is
> > > > undesirable.
> > > > 
> > > > This patch-set extends filesystems to align an mmap address for
> > > > a DAX file so that unmodified applications can use DAX pmd
> > > > mappings.
> > > 
> > > +Hugh
> > > 
> > > Can we get it used for shmem/tmpfs too?
> > > I don't think we should duplicate essentially the same
> > > functionality in multiple places.
> > 
> > Here is my brief analysis when I had looked at the Hugh's patch last
> > time (before�shmem_get_unmapped_area() was accepted).
> > https://patchwork.kernel.org/patch/8916741/
> > 
> > Besides some differences in the logic, ex. shmem_get_unmapped_area()
> > always calls�current->mm->get_unmapped_area twice, yes, they
> > basically provide the same functionality.
> > 
> > I think one issue is that shmem_get_unmapped_area() checks with its
> > static flag 'shmem_huge', and additinally deals with SHMEM_HUGE_DENY
> > and�SHMEM_HUGE_FORCE cases. �It also handles non-file case for
> > !SHMEM_HUGE_FORCE.
> 
> Looking further, these shmem_huge handlings only check pre-conditions.
> �So, we should be able to make shmem_get_unmapped_area() as a wrapper,
> which checks such shmem-specific conitions, and then
> call�__thp_get_unmapped_area() for the actual work. �All DAX-specific
> checks are performed in thp_get_unmapped_area() as well. �We can make
> �__thp_get_unmapped_area() as a common function.
> 
> I'd prefer to make such change as a separate item,

Do you have plan to submit such change?

-- 
 Kirill A. Shutemov

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
