Received: from ozlabs.org (bilbo.ozlabs.org [203.11.71.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C1C2F80
	for <nvdimm@lists.linux.dev>; Mon, 24 May 2021 04:55:08 +0000 (UTC)
Received: by ozlabs.org (Postfix, from userid 1007)
	id 4FpPrP3lfSz9sPf; Mon, 24 May 2021 14:49:25 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=gibson.dropbear.id.au; s=201602; t=1621831765;
	bh=TYSEoVvepypGulY3hx66YvaoKLjvj6EpNj205Et0BrE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C5BBSvbKkjdjKcjNCzkLOgwE2O14skIo1hPWsGpJBIGTAm1udS2qHyuXcd+ODNs2X
	 rH9O2z0xwiv5cAjsnAGHlGg3b/dIytfNdghlqvAUjzrvzORztGcQI5H/QcKVbCPXke
	 Jx5QPHmzGqImbqvsrCcYt7pEdx5IJ+Lbh5D78Kbc=
Date: Mon, 24 May 2021 14:45:23 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: groug@kaod.org, qemu-ppc@nongnu.org, qemu-devel@nongnu.org,
	aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
	kvm-ppc@vger.kernel.org, shivaprasadbhat@gmail.com,
	bharata@linux.vnet.ibm.com
Subject: Re: [PATCH v5 1/3] spapr: nvdimm: Forward declare and move the
 definitions
Message-ID: <YKsvY5h837sbO3UB@yekko>
References: <162133924680.610.15121309741756314238.stgit@4f1e6f2bd33e>
 <162133925415.610.11584121797866216417.stgit@4f1e6f2bd33e>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="FRUbPektJYbiNupX"
Content-Disposition: inline
In-Reply-To: <162133925415.610.11584121797866216417.stgit@4f1e6f2bd33e>


--FRUbPektJYbiNupX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 18, 2021 at 08:03:17AM -0400, Shivaprasad G Bhat wrote:
> The subsequent patches add definitions which tend to get
> the compilation to cyclic dependency. So, prepare with
> forward declarations, move the definitions and clean up.
>=20
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>

This is a reasonable cleanup regardless of the rest of the series, so
I've applied this to ppc-for-6.1.

> ---
>  hw/ppc/spapr_nvdimm.c         |   12 ++++++++++++
>  include/hw/ppc/spapr_nvdimm.h |   14 ++------------
>  2 files changed, 14 insertions(+), 12 deletions(-)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 252204e25f..3f57a8b6fa 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -35,6 +35,18 @@
>  /* SCM device is unable to persist memory contents */
>  #define PAPR_PMEM_UNARMED PPC_BIT(0)
> =20
> +/*
> + * The nvdimm size should be aligned to SCM block size.
> + * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
> + * in order to have SCM regions not to overlap with dimm memory regions.
> + * The SCM devices can have variable block sizes. For now, fixing the
> + * block size to the minimum value.
> + */
> +#define SPAPR_MINIMUM_SCM_BLOCK_SIZE SPAPR_MEMORY_BLOCK_SIZE
> +
> +/* Have an explicit check for alignment */
> +QEMU_BUILD_BUG_ON(SPAPR_MINIMUM_SCM_BLOCK_SIZE % SPAPR_MEMORY_BLOCK_SIZE=
);
> +
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp)
>  {
> diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
> index 73be250e2a..764f999f54 100644
> --- a/include/hw/ppc/spapr_nvdimm.h
> +++ b/include/hw/ppc/spapr_nvdimm.h
> @@ -11,19 +11,9 @@
>  #define HW_SPAPR_NVDIMM_H
> =20
>  #include "hw/mem/nvdimm.h"
> -#include "hw/ppc/spapr.h"
> =20
> -/*
> - * The nvdimm size should be aligned to SCM block size.
> - * The SCM block size should be aligned to SPAPR_MEMORY_BLOCK_SIZE
> - * inorder to have SCM regions not to overlap with dimm memory regions.
> - * The SCM devices can have variable block sizes. For now, fixing the
> - * block size to the minimum value.
> - */
> -#define SPAPR_MINIMUM_SCM_BLOCK_SIZE SPAPR_MEMORY_BLOCK_SIZE
> -
> -/* Have an explicit check for alignment */
> -QEMU_BUILD_BUG_ON(SPAPR_MINIMUM_SCM_BLOCK_SIZE % SPAPR_MEMORY_BLOCK_SIZE=
);
> +typedef struct SpaprDrc SpaprDrc;
> +typedef struct SpaprMachineState SpaprMachineState;
> =20
>  int spapr_pmem_dt_populate(SpaprDrc *drc, SpaprMachineState *spapr,
>                             void *fdt, int *fdt_start_offset, Error **err=
p);
>=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--FRUbPektJYbiNupX
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmCrL2MACgkQbDjKyiDZ
s5J9Rw//V1W1q5wDmubYAkWlySjaEe2fY+4Fzxr0Ic+qh4oJP1Y3JZCIw7sKCZoC
lcIHfI/hBVHp/xBMo2oa5RmL6CJa8iAf5toE/HDNsOAInKmGbhJ3OTR71HFLj0wh
EK9MlbsIxLhIL73/XIzsAYd+C1wz8tp0/UGstvHMk7VJMoPAIkDhHki+WOt1gonK
ZySnrL4orrr5cDUVKiDHYc/PClQl3KLp0Foog6G2/fD2dn+lElIVM1uEbgxPJf2V
TgCoaNX+CNIkMaJzYbe4bQ5toidOrBrfh5fPLhT/DMD295EIzLk38nns7j8h2Wn1
4i4MF8Dj+2+fjuHd0TJvuq98m6HwJE3H2SngIBvQkCmA/imla9GfjNTxQFKsOjXZ
JtVkVIQlCXJOaWCbVKE47msphsYZ6p0YH000bmBUkq8ADeqB6FpbwLP9W5+pjTuq
SNQ0MLLX01ZrpcsFCpAbKpVU6It2p9MC4mfZjNTQU30/RGljtBL8rUNxkBsQYYTa
CD6I0LL5f8yNlIoTqyVFzwKA31QmRh+YSDvwsHvZ5f5Dhxh0DMrfmBVVE+jZH8nr
RcqNGGGuoJVZ0z+lzfyV4xKWkSzLDpCpXlBZ0BO2BlUHr3mFAJd9momQU5JzgYVj
8EES1xs3FbzTvR/YjeLlNvjFUi0WIZnew829KC/RzTdgoyk5ic0=
=Ptw/
-----END PGP SIGNATURE-----

--FRUbPektJYbiNupX--
