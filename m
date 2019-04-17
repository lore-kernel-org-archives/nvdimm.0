Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552639290.2015392.17304211251966796338.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190417150202.b7cec444cf81ed44a150ea9d@linux-foundation.org>
In-Reply-To: <20190417150202.b7cec444cf81ed44a150ea9d@linux-foundation.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Apr 2019 15:09:42 -0700
Message-ID: <CAPcyv4jL4V=cV0rb=CYFDN=hs-1ETyH8JXJ2DOT3iB4UQemJXw@mail.gmail.com>
Subject: Re: [PATCH v6 11/12] libnvdimm/pfn: Fix fsdax-mode namespace
 info-block zero-fields
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: stable <stable@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 17, 2019 at 3:02 PM Andrew Morton <akpm@linux-foundation.org> wrote:
>
> On Wed, 17 Apr 2019 11:39:52 -0700 Dan Williams <dan.j.williams@intel.com> wrote:
>
> > At namespace creation time there is the potential for the "expected to
> > be zero" fields of a 'pfn' info-block to be filled with indeterminate
> > data. While the kernel buffer is zeroed on allocation it is immediately
> > overwritten by nd_pfn_validate() filling it with the current contents of
> > the on-media info-block location. For fields like, 'flags' and the
> > 'padding' it potentially means that future implementations can not rely
> > on those fields being zero.
> >
> > In preparation to stop using the 'start_pad' and 'end_trunc' fields for
> > section alignment, arrange for fields that are not explicitly
> > initialized to be guaranteed zero. Bump the minor version to indicate it
> > is safe to assume the 'padding' and 'flags' are zero. Otherwise, this
> > corruption is expected to benign since all other critical fields are
> > explicitly initialized.
> >
> > Fixes: 32ab0a3f5170 ("libnvdimm, pmem: 'struct page' for pmem")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> Buried at the end of a 12 patch series.  Should this be a standalone
> patch, suitable for a prompt merge?

It's not a problem unless a kernel implementation is explicitly
expecting those fields to be zero-initialized. I only marked it for
-stable in case some future kernel backports patch12. Otherwise it's
benign on older kernels that don't have patch12 since all fields are
indeed initialized.
