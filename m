Received: from ozlabs.org (ozlabs.org [203.11.71.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C059972
	for <nvdimm@lists.linux.dev>; Tue, 21 Sep 2021 06:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=gibson.dropbear.id.au; s=201602; t=1632206039;
	bh=NsRLljEEFUoh5BRCbSG2i/cbqOMfUnrjSang9GEHcHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SpNrXtRg2X+sO75CSH6WbOmrRUO/Evpz+2KbWhqNq1SrAmsSD0Z5N/zZqk+lrGN1p
	 nWdhxQqB+06gK732Op22r8jr5qYLcN0+YLdnZ+NjDvjm4Gs75YlamoiiP2KQRmV/69
	 l7lGcxiB/XnDqijerD9fYkt+lvgVmpQnLhhjuUvQ=
Received: by ozlabs.org (Postfix, from userid 1007)
	id 4HDBTg37yGz9t0p; Tue, 21 Sep 2021 16:33:59 +1000 (AEST)
Date: Tue, 21 Sep 2021 16:32:27 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: groug@kaod.org, qemu-ppc@nongnu.org, qemu-devel@nongnu.org,
	aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
	kvm-ppc@vger.kernel.org, bharata@linux.vnet.ibm.com
Subject: Re: [PATCH REBASED v5 2/2] spapr: nvdimm: Introduce spapr-nvdimm
 device
Message-ID: <YUl8e5NLb1Jnn5W6@yekko>
References: <162571302321.1030381.15196355582642786915.stgit@lep8c.aus.stglabs.ibm.com>
 <162571304881.1030381.2406869533148471546.stgit@lep8c.aus.stglabs.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="R6vzE2RZledxjS/Z"
Content-Disposition: inline
In-Reply-To: <162571304881.1030381.2406869533148471546.stgit@lep8c.aus.stglabs.ibm.com>


--R6vzE2RZledxjS/Z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 07, 2021 at 09:57:31PM -0500, Shivaprasad G Bhat wrote:
> If the device backend is not persistent memory for the nvdimm, there is
> need for explicit IO flushes on the backend to ensure persistence.
>=20
> On SPAPR, the issue is addressed by adding a new hcall to request for
> an explicit flush from the guest when the backend is not pmem. So, the
> approach here is to convey when the hcall flush is required in a device
> tree property. The guest once it knows the device backend is not pmem,
> makes the hcall whenever flush is required.
>=20
> To set the device tree property, the patch introduces a new papr specific
> device type inheriting the nvdimm device. When the backend doesn't have
> pmem=3D"yes", the device tree property "ibm,hcall-flush-required" is set,
> and the guest makes hcall H_SCM_FLUSH requesting for an explicit flush.
>=20
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  hw/ppc/spapr_nvdimm.c         |   46 +++++++++++++++++++++++++++++++++++=
++++++
>  include/hw/ppc/spapr_nvdimm.h |    4 ++++
>  2 files changed, 50 insertions(+)
>=20
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 4f8931ab15..4dc7c3f147 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -54,6 +54,8 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev,=
 NVDIMMDevice *nvdimm,
>  {
>      const MachineClass *mc =3D MACHINE_GET_CLASS(hotplug_dev);
>      const MachineState *ms =3D MACHINE(hotplug_dev);
> +    PCDIMMDevice *dimm =3D PC_DIMM(nvdimm);
> +    MemoryRegion *mr =3D host_memory_backend_get_memory(dimm->hostmem);
>      g_autofree char *uuidstr =3D NULL;
>      QemuUUID uuid;
>      int ret;
> @@ -91,6 +93,14 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev=
, NVDIMMDevice *nvdimm,
>          return false;
>      }
> =20
> +    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM) &&
> +        (memory_region_get_fd(mr) < 0)) {
> +        error_setg(errp, "spapr-nvdimm device requires the "
> +                   "memdev %s to be of memory-backend-file type",
> +                   object_get_canonical_path_component(OBJECT(dimm->host=
mem)));

It's not obvious to me why the spapr nvdimm device has an additional
restriction here over the regular nvdimm device.

> +        return false;
> +    }
> +
>      return true;
>  }
> =20
> @@ -162,6 +172,21 @@ static int spapr_dt_nvdimm(SpaprMachineState *spapr,=
 void *fdt,
>                               "operating-system")));
>      _FDT(fdt_setprop(fdt, child_offset, "ibm,cache-flush-required", NULL=
, 0));
> =20
> +    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM)) {
> +        bool is_pmem =3D false;
> +#ifdef CONFIG_LIBPMEM
> +        PCDIMMDevice *dimm =3D PC_DIMM(nvdimm);
> +        HostMemoryBackend *hostmem =3D dimm->hostmem;
> +
> +        is_pmem =3D object_property_get_bool(OBJECT(hostmem), "pmem",
> +                                           &error_abort);

Presenting to the guest a property of the backend worries me
slightly.  How the backends are synchronized between the source and
destination is out of scope for qemu: is there any possibility that we
could migrate from a host where the backend is pmem to one where it is
not (or the reverse).

I think at the least we want a property on the spapr-nvdimm object
which will override what's presented to the guest (which, yes, might
mean lying to the guest).  I think that could be important for
testing, if nothing else.

