Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-it0-x22d.google.com (mail-it0-x22d.google.com
 [IPv6:2607:f8b0:4001:c0b::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8982321D18236
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 08:35:46 -0700 (PDT)
Received: by mail-it0-x22d.google.com with SMTP id 76so22378379ith.0
 for <linux-nvdimm@lists.01.org>; Mon, 14 Aug 2017 08:38:10 -0700 (PDT)
Subject: Re: [PATCH v1 2/6] fs: use on-stack-bio if backing device has
 BDI_CAP_SYNC capability
References: <20170809023122.GF31390@bombadil.infradead.org>
 <20170809024150.GA32471@bbox> <20170810030433.GG31390@bombadil.infradead.org>
 <CAA9_cmekE9_PYmNnVmiOkyH2gq5o8=uvEKnAbMWw5nBX-zE69g@mail.gmail.com>
 <20170811104615.GA14397@lst.de>
 <20c5b30a-b787-1f46-f997-7542a87033f8@kernel.dk>
 <20170814085042.GG26913@bbox>
 <51f7472a-977b-be69-2688-48f2a0fa6fb3@kernel.dk>
 <20170814150620.GA12657@bgram>
 <51893dc5-05a3-629a-3b88-ecd8e25165d0@kernel.dk>
 <20170814153059.GA13497@bgram>
From: Jens Axboe <axboe@kernel.dk>
Message-ID: <0c83e7af-10a4-3462-bb4c-4254adcf6f7a@kernel.dk>
Date: Mon, 14 Aug 2017 09:38:06 -0600
MIME-Version: 1.0
In-Reply-To: <20170814153059.GA13497@bgram>
Content-Language: en-US
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
To: Minchan Kim <minchan@kernel.org>
Cc: kernel-team <kernel-team@lge.com>, Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Dave Chinner <david@fromorbit.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-mm <linux-mm@kvack.org>, seungho1.park@lge.com, Andrew Morton <akpm@linux-foundation.org>, "karam . lee" <karam.lee@lge.com>
List-ID: <linux-nvdimm@lists.01.org>

On 08/14/2017 09:31 AM, Minchan Kim wrote:
>> Secondly, generally you don't have slow devices and fast devices
>> intermingled when running workloads. That's the rare case.
> 
> Not true. zRam is really popular swap for embedded devices where
> one of low cost product has a really poor slow nand compared to
> lz4/lzo [de]comression.

I guess that's true for some cases. But as I said earlier, the recycling
really doesn't care about this at all. They can happily coexist, and not
step on each others toes.

-- 
Jens Axboe

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
