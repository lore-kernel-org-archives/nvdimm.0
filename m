Received: from mx0a-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8882C9C
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 21:41:34 +0000 (UTC)
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
	by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 211LSkwF002398;
	Tue, 1 Feb 2022 21:41:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=BHKsYNWnQA7Q+5dTabzrCHZcG7IaRmtbdzul69H926c=;
 b=UbuJBNisOti/wXlsmBU5VWwWur6YpgK9fkUJxVWuYDr/ByQNpTjX8cGqcZ40XskSEnwQ
 cDMwmKMHOg9dUot+RRSfl5Sg1rNE7Jp0zW+fk4FL53lwBq2UmqlWnnUjPO1XSYZgz2vB
 rZ6Dan2+Sp+MYuzIHDlETheodHI+y3tOmY+FJ4erXcQIn1mErw0aGjskSkGiK4vVT4Br
 PzrOQHIv6n8LIHfSStla/QDxA+KnV2xkUKynp6czGifbmjbjkZg3JmHefCWHiBVy+0/D
 0YoPdh0Ezbn6s7iNd1Fs56MjXvV48Kes3L+euTKPFM94i5OWQboukBie0pGruy4Rfy9v /Q== 
Received: from ppma01fra.de.ibm.com (46.49.7a9f.ip4.static.sl-reverse.com [159.122.73.70])
	by mx0b-001b2d01.pphosted.com with ESMTP id 3dyctj06ff-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Feb 2022 21:41:29 +0000
Received: from pps.filterd (ppma01fra.de.ibm.com [127.0.0.1])
	by ppma01fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 211LaLV9017209;
	Tue, 1 Feb 2022 21:41:27 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
	by ppma01fra.de.ibm.com with ESMTP id 3dvw79f04w-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 01 Feb 2022 21:41:27 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
	by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 211LfP4H34537734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 1 Feb 2022 21:41:25 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F782AE04D;
	Tue,  1 Feb 2022 21:41:25 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 353AAAE045;
	Tue,  1 Feb 2022 21:41:23 +0000 (GMT)
Received: from [9.43.60.126] (unknown [9.43.60.126])
	by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
	Tue,  1 Feb 2022 21:41:22 +0000 (GMT)
Message-ID: <342e1a28-b06d-5289-d431-de97e10f5cce@linux.ibm.com>
Date: Wed, 2 Feb 2022 03:11:22 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH REBASED v5 2/2] spapr: nvdimm: Introduce spapr-nvdimm
 device
Content-Language: en-US
To: David Gibson <david@gibson.dropbear.id.au>
Cc: groug@kaod.org, qemu-ppc@nongnu.org, qemu-devel@nongnu.org,
        aneesh.kumar@linux.ibm.com, nvdimm@lists.linux.dev,
        kvm-ppc@vger.kernel.org
References: <162571302321.1030381.15196355582642786915.stgit@lep8c.aus.stglabs.ibm.com>
 <162571304881.1030381.2406869533148471546.stgit@lep8c.aus.stglabs.ibm.com>
 <YUl8e5NLb1Jnn5W6@yekko>
From: Shivaprasad G Bhat <sbhat@linux.ibm.com>
In-Reply-To: <YUl8e5NLb1Jnn5W6@yekko>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: FBH8La_QDftxGaFCLmORJ1_h3ME9Cni3
X-Proofpoint-GUID: FBH8La_QDftxGaFCLmORJ1_h3ME9Cni3
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-01_09,2022-02-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=940 mlxscore=0
 lowpriorityscore=0 clxscore=1015 impostorscore=0 bulkscore=0
 suspectscore=0 malwarescore=0 priorityscore=1501 spamscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202010118


