Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x241.google.com (mail-it0-x241.google.com
 [IPv6:2607:f8b0:4001:c0b::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1533321127CB5
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 17:38:03 -0700 (PDT)
Received: by mail-it0-x241.google.com with SMTP id h1-v6so31214404itj.4
 for <linux-nvdimm@lists.01.org>; Mon, 10 Sep 2018 17:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <20180910232615.4068.29155.stgit@localhost.localdomain>
 <20180910234400.4068.15541.stgit@localhost.localdomain>
In-Reply-To: <20180910234400.4068.15541.stgit@localhost.localdomain>
From: Alexander Duyck <alexander.duyck@gmail.com>
Date: Mon, 10 Sep 2018 17:37:50 -0700
Message-ID: <CAKgT0UceRHjfoKPxAJEchX4O91j_mtCQxqjTSQ=GJSoSOGbWmg@mail.gmail.com>
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
To: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
Cc: pavel.tatashin@microsoft.com, Michal Hocko <mhocko@suse.com>, Dave Hansen <dave.hansen@intel.com>, jglisse@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Sep 10, 2018 at 4:44 PM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
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

Same mistake here as in patch 1. It is 3TB, not 3GB. I will fix for
the next version.

- Alex
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
