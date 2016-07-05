Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 37A611A1E18
 for <linux-nvdimm@lists.01.org>; Tue,  5 Jul 2016 02:02:58 -0700 (PDT)
Date: Tue, 5 Jul 2016 11:02:15 +0200
From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] libnvdimm: initialize struct blk_integrity with 0
Message-ID: <20160705090215.k7xlvjjx4uvfit2m@c203.arch.suse.de>
References: <20160623095204.32167-1-jthumshirn@suse.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160623095204.32167-1-jthumshirn@suse.de>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jun 23, 2016 at 11:52:04AM +0200, Johannes Thumshirn wrote:
> Initialize struct blk_integrity with 0 as blk_integrity_register() takes =
the
> then unitialized struct blk_integrity::flags and ORs it to the resulting =
block
> integrity structure.
> =

> Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
> ---
>  drivers/nvdimm/core.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> =

> diff --git a/drivers/nvdimm/core.c b/drivers/nvdimm/core.c
> index be89764..32e4fe2 100644
> --- a/drivers/nvdimm/core.c
> +++ b/drivers/nvdimm/core.c
> @@ -601,7 +601,8 @@ int nd_integrity_init(struct gendisk *disk, unsigned =
long meta_size)
>  	if (meta_size =3D=3D 0)
>  		return 0;
>  =

> -	bi.profile =3D NULL;
> +	memset(&bi, 0, sizeof(bi));
> +
>  	bi.tuple_size =3D meta_size;
>  	bi.tag_size =3D meta_size;
>  =

> -- =

> 2.8.4
> =


Dan,

have you seen this one? I've found it in patchwork but didn't get a mail on
the list either.

Thanks,
	Johannes

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
