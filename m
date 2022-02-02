Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AF62CA5
	for <nvdimm@lists.linux.dev>; Wed,  2 Feb 2022 18:57:55 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id e81so110646oia.6
        for <nvdimm@lists.linux.dev>; Wed, 02 Feb 2022 10:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bmPKXKYzPy1kA7KW4d7u/vuxxsqjR+u4nCn+G+mUQts=;
        b=gs+LRMQosD/9IF3FxlH7sFU+DULvgxN0Gbg+gmae5GeYk8CBiTTgSOB//w7RPxo7gs
         RQI+Q3ZqVFXsrHZfiUh1OS6IN17l2Kf51/g2TGju5yuySZ30m/dtgotalDRgMPJL5G5o
         U3jlIAAL1X3L0fDRdpPnlQGlcb6GpX2zCkJ8N4fMfIO6YLnWvxNe/ZZH4My3SHKkcGog
         a+mV/fmRXtp0dDcnuQLDKUdug0c/4ugsp3TRGGBfsu5P2Z5M90rSBGsO2PuLxCh8XIp9
         oEie7HlARFsuHlLkV4G0hCU99PnqcxeQu7cDzp6X0tZHnUQQ0rjGc6l6NZjA/BrN+hob
         lb9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bmPKXKYzPy1kA7KW4d7u/vuxxsqjR+u4nCn+G+mUQts=;
        b=Ux5p6UR3mP7YC9n+5Oqicbn20J9ZWuZMfRe6aPBvyq9XjlrWP22iet1z3Upi6qm0Aq
         wv+HgLlK5LHyWtGsIgu2O8xvLBmyJtXkG+lf64LXU56Zy3Kpwy0Xoe8RKgyzZlRWBfDm
         KdJJMrdH4ub7QWc6lecI1MLyBwmtS9lPSjL3qEwR0RkJRTuLsTnBYezSaGX+vWmt5LxX
         ecAcazGcDCOqZZi/PE95FAIqtGZ1VZYoCaYMa7RnTnxoLh87LZaMaoxQzkIy6TBZLWAr
         N94S1Wfbmja15eIFl9kT7bIETEJ7Fs9CMSjhw1tjnHjPRQn43mPllb2i+yBKKl10ZHZJ
         XUhg==
X-Gm-Message-State: AOAM533sFDZuAYngAJ5bAw1CwOZE0rHh8uzf74l+rTj0i9p2JSK/4Wdf
	Jos4qovTM9dd6p8Lk1MNNrw=
X-Google-Smtp-Source: ABdhPJws4EXYOoyK07bOw2kLZKiVhvSxSvWxk1Si4Y/eLm2oCN53EYbI/58wNNh+AEdCSy8nnNj9ww==
X-Received: by 2002:a05:6808:168e:: with SMTP id bb14mr5395070oib.106.1643828274797;
        Wed, 02 Feb 2022 10:57:54 -0800 (PST)
Received: from [192.168.10.222] (189-68-153-170.dsl.telesp.net.br. [189.68.153.170])
        by smtp.gmail.com with ESMTPSA id d65sm12956442otb.17.2022.02.02.10.57.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Feb 2022 10:57:54 -0800 (PST)
Message-ID: <01c25b65-cd6f-ded9-fa46-aa5f5a82d05a@gmail.com>
Date: Wed, 2 Feb 2022 15:57:49 -0300
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v6 3/3] spapr: nvdimm: Introduce spapr-nvdimm device
Content-Language: en-US
To: Shivaprasad G Bhat <sbhat@linux.ibm.com>, clg@kaod.org, mst@redhat.com,
 ani@anisinha.ca, david@gibson.dropbear.id.au, groug@kaod.org,
 imammedo@redhat.com, xiaoguangrong.eric@gmail.com, qemu-ppc@nongnu.org
Cc: qemu-devel@nongnu.org, aneesh.kumar@linux.ibm.com,
 nvdimm@lists.linux.dev, kvm-ppc@vger.kernel.org
