Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B069A21BB251D
 for <linux-nvdimm@lists.01.org>; Mon, 12 Jun 2017 05:08:21 -0700 (PDT)
Date: Mon, 12 Jun 2017 15:08:30 +0300
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 1/2] mm: improve readability of
 transparent_hugepage_enabled()
Message-ID: <20170612120829.2qrkjnp3nrgybfla@black.fi.intel.com>
References: <149713136649.17377.3742583729924020371.stgit@dwillia2-desk3.amr.corp.intel.com>
 <149713137177.17377.6712234218256825718.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149713137177.17377.6712234218256825718.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, hch@lst.de, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Jun 10, 2017 at 02:49:31PM -0700, Dan Williams wrote:
> Turn the macro into a static inline and rewrite the condition checks for
> better readability in preparation for adding another condition.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Looks good (unless it breaks build somewhere).

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
