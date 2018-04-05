Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x243.google.com (mail-pl0-x243.google.com
 [IPv6:2607:f8b0:400e:c01::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C42A922526482
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 18:12:11 -0700 (PDT)
Received: by mail-pl0-x243.google.com with SMTP id 91-v6so16761704pld.3
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 18:12:11 -0700 (PDT)
Date: Thu, 5 Apr 2018 11:11:56 +1000
From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RESEND 1/3] powerpc/mce: Bug fixes for MCE handling in kernel
 space
Message-ID: <20180405111156.09cd3150@gmail.com>
In-Reply-To: <20180405094900.3ce4be8b@roar.ozlabs.ibm.com>
References: <20180404231943.29581-1-bsingharora@gmail.com>
 <20180404231943.29581-2-bsingharora@gmail.com>
 <20180405094900.3ce4be8b@roar.ozlabs.ibm.com>
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
To: Nicholas Piggin <npiggin@gmail.com>
Cc: mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 5 Apr 2018 09:49:00 +1000
Nicholas Piggin <npiggin@gmail.com> wrote:

> On Thu,  5 Apr 2018 09:19:41 +1000
> Balbir Singh <bsingharora@gmail.com> wrote:
> 
> > The code currently assumes PAGE_SHIFT as the shift value of
> > the pfn, this works correctly (mostly) for user space pages,
> > but the correct thing to do is  
> 
> It would be good to actually explain the problem in the
> changelog. I would have thought pte_pfn returns a
> PAGE_SIZE based pfn value?
>

The issue is hidden inside of hugepte_offset() as invoked by __find_linux_pte().
I will send a new version because the code needs to do
<< (shift - PAGE_SHIFT) for instruction address.

> > 
> > 1. Extrace the shift value returned via the pte-walk API's  
> 
>       ^^^ extract?

Thanks, yes, typo!

Balbir Singh.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
