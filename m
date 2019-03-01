Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org
 [IPv6:2607:7c80:54:e::133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D1C0208AE2C9
 for <linux-nvdimm@lists.01.org>; Fri,  1 Mar 2019 11:13:53 -0800 (PST)
Date: Fri, 1 Mar 2019 11:13:52 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] dax: Flush partial PMDs correctly
Message-ID: <20190301191352.GN11592@bombadil.infradead.org>
References: <20190301042448.6868-1-willy@infradead.org>
 <20190301134954.GA31094@quack2.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190301134954.GA31094@quack2.suse.cz>
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
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Piotr Balcer <piotr.balcer@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 01, 2019 at 02:49:54PM +0100, Jan Kara wrote:
> >  	pfn = dax_to_pfn(entry);
> > -	size = PAGE_SIZE << dax_entry_order(entry);
> > +	count = 1UL << dax_entry_order(entry);
> > +	index = xas->xa_index &~ (count - 1);
> 
> Hum, why do you compute 'index' here when you actually never use it? The
> whole patch looks fishy since it is effectively a noop AFAICT...

*facepalm*.  I lost the change to the next line while I was backing out
some extraneous changes.

> >  	dax_entry_mkclean(mapping, xas->xa_index, pfn);

Replacement patch sent.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
