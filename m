Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 22D02207E53F1
 for <linux-nvdimm@lists.01.org>; Fri, 18 May 2018 08:44:59 -0700 (PDT)
Date: Fri, 18 May 2018 11:44:54 -0400
From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-writecache
Message-ID: <20180518154454.GA4902@redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, device-mapper development <dm-devel@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 08 2018 at 12:08pm -0500,
Dan Williams <dan.j.williams@intel.com> wrote:

> Mikulas sent this useful enhancement to the memcpy_flushcache API:
> 
>     https://patchwork.kernel.org/patch/10217655/
> 
> ...it's in my queue to either push through -tip or add it to the next
> libnvdimm pull request for 4.17-rc1.

Hi Dan,

Seems this never actually went upstream.  I've staged it in
linux-dm.git's "for-next" for the time being:
https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.18&id=a7e96990b5ff6206fefdc5bfe74396bb880f7e48

But do you intend to pick it up for 4.18 inclusion?  If so I'll drop
it.. would just hate for it to get dropped on the floor by getting lost
in the shuffle between trees.

Please avise, thanks!
Mike
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
