Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1FC521BADAB6
 for <linux-nvdimm@lists.01.org>; Mon,  8 Oct 2018 17:21:06 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id l58so6862911otd.6
 for <linux-nvdimm@lists.01.org>; Mon, 08 Oct 2018 17:21:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAPcyv4jX5WYmMYzGCBrnaqT7tqHGSVPwm7Dpi-XpuM9ns84+0w@mail.gmail.com>
 <20181008233404.1909.37302.stgit@localhost.localdomain>
In-Reply-To: <20181008233404.1909.37302.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 8 Oct 2018 17:20:54 -0700
Message-ID: <CAPcyv4jB5S7DbYr+LmMNpD0teKrO2aoVfJxnSFPrswPCcs-Snw@mail.gmail.com>
Subject: Re: [mm PATCH] memremap: Fix reference count for pgmap in
 devm_memremap_pages
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
To: alexander.h.duyck@linux.intel.com
Cc: Pasha Tatashin <pavel.tatashin@microsoft.com>, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 8, 2018 at 4:34 PM Alexander Duyck
<alexander.h.duyck@linux.intel.com> wrote:
>
> In the earlier patch "mm: defer ZONE_DEVICE page initialization to the
> point where we init pgmap" I had overlooked the reference count that was
> being held per page on the pgmap. As a result on running the ndctl test
> "create.sh" we would call into devm_memremap_pages_release and encounter
> the following percpu reference count error and hang:
>   WARNING: CPU: 30 PID: 0 at lib/percpu-refcount.c:155
>   percpu_ref_switch_to_atomic_rcu+0xf3/0x120
>
> This patch addresses that by performing an update for all of the device
> PFNs in a single call. In my testing this seems to resolve the issue while
> still allowing us to retain the improvements seen in memory initialization.
>
> Reported-by: Dan Williams <dan.j.williams@intel.com>

Tested-by: Dan Williams <dan.j.williams@intel.com>

Thanks Alex!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
