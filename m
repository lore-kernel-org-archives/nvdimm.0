Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053B91E9B3A
	for <nvdimm@lists.linux.dev>; Mon, 10 Nov 2025 04:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762749312; cv=none; b=TEkXcNHpMm4o3KQUDpot12be0P/OYQRO7e+V3cAsxIAmrJYKFLr8hEs/RgBFUGgvSo1dPDvly4kCuO3chI4Pio4cYg6FK16zBIghXaFyt+FDkKYtDCjyOTbr15PRDctariAentEPgEi2+LpAukhW/XKxhUh0x1Dn2NCit2k9il0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762749312; c=relaxed/simple;
	bh=qxQcWFEZDKCs4Qp5/D2p72QlkhzRvP9ZQzqijavBSkY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=CjE2Lt0hf2NHZh8cVTiDTwwcPT4axPqhmvVb3cCHjEWRt+8Wwa68pdezemBVlmxrFyk3MBpxzIoD9vOYHmrdGy9LUDVZpkHvmz/o6utkUF49B9+Dxmyd8Ui+MVqt7ewvFK4v7eOxPmizUw9EnBu273AyoT3ldDJWrTlial3oi+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lexdT/F2; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lexdT/F2"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20251110043502epoutp04122cfca8ef666bfcbaf7aaacac145a29~2iyaqZ75z0624306243epoutp04M
	for <nvdimm@lists.linux.dev>; Mon, 10 Nov 2025 04:35:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20251110043502epoutp04122cfca8ef666bfcbaf7aaacac145a29~2iyaqZ75z0624306243epoutp04M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1762749302;
	bh=CmNfyZ8B/JPUeYZvEfmYdeSwWDFaPBDrKgPgdjjzBVA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lexdT/F24ogtLPrGWO/wlopqjnK+zpvTV+zEqTZZ9J39WZ/SzF84X4GaubWF6z8Pm
	 wFnVzlBrrRgEksm0rOkZlt6MoUZOnKcKU+ehLoBuK0KrqJBth6lm6uj/CazKxQ9SXo
	 6R68I4ZdPVOiV32hZt1uMFCrYa5AcYGDwqZeXbxc=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251110043501epcas5p3c73febf60560742c7e60fec9d89395bf~2iyaJ8NHm2710327103epcas5p3j;
	Mon, 10 Nov 2025 04:35:01 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4d4cK15SW0z2SSKj; Mon, 10 Nov
	2025 04:35:01 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251107123926epcas5p11068433443badb6b8f19acbca16ce5cc~1udf7K1ex1256612566epcas5p1P;
	Fri,  7 Nov 2025 12:39:26 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251107123919epsmtip1476716405b7dd6adf419018f5de5d3e6~1udZ3ic002787027870epsmtip1y;
	Fri,  7 Nov 2025 12:39:19 +0000 (GMT)
Date: Fri, 7 Nov 2025 18:09:12 +0530
From: Neeraj Kumar <s.neeraj@samsung.com>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com,
	a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	cpgs@samsung.com
Subject: Re: [PATCH V3 13/20] cxl/mem: Refactor cxl pmem region
 auto-assembling
Message-ID: <1983025922.01762749301758.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <361d0e84-9362-4389-a909-37878910b90f@intel.com>
X-CMS-MailID: 20251107123926epcas5p11068433443badb6b8f19acbca16ce5cc
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_a59d6_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97
References: <20250917134116.1623730-1-s.neeraj@samsung.com>
	<CGME20250917134157epcas5p1b30306bc8596b7b50548ddf3683c3b97@epcas5p1.samsung.com>
	<20250917134116.1623730-14-s.neeraj@samsung.com>
	<c7b41eb6-b946-4ac0-9ddd-e75ba4ceb636@intel.com>
	<1296674576.21759726502325.JavaMail.epsvc@epcpadp1new>
	<361d0e84-9362-4389-a909-37878910b90f@intel.com>

