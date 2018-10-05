Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37C2521962301
 for <linux-nvdimm@lists.01.org>; Thu,  4 Oct 2018 23:25:26 -0700 (PDT)
Date: Thu, 4 Oct 2018 23:25:24 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Problems with VM_MIXEDMAP removal from /proc/<pid>/smaps
Message-ID: <20181005062524.GA30582@infradead.org>
References: <20181002100531.GC4135@quack2.suse.cz>
 <20181002121039.GA3274@linux-x5ow.site>
 <20181002142010.GB4963@linux-x5ow.site>
 <20181002144547.GA26735@infradead.org>
 <20181002150123.GD4963@linux-x5ow.site>
 <20181002150634.GA22209@infradead.org>
 <20181004100949.GF6682@linux-x5ow.site>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181004100949.GF6682@linux-x5ow.site>
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
Cc: mhocko@suse.cz, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 04, 2018 at 12:09:49PM +0200, Johannes Thumshirn wrote:
> On Tue, Oct 02, 2018 at 08:06:34AM -0700, Christoph Hellwig wrote:
> > There is no promise, sorry.
> 
> Well there have been lot's of articles on for instance lwn.net [1] [2]
> [3] describing how to avoid the "overhead" of the page cache when
> running on persistent memory.

Since when is an article on some website a promise (of what exactly)
by linux kernel developers?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
