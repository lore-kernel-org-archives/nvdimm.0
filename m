Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x233.google.com (mail-ob0-x233.google.com
 [IPv6:2607:f8b0:4003:c01::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E6E261A1EC4
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 15:36:00 -0800 (PST)
Received: by mail-ob0-x233.google.com with SMTP id m7so63550160obh.3
 for <linux-nvdimm@lists.01.org>; Wed, 09 Mar 2016 15:35:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160309215702.20904.61407.stgit@noble>
References: <20160309215702.20904.61407.stgit@noble>
Date: Wed, 9 Mar 2016 15:35:45 -0800
Message-ID: <CAPcyv4gcOdBmzhMoyEErwh9Q7sXmWprdYy=W-iSSj+JwT=n6YA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Remove un-needed 'major' registration when
 alloc_disk(0) is used.
From: Dan Williams <dan.j.williams@intel.com>
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
To: NeilBrown <neilb@suse.com>
Cc: Jens Axboe <axboe@fb.com>, Maxim Levitsky <maximlevitsky@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, Keith Busch <keith.busch@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 9, 2016 at 1:59 PM, NeilBrown <neilb@suse.com> wrote:
> When alloc_disk(0) is used, the ->major number is ignored and
> irrelevant.  Yet several drivers register a major number anyway.
>
> This series of patches removes the pointless registrations.  The pmem
> driver also does this, but a patch has already been sent for that
> driver.
>
> Note that I am not in a position to test these beyond simple compile
> testing.
>
> Thanks,
> NeilBrown
>
>
> ---
>
> NeilBrown (4):
>       nvdimm/blk: don't allocate unused major device number
>       nvdimm/btt: don't allocate unused major device number

The libnvdimm unit tests were fine with these, applied.

Btw, because you mentioned it, our unit test infrastructure does not
require real hardware.  See the ndctl readme [1], and if you have
copious amounts of free time the lwn write up on how we're mocking
resources [2].

[1]: https://github.com/pmem/ndctl/blob/master/README.md
[2]: https://lwn.net/Articles/654071/
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
