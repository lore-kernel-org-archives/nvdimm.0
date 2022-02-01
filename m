Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 142B72F27
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 21:41:22 +0000 (UTC)
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211JwZNo018844;
	Tue, 1 Feb 2022 21:41:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=8DZOlTGlBIN5bjX0KJwIZVdE5c2Hx4FSvrMAh6bXyDM=;
 b=p4TvnewK2Pvyk8GfbyW9dlp5HVOPwrUktvmsrWMEQzllo/9r3wI6YsdSYRkpkF8i8SNd
 LIw03HsSMllnuZg3wM0fQxCPaY+vPZfsuoMO/7laIR/8wT7JUynZ972qNKsJz+2NaGd/
 D0WqIsRVoU+LtFLUPVnDcz9Fk1vyZL+TPgllrs2srMut+cy01t4z44tst3GKlzkuyAoK
 j2PyM4/XWooKTTm2mxva1pO3nOx8Q/5nNsxMyXme2RVjhtc1pDBbNxdAY1CZP9zL2aAC
 mhCKGQF/BCGtoI4rrAlGt4Gkxu+yzZHCfJY7Sn4oFW0gRuNMvKOTzkU6hEyaQCOeNT66 fg== 
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
	by mx0a-001b2d01.pphosted.com with ESMTP id 3dybg91pv0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Feb 2022 21:41:14 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
	by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211LciE0015878;
	Tue, 1 Feb 2022 21:41:12 GMT
Received: from b06avi18626390.portsmouth.uk.ibm.com (b06avi18626390.portsmouth.uk.ibm.com [9.149.26.192])
	by ppma03ams.nl.ibm.com with ESMTP id 3dvw79r68f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Feb 2022 21:41:12 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06avi18626390.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211LVKUV42926464
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Feb 2022 21:31:20 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 48333AE053;
	Tue,  1 Feb 2022 21:41:10 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 19E2EAE051;
	Tue,  1 Feb 2022 21:41:08 +0000 (GMT)
Received: from [9.43.60.126] (unknown [9.43.60.126])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  1 Feb 2022 21:41:07 +0000 (GMT)
Message-ID: <33114b36-15ca-3f6f-aa8d-8be9e69e8476@linux.ibm.com>
Date: Wed, 2 Feb 2022 03:11:06 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH REBASED v5 1/2] spapr: nvdimm: Implement H_SCM_FLUSH hcall
Content-Language: en-US
To: David Gibson <david@gibson.dropbear.id.au>
Cc: groug@kaod.org, qemu-ppc@nongnu.org, qemu-devel@nongnu.org,
        aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org, bharata@linux.vnet.ibm.com
References: <162571302321.1030381.15196355582642786915.stgit@lep8c.aus.stglabs.ibm.com>
 <162571303048.1030381.13893352223345979621.stgit@lep8c.aus.stglabs.ibm.com>
 <YUl6bnSuWVsX4P1I@yekko>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <YUl6bnSuWVsX4P1I@yekko>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: gGr3E67fIuRCz7tgUPuugD94oSdsE96G
X-Proofpoint-GUID: gGr3E67fIuRCz7tgUPuugD94oSdsE96G
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_10,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 lowpriorityscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 impostorscore=0 adultscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010118

Hi David,

Thanks for comments. Sorry about the delay. Replies inline.

On 9/21/21 11:53, David Gibson wrote:
> On Wed, Jul 07, 2021 at 09:57:21PM -0500, Shivaprasad G Bhat wrote:
>> The patch adds support for the SCM flush hcall for the nvdimm devices.
>> To be available for exploitation by guest through the next patch.
>>
>> The hcall expects the semantics such that the flush to return
>> with one of H_LONG_BUSY when the operation is expected to take longer
>> time along with a continue_token. The hcall to be called again providing
>> the continue_token to get the status. So, all fresh requests are put into
>> a 'pending' list and flush worker is submitted to the thread pool. The
>> thread pool completion callbacks move the requests to 'completed' list,
>> which are cleaned up after reporting to guest in subsequent hcalls t

<snip>

>> @@ -30,6 +31,7 @@
>>   #include "hw/ppc/fdt.h"
>>   #include "qemu/range.h"
>>   #include "hw/ppc/spapr_numa.h"
>> +#include "block/thread-pool.h"
>>   
>>   /* DIMM health bitmap bitmap indicators. Taken from kernel's papr_scm.c */
>>   /* SCM device is unable to persist memory contents */
>> @@ -375,6 +377,243 @@ static target_ulong h_scm_bind_mem(PowerPCCPU *cpu, SpaprMachineState *spapr,
>>       return H_SUCCESS;
>>   }
>>   
>> +static uint64_t flush_token;
> 
> Better to put this in the machine state structure than a global.

