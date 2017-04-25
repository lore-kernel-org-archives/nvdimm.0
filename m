Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com
 [66.111.4.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 180F820D7A3B9
 for <linux-nvdimm@lists.01.org>; Tue, 25 Apr 2017 05:08:02 -0700 (PDT)
Date: Tue, 25 Apr 2017 13:07:28 +0100
From: Greg KH <greg@kroah.com>
Subject: Re: [4.4-stable PATCH 0/2] libnvdimm: stable fixes for 4.4
Message-ID: <20170425120728.GD8686@kroah.com>
References: <149262154180.9164.2041560731963237508.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149262154180.9164.2041560731963237508.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, Matthew Wilcox <mawilcox@microsoft.com>, x86@kernel.org, stable@vger.kernel.org, Jens Axboe <axboe@fb.com>, linux-nvdimm@lists.01.org, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, Robert Hu <robert.hu@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Apr 19, 2017 at 10:05:41AM -0700, Dan Williams wrote:
> Hi -stable team,
> 
> Here is a backport for commit 11e63f6d920d "x86, pmem: fix broken
> __copy_user_nocache cache-bypass assumptions", and another block layer
> fix that allows the libnvdimm unit tests to run.
> 
> I have copied Jens and Jan on the block-layer fix in case they have any
> concerns.

Looks good, thanks.

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
