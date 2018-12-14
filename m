Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 536152119F065
 for <linux-nvdimm@lists.01.org>; Thu, 13 Dec 2018 23:13:47 -0800 (PST)
Date: Fri, 14 Dec 2018 08:13:44 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: FAILED: patch "[PATCH] dax: Don't access a freed inode" failed
 to apply to 4.19-stable tree
Message-ID: <20181214071344.GC31355@kroah.com>
References: <1544536809243247@kroah.com>
 <20181211152349.GE6830@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181211152349.GE6830@bombadil.infradead.org>
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
Cc: jack@suse.cz, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 11, 2018 at 07:23:49AM -0800, Matthew Wilcox wrote:
> On Tue, Dec 11, 2018 at 03:00:09PM +0100, gregkh@linuxfoundation.org wrote:
> > 
> > The patch below does not apply to the 4.19-stable tree.
> > If someone wants it applied there, or to any other stable or longterm
> > tree, then please email the backport, including the original git commit
> > id to <stable@vger.kernel.org>.
> 
> I have only compile-tested this backport.  Dan, do you want to run it
> through some tests before Greg applies it?

Thanks for the backport, I'll wait to hear from Dan before queueing this
up.

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
