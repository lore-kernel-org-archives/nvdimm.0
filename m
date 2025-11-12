Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3931A340280
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 15:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762962949; cv=none; b=dzP1fa9nijEg/W2vVNpiRCD6PFxKWAVPkboWOyUoBvC/10L5G64uIsyMbw9PeRH8N5fQA0tjxaOCLySJB2pnkrtmTY3eH2sP2rHGAALTdZOD/5c1MFPzB3GVCYEh4UwFqU9ST1UrJS+2Z/Hd09082mcHzfoBIGd2Z3siG5z6KGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762962949; c=relaxed/simple;
	bh=XBvdmJ37bzVPfaNJQdFZ0mHd+DP97BaYdjtePvKH4rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y2Bt5ltENA5tsC4rz32tLOtG9INv4sL3Fgju2Dt6f9tSzgVIZ6iQfSSQKmZsCq0JFQPf2QVkqkuj3v8aLQo1O/YF6y23zWEuo8quik2lGzwEtGfosiYZHDhtDNNjPUAztAnIupAOk6Yu4VW76GJMOA1WmDi8S9AQf4WLDZ8nP14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FsBY6DDI; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FsBY6DDI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1762962947; x=1794498947;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=XBvdmJ37bzVPfaNJQdFZ0mHd+DP97BaYdjtePvKH4rw=;
  b=FsBY6DDIF5Dz2EIBAjF9FWwhzyG23LtnJJEeJap3X4pL/iCa9/jbd3O4
   Iejls7fi1aWypKPWlpIO+K0MHW6kHoMGCplpf+HGUuvbU3BDuawUTLLBY
   1xTuWIXZE7Xo8HnxcJG2rd7D+m5Rvcl25jIV0lHcRUrEkje0faS5Aasps
   LHzlDlwEPYNREaAfM/6pI8wBkXpxvazVSuYjsrVaYJgzdF9PzXssSX1Qc
   yFsb6Vs/NIUIvNBXc/vnDHCH7/oM9eSzipp8ZyduZ56SrjRfrd0CVMTg8
   sYK16BAzM6y8s/QO8DjAvrPttnOWNmlXYkJql2ueiDCYVKA7HcT435skx
   g==;
X-CSE-ConnectionGUID: 9OdF5vZwRjSckyMrSAJtkA==
X-CSE-MsgGUID: jm/G36+KTX2gIzhtVe/jWQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11611"; a="67630322"
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="67630322"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 07:55:46 -0800
X-CSE-ConnectionGUID: JORSUiZkR5i/BhCSGCphTw==
X-CSE-MsgGUID: QtTUdJYtQGC5vM30Ae7zYg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.19,299,1754982000"; 
   d="scan'208";a="226529653"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO [10.125.108.30]) ([10.125.108.30])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2025 07:55:46 -0800
Message-ID: <a204bc0e-1111-4ff9-a8d2-eeb8b7b9fe8d@intel.com>
Date: Wed, 12 Nov 2025 08:55:45 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
To: Neeraj Kumar <s.neeraj@samsung.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, gost.dev@samsung.com,
 a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
 cpgs@samsung.com
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
 <CGME20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97@epcas5p1.samsung.com>
 <20250917134116.1623730-14-s.neeraj@samsung.com>
 <c7b41eb6-b946-4ac0-9ddd-e75ba4ceb636@intel.com>
 <1296674576.21759726502325.JavaMail.epsvc@epcpadp1new>
 <361d0e84-9362-4389-a909-37878910b90f@intel.com>
 <1983025922.01762749301758.JavaMail.epsvc@epcpadp1new>
