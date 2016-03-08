Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ob0-x234.google.com (mail-ob0-x234.google.com
 [IPv6:2607:f8b0:4003:c01::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A6A481A1E8E
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 14:30:12 -0800 (PST)
Received: by mail-ob0-x234.google.com with SMTP id m7so28740528obh.3
 for <linux-nvdimm@lists.01.org>; Tue, 08 Mar 2016 14:29:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87k2lclif1.fsf@notabene.neil.brown.name>
References: <87k2lclif1.fsf@notabene.neil.brown.name>
Date: Tue, 8 Mar 2016 14:29:58 -0800
Message-ID: <CAPcyv4guybB1QRqqjjvWsjKvpJjnc=qf81iT-E77-GonAApKCw@mail.gmail.com>
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

Ross, I remember you looked into this when Boaz pointed out something similar.

>  In any case, I propose this patch but cannot test it (beyond compiling)
>  as I don't have relevant hardware.  And maybe some user-space code greps
>  /proc/devices for "pmem" to determine if "pmem" is compiled in (though
>  I sincerely hope not).
>  So I cannot be certain that this patch won't break anything, but am
>  hoping that if you like it you might test it.

Will do.

Thanks Neil!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
