Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-lf0-x243.google.com (mail-lf0-x243.google.com
 [IPv6:2a00:1450:4010:c07::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1C91A1A1E0A
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 02:59:05 -0700 (PDT)
Received: by mail-lf0-x243.google.com with SMTP id l131so5628767lfl.0
 for <linux-nvdimm@lists.01.org>; Mon, 12 Sep 2016 02:59:05 -0700 (PDT)
Date: Mon, 12 Sep 2016 12:59:00 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: [PATCH 1/2] shmem: fix tmpfs to handle the huge= option properly
Message-ID: <20160912095900.GA23346@node.shutemov.name>
References: <1473459863-11287-1-git-send-email-toshi.kani@hpe.com>
 <1473459863-11287-2-git-send-email-toshi.kani@hpe.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1473459863-11287-2-git-send-email-toshi.kani@hpe.com>
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: linux-nvdimm@lists.01.org, mawilcox@microsoft.com, hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Sep 09, 2016 at 04:24:22PM -0600, Toshi Kani wrote:
> shmem_get_unmapped_area() checks SHMEM_SB(sb)->huge incorrectly,
> which leads to a reversed effect of "huge=" mount option.
> 
> Fix the check in shmem_get_unmapped_area().
> 
> Note, the default value of SHMEM_SB(sb)->huge remains as
> SHMEM_HUGE_NEVER.  User will need to specify "huge=" option to
> enable huge page mappings.
> 
> Reported-by: Hillf Danton <hillf.zj@alibaba-inc.com>
> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: Hugh Dickins <hughd@google.com>

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

-- 
 Kirill A. Shutemov
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
