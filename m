Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 56F4D820EA
 for <linux-nvdimm@lists.01.org>; Thu, 16 Feb 2017 07:42:39 -0800 (PST)
Subject: Re: [PATCH] mm,x86: fix SMP x86 32bit build for native_pud_clear()
References: <148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <68216ac2-e194-30fa-9dcb-2020e8953bf5@linux.intel.com>
Date: Thu, 16 Feb 2017 07:42:34 -0800
MIME-Version: 1.0
In-Reply-To: <148719066814.31111.3239231168815337012.stgit@djiang5-desk3.ch.intel.com>
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
To: Dave Jiang <dave.jiang@intel.com>, akpm@linux-foundation.org
Cc: jack@suse.com, alexander.kapshuk@gmail.com, linux-nvdimm@lists.01.org, mawilcox@microsoft.com, linux-xfs@vger.kernel.org, linux-mm@kvack.org, vbabka@suse.cz, keescook@google.com, linux-ext4@vger.kernel.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 02/15/2017 12:31 PM, Dave Jiang wrote:
> The fix introduced by e4decc90 to fix the UP case for 32bit x86, however
> that broke the SMP case that was working previously. Add ifdef so the dummy
> function only show up for 32bit UP case only.

Could you elaborate a bit on how it broke things?

> Fix: e4decc90 mm,x86: native_pud_clear missing on i386 build

Which tree is that in, btw?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
