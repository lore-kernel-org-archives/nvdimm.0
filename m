Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 198E921954077
 for <linux-nvdimm@lists.01.org>; Sun, 23 Apr 2017 04:53:13 -0700 (PDT)
In-Reply-To: <20170411174233.21902-8-oohall@gmail.com>
From: Michael Ellerman <patch-notifications@ellerman.id.au>
Subject: Re: [7/9] powerpc/mm: Wire up ioremap_cache
Message-Id: <3w9nsx3nzqz9s2G@ozlabs.org>
Date: Sun, 23 Apr 2017 21:53:09 +1000 (AEST)
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Oliver O'Halloran <oohall@gmail.com>, linuxppc-dev@lists.ozlabs.org
Cc: arbab@linux.vnet.ibm.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, 2017-04-11 at 17:42:31 UTC, Oliver O'Halloran wrote:
> The default implementation of ioremap_cache() is aliased to ioremap().
> On powerpc ioremap() creates cache-inhibited mappings by default which
> is almost certainly not what you wanted.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>

Applied to powerpc next, thanks.

https://git.kernel.org/powerpc/c/f855b2f544d664cfa3055edb7ffd20

cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
