Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 025B22125ADC5
 for <linux-nvdimm@lists.01.org>; Mon, 24 Jun 2019 10:57:59 -0700 (PDT)
Message-ID: <1561399075.3073.6.camel@suse.de>
Subject: Re: [PATCH v10 03/13] mm/sparsemem: Add helpers track active
 portions of a section at boot
From: Oscar Salvador <osalvador@suse.de>
Date: Mon, 24 Jun 2019 19:57:55 +0200
In-Reply-To: <156092350874.979959.18185938451405518285.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <156092349300.979959.17603710711957735135.stgit@dwillia2-desk3.amr.corp.intel.com>
 <156092350874.979959.18185938451405518285.stgit@dwillia2-desk3.amr.corp.intel.com>
Mime-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, akpm@linux-foundation.org
Cc: Michal Hocko <mhocko@suse.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Qian Cai <cai@lca.pw>, Vlastimil Babka <vbabka@suse.cz>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2019-06-18 at 22:51 -0700, Dan Williams wrote:
> Prepare for hot{plug,remove} of sub-ranges of a section by tracking a
> sub-section active bitmask, each bit representing a PMD_SIZE span of
> the
> architecture's memory hotplug section size.
> 
> The implications of a partially populated section is that pfn_valid()
> needs to go beyond a valid_section() check and either determine that
> the
> section is an "early section", or read the sub-section active ranges
> from the bitmask. The expectation is that the bitmask
> (subsection_map)
> fits in the same cacheline as the valid_section() / early_section()
> data, so the incremental performance overhead to pfn_valid() should
> be
> negligible.
> 
> The rationale for using early_section() to short-ciruit the
> subsection_map check is that there are legacy code paths that use
> pfn_valid() at section granularity before validating the pfn against
> pgdat data. So, the early_section() check allows those traditional
> assumptions to persist while also permitting subsection_map to tell
> the
> truth for purposes of populating the unused portions of early
> sections
> with PMEM and other ZONE_DEVICE mappings.
> 
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Logan Gunthorpe <logang@deltatee.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Pavel Tatashin <pasha.tatashin@soleen.com>
> Reported-by: Qian Cai <cai@lca.pw>
> Tested-by: Jane Chu <jane.chu@oracle.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Oscar Salvador <osalvador@suse.de>

-- 
Oscar Salvador
SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
