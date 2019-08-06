Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 807EF21306CDA
 for <linux-nvdimm@lists.01.org>; Tue,  6 Aug 2019 14:14:38 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id s20so30611410otp.4
 for <linux-nvdimm@lists.01.org>; Tue, 06 Aug 2019 14:12:08 -0700 (PDT)
MIME-Version: 1.0
References: <1565112345-28754-1-git-send-email-jane.chu@oracle.com>
 <1565112345-28754-3-git-send-email-jane.chu@oracle.com>
In-Reply-To: <1565112345-28754-3-git-send-email-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Aug 2019 14:11:56 -0700
Message-ID: <CAPcyv4jgtYMKgEB4jnQ0g4fQPO39BCOmQM8Zo231=_D7L6wH=A@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] mm/memory-failure: Poison read receives SIGKILL
 instead of SIGBUS if mmaped more than once
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
Cc: Linux MM <linux-mm@kvack.org>, Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Aug 6, 2019 at 10:28 AM Jane Chu <jane.chu@oracle.com> wrote:
>
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

Looks good, ignore the checkpatch warning about too long subject line,
looks appropriate to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
