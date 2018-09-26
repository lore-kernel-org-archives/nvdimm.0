Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1591221A07A80
 for <linux-nvdimm@lists.01.org>; Wed, 26 Sep 2018 00:38:35 -0700 (PDT)
Date: Wed, 26 Sep 2018 09:38:31 +0200
From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v5 2/4] mm: Provide kernel parameter to allow disabling
 page init poisoning
Message-ID: <20180926073831.GC6278@dhcp22.suse.cz>
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925201921.3576.84239.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180925201921.3576.84239.stgit@localhost.localdomain>
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Cc: pavel.tatashin@microsoft.com, linux-nvdimm@lists.01.org, dave.hansen@intel.com, linux-kernel@vger.kernel.org, mingo@kernel.org, linux-mm@kvack.org, jglisse@redhat.com, rppt@linux.vnet.ibm.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue 25-09-18 13:20:12, Alexander Duyck wrote:
[...]
> +	vm_debug[=options]	[KNL] Available with CONFIG_DEBUG_VM=y.
> +			May slow down system boot speed, especially when
> +			enabled on systems with a large amount of memory.
> +			All options are enabled by default, and this
> +			interface is meant to allow for selectively
> +			enabling or disabling specific virtual memory
> +			debugging features.
> +
> +			Available options are:
> +			  P	Enable page structure init time poisoning
> +			  -	Disable all of the above options

I agree with Dave that this is confusing as hell. So what does vm_debug
(without any options means). I assume it's NOP and all debugging is
enabled and that is the default. What if I want to disable _only_ the
page struct poisoning. The weird lookcing `-' will disable all other
options that we might gather in the future.

Why cannot you simply go with [no]vm_page_poison[=on/off]?
-- 
Michal Hocko
SUSE Labs
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