------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_a59d6_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 06/10/25 08:55AM, Dave Jiang wrote:
>
>
>On 9/29/25 6:30 AM, Neeraj Kumar wrote:
>> On 23/09/25 03:37PM, Dave Jiang wrote:
>>>
>>>
>>> On 9/17/25 6:41 AM, Neeraj Kumar wrote:
>>>> In 84ec985944ef3, devm_cxl_add_nvdimm() sequence was changed and called
>>>> before devm_cxl_add_endpoint(). It's because cxl pmem region auto-assembly
>>>> used to get called at last in cxl_endpoint_port_probe(), which requires
>>>> cxl_nvd presence.
>>>>
>>>> For cxl region persistency, region creation happens during nvdimm_probe
>>>> which need the completion of endpoint probe.
>>>>
>>>> In order to accommodate both cxl pmem region auto-assembly and cxl region
>>>> persistency, refactored following
>>>>
>>>> 1. Re-Sequence devm_cxl_add_nvdimm() after devm_cxl_add_endpoint(). This
>>>>    will be called only after successful completion of endpoint probe.
>>>>
>>>> 2. Moved cxl pmem region auto-assembly from cxl_endpoint_port_probe() to
>>>>    cxl_mem_probe() after devm_cxl_add_nvdimm(). It gurantees both the
>>>>    completion of endpoint probe and cxl_nvd presence before its call.
>>>
>>> Given that we are going forward with this implementation [1] from Dan and drivers like the type2 enabling are going to be using it as well, can you please consider converting this change to Dan's mechanism instead of creating a whole new one?
>>>
>>> I think the region discovery can be done via the ops->probe() callback. Thanks.
>>>
>>> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/commit/?h=for-6.18/cxl-probe-order&id=88aec5ea7a24da00dc92c7778df4851fe4fd3ec6
>>>
>>> DJ
>>>
>>
>> Sure, Let me revisit this.
>> It seems [1] is there in seperate branch "for-6.18/cxl-probe-order", and not yet merged into next, right?
>
>Right. I believe Smita and Alejandro are using that as well. Depending on who gets there first. We can setup an immutable branch at some point.
>
>[1]: https://lore.kernel.org/linux-cxl/20250822034202.26896-1-Smita.KoralahalliChannabasappa@amd.com/T/#t
>
>DJ

Hi Dave,

As per Dan's [1] newly introduced infra, Following is my understanding.

Currently cxl_pci does not care about the attach state of the cxl_memdev
because all generic memory expansion functionality can be handled by the
cxl_core. For accelerators, the driver needs to know and perform driver
specific initialization if CXL is available, or exectute a fallback to PCIe
only operation.

Dan's new infra is needed for CXL accelerator device drivers that need to
make decisions about enabling CXL dependent functionality in the device, or
falling back to PCIe-only operation.

During cxl_pci_probe() we call devm_cxl_add_memdev(struct cxl_memdev_ops *ops)
where function pointer as ops gets registered which gets called in cxl_mem_probe()
using cxlmd->ops->probe()

The probe callback runs after the port topology is successfully attached for
the given memdev.

So to use this infra we have to pass cxl_region_discovery() as ops parameter
of devm_cxl_add_memdev() getting called from cxl_pci_probe().
  
In this patch-set cxl_region_discovery() signature is different from cxlmd->ops->probe()

    {{{
	void cxl_region_discovery(struct cxl_port *port)
	{
         	device_for_each_child(&port->dev, NULL, discover_region);
	}

	struct cxl_memdev_ops {
	        int (*probe)(struct cxl_memdev *cxlmd);
	};
    }}}

Even after changing the signature of cxl_region_discovery() as per cxlmd->ops->probe()
may create problem as when the ops->probe() fails, then it will halts the probe sequence
of cxl_pci_probe()

It is because discover_region() may fail if two memdevs are participating into one region

Also, region auto assembly is mandatory functionality which creates region
if (cxled->state == CXL_DECODER_STATE_AUTO) gets satisfied.

Currently region auto assembly (added by a32320b71f085) happens after successfull
enumeration of endpoint decoders at cxl_endpoint_port_probe(), which I have moved at
cxl_mem_probe() after devm_cxl_add_nvdimm() which prepares cxl_nvd infra required by it.

As discussed in [1], this patch-set does the movement of auto region assembly from
cxl_endpoint_port_probe() to cxl_mem_probe() and resolved the conflicting dependency
of cxl_nvd infra required by both region creation using LSA and auto region assembly.

[1]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/commit/?h=for-6.18/cxl-probe-order&id=88aec5ea7a24da00dc92c7778df4851fe4fd3ec6 
[2]: https://lore.kernel.org/linux-cxl/1931444790.41752909482841.JavaMail.epsvc@epcpadp2new/

Please let me know if my understanding is correct or I am missing something?


Regards,
Neeraj


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_a59d6_
Content-Type: text/plain; charset="utf-8"


------fevm_dXp0U54qslEOU8oiqO.VnigTQz743t4hqwhjBnK2JlQ=_a59d6_--

