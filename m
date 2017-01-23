Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from newverein.lst.de (verein.lst.de [213.95.11.211])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2B21B81EE3
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 08:01:05 -0800 (PST)
Date: Mon, 23 Jan 2017 17:01:03 +0100
From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to libnvdimm
Message-ID: <20170123160103.GC517@lst.de>
References: <148488421301.37913.12835362165895864897.stgit@dwillia2-desk3.amr.corp.intel.com>
 <BY2PR21MB0036C7BBC487D7C101F36DCFCB700@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170121175212.GA28180@lst.de>
 <CAPcyv4jEXsjw_Mo3aLRFmJr8ThqLPJPjdPjz7Q3ZS0ZC-AaDBw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4jEXsjw_Mo3aLRFmJr8ThqLPJPjdPjz7Q3ZS0ZC-AaDBw@mail.gmail.com>
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
Cc: "x86@kernel.org" <x86@kernel.org>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jens Axboe <axboe@fb.com>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Jan 22, 2017 at 09:30:23AM -0800, Dan Williams wrote:
> So are you saying we need a way to go from a block_device inode to a
> dax_device inode and then look up the dax_operations from there?
> 
> A filesystem, if it so chooses, could mount on top of the dax_device
> inode directly?

Sentence 1: maybe if we have to.  Sentence 2: absolutely.

> I did add a dax_superblock for the device-dax character device
> representation I could refactor that so the block_device presentation
> of a namespace and a character device presentation are just different
> layers on top of the base-level dax inode.

That's a good start.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
