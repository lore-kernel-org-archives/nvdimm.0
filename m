Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.linuxfoundation.org (mail.linuxfoundation.org
 [140.211.169.12])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B9DDF207DF295
 for <linux-nvdimm@lists.01.org>; Tue, 17 Jul 2018 14:37:52 -0700 (PDT)
Date: Tue, 17 Jul 2018 14:37:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2] mm: disallow mapping that conflict for
 devm_memremap_pages()
Message-Id: <20180717143750.3cd7e77544d181a346212715@linux-foundation.org>
In-Reply-To: <152909478401.50143.312364396244072931.stgit@djiang5-desk3.ch.intel.com>
References: <152909478401.50143.312364396244072931.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-mm@kvack.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 15 Jun 2018 13:33:39 -0700 Dave Jiang <dave.jiang@intel.com> wrote:

> When pmem namespaces created are smaller than section size, this can cause
> issue during removal and gpf was observed:
> 
> ...
>
> Add code to check whether we have mapping already in the same section and
> prevent additional mapping from created if that is the case.
> 

Which kernel version(s) do you believe need this fix, and why?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
