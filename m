Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359C62F23
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 18:51:27 +0000 (UTC)
Received: by mail-ot1-f53.google.com with SMTP id b17-20020a9d4791000000b005a17fc2dfc1so338337otf.1
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 10:51:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hahoYMxVE3N3IFtwnMrwWdqvMnsVms4nJCcITNrjTdA=;
        b=Jthx97Dionq5URYbz7ik97kyuwIPTMxrNBR4c9Ob47KXryC0VhCkMXKtY6wUCJemIT
         EibtdzpZkxeadZR5tzSAKjBl1UDzWOtTJW8z1pcywZ9VOJ8fbFFU38AGlLhmOVbn8Lyw
         /gwvfk9m2yGpLMxiy+qXzokJ9ZrbbMoKHCtrBK+kTb2XWMORqJ9PuEMtc5DY1bvRGaCg
         I0QYXvn+f4gjufN27inCgI2BK1oZlOcqAMJXo0/P/E8iFs0vjomuBq1AM/TPZGJX5/lv
         RXjSKFmyCyWUsm00cMOFNb7BU60Pk2VlRU4bQm3NeDH8+83PsvnDJvYh54EtwEERQYa2
         VwfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hahoYMxVE3N3IFtwnMrwWdqvMnsVms4nJCcITNrjTdA=;
        b=hOgP05JhTDbzwnZUuk1KVS25q1ywJ8y3pwkpNt0NC6UPexiY9UgA2t/I9d6E9EecbI
         QigvssGjOlH8KdDNalpdGeuKdcbIJ1K4XFvpJifGlfrDVXyzFcXnwLPzc+kkRldu/Kbh
         wuH+eqwr6r2QWjjqeT3AbhmweMpcX1U/5ZUZwH9EDtI3g9/ptLUoahJgejNr+AcXdRvV
         zg2Gpt22DaB+2TpaCYo3UV+CwUHtbbIv5W1CXtjwrhs8DHWyfEZ4YVJv4ZXvyZcumOrU
         fyy+1Ho93r3SJwyum6bqNDIMIpx0uQ2qkmS1qVIc0XHTQ3V4xoTjlc2CaIdWeY1UTMyF
         AFBg==
X-Gm-Message-State: AOAM530RYGmR1TslDt3iAxMF04dAEaSu4Dc06tUbIuOFqShZTMnbUXbb
	5f6D5UhUIK9f8rkyYaOqq88=
X-Google-Smtp-Source: ABdhPJxmK74riMMAFdqhh/OlbQXC/yu1B84Zi+SSi8XGbTFcrWl9mnLKqetDUleOO6Ko0r/KQq0Ryg==
X-Received: by 2002:a9d:315:: with SMTP id 21mr17158984otv.271.1643827886267;
        Wed, 02 Feb 2022 10:51:26 -0800 (PST)
Received: from [192.168.10.222] (189-68-153-170.dsl.telesp.net.br. [189.68.153.170])
        by smtp.gmail.com with ESMTPSA id bj8sm102890oib.20.2022.02.02.10.51.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:51:26 -0800 (PST)
Message-ID: <65ce5709-5a60-41df-5562-12f3369006ce@gmail.com>
Date: Wed, 2 Feb 2022 15:51:20 -0300
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v6 2/3] spapr: nvdimm: Implement H_SCM_FLUSH hcall
Content-Language: en-US
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, clg@kaod.org, mst@redhat.com,
 ani@anisinha.ca, david@gibson.dropbear.id.au, groug@kaod.org,
 imammedo@redhat.com, xiaoguangrong.eric@gmail.com, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
 nvdimm@lists.linux.dev, kvm-ppc@vger.kernel.org
References: <164375265242.118489.1350738893986283213.stgit@82dbe1ffb256>
 <164375267183.118489.3597740907450213654.stgit@82dbe1ffb256>