From: Dave Jiang <dave.jiang@intel.com>
Content-Language: en-US
In-Reply-To: <1983025922.01762749301758.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 11/7/25 5:39 AM, Neeraj Kumar wrote:
> On 06/10/25 08:55AM, Dave Jiang wrote:
>>
>>
>> On 9/29/25 6:30 AM, Neeraj Kumar wrote:
>>> On 23/09/25 03:37PM, Dave Jiang wrote:
>>>>
>>>>
>>>> On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>>>>> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
>>>>> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
>>>>> used to get called at last in cxl_endpoint_port_probe(), which requires
>>>>> cxl_nvd presence.
>>>>>
>>>>> For cxl region persistency, region creation happens during nvdimm_probe
>>>>> which need the completion of endpoint probe.
>>>>>
>>>>> In order to accommodate both cxl pmem region auto-assembly and cxl region
>>>>> persistency, refactored following
>>>>>
>>>>> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>>>>>    will be called only after successful completion of endpoint probe.
>>>>>
>>>>> 2. Moved cxl pmem region auto-assembly from cxl_endpoint_port_probe() to
>>>>>    cxl_mem_probe() after devm_cxl_add_nvdimm(). It gurantees both the
>>>>>    completion of endpoint probe and cxl_nvd presence before its call.
>>>>
>>>> Given that we are going forward with this implementation [1] from Dan and drivers like the type2 enabling are going to be using it as well, can you please consider converting this change to Dan's mechanism instead of creating a whole new one?
>>>>
>>>> I think the region discovery can be done via the ops->probe() callback. Thanks.
>>>>
>>>> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/commit/?h=for-6.18/cxl-probe-order&id=88aec5ea7a24da00dc92c7778df4851fe4fd3ec6
>>>>
>>>> DJ
>>>>
>>>
>>> Sure, Let me revisit this.
>>> It seems [1] is there in seperate branch "for-6.18/cxl-probe-order", and not yet merged into next, right?
>>
>> Right. I believe Smita and Alejandro are using that as well. Depending on who gets there first. We can setup an immutable branch at some point.
>>
>> [1]: https://lore.kernel.org/linux-cxl/20250822034202.26896-1-Smita.KoralahalliChannabasappa@amd.com/T/#t
>>
>> DJ
> 
> Hi Dave,
> 
> As per Dan's [1] newly introduced infra, Following is my understanding.
> 
> Currently cxl_pci does not care about the attach state of the cxl_memdev
> because all generic memory expansion functionality can be handled by the
> cxl_core. For accelerators, the driver needs to know and perform driver
> specific initialization if CXL is available, or exectute a fallback to PCIe
> only operation.
> 
> Dan's new infra is needed for CXL accelerator device drivers that need to
> make decisions about enabling CXL dependent functionality in the device, or
> falling back to PCIe-only operation.
> 
> During cxl_pci_probe() we call devm_cxl_add_memdev(struct cxl_memdev_ops *ops)
> where function pointer as ops gets registered which gets called in cxl_mem_probe()
> using cxlmd->ops->probe()
> 
> The probe callback runs after the port topology is successfully attached for
> the given memdev.
> 
> So to use this infra we have to pass cxl_region_discovery() as ops parameter
> of devm_cxl_add_memdev() getting called from cxl_pci_probe().
>  
> In this patch-set cxl_region_discovery() signature is different from cxlmd->ops->probe()
> 
>    {{{
>     void cxl_region_discovery(struct cxl_port *port)
>     {
>             device_for_each_child(&port->dev, NULL, discover_region);
>     }
> 
>     struct cxl_memdev_ops {
>             int (*probe)(struct cxl_memdev *cxlmd);
>     };
>    }}}
> 
> Even after changing the signature of cxl_region_discovery() as per cxlmd->ops->probe()
> may create problem as when the ops->probe() fails, then it will halts the probe sequence
> of cxl_pci_probe()
> 
> It is because discover_region() may fail if two memdevs are participating into one region

While discover_region() may fail, the return value is ignored. The current code disregards failures from device_for_each_child(). And also above, cxl_region_discovery() returns void. So I don't follow how ops->probe() would fail if we ignore errors from discover_region().

DJ

> 
> Also, region auto assembly is mandatory functionality which creates region
> if (cxled->state == CXL_DECODER_STATE_AUTO) gets satisfied.
> 
> Currently region auto assembly (added by a32320b71f085) happens after successfull
> enumeration of endpoint decoders at cxl_endpoint_port_probe(), which I have moved at
> cxl_mem_probe() after devm_cxl_add_nvdimm() which prepares cxl_nvd infra required by it.
> 
> As discussed in [1], this patch-set does the movement of auto region assembly from
> cxl_endpoint_port_probe() to cxl_mem_probe() and resolved the conflicting dependency
> of cxl_nvd infra required by both region creation using LSA and auto region assembly.
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/commit/?h=for-6.18/cxl-probe-order&id=88aec5ea7a24da00dc92c7778df4851fe4fd3ec6 [2]: https://lore.kernel.org/linux-cxl/1931444790.41752909482841.JavaMail.epsvc@epcpadp2new/
> 
> Please let me know if my understanding is correct or I am missing something?
> 
> 
> Regards,
> Neeraj
> 
>
