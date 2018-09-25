Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B1FD021AE30DB
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 13:27:42 -0700 (PDT)
Subject: Re: [PATCH v5 2/4] mm: Provide kernel parameter to allow disabling
 page init poisoning
References: <20180925200551.3576.18755.stgit@localhost.localdomain>
 <20180925201921.3576.84239.stgit@localhost.localdomain>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <13285e05-fb90-b948-6f96-777f94079657@intel.com>
Date: Tue, 25 Sep 2018 13:26:39 -0700
MIME-Version: 1.0
In-Reply-To: <20180925201921.3576.84239.stgit@localhost.localdomain>
Content-Language: en-US
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
To: Alexander Duyck <alexander.h.duyck@linux.intel.com>, linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
Cc: pavel.tatashin@microsoft.com, mhocko@suse.com, jglisse@redhat.com, rppt@linux.vnet.ibm.com, mingo@kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 09/25/2018 01:20 PM, Alexander Duyck wrote:
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

Can we have vm_debug=off for turning things off, please?  That seems to
be pretty standard.

Also, we need to document the defaults.  I think the default is "all
debug options are enabled", but it would be nice to document that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
