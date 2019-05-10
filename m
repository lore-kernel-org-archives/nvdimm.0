Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Fri, 10 May 2019 14:56:54 +0200
From: osalvador@suse.de
Subject: Re: [PATCH v8 03/12] mm/sparsemem: Add helpers track active portions
 of a section at boot
In-Reply-To: <155718598213.130019.10989541248734713186.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <155718596657.130019.17139634728875079809.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155718598213.130019.10989541248734713186.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-ID: <5ce1d8dfe8e485616f9ade30fade88a5@suse.de>
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: akpm@linux-foundation.org, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Logan Gunthorpe <logang@deltatee.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, Jane Chu <jane.chu@oracle.com>, linux-nvdimm@lists.01.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 2019-05-07 01:39, Dan Williams wrote:
> Prepare for hot{plug,remove} of sub-ranges of a section by tracking a
> sub-section active bitmask, each bit representing a PMD_SIZE span of 
> the
> architecture's memory hotplug section size.
> 
> The implications of a partially populated section is that pfn_valid()
> needs to go beyond a valid_section() check and read the sub-section
> active ranges from the bitmask. The expectation is that the bitmask
> (subsection_map) fits in the same cacheline as the valid_section() 
> data,
> so the incremental performance overhead to pfn_valid() should be
> negligible.
> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Tested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Now that the handling is done in pfn/nr_pages, it looks better to me:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

Thanks