From: Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <164375267183.118489.3597740907450213654.stgit@82dbe1ffb256>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/1/22 18:57, Shivaprasad G Bhat wrote:
> The patch adds support for the SCM flush hcall for the nvdimm devices.
> To be available for exploitation by guest through the next patch. The
> hcall is applicable only for new SPAPR specific device class which is
> also introduced in this patch.
> 
> The hcall expects the semantics such that the flush to return with
> H_LONG_BUSY_ORDER_10_MSEC when the operation is expected to take longer
> time along with a continue_token. The hcall to be called again by providing
> the continue_token to get the status. So, all fresh requests are put into
> a 'pending' list and flush worker is submitted to the thread pool. The
> thread pool completion callbacks move the requests to 'completed' list,
> which are cleaned up after collecting the return status for the guest
> in subsequent hcall from the guest.
> 
> The semantics makes it necessary to preserve the continue_tokens and
> their return status across migrations. So, the completed flush states
> are forwarded to the destination and the pending ones are restarted
> at the destination in post_load. The necessary nvdimm flush specific
> vmstate structures are also introduced in this patch which are to be
> saved in the new SPAPR specific nvdimm device to be introduced in the
> following patch.
> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---
>   hw/ppc/spapr.c                |    2
>   hw/ppc/spapr_nvdimm.c         |  263 +++++++++++++++++++++++++++++++++++++++++
>   include/hw/ppc/spapr.h        |    4 -
>   include/hw/ppc/spapr_nvdimm.h |    1
>   4 files changed, 269 insertions(+), 1 deletion(-)
> 
> diff --git a/hw/ppc/spapr.c b/hw/ppc/spapr.c
> index 3d6ec309dd..9263985663 100644
> --- a/hw/ppc/spapr.c
> +++ b/hw/ppc/spapr.c
> @@ -1634,6 +1634,8 @@ static void spapr_machine_reset(MachineState *machine)
>           spapr->ov5_cas = spapr_ovec_clone(spapr->ov5);
>       }
>   
> +    spapr_nvdimm_finish_flushes();
> +
>       /* DRC reset may cause a device to be unplugged. This will cause troubles
>        * if this device is used by another device (eg, a running vhost backend
>        * will crash QEMU if the DIMM holding the vring goes away). To avoid such
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index 91de1052f2..ed6fda2c23 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -22,6 +22,7 @@
>    * THE SOFTWARE.
>    */
>   #include "qemu/osdep.h"
> +#include "qemu/cutils.h"
>   #include "qapi/error.h"
>   #include "hw/ppc/spapr_drc.h"
>   #include "hw/ppc/spapr_nvdimm.h"
> @@ -30,6 +31,9 @@
>   #include "hw/ppc/fdt.h"
>   #include "qemu/range.h"
>   #include "hw/ppc/spapr_numa.h"
> +#include "block/thread-pool.h"
> +#include "migration/vmstate.h"
> +#include "qemu/pmem.h"
>   
>   /* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
>   /* SCM device is unable to persist memory contents */
> @@ -47,6 +51,14 @@
>   /* Have an explicit check for alignment */
>   QEMU_BUILD_BUG_ON(SPAPR_MINIMUM_SCM_BLOCK_SIZE % SPAPR_MEMORY_BLOCK_SIZE);
>   
> +#define TYPE_SPAPR_NVDIMM "spapr-nvdimm"
> +OBJECT_DECLARE_TYPE(SpaprNVDIMMDevice, SPAPRNVDIMMClass, SPAPR_NVDIMM)
> +
> +struct SPAPRNVDIMMClass {
> +    /* private */
> +    NVDIMMClass parent_class;
> +};
> +
>   bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>                              uint64_t size, Error **errp)
>   {
> @@ -375,6 +387,256 @@ static target_ulong h_scm_bind_mem(PowerPCCPU *cpu, SpaprMachineState *spapr,
>       return H_SUCCESS;
>   }
>   
> +typedef struct SpaprNVDIMMDeviceFlushState {
> +    uint64_t continue_token;
> +    int64_t hcall_ret;
> +    int backend_fd;

state->backend_fd is being calculated right before calling thread_pool_submit_aio() and used
in the flush_worker_cb() callback. I believe we can remove it and calculate backend_fd inside
flush_worker_cb(), like this:


--- a/hw/ppc/spapr_nvdimm.c
+++ b/hw/ppc/spapr_nvdimm.c
@@ -390,7 +390,6 @@ static target_ulong h_scm_bind_mem(PowerPCCPU *cpu, SpaprMachineState *spa
pr,
  typedef struct SpaprNVDIMMDeviceFlushState {
      uint64_t continue_token;
      int64_t hcall_ret;
-    int backend_fd;
      uint32_t drcidx;
  
      QLIST_ENTRY(SpaprNVDIMMDeviceFlushState) node;
@@ -411,6 +410,7 @@ static int flush_worker_cb(void *opaque)
      SpaprDrc *drc = spapr_drc_by_index(state->drcidx);
      PCDIMMDevice *dimm = PC_DIMM(drc->dev);
      HostMemoryBackend *backend = MEMORY_BACKEND(dimm->hostmem);
+    int backend_fd = memory_region_get_fd(&backend->mr);
  
      if (object_property_get_bool(OBJECT(backend), "pmem", NULL)) {
          MemoryRegion *mr = host_memory_backend_get_memory(dimm->hostmem);
@@ -422,7 +422,7 @@ static int flush_worker_cb(void *opaque)
          pmem_persist(ptr, size);
      } else {
          /* flush raw backing image */
-        if (qemu_fdatasync(state->backend_fd) < 0) {
+        if (qemu_fdatasync(backend_fd) < 0) {
              error_report("papr_scm: Could not sync nvdimm to backend file: %s",
                           strerror(errno));
              return H_HARDWARE;
@@ -447,12 +447,9 @@ static int spapr_nvdimm_flush_post_load(void *opaque, int version_id)
  {
      SpaprNVDIMMDevice *s_nvdimm = (SpaprNVDIMMDevice *)opaque;
      SpaprNVDIMMDeviceFlushState *state;
-    HostMemoryBackend *backend = MEMORY_BACKEND(PC_DIMM(s_nvdimm)->hostmem);
      ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
  
      QLIST_FOREACH(state, &s_nvdimm->pending_nvdimm_flush_states, node) {
-        state->backend_fd = memory_region_get_fd(&backend->mr);
-
          thread_pool_submit_aio(pool, flush_worker_cb, state,
                                 spapr_nvdimm_flush_completion_cb, state);
      }
@@ -621,7 +618,6 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
          }
  
          state->drcidx = drc_index;
-        state->backend_fd = fd;
  
          thread_pool_submit_aio(pool, flush_worker_cb, state,
                                 spapr_nvdimm_flush_completion_cb, state);


This will spare some lines in flush_post_load() and a field in the SpaprNVDIMMDeviceFlushState.


> +    uint32_t drcidx;
> +
> +    QLIST_ENTRY(SpaprNVDIMMDeviceFlushState) node;
> +} SpaprNVDIMMDeviceFlushState;
> +
> +typedef struct SpaprNVDIMMDevice SpaprNVDIMMDevice;
> +struct SpaprNVDIMMDevice {
> +    NVDIMMDevice parent_obj;
> +
> +    uint64_t nvdimm_flush_token;
> +    QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) pending_nvdimm_flush_states;
> +    QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) completed_nvdimm_flush_states;
> +};
> +
> +static int flush_worker_cb(void *opaque)
> +{
> +    SpaprNVDIMMDeviceFlushState *state = opaque;
> +    SpaprDrc *drc = spapr_drc_by_index(state->drcidx);
> +    PCDIMMDevice *dimm = PC_DIMM(drc->dev);
> +    HostMemoryBackend *backend = MEMORY_BACKEND(dimm->hostmem);
> +
> +    if (object_property_get_bool(OBJECT(backend), "pmem", NULL)) {
> +        MemoryRegion *mr = host_memory_backend_get_memory(dimm->hostmem);
> +        void *ptr = memory_region_get_ram_ptr(mr);
> +        size_t size = object_property_get_uint(OBJECT(dimm), PC_DIMM_SIZE_PROP,
> +                                               NULL);
> +
> +        /* flush pmem backend */
> +        pmem_persist(ptr, size);
> +    } else {
> +        /* flush raw backing image */
> +        if (qemu_fdatasync(state->backend_fd) < 0) {
> +            error_report("papr_scm: Could not sync nvdimm to backend file: %s",
> +                         strerror(errno));
> +            return H_HARDWARE;
> +        }
> +    }
> +
> +    return H_SUCCESS;
> +}
> +
> +static void spapr_nvdimm_flush_completion_cb(void *opaque, int hcall_ret)
> +{
> +    SpaprNVDIMMDeviceFlushState *state = opaque;
> +    SpaprDrc *drc = spapr_drc_by_index(state->drcidx);
> +    SpaprNVDIMMDevice *s_nvdimm = SPAPR_NVDIMM(drc->dev);
> +
> +    state->hcall_ret = hcall_ret;
> +    QLIST_REMOVE(state, node);
> +    QLIST_INSERT_HEAD(&s_nvdimm->completed_nvdimm_flush_states, state, node);
> +}
> +
> +static int spapr_nvdimm_flush_post_load(void *opaque, int version_id)
> +{
> +    SpaprNVDIMMDevice *s_nvdimm = (SpaprNVDIMMDevice *)opaque;
> +    SpaprNVDIMMDeviceFlushState *state;
> +    HostMemoryBackend *backend = MEMORY_BACKEND(PC_DIMM(s_nvdimm)->hostmem);
> +    ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
> +
> +    QLIST_FOREACH(state, &s_nvdimm->pending_nvdimm_flush_states, node) {
> +        state->backend_fd = memory_region_get_fd(&backend->mr);
> +
> +        thread_pool_submit_aio(pool, flush_worker_cb, state,
> +                               spapr_nvdimm_flush_completion_cb, state);
> +    }
> +
> +    return 0;
> +}
> +
> +static const VMStateDescription vmstate_spapr_nvdimm_flush_state = {
> +     .name = "spapr_nvdimm_flush_state",
> +     .version_id = 1,
> +     .minimum_version_id = 1,
> +     .fields = (VMStateField[]) {
> +         VMSTATE_UINT64(continue_token, SpaprNVDIMMDeviceFlushState),
> +         VMSTATE_INT64(hcall_ret, SpaprNVDIMMDeviceFlushState),
> +         VMSTATE_UINT32(drcidx, SpaprNVDIMMDeviceFlushState),
> +         VMSTATE_END_OF_LIST()
> +     },
> +};
> +
> +const VMStateDescription vmstate_spapr_nvdimm_states = {
> +    .name = "spapr_nvdimm_states",
> +    .version_id = 1,
> +    .minimum_version_id = 1,
> +    .post_load = spapr_nvdimm_flush_post_load,
> +    .fields = (VMStateField[]) {
> +        VMSTATE_UINT64(nvdimm_flush_token, SpaprNVDIMMDevice),
> +        VMSTATE_QLIST_V(completed_nvdimm_flush_states, SpaprNVDIMMDevice, 1,
> +                        vmstate_spapr_nvdimm_flush_state,
> +                        SpaprNVDIMMDeviceFlushState, node),
> +        VMSTATE_QLIST_V(pending_nvdimm_flush_states, SpaprNVDIMMDevice, 1,
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
> +                                                SpaprNVDIMMDevice *spapr_nvdimm)
> +{
> +    SpaprNVDIMMDeviceFlushState *state;
> +
> +    state = g_malloc0(sizeof(*state));
> +
> +    spapr_nvdimm->nvdimm_flush_token++;
> +    /* Token zero is presumed as no job pending. Asser on overflow to zero */


I guess you meant 'Assert'.



> +    g_assert(spapr_nvdimm->nvdimm_flush_token != 0);
> +
> +    state->continue_token = spapr_nvdimm->nvdimm_flush_token;
> +
> +    QLIST_INSERT_HEAD(&spapr_nvdimm->pending_nvdimm_flush_states, state, node);
> +
> +    return state;
> +}
> +
> +/*
> + * spapr_nvdimm_finish_flushes
> + *      Waits for all pending flush requests to complete
> + *      their execution and free the states
> + */
> +void spapr_nvdimm_finish_flushes(void)
> +{
> +    SpaprNVDIMMDeviceFlushState *state, *next;
> +    GSList *list, *nvdimms;
> +
> +    /*
> +     * Called on reset path, the main loop thread which calls
> +     * the pending BHs has gotten out running in the reset path,
> +     * finally reaching here. Other code path being guest
> +     * h_client_architecture_support, thats early boot up.
> +     */
> +    nvdimms = nvdimm_get_device_list();
> +    for (list = nvdimms; list; list = list->next) {
> +        NVDIMMDevice *nvdimm = list->data;
> +        if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM)) {
> +            SpaprNVDIMMDevice *s_nvdimm = SPAPR_NVDIMM(nvdimm);
> +            while (!QLIST_EMPTY(&s_nvdimm->pending_nvdimm_flush_states)) {
> +                aio_poll(qemu_get_aio_context(), true);
> +            }
> +
> +            QLIST_FOREACH_SAFE(state, &s_nvdimm->completed_nvdimm_flush_states,
> +                               node, next) {
> +                QLIST_REMOVE(state, node);
> +                g_free(state);
> +            }
> +        }
> +    }
> +    g_slist_free(nvdimms);
> +}
> +
> +/*
> + * spapr_nvdimm_get_flush_status
> + *      Fetches the status of the hcall worker and returns
> + *      H_LONG_BUSY_ORDER_10_MSEC if the worker is still running.
> + */
> +static int spapr_nvdimm_get_flush_status(SpaprNVDIMMDevice *s_nvdimm,
> +                                         uint64_t token)
> +{
> +    SpaprNVDIMMDeviceFlushState *state, *node;
> +
> +    QLIST_FOREACH(state, &s_nvdimm->pending_nvdimm_flush_states, node) {
> +        if (state->continue_token == token) {
> +            return H_LONG_BUSY_ORDER_10_MSEC;
> +        }
> +    }
> +
> +    QLIST_FOREACH_SAFE(state, &s_nvdimm->completed_nvdimm_flush_states,
> +                       node, node) {
> +        if (state->continue_token == token) {
> +            int ret = state->hcall_ret;
> +            QLIST_REMOVE(state, node);
> +            g_free(state);
> +            return ret;
> +        }
> +    }
> +
> +    /* If not found in complete list too, invalid token */
> +    return H_P2;
> +}
> +
> +/*
> + * H_SCM_FLUSH
> + * Input: drc_index, continue-token
> + * Out: continue-token
> + * Return Value: H_SUCCESS, H_Parameter, H_P2, H_LONG_BUSY_ORDER_10_MSEC

We need to mention the H_UNSUPPORTED return value as well.


Thanks,


Daniel

> + *
> + * Given a DRC Index Flush the data to backend NVDIMM device. The hcall returns
> + * H_LONG_BUSY_ORDER_10_MSEC when the flush takes longer time and the hcall
> + * needs to be issued multiple times in order to be completely serviced. The
> + * continue-token from the output to be passed in the argument list of
> + * subsequent hcalls until the hcall is completely serviced at which point
> + * H_SUCCESS or other error is returned.
> + */
> +static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
> +                                target_ulong opcode, target_ulong *args)
> +{
> +    int ret;
> +    uint32_t drc_index = args[0];
> +    uint64_t continue_token = args[1];
> +    SpaprDrc *drc = spapr_drc_by_index(drc_index);
> +    PCDIMMDevice *dimm;
> +    HostMemoryBackend *backend = NULL;
> +    SpaprNVDIMMDeviceFlushState *state;
> +    ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
> +    int fd;
> +
> +    if (!drc || !drc->dev ||
> +        spapr_drc_type(drc) != SPAPR_DR_CONNECTOR_TYPE_PMEM) {
> +        return H_PARAMETER;
> +    }
> +
> +    dimm = PC_DIMM(drc->dev);
> +    if (continue_token == 0) {
> +        backend = MEMORY_BACKEND(dimm->hostmem);
> +        fd = memory_region_get_fd(&backend->mr);
> +
> +        if (fd < 0) {
> +            return H_UNSUPPORTED;
> +        }
> +
> +        state = spapr_nvdimm_init_new_flush_state(SPAPR_NVDIMM(dimm));
> +        if (!state) {
> +            return H_HARDWARE;
> +        }
> +
> +        state->drcidx = drc_index;
> +        state->backend_fd = fd;
> +
> +        thread_pool_submit_aio(pool, flush_worker_cb, state,
> +                               spapr_nvdimm_flush_completion_cb, state);
> +
> +        continue_token = state->continue_token;
> +    }
> +
> +    ret = spapr_nvdimm_get_flush_status(SPAPR_NVDIMM(dimm), continue_token);
> +    if (H_IS_LONG_BUSY(ret)) {
> +        args[0] = continue_token;
> +    }
> +
> +    return ret;
> +}
> +
>   static target_ulong h_scm_unbind_mem(PowerPCCPU *cpu, SpaprMachineState *spapr,
>                                        target_ulong opcode, target_ulong *args)
>   {
> @@ -523,6 +785,7 @@ static void spapr_scm_register_types(void)
>       spapr_register_hypercall(H_SCM_UNBIND_MEM, h_scm_unbind_mem);
>       spapr_register_hypercall(H_SCM_UNBIND_ALL, h_scm_unbind_all);
>       spapr_register_hypercall(H_SCM_HEALTH, h_scm_health);
> +    spapr_register_hypercall(H_SCM_FLUSH, h_scm_flush);
>   }
>   
>   type_init(spapr_scm_register_types)
> diff --git a/include/hw/ppc/spapr.h b/include/hw/ppc/spapr.h
> index ee7504b976..727b2a0e7f 100644
> --- a/include/hw/ppc/spapr.h
> +++ b/include/hw/ppc/spapr.h
> @@ -341,6 +341,7 @@ struct SpaprMachineState {
>   #define H_P7              -60
>   #define H_P8              -61
>   #define H_P9              -62
> +#define H_UNSUPPORTED     -67
>   #define H_OVERLAP         -68
>   #define H_UNSUPPORTED_FLAG -256
>   #define H_MULTI_THREADS_ACTIVE -9005
> @@ -559,8 +560,9 @@ struct SpaprMachineState {
>   #define H_SCM_UNBIND_ALL        0x3FC
>   #define H_SCM_HEALTH            0x400
>   #define H_RPT_INVALIDATE        0x448
> +#define H_SCM_FLUSH             0x44C
>   
> -#define MAX_HCALL_OPCODE        H_RPT_INVALIDATE
> +#define MAX_HCALL_OPCODE        H_SCM_FLUSH
>   
>   /* The hcalls above are standardized in PAPR and implemented by pHyp
>    * as well.
> diff --git a/include/hw/ppc/spapr_nvdimm.h b/include/hw/ppc/spapr_nvdimm.h
> index 764f999f54..e9436cb6ef 100644
> --- a/include/hw/ppc/spapr_nvdimm.h
> +++ b/include/hw/ppc/spapr_nvdimm.h
> @@ -21,5 +21,6 @@ void spapr_dt_persistent_memory(SpaprMachineState *spapr, void *fdt);
>   bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>                              uint64_t size, Error **errp);
>   void spapr_add_nvdimm(DeviceState *dev, uint64_t slot);
> +void spapr_nvdimm_finish_flushes(void);
>   
>   #endif
> 
> 
