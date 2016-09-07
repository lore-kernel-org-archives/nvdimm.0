Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com
 [148.163.156.1])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E74451A1E98
 for <linux-nvdimm@lists.01.org>; Tue,  6 Sep 2016 22:12:17 -0700 (PDT)
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
 by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id
 u8757srP096728
 for <linux-nvdimm@lists.01.org>; Wed, 7 Sep 2016 01:12:17 -0400
Received: from e28smtp05.in.ibm.com (e28smtp05.in.ibm.com [125.16.236.5])
 by mx0a-001b2d01.pphosted.com with ESMTP id 25a098d59x-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Wed, 07 Sep 2016 01:12:17 -0400
Received: from localhost
 by e28smtp05.in.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <khandual@linux.vnet.ibm.com>;
 Wed, 7 Sep 2016 10:42:14 +0530
Received: from d28relay04.in.ibm.com (d28relay04.in.ibm.com [9.184.220.61])
 by d28dlp03.in.ibm.com (Postfix) with ESMTP id 293CA1258066
 for <linux-nvdimm@lists.01.org>; Wed,  7 Sep 2016 10:42:17 +0530 (IST)
Received: from d28av02.in.ibm.com (d28av02.in.ibm.com [9.184.220.64])
 by d28relay04.in.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id
 u875C8MX19005536
 for <linux-nvdimm@lists.01.org>; Wed, 7 Sep 2016 10:42:08 +0530
Received: from d28av02.in.ibm.com (localhost [127.0.0.1])
 by d28av02.in.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id
 u875C58t022497
 for <linux-nvdimm@lists.01.org>; Wed, 7 Sep 2016 10:42:07 +0530
Date: Wed, 07 Sep 2016 10:42:01 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH 5/5] mm: cleanup pfn_t usage in track_pfn_insert()
References: <147318056046.30325.5100892122988191500.stgit@dwillia2-desk3.amr.corp.intel.com>
 <147318058712.30325.12749411762275637099.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147318058712.30325.12749411762275637099.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <57CFA1A1.7060704@linux.vnet.ibm.com>
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
To: Dan Williams <dan.j.williams@intel.com>, linux-nvdimm@lists.01.org
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 09/06/2016 10:19 PM, Dan Williams wrote:
> Now that track_pfn_insert() is no longer used in the DAX path, it no
> longer needs to comprehend pfn_t values.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  arch/x86/mm/pat.c             |    4 ++--
>  include/asm-generic/pgtable.h |    4 ++--
>  mm/memory.c                   |    2 +-
>  3 files changed, 5 insertions(+), 5 deletions(-)

A small nit. Should not the arch/x86/mm/pat.c changes be separated out
into a different patch ? Kind of faced little bit problem separating out
generic core mm changes to that of arch specific mm changes when going
through the commits in retrospect.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
