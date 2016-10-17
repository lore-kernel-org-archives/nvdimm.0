Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com
 [148.163.158.5])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0CF811A1E3B
 for <linux-nvdimm@lists.01.org>; Sun, 16 Oct 2016 22:57:36 -0700 (PDT)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
 by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id
 u9H5rSqW141593
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 01:57:35 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
 by mx0b-001b2d01.pphosted.com with ESMTP id 264eys4edp-1
 (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
 for <linux-nvdimm@lists.01.org>; Mon, 17 Oct 2016 01:57:35 -0400
Received: from localhost
 by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only!
 Violators will be prosecuted
 for <linux-nvdimm@lists.01.org> from <aneesh.kumar@linux.vnet.ibm.com>;
 Sun, 16 Oct 2016 23:57:35 -0600
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: Re: [PATCH v6 17/17] dax: remove "depends on BROKEN" from FS_DAX_PMD
In-Reply-To: <20161012225022.15507-18-ross.zwisler@linux.intel.com>
References: <20161012225022.15507-1-ross.zwisler@linux.intel.com>
 <20161012225022.15507-18-ross.zwisler@linux.intel.com>
Date: Mon, 17 Oct 2016 11:27:24 +0530
MIME-Version: 1.0
Message-Id: <87eg3ftt4r.fsf@linux.vnet.ibm.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Matthew Wilcox <mawilcox@microsoft.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org, linux-mm@kvack.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

Ross Zwisler <ross.zwisler@linux.intel.com> writes:

> Now that DAX PMD faults are once again working and are now participating in
> DAX's radix tree locking scheme, allow their config option to be enabled.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  fs/Kconfig | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/fs/Kconfig b/fs/Kconfig
> index 2bc7ad7..b6f0fce 100644
> --- a/fs/Kconfig
> +++ b/fs/Kconfig
> @@ -55,7 +55,6 @@ config FS_DAX_PMD
>  	depends on FS_DAX
>  	depends on ZONE_DEVICE
>  	depends on TRANSPARENT_HUGEPAGE
> -	depends on BROKEN
>  
>  endif # BLOCK


This series made dax_pmd_fault return VM_FAULT_FALLBACK in [PATCH v6 09/17] dax: remove dax_pmd_fault(). 
That essentially disable dax pmd for ext4. Any plans to fix that ?

-aneesh

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
