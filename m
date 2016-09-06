Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A529D1A1E6F
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 10:32:17 -0700 (PDT)
Received: by mail-oi0-x233.google.com with SMTP id y2so83853890oie.0
 for <linux-nvdimm@lists.01.org>; Tue, 06 Sep 2016 10:32:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <DM2PR21MB00892878E2A17E076A18C795CBF90@DM2PR21MB0089.namprd21.prod.outlook.com>
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147318058165.30325.16762406881120129093.stgit@dwillia2-desk3.amr.corp.intel.com>
 <DM2PR21MB00892878E2A17E076A18C795CBF90@DM2PR21MB0089.namprd21.prod.outlook.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Sep 2016 10:32:16 -0700
Message-ID: <CAPcyv4gZK33SH7FjZDYpkf-9peeZ0E3pZu=ZjmHwSBxdh4zj-g@mail.gmail.com>
Subject: Re: [PATCH 4/5] mm: fix cache mode of dax pmd mappings
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
To: Matthew Wilcox <mawilcox@microsoft.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Nilesh Choudhury <nilesh.choudhury@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Kai Zhang <kai.ka.zhang@oracle.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Sep 6, 2016 at 10:20 AM, Matthew Wilcox <mawilcox@microsoft.com> wrote:
> I have no objection to this patch going in for now.
>
> Longer term, surely we want to track what mode the PFNs are mapped in?  There are various bizarre suppositions out there about how persistent memory should be mapped, and it's probably better if the kernel ignores what the user specifies and keeps everything sane.  I've read the dire warnings in the Intel architecture manual and I have no desire to deal with the inevitable bug reports on some hardware I don't own and requires twenty weeks of operation in order to observe the bug.

Is there a way for userspace to establish mappings with different
cache modes, besides via /dev/mem?  That was the motivation for
CONFIG_IO_STRICT_DEVMEM.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