> +#endif
> +        if (!is_pmem) {
> +            _FDT(fdt_setprop(fdt, child_offset, "ibm,hcall-flush-require=
d",
> +                             NULL, 0));
> +        }
> +    }
> +
>      return child_offset;
>  }
> =20
> @@ -585,7 +610,16 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, Spa=
prMachineState *spapr,
>      }
> =20
>      dimm =3D PC_DIMM(drc->dev);
> +    if (!object_dynamic_cast(OBJECT(dimm), TYPE_SPAPR_NVDIMM)) {
> +        return H_PARAMETER;
> +    }

Hmm.  If you're going to make flushes specific to spapr nvdimms, you
could put the queue of pending flushes into the spapr-nvdimm object,
rather than having a global list in the machine.

> +
>      backend =3D MEMORY_BACKEND(dimm->hostmem);
> +#ifdef CONFIG_LIBPMEM
> +    if (object_property_get_bool(OBJECT(backend), "pmem", &error_abort))=
 {
> +        return H_UNSUPPORTED;

Could you make this not be UNSUPPORTED, but instead fake the flush for
the pmem device?  Either as a no-op, or simulating the guest invoking
the right cpu cache flushes?  That seems like it would be more useful:
that way users who don't care too much about performance could just
always do a flush hcall and not have to have another path for the
"real" pmem case.

> +    }
> +#endif
>      fd =3D memory_region_get_fd(&backend->mr);
> =20
>      if (fd < 0) {
> @@ -766,3 +800,15 @@ static void spapr_scm_register_types(void)
>  }
> =20
>  type_init(spapr_scm_register_types)
> +
> +static TypeInfo spapr_nvdimm_info =3D {
> +    .name          =3D TYPE_SPAPR_NVDIMM,
> +    .parent        =3D TYPE_NVDIMM,
> +};
> +
> +static void spapr_nvdimm_register_types(void)
> +{
> +    type_register_static(&spapr_nvdimm_info);
> +}
> +
> +type_init(spapr_nvdimm_register_types)
> diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
> index 24d8e37b33..fb4e56418e 100644
> --- a/include/hw/ppc/spapr_nvdimm.h
> +++ b/include/hw/ppc/spapr_nvdimm.h
> @@ -13,6 +13,10 @@
>  #include "hw/mem/nvdimm.h"
>  #include "migration/vmstate.h"
> =20
> +#define TYPE_SPAPR_NVDIMM "spapr-nvdimm"
> +OBJECT_DECLARE_SIMPLE_TYPE(SpaprNVDIMMDevice, SPAPR_NVDIMM)
> +
> +typedef struct SpaprNVDIMMDevice  SpaprNVDIMMDevice;
>  typedef struct SpaprDrc SpaprDrc;
>  typedef struct SpaprMachineState SpaprMachineState;
> =20
>=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--R6vzE2RZledxjS/Z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmFJfHsACgkQbDjKyiDZ
s5LpVRAAh46RIJyui8X4bCzAlHqrpp1IIm7YtbPsywngD9UZgkJfhBzqLnUC9GoM
bqOslsGRKNyVUtwc5pBjkoZkDHrc8ZVDAlwrn+4jl0LBD9oAnSfMjukeRxf9lJ4Y
s6mGd7SnPqy0EgezCCH6hj4YmcyMvqstCApkUWqglmoULr1hpLw3pkmP/bYHysOy
FArrhU8o3LU03JBlhfH/RqHu4WFLKPxsLM9KONCHHNjYzlpZP/Y/iE70viWpiWiQ
AXAvb6FUrCNEk3YFechA7SJJPXPkgK/T3Up7SHogIJQ5Ws9v1knyUhOWj2AE7H4B
s2+OVuh3JuEfeQSy2l0n05zGcLUnZYI56t1xiy4u8WUFbcySntXM9TrsvV1QLcFg
YWzzxK1ZQXRKQWU4dIwQc/jJD8sRt8+el0/szQ2quib2Vyyfg0FGNkNbR2ZAHwEd
bSKihW53wAvVnToLnYpm+6TE4a4X6nPx+wiNkkTtbYiKYKfI1FZ/aD0Yyvdb7cSf
KLa2SmJdFx0fBT+1Q9u3dqYr9krjvm+1rm8+7IIQ+QZAzHJkvvnQR1oJpRjsWUvU
J8x1m9WjrfTKhrle9pkAu4KOoZLCDlMttquU3ySASub4NMxWSRlFxUCVzFXv0DAU
817HZn67ZeM8hrp/OkDBikz6AlCxSlBMNHnLzMfbTFMgxAI+Azg=
=Crkm
-----END PGP SIGNATURE-----

--R6vzE2RZledxjS/Z--
