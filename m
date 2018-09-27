Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AE06B2115992F
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 06:41:31 -0700 (PDT)
Date: Thu, 27 Sep 2018 15:41:29 +0200
From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] dax: Fix deadlock in dax_lock_mapping_entry()
Message-ID: <20180927134129.GB8800@quack2.suse.cz>
References: <20180927112332.3649-1-jack@suse.cz>
 <20180927132843.GA19006@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180927132843.GA19006@bombadil.infradead.org>
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
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>, Barret Rhoden <brho@google.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu 27-09-18 06:28:43, Matthew Wilcox wrote:
> On Thu, Sep 27, 2018 at 01:23:32PM +0200, Jan Kara wrote:
> > When dax_lock_mapping_entry() has to sleep to obtain entry lock, it will
> > fail to unlock mapping->i_pages spinlock and thus immediately deadlock
> > against itself when retrying to grab the entry lock again. Fix the
> > problem by unlocking mapping->i_pages before retrying.
> 
> It seems weird that xfstests doesn't provoke this ...

The function currently gets called only from mm/memory-failure.c. And yes,
we are lacking DAX hwpoison error tests in fstests...

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
