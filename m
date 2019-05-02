Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com
 [IPv6:2a00:1450:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3BFF221243BDE
 for <linux-nvdimm@lists.01.org>; Thu,  2 May 2019 12:18:48 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l25so3120696eda.9
 for <linux-nvdimm@lists.01.org>; Thu, 02 May 2019 12:18:48 -0700 (PDT)
MIME-Version: 1.0
References: <155552633539.2015392.2477781120122237934.stgit@dwillia2-desk3.amr.corp.intel.com>
 <155552635609.2015392.6246305135559796835.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <155552635609.2015392.6246305135559796835.stgit@dwillia2-desk3.amr.corp.intel.com>
From: Pavel Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 2 May 2019 15:18:36 -0400
Message-ID: <CA+CK2bD2b5XZCxGXQ47XXRA2RFvc69u2LKx7pu4Mtvw_ezMDLg@mail.gmail.com>
Subject: Re: [PATCH v6 04/12] mm/hotplug: Prepare shrink_{zone, pgdat}_span
 for sub-section removal
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 17, 2019 at 2:53 PM Dan Williams <dan.j.williams@intel.com> wrote:
>
> Sub-section hotplug support reduces the unit of operation of hotplug
> from section-sized-units (PAGES_PER_SECTION) to sub-section-sized units
> (PAGES_PER_SUBSECTION). Teach shrink_{zone,pgdat}_span() to consider
> PAGES_PER_SUBSECTION boundaries as the points where pfn_valid(), not
> valid_section(), can toggle.
>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  include/linux/mmzone.h |    2 ++
>  mm/memory_hotplug.c    |   16 ++++++++--------
>  2 files changed, 10 insertions(+), 8 deletions(-)

given removing all unused "*ms"

Reviewed-by: Pavel Tatashin <pasha.tatashin@soleen.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
