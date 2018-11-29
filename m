Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com
 [66.111.4.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3797211944A2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Nov 2018 00:04:35 -0800 (PST)
Date: Thu, 29 Nov 2018 09:04:30 +0100
From: Greg KH <greg@kroah.com>
Subject: Re: [4.19-stable PATCH] dax: Avoid losing wakeup in
 dax_lock_mapping_entry
Message-ID: <20181129080430.GB13859@kroah.com>
References: <20181126142743.GA25618@bombadil.infradead.org>
 <154343119877.981933.9776503138356369421.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154343119877.981933.9776503138356369421.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 28, 2018 at 10:53:44AM -0800, Dan Williams wrote:
> From: Matthew Wilcox <willy@infradead.org>
> 
> commit 25bbe21bf427a81b8e3ccd480ea0e1d940256156 upstream.
> 
> After calling get_unlocked_entry(), you have to call
> put_unlocked_entry() to avoid subsequent waiters losing wakeups.
> 
> Fixes: c2a7d2a11552 ("filesystem-dax: Introduce dax_lock_mapping_entry()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
> Passes the nvdimm unit test suite which exercises the lock path.

Now applied, thanks.

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
