Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 74A812095AE79
 for <linux-nvdimm@lists.01.org>; Fri, 25 Aug 2017 00:26:15 -0700 (PDT)
Date: Fri, 25 Aug 2017 00:28:44 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Message-ID: <20170825072843.GA4220@infradead.org>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org>
 <20170824205727.yyhzblj372eyvkde@thunk.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824205727.yyhzblj372eyvkde@thunk.org>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: linux-nvdimm@lists.01.org, rdodgen@gmail.com, Christoph Hellwig <hch@infradead.org>, linux-ext4@vger.kernel.org, Randy Dodgen <dodgen@google.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 04:57:27PM -0400, Theodore Ts'o wrote:
> Yeah, agreed, that's the cleaner way of doing that.  It does mean
> we'll have sweep through all of the file systems so that they DTRT
> with this new FAULT_FLAG_ALLOC, though, right?

I think the only ones that it matters for for now are the DAX
fault handlers.  So we can add the new flag, check it in ext2, ext4
and xfs for now and we're done.  But if we eventually want to
phase out the ->page_mkwrite handler it would be useful for other
file systems as well.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