References: <164375265242.118489.1350738893986283213.stgit@82dbe1ffb256>
 <164375268492.118489.6662873828073732668.stgit@82dbe1ffb256>
From: Daniel Henrique Barboza <danielhb413@gmail.com>
In-Reply-To: <164375268492.118489.6662873828073732668.stgit@82dbe1ffb256>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/1/22 18:58, Shivaprasad G Bhat wrote:
> If the device backend is not persistent memory for the nvdimm, there is
> need for explicit IO flushes on the backend to ensure persistence.
> 
> On SPAPR, the issue is addressed by adding a new hcall to request for
> an explicit flush from the guest when the backend is not pmem. So, the
> approach here is to convey when the hcall flush is required in a device
> tree property. The guest once it knows the device backend is not pmem,
> makes the hcall whenever flush is required.
> 
> To set the device tree property, a new PAPR specific device type inheriting
> the nvdimm device is implemented. When the backend doesn't have pmem=on
> the device tree property "ibm,hcall-flush-required" is set, and the guest
> makes hcall H_SCM_FLUSH requesting for an explicit flush. The new device
> has boolean property pmem-override which when "on" advertises the device
> tree property even when pmem=on for the backend. The flush function
> invokes the fdatasync or pmem_persist() based on the type of backend.
> 
> The vmstate structures are made part of the spapr-nvdimm device object.
> The patch attempts to keep the migration compatibility between source and
> destination while rejecting the incompatibles ones with failures.
> 
> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
> ---

Reviewed-by: Daniel Henrique Barboza <danielhb413@gmail.com>

