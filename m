Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A11562267F0F4
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 10:49:21 -0700 (PDT)
Date: Mon, 9 Apr 2018 10:49:18 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] drivers/of: Introduce ARCH_HAS_OWN_OF_NUMA
Message-ID: <20180409174918.GA4629@infradead.org>
References: <20180409074604.17671-1-oohall@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180409074604.17671-1-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: sfr@canb.auug.org.au, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Apr 09, 2018 at 05:46:04PM +1000, Oliver O'Halloran wrote:
> Some OF platforms (pseries and some SPARC systems) has their own
> implementations of NUMA affinity detection rather than using the generic
> OF_NUMA driver, which mainly exists for arm64. For other platforms one
> of two fallbacks provided by the base OF driver are used depending on
> CONFIG_NUMA.
> 
> In the CONFIG_NUMA=n case the fallback is an inline function in of.h.
> In the =y case the fallback is a real function which is defined as a
> weak symbol so that it may be overwritten by the architecture if desired.
> 
> The problem with this arrangement is that the real implementations all
> export of_node_to_nid(). Unfortunately it's not possible to export the
> fallback since it would clash with the non-weak version. As a result
> we get build failures when:
> 
> a) CONFIG_NUMA=y && CONFIG_OF=y, and
> b) The platform doesn't implement of_node_to_nid(), and
> c) A module uses of_node_to_nid()
> 
> Given b) will be true for most platforms this is fairly easy to hit
> and has been observed on ia64 and x86.
> 
> This patch remedies the problem by introducing the ARCH_HAS_OWN_OF_NUMA
> Kconfig option which is selected if an architecture provides an
> implementation of of_node_to_nid(). If a platform does not use it's own,
> or the generic OF_NUMA, then always use the inline fallback in of.h so
> we don't need to futz around with exports.

I'd rather have a specific kconfig symbol for the 'generic'
implementation, especially given that it doesn't appear to be all
that generic.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
