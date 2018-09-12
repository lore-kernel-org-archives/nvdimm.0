Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5605921129479
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 22:48:42 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id b15-v6so1330325oib.10
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 22:48:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180910234400.4068.15541.stgit@localhost.localdomain>
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
 <20180910234400.4068.15541.stgit@localhost.localdomain>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Sep 2018 22:48:40 -0700
Message-ID: <CAPcyv4gm30sT_us0j27jLmNTV_Fug4d8EW4xTmiTMFdwGSjN-A@mail.gmail.com>
Subject: Re: [PATCH 4/4] nvdimm: Trigger the device probe on a cpu local to
 the device
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
Cc: pavel.tatashin@microsoft.com, Michal Hocko <mhocko@suse.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Dave Hansen <dave.hansen@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 10, 2018 at 4:44 PM, Alexander Duyck
<alexander.duyck@gmail.com> wrote:
> From: Alexander Duyck <alexander.h.duyck@intel.com>
>
> This patch is based off of the pci_call_probe function used to initialize
> PCI devices. The general idea here is to move the probe call to a location
> that is local to the memory being initialized. By doing this we can shave
> significant time off of the total time needed for initialization.
>
> With this patch applied I see a significant reduction in overall init time
> as without it the init varied between 23 and 37 seconds to initialize a 3GB
> node. With this patch applied the variance is only between 23 and 26
> seconds to initialize each node.
>
> I hope to refine this further in the future by combining this logic into
> the async_schedule_domain code that is already in use. By doing that it
> would likely make this functionality redundant.

Yeah, it is a bit sad that we schedule an async thread only to move it
back somewhere else.

Could we trivially achieve the same with an
async_schedule_domain_on_cpu() variant? It seems we can and the
workqueue core will "Do the right thing".

I now notice that async uses the system_unbound_wq and work_on_cpu()
uses the system_wq.  I don't think we want long running nvdimm work on
system_wq.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