On 9/21/21 12:02, David Gibson wrote:
> On Wed, Jul 07, 2021 at 09:57:31PM -0500, Shivaprasad G Bhat wrote:
>> If the device backend is not persistent memory for the nvdimm, there is
>> need for explicit IO flushes on the backend to ensure persistence.
>>
>> On SPAPR, the issue is addressed by adding a new hcall to request for
>> an explicit flush from the guest when the backend is not pmem. So, the
>> approach here is to convey when the hcall flush is required in a device
>> tree property. The guest once it knows the device backend is not pmem,
>> makes the hcall whenever flush is required.
>>
>> To set the device tree property, the patch introduces a new papr specific
>> device type inheriting the nvdimm device. When the backend doesn't have
>> pmem="yes", the device tree property "ibm,hcall-flush-required" is set,
>> and the guest makes hcall H_SCM_FLUSH requesting for an explicit flush.
>>
>> Signed-off-by: Shivaprasad G Bhat <sbhat@linux.ibm.com>
<snip>
>> @@ -91,6 +93,14 @@ bool spapr_nvdimm_validate(HotplugHandler *hotplug_dev, NVDIMMDevice *nvdimm,
>>           return false;
>>       }
>>   
>> +    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM) &&
>> +        (memory_region_get_fd(mr) < 0)) {
>> +        error_setg(errp, "spapr-nvdimm device requires the "
>> +                   "memdev %s to be of memory-backend-file type",
>> +                   object_get_canonical_path_component(OBJECT(dimm->hostmem)));
> 
> It's not obvious to me why the spapr nvdimm device has an additional
> restriction here over the regular nvdimm device.

For memory-backend-ram the fd is set to -1. The fdatasync would fail 
later. This restriction is for preventing the hcall failure later. May 
be it is intentionally allowed with nvdimms for testing purposes. Let me 
know if you want me to allow it with a dummy success return for the hcall.

> 
>> +        return false;
>> +    }
>> +
>>       return true;
>>   }
>>   
>> @@ -162,6 +172,21 @@ static int spapr_dt_nvdimm(SpaprMachineState *spapr, void *fdt,
>>                                "operating-system")));
>>       _FDT(fdt_setprop(fdt, child_offset, "ibm,cache-flush-required", NULL, 0));
>>   
>> +    if (object_dynamic_cast(OBJECT(nvdimm), TYPE_SPAPR_NVDIMM)) {
>> +        bool is_pmem = false;
>> +#ifdef CONFIG_LIBPMEM
>> +        PCDIMMDevice *dimm = PC_DIMM(nvdimm);
>> +        HostMemoryBackend *hostmem = dimm->hostmem;
>> +
>> +        is_pmem = object_property_get_bool(OBJECT(hostmem), "pmem",
>> +                                           &error_abort);
> 
> Presenting to the guest a property of the backend worries me
> slightly.  How the backends are synchronized between the source and
> destination is out of scope for qemu: is there any possibility that we
> could migrate from a host where the backend is pmem to one where it is
> not (or the reverse).
> 
> I think at the least we want a property on the spapr-nvdimm object
> which will override what's presented to the guest (which, yes, might
> mean lying to the guest).  I think that could be important for
> testing, if nothing else.

Mix configurations can be attempted on a nested setup itself.

On a side note, the attempts to use pmem=on on non-pmem backend is being 
deprecated as that is unsafe pretension effective commit cdcf766d0b0.

I see your point, adding "pmem-override"(?, suggest me if you have 
better name) to spapr-nvdimm can be helpful. Adding it to spapr-nvdimm 
device. With pmem-override "on" device tree property is added allowing 
hcall-flush even when pmem=on for the backend. This works for migration 
compatibility in such a setup.

> 
>> +#endif
>> +        if (!is_pmem) {
>> +            _FDT(fdt_setprop(fdt, child_offset, "ibm,hcall-flush-required",
>> +                             NULL, 0));
>> +        }
>> +    }
>> +
>>       return child_offset;
>>   }
>>   
>> @@ -585,7 +610,16 @@ static target_ulong h_scm_flush(PowerPCCPU *cpu, SpaprMachineState *spapr,
>>       }
>>   
>>       dimm = PC_DIMM(drc->dev);
>> +    if (!object_dynamic_cast(OBJECT(dimm), TYPE_SPAPR_NVDIMM)) {
>> +        return H_PARAMETER;
>> +    }
> 
> Hmm.  If you're going to make flushes specific to spapr nvdimms, you
> could put the queue of pending flushes into the spapr-nvdimm object,
> rather than having a global list in the machine.

Yes. I have changed the patches to move all the flush specific data 
structures into the spapr-nvdimm object.

> 
>> +
>>       backend = MEMORY_BACKEND(dimm->hostmem);
>> +#ifdef CONFIG_LIBPMEM
>> +    if (object_property_get_bool(OBJECT(backend), "pmem", &error_abort)) {
>> +        return H_UNSUPPORTED;
> 
> Could you make this not be UNSUPPORTED, but instead fake the flush for
> the pmem device?  Either as a no-op, or simulating the guest invoking
> the right cpu cache flushes?  That seems like it would be more useful:
> that way users who don't care too much about performance could just
> always do a flush hcall and not have to have another path for the
> "real" pmem case.
> 

It would actually be wrong use for kernel to attempt that. The device 
tree property is checked before setting the callback to flush in the 
kernel. If someone makes the hcall without the device tree property 
being set, it would actually be a mistaken/wrong usage.

For pmem-override=on, its better to allow this as you suggested along 
with exposing the device tree property. Will call the pmem_persist() for 
pmem backed devices. Switch between pmem_persist() or fdatasync() based 
on the backend type while flushing.


>> +    }
>> +#endif
>>       fd = memory_region_get_fd(&backend->mr);
>>   
>>       if (fd < 0) {
>> @@ -766,3 +800,15 @@ static void spapr_scm_register_types(void)

Thanks!