Moved it to device state itself as suggested, the states list is per 
device now.

> 
>> +static int flush_worker_cb(void *opaque)
>> +{
>> +    int ret = H_SUCCESS;
>> +    SpaprNVDIMMDeviceFlushState *state = opaque;
>> +
>> +    /* flush raw backing image */
>> +  

<snip>

>> +             !QLIST_EMPTY(&spapr->completed_flush_states));
>> +}
>> +
>> +static int spapr_nvdimm_post_load(void *opaque, int version_id)
>> +{
>> +    SpaprMachineState *spapr = (SpaprMachineState *)opaque;
>> +    SpaprNVDIMMDeviceFlushState *state, *next;
>> +    PCDIMMDevice *dimm;
>> +    HostMemoryBackend *backend = NULL;
>> +    ThreadPool *pool = aio_get_thread_pool(qemu_get_aio_context());
>> +    SpaprDrc *drc;
>> +
>> +    QLIST_FOREACH_SAFE(state, &spapr->completed_flush_states, node, next) {
> 
> I don't think you need FOREACH_SAFE here.  You're not removing entries
> from the loop body.  If you're trying to protect against concurrent
> removals, I don't think FOREACH_SAFE is sufficient, you'll need an
> actual lock (but I think it's already protected by the BQL).

Changing here, below and also at spapr_nvdimm_get_flush_status() while 
traversing the pending list. Verified all these invocations are called 
with BQL.

> 
>> +        if (flush_token < state->continue_token) {
>> +            flush_token = state->continue_token;
>> +        }
>> +    }
>> +
>> +    QLIST_FOREACH_SAFE(state, &spapr->pending_flush_states, node, next) {
> 
> Sane comments here.
> 
>> +        if (flush_token < state->continue_token) {
>> +            flush_token = state->continue_token;
>> +        }
>> +
>> +        drc = spapr_drc_by_index(state->drcidx);
>> +        dimm = PC_DIMM(drc->dev);
>> +        backend = MEMORY_BACKEND(dimm->hostmem);
>> +        state->backend_fd = memory_region_get_fd(&backend->mr);
>> +
>> +        thread_pool_submit_aio(pool, flush_worker_cb, state,
>> +                               spapr_nvdimm_flush_completion_cb, state);
>> +    }
>> +
>> +    return 0;
>> +}
>> +
>> +const VMStateDescription vmstate_spapr_nvdimm_states = {
>> +    .name = "spapr_nvdimm_states",
>> +    .version_id = 1,
>> +    .minimum_version_id = 1,
>> +    .needed = spapr_nvdimm_states_needed,
>> +    .post_load = spapr_nvdimm_post_load,
>> +    .fields = (VMStateField[]) {
>> +        VMSTATE_QLIST_V(completed_flush_states, SpaprMachineState, 1,
>> +                        vmstate_spapr_nvdimm_flush_state,
>> +                        SpaprNVDIMMDeviceFlushState, node),
>> +        VMSTATE_QLIST_V(pending_flush_states, SpaprMachineState, 1,
>> +                        vmstate_spapr_nvdimm_flush_state,
>> +                        SpaprNVDIMMDeviceFlushState, node),
>> +        VMSTATE_END_OF_LIST()
>> +    },
>> +};
>> +
>> +/*
>> + * Assign a token and reserve it for the new flush state.
>> + */
>> +static SpaprNVDIMMDeviceFlushState *spapr_nvdimm_init_new_flush_state(
>> +                                                      SpaprMachineState *spapr)
>> +{
>> +    SpaprNVDIMMDeviceFlushState *state;
>> +
>> +    state = g_malloc0(sizeof(*state));
>> +
>> +    flush_token++;
>> +    /* Token zero is presumed as no job pending. Handle the overflow to zero */
>> +    if (flush_token == 0) {
>> +        flush_token++;
> 
> Hmm... strictly speaking, this isn't safe.  It's basically never going
> to happen in practice, but in theory there's nothing preventing
> continue_token 1 still being outstanding when the flush_token counter
> overflows.
> 
> Come to think of it, since it's a uint64_t, I think an actual overflow
> is also never going to happen in practice.  Maybe we should just
> assert() on overflow, and fix it in the unlikely event that we ever
> discover a case where it could happen.

Have added the assert on overflow.

> 
>> +    }
>> +    state->continue_token = flush_token;
>> +
>> +    QLIST_INSERT_HEAD(&spapr->pending_flush_states, state, node);
>> +
>> +    return state;
>> +}
>> +
>> +/*
>> + *

Thanks!
