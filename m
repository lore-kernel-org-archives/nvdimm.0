Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 902E5223522BF
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 00:42:41 -0700 (PDT)
Date: Mon, 12 Mar 2018 00:48:59 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [dm-devel] [PATCH] dm-writecache
Message-ID: <20180312074859.GB30695@infradead.org>
References: <alpine.LRH.2.02.1803080824210.2819@file01.intranet.prod.int.rdu2.redhat.com>
 <20180308145153.GB23262@infradead.org>
 <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gBUt5NYK2Lx0dMZAnENeSgKm3KaUvY9kkqB+PNPyQu4w@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mike Snitzer <msnitzer@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 08, 2018 at 09:08:32AM -0800, Dan Williams wrote:
> I had the same feedback, and Mikulas sent this useful enhancement to
> the memcpy_flushcache API:
> 
>     https://patchwork.kernel.org/patch/10217655/
> 
> ...it's in my queue to either push through -tip or add it to the next
> libnvdimm pull request for 4.17-rc1.

So lets rebase this submission on top of that.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
