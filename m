Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9460C20954B86
 for <linux-nvdimm@lists.01.org>; Thu, 15 Mar 2018 00:16:42 -0700 (PDT)
Date: Thu, 15 Mar 2018 00:22:57 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] Introduce module_nd_driver
Message-ID: <20180315072257.GA14576@infradead.org>
References: <20180314182508.10351-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180314182508.10351-1-jthumshirn@suse.de>
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux NV-DIMM Mailing List <linux-nvdimm@lists.01.org>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 14, 2018 at 07:25:05PM +0100, Johannes Thumshirn wrote:
> Provide a module_nd_driver() wrapper and move over the appliccable
> drivers nd_pmem.ko and dax_pmem.ko.

What is the point?  It saves a hand fulk of lines, while making
the code both harder to read and harder to extend.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
