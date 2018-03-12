Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8523D224C0F39
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 05:08:46 -0700 (PDT)
Date: Mon, 12 Mar 2018 08:15:06 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [dm-devel] [PATCH] dm-writecache
In-Reply-To: <20180312074859.GB30695@infradead.org>
Message-ID: <alpine.LRH.2.02.1803120812490.13914@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
 <20180312074859.GB30695@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>, device-mapper development <dm-devel@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



On Mon, 12 Mar 2018, Christoph Hellwig wrote:

> On Thu, Mar 08, 2018 at 09:08:32AM -0800, Dan Williams wrote:
> > I had the same feedback, and Mikulas sent this useful enhancement to
> > the memcpy_flushcache API:
> > 
> >     https://patchwork.kernel.org/patch/10217655/
> > 
> > ...it's in my queue to either push through -tip or add it to the next
> > libnvdimm pull request for 4.17-rc1.
> 
> So lets rebase this submission on top of that.

I already did and the patch that you criticized is based on the top of 
that.

I've found out that memcpy_flushcache performs better on x86 and dax_flush 
performs betetr on ARM64, so the code has two flushing strategies that are 
switched with preprocessor condition.

Mikulas
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
