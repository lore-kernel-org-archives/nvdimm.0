Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5855F2128D6BE
 for <linux-nvdimm@lists.01.org>; Mon,  1 Jul 2019 16:51:53 -0700 (PDT)
Date: Mon, 1 Jul 2019 16:51:52 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/nvdimm: Add is_ioremap_addr and use that to check
 ioremap address
Message-Id: <20190701165152.7a55299eb670b0ca326f24dd@linux-foundation.org>
In-Reply-To: <20190701134038.14165-1-aneesh.kumar@linux.ibm.com>
References: <20190701134038.14165-1-aneesh.kumar@linux.ibm.com>
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
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>
Cc: linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon,  1 Jul 2019 19:10:38 +0530 "Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com> wrote:

> Architectures like powerpc use different address range to map ioremap
> and vmalloc range. The memunmap() check used by the nvdimm layer was
> wrongly using is_vmalloc_addr() to check for ioremap range which fails for
> ppc64. This result in ppc64 not freeing the ioremap mapping. The side effect
> of this is an unbind failure during module unload with papr_scm nvdimm driver

The patch applies to 5.1.  Does it need a Fixes: and a Cc:stable?

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
