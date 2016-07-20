Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 279811A1E31
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jul 2016 06:11:34 -0700 (PDT)
Date: Wed, 20 Jul 2016 15:10:38 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] radix-tree: fix comment about "exceptional" bits
Message-ID: <20160720131038.w5ouqmyd3kvrfc2s@c203.arch.suse.de>
References: <1468997731-2155-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1468997731-2155-1-git-send-email-ross.zwisler@linux.intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <koct9i@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 20, 2016 at 12:55:31AM -0600, Ross Zwisler wrote:
> The bottom two bits of radix tree entries are reserved for special use by
> the radix tree code itself.  A comment detailing their usage was added by:
> =

> commit 3bcadd6fa6c4 ("radix-tree: free up the bottom bit of exceptional
> entries for reuse")
> =

> This comment states that if the bottom two bits are '11', this means that
> this is a locked exceptional entry.
> =

> It turns out that this bit combination was never actually used.  Radix tr=
ee
> locking for DAX was indeed implemented, but it actually used the third LS=
B:
> =

>   /* We use lowest available exceptional entry bit for locking */
>   #define RADIX_DAX_ENTRY_LOCK (1 << RADIX_TREE_EXCEPTIONAL_SHIFT)
> =

> This locking code was also made specific to the DAX code instead of being
> generally implemented in radix-tree.h.
> =

> So, fix the comment.
> =

> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

-- =

Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton
HRB 21284 (AG N=FCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
