Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7FEC321B02822
 for <linux-nvdimm@lists.01.org>; Wed, 12 Sep 2018 07:10:57 -0700 (PDT)
Date: Wed, 12 Sep 2018 16:10:53 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 1/4] mm: Provide kernel parameter to allow disabling page
 init poisoning
Message-ID: <20180912141053.GL10951@dhcp22.suse.cz>
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
 <20180910234341.4068.26882.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180910234341.4068.26882.stgit@localhost.localdomain>
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
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@intel.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, kirill.shutemov@linux.intel.com, akpm@linux-foundation.org, mingo@kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon 10-09-18 16:43:41, Alexander Duyck wrote:
> From: Alexander Duyck <alexander.h.duyck@intel.com>
> 
> On systems with a large amount of memory it can take a significant amount
> of time to initialize all of the page structs with the PAGE_POISON_PATTERN
> value. I have seen it take over 2 minutes to initialize a system with
> over 12GB of RAM.
> 
> In order to work around the issue I had to disable CONFIG_DEBUG_VM and then
> the boot time returned to something much more reasonable as the
> arch_add_memory call completed in milliseconds versus seconds. However in
> doing that I had to disable all of the other VM debugging on the system.
> 
> In order to work around a kernel that might have CONFIG_DEBUG_VM enabled on
> a system that has a large amount of memory I have added a new kernel
> parameter named "page_init_poison" that can be set to "off" in order to
> disable it.

I am still not convinced that this all is worth the additional code. It
is much better than a new config option for sure. If we really want this
though then I suggest that the parameter handler should note the
disabled state (when CONFIG_DEBUG_VM is on) to the kernel log. I would
also make it explicit who might want to do that in the parameter
description.

> +	page_init_poison=	[KNL] Boot-time parameter changing the
> +			state of poisoning of page structures during early
> +			boot. Used to verify page metadata is not accessed
> +			prior to initialization. Available with
> +			CONFIG_DEBUG_VM=y.
> +			off: turn off poisoning
> +			on: turn on poisoning (default)
> +

what about the following wording or something along those lines

Boot-time parameter to control struct page poisoning which is a
debugging feature to catch unitialized struct page access. This option
is available only for CONFIG_DEBUG_VM=y and it affects boot time
(especially on large systems). If there are no poisoning bugs reported
on the particular system and workload it should be safe to disable it to
speed up the boot time.
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