>   hw/ppc/spapr_nvdimm.c |  131 +++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 131 insertions(+)
> 
> diff --git a/hw/ppc/spapr_nvdimm.c b/hw/ppc/spapr_nvdimm.c
> index ed6fda2c23..8aa6214d6b 100644
> --- a/hw/ppc/spapr_nvdimm.c
> +++ b/hw/ppc/spapr_nvdimm.c
> @@ -34,6 +34,7 @@
>   #include "block/thread-pool.h"
>   #include "migration/vmstate.h"
>   #include "qemu/pmem.h"
> +#include "hw/qdev-properties.h"
>   
>   /* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
>   /* SCM device is unable to persist memory contents */
> @@ -57,6 +58,10 @@ OBJECT_DECLARE_TYPE(SpaprNVDIMMDevice, SPAPRNVDIMMClass, SPAPR_NVDIMM)
>   struct SPAPRNVDIMMClass {
>       /* private */
>       NVDIMMClass parent_class;
> +
> +    /* public */
> +    void (*realize)(NVDIMMDevice *dimm, Error **errp);
> +    void (*unrealize)(NVDIMMDevice *dimm, Error **errp);
>   };
>   
>   bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
> @@ -64,6 +69,8 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>   {
>       const MachineClass *mc = MACHINE_GET_CLASS(hotplug_dev);
>       const MachineState *ms = MACHINE(hotplug_dev);
> +    PCDIMMDevice *dimm = PC_DIMM(nvdimm);
> +    MemoryRegion *mr = host_memory_backend_get_memory(dimm->hostmem);
>       g_autofree char *uuidstr = NULL;
>       QemuUUID uuid;
>       int ret;
> @@ -101,6 +108,14 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>           return false;
>       }
>   
> +    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM) &&
> +        (memory_region_get_fd(mr) < 0)) {
> +        error_setg(errp, "spapr-nvdimm device requires the "
> +                   "memdev %s to be of memory-backend-file type",
> +                   object_get_canonical_path_component(OBJECT(dimm->hostmem)));
> +        return false;
> +    }
> +
>       return true;
>   }
>   
> @@ -172,6 +187,20 @@ static int spapr_dt_nvdimm(SpaprMachineState *spapr, void *fdt,
>                                "operating-system")));
>       _FDT(fdt_setprop(fdt, child_offset, "ibm,cache-flush-required", NULL, 0));
>   
> +    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM)) {
> +        bool is_pmem = false, pmem_override = false;
> +        PCDIMMDevice *dimm = PC_DIMM(nvdimm);
> +        HostMemoryBackend *hostmem = dimm->hostmem;
> +
> +        is_pmem = object_property_get_bool(OBJECT(hostmem), "pmem", NULL);
> +        pmem_override = object_property_get_bool(OBJECT(nvdimm),
> +                                                 "pmem-override", NULL);
> +        if (!is_pmem || pmem_override) {
> +            _FDT(fdt_setprop(fdt, child_offset, "ibm,hcall-flush-required",
> +                             NULL, 0));
> +        }
> +    }
> +
>       return child_offset;
>   }
>   
> @@ -398,11 +427,21 @@ typedef struct SpaprNVDIMMDeviceFlushState {
>   
>   typedef struct SpaprNVDIMMDevice SpaprNVDIMMDevice;
>   struct SpaprNVDIMMDevice {
> +    /* private */
>       NVDIMMDevice parent_obj;
>   
> +    bool hcall_flush_required;
>       uint64_t nvdimm_flush_token;
>       QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) pending_nvdimm_flush_states;
>       QLIST_HEAD(, SpaprNVDIMMDeviceFlushState) completed_nvdimm_flush_states;
> +
> +    /* public */
> +
> +    /*
> +     * The 'on' value for this property forced the qemu to enable the hcall
> +     * flush for the nvdimm device even if the backend is a pmem
> +     */
> +    bool pmem_override;
>   };
>   
>   static int flush_worker_cb(void *opaque)
> @@ -449,6 +488,23 @@ static int spapr_nvdimm_flush_post_load(void *opaque, int version_id)
>       SpaprNVDIMMDeviceFlushState *state;
>       HostMemoryBackend *backend = MEMORY_BACKEND(PC_DIMM(s_nvdimm)->hostmem);
>       ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
> +    bool is_pmem = object_property_get_bool(OBJECT(backend), "pmem", NULL);
> +    bool pmem_override = object_property_get_bool(OBJECT(s_nvdimm),
> +                                                  "pmem-override", NULL);
> +    bool dest_hcall_flush_required = pmem_override || !is_pmem;
> +
> +    if (!s_nvdimm->hcall_flush_required && dest_hcall_flush_required) {
> +        error_report("The file backend for the spapr-nvdimm device %s at "
> +                     "source is a pmem, use pmem=on and pmem-override=off to "
> +                     "continue.", DEVICE(s_nvdimm)->id);
> +        return -EINVAL;
> +    }
> +    if (s_nvdimm->hcall_flush_required && !dest_hcall_flush_required) {
> +        error_report("The guest expects hcall-flush support for the "
> +                     "spapr-nvdimm device %s, use pmem_override=on to "
> +                     "continue.", DEVICE(s_nvdimm)->id);
> +        return -EINVAL;
> +    }
>   
>       QLIST_FOREACH(state, &s_nvdimm->pending_nvdimm_flush_states, node) {
>           state->backend_fd = memory_region_get_fd(&backend->mr);
> @@ -478,6 +534,7 @@ const VMStateDescription vmstate_spapr_nvdimm_states = {
>       .minimum_version_id = 1,
>       .post_load = spapr_nvdimm_flush_post_load,
>       .fields = (VMStateField[]) {
> +        VMSTATE_BOOL(hcall_flush_required, SpaprNVDIMMDevice),
>           VMSTATE_UINT64(nvdimm_flush_token, SpaprNVDIMMDevice),
>           VMSTATE_QLIST_V(completed_nvdimm_flush_states, SpaprNVDIMMDevice, 1,
>                           vmstate_spapr_nvdimm_flush_state,
> @@ -607,7 +664,11 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
>       }
>   
>       dimm = PC_DIMM(drc->dev);
> +    if (!object_dynamic_cast(OBJECT(dimm), TYPE_SPAPR_NVDIMM)) {
> +        return H_PARAMETER;
> +    }
>       if (continue_token == 0) {
> +        bool is_pmem = false, pmem_override = false;
>           backend = MEMORY_BACKEND(dimm->hostmem);
>           fd = memory_region_get_fd(&backend->mr);
>   
> @@ -615,6 +676,13 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
>               return H_UNSUPPORTED;
>           }
>   
> +        is_pmem = object_property_get_bool(OBJECT(backend), "pmem", NULL);
> +        pmem_override = object_property_get_bool(OBJECT(dimm),
> +                                                "pmem-override", NULL);
> +        if (is_pmem && !pmem_override) {
> +            return H_UNSUPPORTED;
> +        }
> +
>           state = spapr_nvdimm_init_new_flush_state(SPAPR_NVDIMM(dimm));
>           if (!state) {
>               return H_HARDWARE;
> @@ -789,3 +857,66 @@ static void spapr_scm_register_types(void)
>   }
>   
>   type_init(spapr_scm_register_types)
> +
> +static void spapr_nvdimm_realize(NVDIMMDevice *dimm, Error **errp)
> +{
> +    SpaprNVDIMMDevice *s_nvdimm = SPAPR_NVDIMM(dimm);
> +    HostMemoryBackend *backend = MEMORY_BACKEND(PC_DIMM(dimm)->hostmem);
> +    bool is_pmem = object_property_get_bool(OBJECT(backend),  "pmem", NULL);
> +    bool pmem_override = object_property_get_bool(OBJECT(dimm), "pmem-override",
> +                                             NULL);
> +    if (!is_pmem || pmem_override) {
> +        s_nvdimm->hcall_flush_required = true;
> +    }
> +
> +    vmstate_register(NULL, VMSTATE_INSTANCE_ID_ANY,
> +                     &vmstate_spapr_nvdimm_states, dimm);
> +}
> +
> +static void spapr_nvdimm_unrealize(NVDIMMDevice *dimm)
> +{
> +    vmstate_unregister(NULL, &vmstate_spapr_nvdimm_states, dimm);
> +}
> +
> +static Property spapr_nvdimm_properties[] = {
> +#ifdef CONFIG_LIBPMEM
> +    DEFINE_PROP_BOOL("pmem-override", SpaprNVDIMMDevice, pmem_override, false),
> +#endif
> +    DEFINE_PROP_END_OF_LIST(),
> +};
> +
> +static void spapr_nvdimm_class_init(ObjectClass *oc, void *data)
> +{
> +    DeviceClass *dc = DEVICE_CLASS(oc);
> +    NVDIMMClass *nvc = NVDIMM_CLASS(oc);
> +
> +    nvc->realize = spapr_nvdimm_realize;
> +    nvc->unrealize = spapr_nvdimm_unrealize;
> +
> +    device_class_set_props(dc, spapr_nvdimm_properties);
> +}
> +
> +static void spapr_nvdimm_init(Object *obj)
> +{
> +    SpaprNVDIMMDevice *s_nvdimm = SPAPR_NVDIMM(obj);
> +
> +    s_nvdimm->hcall_flush_required = false;
> +    QLIST_INIT(&s_nvdimm->pending_nvdimm_flush_states);
> +    QLIST_INIT(&s_nvdimm->completed_nvdimm_flush_states);
> +}
> +
> +static TypeInfo spapr_nvdimm_info = {
> +    .name          = TYPE_SPAPR_NVDIMM,
> +    .parent        = TYPE_NVDIMM,
> +    .class_init    = spapr_nvdimm_class_init,
> +    .class_size    = sizeof(SPAPRNVDIMMClass),
> +    .instance_size = sizeof(SpaprNVDIMMDevice),
> +    .instance_init = spapr_nvdimm_init,
> +};
> +
> +static void spapr_nvdimm_register_types(void)
> +{
> +    type_register_static(&spapr_nvdimm_info);
> +}
> +
> +type_init(spapr_nvdimm_register_types)
> 
> 
