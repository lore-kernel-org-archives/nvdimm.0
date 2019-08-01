Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tyo162.gate.nec.co.jp (tyo162.gate.nec.co.jp [114.179.232.162])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9C00212FD4E0
 for <linux-nvdimm@lists.01.org>; Thu,  1 Aug 2019 02:06:34 -0700 (PDT)
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v3 2/2] mm/memory-failure: Poison read receives SIGKILL
 instead of SIGBUS if mmaped more than once
Date: Thu, 1 Aug 2019 08:18:26 +0000
Message-ID: <20190801081826.GB31767@hori.linux.bs1.fc.nec.co.jp>
References: <1564092101-3865-1-git-send-email-jane.chu@oracle.com>
 <1564092101-3865-3-git-send-email-jane.chu@oracle.com>
In-Reply-To: <1564092101-3865-3-git-send-email-jane.chu@oracle.com>
Content-Language: ja-JP
Content-ID: <3643947E1DEB764F9AEBCC8A0B8504B2@gisp.nec.co.jp>
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
To: Jane Chu <jane.chu@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 25, 2019 at 04:01:41PM -0600, Jane Chu wrote:
> Mmap /dev/dax more than once, then read the poison location using address
> from one of the mappings. The other mappings due to not having the page
> mapped in will cause SIGKILLs delivered to the process. SIGKILL succeeds
> over SIGBUS, so user process looses the opportunity to handle the UE.
> 
> Although one may add MAP_POPULATE to mmap(2) to work around the issue,
> MAP_POPULATE makes mapping 128GB of pmem several magnitudes slower, so
> isn't always an option.
> 
> Details -
> 
> ndctl inject-error --block=10 --count=1 namespace6.0
> 
> ./read_poison -x dax6.0 -o 5120 -m 2
> mmaped address 0x7f5bb6600000
> mmaped address 0x7f3cf3600000
> doing local read at address 0x7f3cf3601400
> Killed
> 
> Console messages in instrumented kernel -
> 
> mce: Uncorrected hardware memory error in user-access at edbe201400
> Memory failure: tk->addr = 7f5bb6601000
> Memory failure: address edbe201: call dev_pagemap_mapping_shift
> dev_pagemap_mapping_shift: page edbe201: no PUD
> Memory failure: tk->size_shift == 0
> Memory failure: Unable to find user space address edbe201 in read_poison
> Memory failure: tk->addr = 7f3cf3601000
> Memory failure: address edbe201: call dev_pagemap_mapping_shift
> Memory failure: tk->size_shift = 21
> Memory failure: 0xedbe201: forcibly killing read_poison:22434 because of failure to unmap corrupted page
>   => to deliver SIGKILL
> Memory failure: 0xedbe201: Killing read_poison:22434 due to hardware memory corruption
>   => to deliver SIGBUS
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> Suggested-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Thanks for the fix.

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
