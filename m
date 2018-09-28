Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com
 [209.85.128.52])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5BE1621A07A80
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 01:44:36 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id o2-v6so1319180wmh.5
 for <linux-nvdimm@lists.01.org>; Fri, 28 Sep 2018 01:44:36 -0700 (PDT)
Date: Fri, 28 Sep 2018 10:44:33 +0200
From: Oscar Salvador <osalvador@techadventures.net>
Subject: Re: [PATCH v5 4/4] mm: Defer ZONE_DEVICE page initialization to the
 point where we init pgmap
Message-ID: <20180928084433.GB25561@techadventures.net>
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925202053.3576.66039.stgit@localhost.localdomain>
 <20180926075540.GD6278@dhcp22.suse.cz>
 <6f87a5d7-05e2-00f4-8568-bb3521869cea@linux.intel.com>
 <20180927110926.GE6278@dhcp22.suse.cz>
 <20180927122537.GA20378@techadventures.net>
 <20180927131329.GI6278@dhcp22.suse.cz>
 <20180928081224.GA25561@techadventures.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180928081224.GA25561@techadventures.net>
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
To: Michal Hocko <mhocko@kernel.org>
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-mm@kvack.org, jglisse@redhat.com, rppt@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, Alexander Duyck <alexander.h.duyck@linux.intel.com>, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 28, 2018 at 10:12:24AM +0200, Oscar Salvador wrote:
> Although I am not sure about leaving memmap_init_zone unprotected.
> For the normal memory, that is not a problem since the memblock's lock
> protects us from touching the same pages at the same time in online/offline_pages,
> but for HMM/devm the story is different.
> 
> I am totally unaware of HMM/devm, so I am not sure if its protected somehow.
> e.g: what happens if devm_memremap_pages and devm_memremap_pages_release are running
> at the same time for the same memory-range (with the assumption that the hotplug-lock
> does not protect move_pfn_range_to_zone anymore).

I guess that this could not happen since the device is not linked to devm_memremap_pages_release
until the end with:

devm_add_action(dev, devm_memremap_pages_release, pgmap)
-- 
Oscar Salvador
SUSE L3
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
