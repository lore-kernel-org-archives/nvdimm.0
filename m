Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com
 [IPv6:2a00:1450:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B92D82130A4E1
 for <linux-nvdimm@lists.01.org>; Mon,  5 Aug 2019 12:19:21 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id s15so52725400wmj.3
 for <linux-nvdimm@lists.01.org>; Mon, 05 Aug 2019 12:16:51 -0700 (PDT)
Subject: Re: [PATCH] dax: dax_layout_busy_page() should not unmap cow pages
References: <20190802192956.GA3032@redhat.com>
 <CAPcyv4jxknEGq9FzGpsMJ6E7jC51d1W9KbNg4HX6Cj6vqt7dqg@mail.gmail.com>
 <9678e812-08c1-fab7-f358-eaf123af14e5@plexistor.com>
 <20190805184951.GC13994@redhat.com>
From: Boaz Harrosh <boaz@plexistor.com>
Message-ID: <9c0ec951-01e7-7ae0-2d69-1b26f3450d65@plexistor.com>
Date: Mon, 5 Aug 2019 22:16:45 +0300
MIME-Version: 1.0
In-Reply-To: <20190805184951.GC13994@redhat.com>
Content-Language: en-MW
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
To: Vivek Goyal <vgoyal@redhat.com>, Boaz Harrosh <boaz@plexistor.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, virtio-fs@redhat.com, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On 05/08/2019 21:49, Vivek Goyal wrote:
> On Mon, Aug 05, 2019 at 02:53:06PM +0300, Boaz Harrosh wrote:
<>
>> So as I understand the man page:
>> fallocate(FL_PUNCH_HOLE); means user is asking to get rid also of COW pages.
>> On the other way fallocate(FL_ZERO_RANGE) only the pmem portion is zeroed and COW (private pages) stays
> 
> I tested fallocate(FL_PUNCH_HOLE) on xfs (non-dax) and it does not seem to
> get rid of COW pages and my test case still can read the data it wrote
> in private pages.
> 

It seems you are right and I am wrong. This is what the Kernel code has to say about it:

	/*
	 * Unlike in truncate_pagecache, unmap_mapping_range is called only
	 * once (before truncating pagecache), and without "even_cows" flag:
	 * hole-punching should not remove private COWed pages from the hole.
	 */

For me this is confusing but that is what it is. So remove private COWed pages
is only done when we do an setattr(ATTR_SIZE).

>>
>> Just saying I have not followed the above code path
>> (We should have an xfstest for this?)
> 
> I don't know either. It indeed is interesting to figure out what's the
> expected behavior with fallocate() and truncate() for COW pages and cover
> that using xfstest (if not already done).
> 

I could not find any test for the COW positive FL_PUNCH_HOLE (I have that bug)
could be nice to make one, and let FSs like mine fail.
Any way very nice catch.

> 
> Thanks
> Vivek
> 

Thanks
Boaz
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
