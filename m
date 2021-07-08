Received: from ozlabs.org (bilbo.ozlabs.org [203.11.71.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD7272
	for <nvdimm@lists.linux.dev>; Thu,  8 Jul 2021 09:24:23 +0000 (UTC)
Received: by ozlabs.org (Postfix, from userid 1007)
	id 4GL9X775jHz9sX2; Thu,  8 Jul 2021 19:11:35 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=gibson.dropbear.id.au; s=201602; t=1625735496;
	bh=yqUKHfJL6cmSMFXUokqzI13g+wUoyr4KsWhtcvYLe4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T6pa0QhIk059/xv7FrBpKaHZ+sHuS2n6hTa7+s68Eii0DpvECXEkUr0///9jL8egF
	 61lCOrHQ9BEa2nI5Skijc5zeksYkkWLkwTOQ0WI59Se9yS5+7m96mcY0ldvXECyyOg
	 +XSUAFe/JYgzP8820C0xeqR1SttMRWR2u1yAPVqo=
Date: Thu, 8 Jul 2021 16:12:37 +1000
From: David Gibson <david@gibson.dropbear.id.au>
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>
Cc: groug@kaod.org, qemu-ppc@nongnu.org, qemu-devel@nongnu.org,
	aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
	kvm-ppc@vger.kernel.org, bharata@linux.vnet.ibm.com
Subject: Re: [PATCH REBASED v5 1/2] spapr: nvdimm: Implement H_SCM_FLUSH hcall
Message-ID: <YOaXVZqXb631GoGR@yekko>
References: <162571302321.1030381.15196355582642786915.stgit@lep8c.aus.stglabs.ibm.com>
 <162571303048.1030381.13893352223345979621.stgit@lep8c.aus.stglabs.ibm.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HJ/h8TT/zp4p/89v"
Content-Disposition: inline
In-Reply-To: <162571303048.1030381.13893352223345979621.stgit@lep8c.aus.stglabs.ibm.com>


--HJ/h8TT/zp4p/89v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 07, 2021 at 09:57:21PM -0500, Shivaprasad G Bhat wrote:
> The patch adds support for the SCM flush hcall for the nvdimm devices.
> To be available for exploitation by guest through the next patch.
>=20
> The hcall expects the semantics such that the flush to return
> with one of H_LONG_BUSY when the operation is expected to take longer
> time along with a continue_token. The hcall to be called again providing
> the continue_token to get the status. So, all fresh requests are put into
> a 'pending' list and flush worker is submitted to the thread pool. The
> thread pool completion callbacks move the requests to 'completed' list,
> which are cleaned up after reporting to guest in subsequent hcalls to
> get the status.
>=20
> The semantics makes it necessary to preserve the continue_tokens and
> their return status across migrations. So, the completed flush states
> are forwarded to the destination and the pending ones are restarted
> at the destination in post_load. The necessary nvdimm flush specific
> vmstate structures are added to the spapr machine vmstate.
>=20
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>  hw/ppc/spapr.c                |    6 +
>  hw/ppc/spapr_nvdimm.c         |  240 +++++++++++++++++++++++++++++++++++=
++++++
>  include/hw/ppc/spapr.h        |   11 ++
>  include/hw/ppc/spapr_nvdimm.h |   13 ++
>  4 files changed, 269 insertions(+), 1 deletion(-)
>=20
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index 4dd90b75cc..546d825dde 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -1622,6 +1622,8 @@ static void spapr_machine_reset(MachineState *machi=
ne)
>          spapr->ov5_cas =3D spapr_ovec_clone(spapr->ov5);
>      }
> =20
> +    spapr_nvdimm_finish_flushes(spapr);
> +
>      /* DRC reset may cause a device to be unplugged. This will cause tro=
ubles
>       * if this device is used by another device (eg, a running vhost bac=
kend
>       * will crash QEMU if the DIMM holding the vring goes away). To avoi=
d such
> @@ -2018,6 +2020,7 @@ static const VMStateDescription vmstate_spapr =3D {
>          &vmstate_spapr_cap_ccf_assist,
>          &vmstate_spapr_cap_fwnmi,
>          &vmstate_spapr_fwnmi,
> +        &vmstate_spapr_nvdimm_states,
>          NULL
>      }
>  };
> @@ -3014,6 +3017,9 @@ static void spapr_machine_init(MachineState *machin=
e)
>      }
> =20
>      qemu_cond_init(&spapr->fwnmi_machine_check_interlock_cond);
> +
> +    QLIST_INIT(&spapr->pending_flush_states);
> +    QLIST_INIT(&spapr->completed_flush_states);

These need nvdimm in the variable names.  There are any number of
things in the machine that could be the subject of some sort of flush.

>  }
> =20
>  #define DEFAULT_KVM_TYPE "auto"
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 91de1052f2..4f8931ab15 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -22,6 +22,7 @@
>   * THE SOFTWARE.
>   */
>  #include "qemu/osdep.h"
> +#include "qemu/cutils.h"
>  #include "qapi/error.h"
>  #include "hw/ppc/spapr_drc.h"
>  #include "hw/ppc/spapr_nvdimm.h"
> @@ -30,6 +31,7 @@
>  #include "hw/ppc/fdt.h"
>  #include "qemu/range.h"
>  #include "hw/ppc/spapr_numa.h"
> +#include "block/thread-pool.h"
> =20
>  /* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c =
*/
>  /* SCM device is unable to persist memory contents */
> @@ -375,6 +377,243 @@ static target_ulong h_scm_bind_mem(PowerPCCPU *cpu,=
 SpaprMachineState *spapr,
>      return H_SUCCESS;
>  }
> =20
> +static uint64_t flush_token;
> +
> +static int flush_worker_cb(void *opaque)
> +{
> +    int ret =3D H_SUCCESS;
> +    SpaprNVDIMMDeviceFlushState *state =3D opaque;
> +
> +    /* flush raw backing image */
> +    if (qemu_fdatasync(state->backend_fd) < 0) {
> +        error_report("papr_scm: Could not sync nvdimm to backend file: %=
s",
> +                     strerror(errno));
> +        ret =3D H_HARDWARE;
> +    }
> +
> +    return ret;
> +}
> +
> +static void spapr_nvdimm_flush_completion_cb(void *opaque, int hcall_ret)
> +{
> +    SpaprMachineState *spapr =3D SPAPR_MACHINE(qdev_get_machine());
> +    SpaprNVDIMMDeviceFlushState *state =3D opaque;
> +
> +    state->hcall_ret =3D hcall_ret;
> +    QLIST_REMOVE(state, node);
> +    QLIST_INSERT_HEAD(&spapr->completed_flush_states, state, node);
> +}
> +
> +static const VMStateDescription vmstate_spapr_nvdimm_flush_state =3D {
> +     .name =3D "spapr_nvdimm_flush_state",
> +     .version_id =3D 1,
> +     .minimum_version_id =3D 1,
> +     .fields =3D (VMStateField[]) {
> +         VMSTATE_UINT64(continue_token, SpaprNVDIMMDeviceFlushState),
> +         VMSTATE_INT64(hcall_ret, SpaprNVDIMMDeviceFlushState),
> +         VMSTATE_UINT32(drcidx, SpaprNVDIMMDeviceFlushState),
> +         VMSTATE_END_OF_LIST()
> +     },
> +};
> +
> +static bool spapr_nvdimm_states_needed(void *opaque)
> +{
> +     SpaprMachineState *spapr =3D (SpaprMachineState *)opaque;
> +
> +     return (!QLIST_EMPTY(&spapr->pending_flush_states) ||
> +             !QLIST_EMPTY(&spapr->completed_flush_states));
> +}
> +
> +static int spapr_nvdimm_post_load(void *opaque, int version_id)
> +{
> +    SpaprMachineState *spapr =3D (SpaprMachineState *)opaque;
> +    SpaprNVDIMMDeviceFlushState *state, *next;
> +    PCDIMMDevice *dimm;
> +    HostMemoryBackend *backend =3D NULL;
> +    ThreadPool *pool =3D aio_get_thread_pool(qemu_get_aio_context());
> +    SpaprDrc *drc;
> +
> +    QLIST_FOREACH_SAFE(state, &spapr->completed_flush_states, node, next=
) {
> +        if (flush_token < state->continue_token) {
> +            flush_token =3D state->continue_token;
> +        }
> +    }
> +
> +    QLIST_FOREACH_SAFE(state, &spapr->pending_flush_states, node, next) {
> +        if (flush_token < state->continue_token) {
> +            flush_token =3D state->continue_token;
> +        }
> +
> +        drc =3D spapr_drc_by_index(state->drcidx);
> +        dimm =3D PC_DIMM(drc->dev);
> +        backend =3D MEMORY_BACKEND(dimm->hostmem);
> +        state->backend_fd =3D memory_region_get_fd(&backend->mr);
> +
> +        thread_pool_submit_aio(pool, flush_worker_cb, state,
> +                               spapr_nvdimm_flush_completion_cb, state);
> +    }
> +
> +    return 0;
> +}
> +
> +const VMStateDescription vmstate_spapr_nvdimm_states =3D {
> +    .name =3D "spapr_nvdimm_states",
> +    .version_id =3D 1,
> +    .minimum_version_id =3D 1,
> +    .needed =3D spapr_nvdimm_states_needed,
> +    .post_load =3D spapr_nvdimm_post_load,
> +    .fields =3D (VMStateField[]) {
> +        VMSTATE_QLIST_V(completed_flush_states, SpaprMachineState, 1,
> +                        vmstate_spapr_nvdimm_flush_state,
> +                        SpaprNVDIMMDeviceFlushState, node),
> +        VMSTATE_QLIST_V(pending_flush_states, SpaprMachineState, 1,
> +                        vmstate_spapr_nvdimm_flush_state,
> +                        SpaprNVDIMMDeviceFlushState, node),
> +        VMSTATE_END_OF_LIST()
> +    },
> +};
> +
> +/*
> + * Assign a token and reserve it for the new flush state.
> + */
> +static SpaprNVDIMMDeviceFlushState *spapr_nvdimm_init_new_flush_state(
> +                                                      SpaprMachineState =
*spapr)
> +{
> +    SpaprNVDIMMDeviceFlushState *state;
> +
> +    state =3D g_malloc0(sizeof(*state));
> +
> +    flush_token++;
> +    /* Token zero is presumed as no job pending. Handle the overflow to =
zero */
> +    if (flush_token =3D=3D 0) {
> +        flush_token++;
> +    }
> +    state->continue_token =3D flush_token;
> +
> +    QLIST_INSERT_HEAD(&spapr->pending_flush_states, state, node);
> +
> +    return state;
> +}
> +
> +/*
> + * spapr_nvdimm_finish_flushes
> + *      Waits for all pending flush requests to complete
> + *      their execution and free the states
> + */
> +void spapr_nvdimm_finish_flushes(SpaprMachineState *spapr)
> +{
> +    SpaprNVDIMMDeviceFlushState *state, *next;
> +
> +    /*
> +     * Called on reset path, the main loop thread which calls
> +     * the pending BHs has gotten out running in the reset path,
> +     * finally reaching here. Other code path being guest
> +     * h_client_architecture_support, thats early boot up.
> +     */
> +    while (!QLIST_EMPTY(&spapr->pending_flush_states)) {
> +        aio_poll(qemu_get_aio_context(), true);
> +    }
> +
> +    QLIST_FOREACH_SAFE(state, &spapr->completed_flush_states, node, next=
) {
> +        QLIST_REMOVE(state, node);
> +        g_free(state);
> +    }
> +}
> +
> +/*
> + * spapr_nvdimm_get_flush_status
> + *      Fetches the status of the hcall worker and returns
> + *      H_LONG_BUSY_XYZ if the worker is still running.
> + */
> +static int spapr_nvdimm_get_flush_status(SpaprMachineState *spapr,
> +                                         uint64_t token)
> +{
> +    int ret =3D H_LONG_BUSY_ORDER_10_MSEC;
> +    SpaprNVDIMMDeviceFlushState *state, *node;
> +
> +    QLIST_FOREACH_SAFE(state, &spapr->pending_flush_states, node, node) {
> +        if (state->continue_token =3D=3D token) {
> +            goto exit;

There's no need for an ugly goto here.  Just return.

> +        }
> +    }
> +    ret =3D H_P2; /* If not found in complete list too, invalid token */
> +    QLIST_FOREACH_SAFE(state, &spapr->completed_flush_states, node, node=
) {
> +        if (state->continue_token =3D=3D token) {
> +            ret =3D state->hcall_ret;
> +            QLIST_REMOVE(state, node);
> +            g_free(state);

Likewise you can return here.

> +            break;
> +        }
> +    }
> +exit:
> +    return ret;

And here, and you won't need the 'ret' variable any more.

> +}
> +
> +/*
> + * H_SCM_FLUSH
> + * Input: drc_index, continue-token
> + * Out: continue-token
> + * Return Value: H_SUCCESS, H_Parameter, H_P2, H_LONG_BUSY
> + *
> + * Given a DRC Index Flush the data to backend NVDIMM device.
> + * The hcall returns H_LONG_BUSY_XX when the flush takes longer time and
> + * the hcall needs to be issued multiple times in order to be completely
> + * serviced. The continue-token from the output to be passed in the
> + * argument list of subsequent hcalls until the hcall is completely serv=
iced
> + * at which point H_SUCCESS or other error is returned.
> + */
> +static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spap=
r,
> +                                target_ulong opcode, target_ulong *args)
> +{
> +    int ret;
> +    uint32_t drc_index =3D args[0];
> +    uint64_t continue_token =3D args[1];
> +    SpaprDrc *drc =3D spapr_drc_by_index(drc_index);
> +    PCDIMMDevice *dimm;
> +    HostMemoryBackend *backend =3D NULL;
> +    SpaprNVDIMMDeviceFlushState *state;
> +    ThreadPool *pool =3D aio_get_thread_pool(qemu_get_aio_context());
> +    int fd;
> +
> +    if (!drc || !drc->dev ||
> +        spapr_drc_type(drc) !=3D SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> +        return H_PARAMETER;
> +    }
> +
> +    if (continue_token !=3D 0) {
> +        goto get_status;

Again, not really an idiomatically justified use of goto.  Just put
the body in an if block - it's pretty simple so that's not excessively
indented.

> +    }
> +
> +    dimm =3D PC_DIMM(drc->dev);
> +    backend =3D MEMORY_BACKEND(dimm->hostmem);
> +    fd =3D memory_region_get_fd(&backend->mr);
> +
> +    if (fd < 0) {
> +        return H_UNSUPPORTED;
> +    }
> +
> +    state =3D spapr_nvdimm_init_new_flush_state(spapr);
> +    if (!state) {
> +        return H_HARDWARE;
> +    }
> +
> +    state->drcidx =3D drc_index;
> +    state->backend_fd =3D fd;
> +
> +    thread_pool_submit_aio(pool, flush_worker_cb, state,
> +                           spapr_nvdimm_flush_completion_cb, state);
> +
> +    continue_token =3D state->continue_token;
> +
> +get_status:
> +    ret =3D spapr_nvdimm_get_flush_status(spapr, continue_token);
> +    if (H_IS_LONG_BUSY(ret)) {
> +        args[0] =3D continue_token;
> +    }
> +
> +    return ret;
> +}
> +
>  static target_ulong h_scm_unbind_mem(PowerPCCPU *cpu, SpaprMachineState =
*spapr,
>                                       target_ulong opcode, target_ulong *=
args)
>  {
> @@ -523,6 +762,7 @@ static void spapr_scm_register_types(void)
>      spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>      spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>      spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> +    spapr_register_hypercall(H_SCM_FLUSH, h_scm_flush);
>  }
> =20
>  type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index f05219f75e..1684d72546 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -12,10 +12,12 @@
>  #include "hw/ppc/spapr_xive.h"  /* For SpaprXive */
>  #include "hw/ppc/xics.h"        /* For ICSState */
>  #include "hw/ppc/spapr_tpm_proxy.h"
> +#include "hw/ppc/spapr_nvdimm.h"
> =20
>  struct SpaprVioBus;
>  struct SpaprPhbState;
>  struct SpaprNvram;
> +struct SpaprNVDIMMDeviceFlushState;
> =20
>  typedef struct SpaprEventLogEntry SpaprEventLogEntry;
>  typedef struct SpaprEventSource SpaprEventSource;
> @@ -248,6 +250,11 @@ struct SpaprMachineState {
>      uint32_t numa_assoc_array[MAX_NODES + NVGPU_MAX_NUM][NUMA_ASSOC_SIZE=
];
> =20
>      Error *fwnmi_migration_blocker;
> +
> +    /* nvdimm flush states */
> +    QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) pending_flush_states;
> +    QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) completed_flush_states;
> +
>  };
> =20
>  #define H_SUCCESS         0
> @@ -328,6 +335,7 @@ struct SpaprMachineState {
>  #define H_P7              -60
>  #define H_P8              -61
>  #define H_P9              -62
> +#define H_UNSUPPORTED     -67
>  #define H_OVERLAP         -68
>  #define H_UNSUPPORTED_FLAG -256
>  #define H_MULTI_THREADS_ACTIVE -9005
> @@ -542,8 +550,9 @@ struct SpaprMachineState {
>  #define H_SCM_UNBIND_MEM        0x3F0
>  #define H_SCM_UNBIND_ALL        0x3FC
>  #define H_SCM_HEALTH            0x400
> +#define H_SCM_FLUSH             0x44C
> =20
> -#define MAX_HCALL_OPCODE        H_SCM_HEALTH
> +#define MAX_HCALL_OPCODE        H_SCM_FLUSH
> =20
>  /* The hcalls above are standardized in PAPR and implemented by pHyp
>   * as well.
> diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
> index 764f999f54..24d8e37b33 100644
> --- a/include/hw/ppc/spapr_nvdimm.h
> +++ b/include/hw/ppc/spapr_nvdimm.h
> @@ -11,6 +11,7 @@
>  #define HW_SPAPR_NVDIMM_H
> =20
>  #include "hw/mem/nvdimm.h"
> +#include "migration/vmstate.h"
> =20
>  typedef struct SpaprDrc SpaprDrc;
>  typedef struct SpaprMachineState SpaprMachineState;
> @@ -21,5 +22,17 @@ void spapr_dt_persistent_memory(SpaprMachineState *spa=
pr, void *fdt);
>  bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nv=
dimm,
>                             uint64_t size, Error **errp);
>  void spapr_add_nvdimm(DeviceState *dev, uint64_t slot);
> +void spapr_nvdimm_finish_flushes(SpaprMachineState *spapr);
> +
> +typedef struct SpaprNVDIMMDeviceFlushState {
> +    uint64_t continue_token;
> +    int64_t hcall_ret;
> +    int backend_fd;
> +    uint32_t drcidx;
> +
> +    QLIST_ENTRY(SpaprNVDIMMDeviceFlushState) node;
> +} SpaprNVDIMMDeviceFlushState;
> +
> +extern const VMStateDescription vmstate_spapr_nvdimm_states;
> =20
>  #endif
>=20
>=20

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--HJ/h8TT/zp4p/89v
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEdfRlhq5hpmzETofcbDjKyiDZs5IFAmDml1IACgkQbDjKyiDZ
s5Ji3Q//fx2Ptvjumxh3wo6Vz9N7y2xEi6di8mSwQNbRQMnAoAX4uydCPDEj2l7R
DEGa6/lu46k0Zyv8Wp0GQGarzSqQu+p0McFRwyiVaL/9P3baTPejMHerhrYDW1eB
aZ/fVLJiITv8R0vYcSnYIr70pKEyiw347k9qcZMmqY/xyln99FCyd8OfpYyHBLt/
vf+99J4Yfez1XxDuNbgDsszDElKd8HoxT+pWFtGWr8W4wcDIigIo85BUa+rnByux
0i4Iuj0Vk6DMwZ1f4T14AaX7noBYtbBD9bBAD0BxXD/dfAg4xpiKI7bUWfQZ0jC0
ZPhKddhHufLhVTyewVIpC7atHrEEak5kjXtjJyku4u7XD9NgBpDtFNYYqKbr/hMz
5yu1dh5ixTERPRSSSO5FQ4CmN+NJukD2ZVKLQpXY9w6bJFLPsmGXRVXlJxu61i3m
RJ27ZznRp8odL+XhZKw0H5bYZzcdV6rbtZ6+7Txt7bZrGTyIkraFHPBf1S2+IahF
UE7o90p4MSuNdnac5j2pGZej2TeBOG2OdLLrSRttHiQ8yFHJS965nOdty67o2aZ0
TZqlQCTPNe9ixvC9j2i1j3YVuuGe7uNJQjdSdc0Wwo9IWo2vYoDc7XDQ71KIBMgP
/+Rf8YqZwoDTVDsMjnZuxD4ihZfwRBeT15S7CnM6dRJai2iPNYg=
=+q2B
-----END PGP SIGNATURE-----

--HJ/h8TT/zp4p/89v--
