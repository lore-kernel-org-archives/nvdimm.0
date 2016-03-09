Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22b.google.com (mail-oi0-x22b.google.com
 [IPv6:2607:f8b0:4003:c06::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 49B851A1F4C
 for <linux-nvdimm@lists.01.org>; Wed,  9 Mar 2016 11:25:02 -0800 (PST)
Received: by mail-oi0-x22b.google.com with SMTP id c203so43556256oia.2
 for <linux-nvdimm@lists.01.org>; Wed, 09 Mar 2016 11:24:48 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87k2lclif1.fsf@notabene.neil.brown.name>
References: <87k2lclif1.fsf@notabene.neil.brown.name>
Date: Wed, 9 Mar 2016 11:24:47 -0800
Message-ID: <CAPcyv4jRR-27wFYjQepwbug-csUmqbaSaPEu0PvMCthhaZNMnA@mail.gmail.com>
Subject: Re: [PATCH] pmem: don't allocate unused major device number
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 8, 2016 at 2:21 PM, NeilBrown <neilb@suse.com> wrote:
>
> When alloc_disk(0) or alloc_disk-node(0, XX) is used, the ->major
> number is completely ignored:  all devices are allocated with a
> major of BLOCK_EXT_MAJOR.
>
> So there is no point allocating pmem_major.
>
> Signed-off-by: NeilBrown <neilb@suse.com>
> ---
>  drivers/nvdimm/pmem.c | 19 +------------------
>  1 file changed, 1 insertion(+), 18 deletions(-)
>
> Hi Dan et al,
>  I was recently educating myself about the behavior of alloc_disk(0).
>  As I understand it, the ->major is ignored and all device numbers for all
>  partitions (including '0') are allocated on demand with major number of
>  BLOCK_EXT_MAJOR.
>
>  So I was a little surprised to find that pmem.c allocated a major
>  number which is never used - historical anomaly I suspect.
>  I was a bit more surprised at the comment in:
>
>   Commit: 9f53f9fa4ad1 ("libnvdimm, pmem: add libnvdimm support to the pmem driver")
>
>  "The minor numbers are also more predictable by passing 0 to alloc_disk()."
>
>  How can they possibly be more predictable given that they are allocated
>  on-demand?  Maybe discovery order is very predictable???
>
>  In any case, I propose this patch but cannot test it (beyond compiling)
>  as I don't have relevant hardware.  And maybe some user-space code greps
>  /proc/devices for "pmem" to determine if "pmem" is compiled in (though
>  I sincerely hope not).
>  So I cannot be certain that this patch won't break anything, but am
>  hoping that if you like it you might test it.
>
>  If it does prove acceptable, then similar changes would be appropriate
>  for btt.c and blk.c.   And drivers/memstick/core/ms_block.c and
>  drivers/nvme/host/core.c. (gotta stamp out this cargo cult)

This is passing my tests.  Are you going to send these follow-ups as well?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
