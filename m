Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from imap.thunk.org (imap.thunk.org
 [IPv6:2600:3c02::f03c:91ff:fe96:be03])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 603522095AE63
 for <linux-nvdimm@lists.01.org>; Thu, 24 Aug 2017 13:54:58 -0700 (PDT)
Date: Thu, 24 Aug 2017 16:57:27 -0400
From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3] Fix ext4 fault handling when mounted with -o dax,ro
Message-ID: <20170824205727.yyhzblj372eyvkde@thunk.org>
References: <CAC9jV4pfQr=z9dHqtnTP8kAXGReeLDZWAAAfW2a7KRsK22UWkA@mail.gmail.com>
 <416a465a9fbe1d27085883dbf652c115cd195697.1503523424.git.dodgen@google.com>
 <20170824160144.GA14287@infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170824160144.GA14287@infradead.org>
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
Cc: rdodgen@gmail.com, linux-ext4@vger.kernel.org, Randy Dodgen <dodgen@google.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 24, 2017 at 09:01:44AM -0700, Christoph Hellwig wrote:
> 
> We really need to do the same for ext2 and xfs.  And we really should
> be doing that in common VM code instead of the file system.  See
> my recent xfs synchronous page fault series on the mess the inconsistent
> handling of the FAULT_FLAG_WRITE causes.  I think we just need a new
> FAULT_FLAG_ALLOC or similar for those page faults that needs to
> allocate space instead of piling hacks over hacks, and make sure
> it's only set over the method that will actually do the allocation,
> as the DAX and non-DAX path are not consistent on that.

Yeah, agreed, that's the cleaner way of doing that.  It does mean
we'll have sweep through all of the file systems so that they DTRT
with this new FAULT_FLAG_ALLOC, though, right?

						- Ted
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
