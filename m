Return-Path: <owner-linux-mm@kvack.org>
Message-ID: <1559943687.3141.8.camel@suse.de>
Subject: Re: [PATCH v9 08/12] mm/sparsemem: Support sub-section hotplug
From: Oscar Salvador <osalvador@suse.de>
Date: Fri, 07 Jun 2019 23:41:27 +0200
In-Reply-To: <CAPcyv4hgmjUvA0+uMWYJibmgSWtoLw7zM-jFuP7eRdU2xyVxOw@mail.gmail.com>
References: 
	<155977186863.2443951.9036044808311959913.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <155977192280.2443951.13941265207662462739.stgit@dwillia2-desk3.amr.corp.intel.com>
	 <20190607083351.GA5342@linux>
	 <CAPcyv4hgmjUvA0+uMWYJibmgSWtoLw7zM-jFuP7eRdU2xyVxOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: owner-linux-mm@kvack.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Logan Gunthorpe <logang@deltatee.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, Linux MM <linux-mm@kvack.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 2019-06-07 at 08:38 -0700, Dan Williams wrote:
> I don't know, but I can't imagine it would because it's much easier
> to
> do mem_map relative translations by simple PAGE_OFFSET arithmetic.

Yeah, I guess so.

> No worries, its a valid question. The bitmap dance is still valid it
> will just happen on section boundaries instead of subsection. If
> anything breaks that's beneficial additional testing that we got from
> the SPARSEMEM sub-case for the SPARSEMEM_VMEMMAP superset-case.
> That's
> the gain for keeping them unified, what's the practical gain from
> hiding this bit manipulation from the SPARSEMEM case?

It is just that I thought that we might benefit from not doing extra
work if not needed (bitmap dance) in SPARSEMEM case.
But given that 1) hot-add/hot-remove paths are not hot paths, it does
not really matter 2) and that having all cases unified in one function
make sense too, spreading the work in more functions might be sub-
optimal.
I guess I could justfiy it in case both activate/deactive functions
would look convulated, but it is not the case here.

I just took another look to check that I did not miss anything.
It looks quite nice and compact IMO:

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
