Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552636181.2015392.6062894291885124658.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155552636181.2015392.6062894291885124658.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 2 May 2019 15:28:21 -0400
Message-ID: <CA+CK2bAfw=pkYF2Ux-PM5r7U46JbDA-fM3NjQ3a5F_Fs0D0GHA@mail.gmail.com>
Subject: Re: [PATCH v6 05/12] mm/sparsemem: Convert kmalloc_section_memmap()
 to populate_section_memmap()
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Logan Gunthorpe <logang@deltatee.com>, linux-mm <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 17, 2019 at 2:53 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Allow sub-section sized ranges to be added to the memmap.
> populate_section_memmap() takes an explict pfn range rather than
> assuming a full section, and those parameters are plumbed all the way
> through to vmmemap_populate(). There should be no sub-section usage in
> current deployments. New warnings are added to clarify which memmap
> allocation paths are sub-section capable.
>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

 Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
