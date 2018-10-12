Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5009.houston.hpe.com (g9t5009.houston.hpe.com [15.241.48.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 177B32116DA05
 for <linux-nvdimm@lists.01.org>; Fri, 12 Oct 2018 08:36:44 -0700 (PDT)
From: "Kani, Toshi" <toshi.kani@hpe.com>
Subject: Re: [nvdimm PATCH 0/6] Label initialization time optimizations
Date: Fri, 12 Oct 2018 15:36:41 +0000
Message-ID: <64d9ee00e363178409a0c42928a13752abe58cdb.camel@hpe.com>
References: <20181010233428.12228.26106.stgit@localhost.localdomain>
In-Reply-To: <20181010233428.12228.26106.stgit@localhost.localdomain>
Content-Language: en-US
Content-ID: <6C36CD82ED54E9418D333C62E4C69872@NAMPRD84.PROD.OUTLOOK.COM>
MIME-Version: 1.0
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "alexander.h.duyck@linux.intel.com" <alexander.h.duyck@linux.intel.com>
Cc: "zwisler@kernel.org" <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2018-10-10 at 16:36 -0700, Alexander Duyck wrote:
> This patch set is intended to improve NVDIMM label read times by first
> increasing the upper limit on the label read/write size, and then
> reducing the number of reads by making use of the free label bitmap in
> the index to determine what labels are actually populated and only read
> those labels. In my testing on a system populated with 24 NVDIMM modules
> I see the total label init time drop from about 24 seconds down to 2 to
> 3 seconds. 
> 
> In the process of coding this up I came across a few minor issues that
> I felt should be addressed so I have added a few patches for those fixes
> along the way.
> 
> ---
> 
> Alexander Duyck (5):
>       nvdimm: Sanity check labeloff
>       nvdimm: Clarify comment in sizeof_namespace_index
>       nvdimm: Remove empty if statement
>       nvdimm: Split label init out from the logic for getting config data
>       nvdimm: Use namespace index data to reduce number of label reads needed
> 
> Dan Williams (1):
>       libnvdimm, dimm: Maximize label transfer size
> 

This series really helps us a lot!! The change looks good to me.

Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
