Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x229.google.com (mail-oi0-x229.google.com
 [IPv6:2607:f8b0:4003:c06::229])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59D1081EE5
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 10:31:22 -0800 (PST)
Received: by mail-oi0-x229.google.com with SMTP id m124so85254278oif.1
 for <linux-nvdimm@lists.01.org>; Mon, 23 Jan 2017 10:31:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20170123180314.GA23073@lst.de>
References: <BY2PR21MB00367799FE7B7E8302A99260CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122162910.GA5267@lst.de>
 <BY2PR21MB00368E95CBB533D4C761C882CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122183046.GA7359@lst.de>
 <BY2PR21MB0036CC7935BFE438EA001763CB730@BY2PR21MB0036.namprd21.prod.outlook.com>
 <20170122184439.GA7603@lst.de>
 <BY2PR21MB0036CA85562DDD21814C0B27CB720@BY2PR21MB0036.namprd21.prod.outlook.com>
 <CAPcyv4h83wk5SGVPY+8nUZ1e4Gq9fz61GE3BhAdzGi=HFAuDcg@mail.gmail.com>
 <20170123160009.GB517@lst.de>
 <CAPcyv4gAbwS9yKNgAN9ytpDg7Jqh1FubZbGSfbFP0f-DdXPpCg@mail.gmail.com>
 <20170123180314.GA23073@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 23 Jan 2017 10:31:20 -0800
Message-ID: <CAPcyv4iNXeAsDkhyC6KxNxWYMAPUKt7gPneMDUu97aL6ke7RLg@mail.gmail.com>
Subject: Re: [PATCH 00/13] dax, pmem: move cpu cache maintenance to libnvdimm
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
To: Christoph Hellwig <hch@lst.de>
Cc: "x86@kernel.org" <x86@kernel.org>, Tony Luck <tony.luck@intel.com>, Jan Kara <jack@suse.cz>, Mike Snitzer <snitzer@redhat.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Matthew Wilcox <mawilcox@microsoft.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jens Axboe <axboe@fb.com>, Ingo Molnar <mingo@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, "H. Peter Anvin" <hpa@zytor.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 23, 2017 at 10:03 AM, Christoph Hellwig <hch@lst.de> wrote:
> On Mon, Jan 23, 2017 at 09:14:04AM -0800, Dan Williams wrote:
>> The use case that we have now is distinguishing volatile vs persistent
>> memory (brd vs pmem).
>
> brd is a development tool, so until we have other reasons for this
> abstraction (which I'm pretty sure will show up rather sooner than later)
> I would not worry about it too much.

By "volatile" I also meant cases where pmem is fronting volatile
memory, or more importantly when the platform has otherwise arranged
for cpu caches to be flushed on a power loss event like I believe some
existing storage appliances do.

>> I took a look at mtd layering approach and the main difference is that
>> layers above the block layer do not appear to know anything about mtd
>> specifics.
>
> Or the block layer itself for that matter.  And that's exactly where
> I want DAX to be in the future.
>
>> For fs/dax.c we currently need some path to retrieve a dax
>> anchor object through the block device.
>
> We have a need to retreiver the anchor object.  We currently do it
> though the block layer for historical reasons, but it doesn't have
> to be that way.
>
>> > In the longer run I like your dax_operations, but they need to be
>> > separate from the block layer.
>>
>> I'll move them from block_device_operations to dax data hanging off of
>> the bdev_inode, or is there a better way to go from bdev-to-dax?
>
> I don't think that's any better.  What we really want is a way
> to find the underlying persistent memory / DAX / whatever we call
> it node without going through a block device.  E.g. a library function
> to give that object for a given path name, where the path name could
> be either that of the /dev/pmemN or the /dev/daxN device.
>
> If the file system for now still needs a block device as well it
> will only accept the /dev/pmemN name, and open both the low-level
> pmem device and the block device.  Once that file system doesn't
> need block code (and I think we could do that easily for XFS,
> nevermind any new FS) it won't have to deal with the block
> device at all.
>
> pmem.c then becomes a consumer of the dax_ops just like the file system.

Ah ok, I'll take a look at a dax_by_path() capability.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
