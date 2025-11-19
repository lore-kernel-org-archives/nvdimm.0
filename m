Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233D92E0927
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763538800; cv=none; b=I75RqXvaNROwzg8/41WfEpLWNmIL6UFTiO2cEkxz50T5wXPGyY4J6gaJDWnBKTEvL8xrchTpCAszB+veS56Tmky4vVCiiF6GPk7xw2yBR4RF7f574rVtWtHqzNb+u9eczHKOkwjN9M0mR6KF8PE4eCN1xz7sCR+6DU7qGVQji24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763538800; c=relaxed/simple;
	bh=OoCL1vidC1ntP9kYRf1m8AIPcicVLQBDHrkJGLprSns=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=d+V0uvc9iRuhUnFvRDLbbl8YC7sqt+85Gz7vOh29KOoiaWcfbD5FxKSmw0jAuEK9Wls3wK481Soz1Sq7CWNUIUjADAvmx8HwIg1rhKE7DKaLWCpTdubSym2DAvhGdIl/zi214Mr7YUwb3Vu5XgkzB0WWN6OiYfKzFVXa9NiBlTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NHveG0Gp; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NHveG0Gp"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20251119075309epoutp0128e8051b4a980fbf77906ea6bca7c2d9~5WS9ay6dR0084400844epoutp01G
	for <nvdimm@lists.linux.dev>; Wed, 19 Nov 2025 07:53:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20251119075309epoutp0128e8051b4a980fbf77906ea6bca7c2d9~5WS9ay6dR0084400844epoutp01G
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1763538789;
	bh=uuYvamklocyJ1nt6pfnCiZclsSZY1+fnIhhnYcUECwE=;
	h=From:To:Cc:Subject:Date:References:From;
	b=NHveG0GpTjnytAzQ0GeNt7Uo/sbb8yrKinrpGxBhMErNwYe04svIc2nn+MiTvifIo
	 hQJNQqXbfD34tDFSIxucVlFDtq6/gDQWnArBCU0QwsbhoxW2kmysg/uS8RZvSx1S8G
	 HeD81eI1IU6V8110gLah+s86OEnXphHLh40JEJms=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20251119075308epcas5p1363d19d3781b21ec66dc9207f0bfaffb~5WS9G1Gin3162631626epcas5p1A;
	Wed, 19 Nov 2025 07:53:08 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.95]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4dBDHR2bQDz6B9mN; Wed, 19 Nov
	2025 07:53:07 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251119075306epcas5p22a87515de65a3c668275b394cdea83b0~5WS65--3F0870808708epcas5p2t;
	Wed, 19 Nov 2025 07:53:06 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251119075305epsmtip15da946aa7a10f362be19e9dbf13ae1f5~5WS5xQKv92565625656epsmtip1_;
	Wed, 19 Nov 2025 07:53:04 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V4 00/17] Add CXL LSA 2.1 format support in nvdimm and cxl
 pmem
Date: Wed, 19 Nov 2025 13:22:38 +0530
Message-Id: <20251119075255.2637388-1-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251119075306epcas5p22a87515de65a3c668275b394cdea83b0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251119075306epcas5p22a87515de65a3c668275b394cdea83b0
References: <CGME20251119075306epcas5p22a87515de65a3c668275b394cdea83b0@epcas5p2.samsung.com>

Introduction:
=============
CXL Persistent Memory (Pmem) devices region, namespace and content must be
persistent across system reboot. In order to achieve this persistency, it
uses Label Storage Area (LSA) to store respective metadata. During system
reboot, stored metadata in LSA is used to bring back the region, namespace
and content of CXL device in its previous state.
CXL specification provides Get_LSA (4102h) and Set_LSA (4103h) mailbox
commands to access the LSA area. nvdimm driver is using same commands to
get/set LSA data.

There are three types of LSA format and these are part of following
specifications: 
 - v1.1: https://pmem.io/documents/NVDIMM_Namespace_Spec.pdf
 - v1.2: https://uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf
 - v2.1: https://computeexpresslink.org/wp-content/uploads/2024/02/CXL-2.0-Specification.pdf

Basic differences between these LSA formats:
 - v1.1: Support Namespace persistency. Size of Namespace Label is 128 bytes
 - v1.2: Support Namespace persistency. Size of Namespace Label is 256 bytes
 - v2.1: Support Namespace and Region persistency. Size of Namespace and
   Region Label is 256 bytes.

Linux nvdimm driver supports only v1.1 and v1.2 LSA format. CXL pmem device
require support of LSA v2.1 format for region and namespace persistency.
Initial support of LSA 2.1 was add in [1].

This patchset adds support of LSA 2.1 in nvdimm and cxl pmem driver.

Patch 1:     Introduce NDD_CXL_LABEL flag and Update cxl label index as per v2.1
Patch 2:     Skip the need for 'interleave-set cookie' for LSA 2.1 support
Patch 3-9:   Introduce region label and update namespace label as per LSA 2.1
Patch 10:    Refactor cxl pmem region auto assembly using Dan's Infra [2]
Patch 11-12: Save cxl region info in LSA and region recreation during reboot
Patch 13:14: Segregate out cxl pmem region code from region.c to pmem_region.c
Patch 15:    Introduce cxl region addition/deletion attributes
Patch 16-17: Add support of cxl pmem region re-creation from CXL as per LSA 2.1

Pre-requisite:
==============
This patch series has dependency on Dan's Infra [2]

Testing:
========
In order to test this patchset, I also added the support of LSA v2.1 format
in ndctl. ndctl changes are available at [3]. After review, I’ll push in
ndctl repo for community review.

1. Used Qemu using following CXL topology
   M2="-object memory-backend-file,id=cxl-mem1,share=on,mem-path=$TMP_DIR/cxltest.raw,size=512M \
       -object memory-backend-file,id=cxl-lsa1,share=on,mem-path=$TMP_DIR/lsa.raw,size=1M \
       -object memory-backend-file,id=cxl-mem2,share=on,mem-path=$TMP_DIR/cxltest2.raw,size=512M \
       -object memory-backend-file,id=cxl-lsa2,share=on,mem-path=$TMP_DIR/lsa2.raw,size=1M \
       -device pxb-cxl,bus_nr=10,bus=pcie.0,id=cxl.1 \
       -device cxl-rp,port=1,bus=cxl.1,id=root_port11,chassis=0,slot=1 \
       -device cxl-type3,bus=root_port11,memdev=cxl-mem1,lsa=cxl-lsa1,id=cxl-pmem1,sn=1 \
       -device cxl-rp,port=2,bus=cxl.1,id=root_port12,chassis=0,slot=2 \
       -device cxl-type3,bus=root_port12,memdev=cxl-mem2,lsa=cxl-lsa2,id=cxl-pmem2,sn=2 \
       -M cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=4G,cxl-fmw.0.interleave-granularity=8k"

2. Create cxl region on both devices
	cxl create-region -d decoder0.0 -m mem0
	cxl create-region -d decoder0.0 -m mem1

	root@QEMUCXL6060pmem:~# cxl list
	[
	  {
	    "memdevs":[
	      {
	        "memdev":"mem0",
	        "pmem_size":536870912,
	        "serial":2,
	        "host":"0000:0c:00.0",
	        "firmware_version":"BWFW VERSION 00"
	      },
	      {
	        "memdev":"mem1",
	        "pmem_size":536870912,
	        "serial":1,
	        "host":"0000:0b:00.0",
	        "firmware_version":"BWFW VERSION 00"
	      }
	    ]
	  },
	  {
	    "regions":[
	      {
	        "region":"region0",
	        "resource":45365592064,
	        "size":536870912,
	        "type":"pmem",
	        "interleave_ways":1,
	        "interleave_granularity":256,
	        "decode_state":"commit",
	        "qos_class_mismatch":true
	      },
	      {
	        "region":"region1",
	        "resource":45902462976,
	        "size":536870912,
	        "type":"pmem",
	        "interleave_ways":1,
	        "interleave_granularity":256,
	        "decode_state":"commit",
	        "qos_class_mismatch":true
	      }
	    ]
	  }
	]

3. Re-Start Qemu and we could see cxl region persistency using "cxl list"

4. Create namespace for both regions
	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region0 --size=128M
	{
	  "dev":"namespace0.0",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"124.00 MiB (130.02 MB)",
	  "uuid":"8a125dcb-f992-406d-b3ad-be82fc518f05",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem0"
	}
	
	real    0m31.866s
	user    0m0.183s
	sys     0m14.855s

	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region1 --size=256M
	{
	  "dev":"namespace1.0",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"250.00 MiB (262.14 MB)",
	  "uuid":"8e16d950-c11d-4253-94a0-5b2928926433",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem1"
	}
	
	real    0m44.359s
	user    0m0.196s
	sys     0m26.768s

	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region0 --size=256M
	{
	  "dev":"namespace0.1",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"250.00 MiB (262.14 MB)",
	  "uuid":"f3170bfe-548a-4ce4-ae00-145a24e70426",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem0.1"
	}
	
	real    0m44.004s
	user    0m0.220s
	sys     0m25.711s

	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region1 --size=128M
	{
	  "dev":"namespace1.1",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"124.00 MiB (130.02 MB)",
	  "uuid":"6318d2d9-bc78-4896-84f9-6c18c3a8f58c",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem1.1"
	}
	
	real    0m36.612s
	user    0m0.225s
	sys     0m16.457s

	root@QEMUCXL6060pmem:~# ndctl list
	[
	  {
	    "dev":"namespace1.0",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":262144000,
	    "uuid":"e07564eb-6653-4d67-ab07-434c22474001",
	    "sector_size":512,
	    "align":2097152,
	    "blockdev":"pmem1"
	  },
	  {
	    "dev":"namespace1.1",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":130023424,
	    "uuid":"27dfd65a-c428-426a-8316-f340a59e0671",
	    "sector_size":512,
	    "align":2097152,
	    "blockdev":"pmem1.1"
	  },
	  {
	    "dev":"namespace0.1",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":130023424,
	    "uuid":"689b4135-668d-4885-b138-b86f27d7602f",
	    "sector_size":512,
	    "align":2097152,
	    "blockdev":"pmem0.1"
	  },
	  {
	    "dev":"namespace0.0",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":262144000,
	    "uuid":"ed15c67a-842d-4d5d-8996-be3aa24985e4",
	    "sector_size":512,
	    "align":2097152,
	    "blockdev":"pmem0"
	  }
	]

5. Re-Start Qemu and we could see
	- Region persistency using "cxl list"
	- Namespace persistency using "ndctl list" and cat /proc/iomem

	root@QEMUCXL6060pmem:~# cat /proc/iomem
	
	a90000000-b8fffffff : CXL Window 0
	  a90000000-aafffffff : Persistent Memory
	    a90000000-aafffffff : region0
	      a90000000-a97ffffff : namespace0.0
	      a98000000-aa7ffffff : namespace0.1
	  ab0000000-acfffffff : Persistent Memory
	    ab0000000-acfffffff : region1
	      ab0000000-abfffffff : namespace1.0
	      ac0000000-ac7ffffff : namespace1.1
	

	- NOTE: We can see some lag in restart. Look at Observesation below

6. Also verify LSA version using "ndctl read-labels -j nmem0"
	root@QEMUCXL6060pmem:~# ndctl read-labels -j nmem0
	{
	  "dev":"nmem0",
	  "index":[
	    {
	      "signature":"NAMESPACE_INDEX",
	      "major":2,
	      "minor":1,
	      "labelsize":256,
	      "seq":2,
	      "nslot":4090
	    },
	    {
	      "signature":"NAMESPACE_INDEX",
	      "major":2,
	      "minor":1,
	      "labelsize":256,
	      "seq":1,
	      "nslot":4090
	    }
	  ],
	  "label":[
	    {
	      "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
	      "uuid":"cbb3fe1e-9345-4ae7-95ca-2638db27ee7d",
	      "name":"",
	      "flags":8,
	      "nrange":1,
	      "position":0,
	      "dpa":134217728,
	      "rawsize":268435456,
	      "slot":0,
	      "align":0,
	      "region_uuid":"50d806c8-fd11-49eb-b19e-77fc67f6364b",
	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
	      "lbasize":512
	    },
	    {
	      "type":"529d7c61-da07-47c4-a93f-ecdf2c06f444",
	      "uuid":"50d806c8-fd11-49eb-b19e-77fc67f6364b",
	      "flags":0,
	      "nlabel":1,
	      "position":0,
	      "dpa":0,
	      "rawsize":536870912,
	      "hpa":45365592064,
	      "slot":1,
	      "interleave granularity":256,
	      "align":0
	    },
	    {
	      "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
	      "uuid":"d9ef8d35-ef84-4111-b302-bce53c94a2ad",
	      "name":"",
	      "flags":0,
	      "nrange":1,
	      "position":0,
	      "dpa":0,
	      "rawsize":134217728,
	      "slot":2,
	      "align":0,
	      "region_uuid":"50d806c8-fd11-49eb-b19e-77fc67f6364b",
	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
	      "lbasize":512
	    },
	    {
	      "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
	      "uuid":"cbb3fe1e-9345-4ae7-95ca-2638db27ee7d",
	      "name":"",
	      "flags":0,
	      "nrange":1,
	      "position":0,
	      "dpa":134217728,
	      "rawsize":268435456,
	      "slot":3,
	      "align":0,
	      "region_uuid":"50d806c8-fd11-49eb-b19e-77fc67f6364b",
	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
	      "lbasize":512
	    }
	  ]
	}
	read 1 nmem

	- NOTE: We have following UUID types as per CXL Spec
		"type":"529d7c61-da07-47c4-a93f-ecdf2c06f444" is region label
		"type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c" is namespace label


Limitation (WIP):
================
Current changes only support interleave way == 1


Observation:
============
First time namespace creation using ndctl takes around 10 to 20 second time
while executing "devm_memremap_pages" at [4]

As using this patchset, after auto region creation, namespace creation is
happening in boot sequence (if nvdimm and cxl drivers are static), It is
therefore boot sequence is increased by around 10 to 20 sec.

Changes:
========
Changes in v3->v4
-----------------
[MISC Changes]
- Reduce Patch Series Commits from 20 to 17
- Re-arranged few commits
[PATCH 01/17]
- Rename nvdimm_region_label_supported() [Dave]
- Add Jonathan RB tag
- Add Dave RB tag
[PATCH 02/17]
- Add Dave RB tag
[PATCH 03/17]
- Merge v3 patch 05-06/20 in v4 patch 03/17
- Use pre-parsed namespace and region labels uuids - [Dave]
- Remove dubious typecasting [Jonathan]
- Add 'uuid_t label_uuid' member in ' struct nd_label_ent' [Dave]
- Introduce to_lsa_label() along with to_label()
[PATCH 04/17]
- Re-arrange v3 patch 08/20 in v4 patch 04/17
- Create static string table enumerated by 'enum label_type' [Dave]
- Elaborate commit message [Alison]
- Replace use of to_label() with new to_lsa_label()
[PATCH 07/17]
- Immediate return -EBUSY in region label deletion [Dave]
[PATCH 09/17]
- Return error early and return the success case last [Dave]
[PATCH 10/17]
- Call region discovery via the ops->probe() callback using [2] [Dave]
[PATCH 11/17]
- Conform to existing style in the subsystem [Dave]
- Remove mode from devm_cxl_pmem_add_region() [Dave]
- Fix error return from EINVAL to EOPNOTSUPP [Dave]
[PATCH 13/17]
- Prep patch with just code movement from region.c to pmem_region.c [Dave]
[PATCH 13/17]
- Introduce CONFIG_CXL_PMEM_REGION for core/pmem_region.c [Dave]
[PATCH 15/17]
- Return error early and return the success case last [Dave]
- Change region_label_state as enum in struct cxl_region_params [Dave]
[PATCH 16/17]
- Caller release the device reference [Dave]
- Add is_endpoint_decoder() check in match_free_ep_decoder [Dave]
- Use dev_dbg() instead of dev_info() in create_pmem_region() [Dave]
- Use dev_warn() instead of dev_info() in create_pmem_region() [Dave] 

Previous Series:
----------------
- Find v3 link at [5]
- Find v2 link at [6]
- v1 patch-set was broken. Find the v1 links at [7] and [8]


[1]: https://lore.kernel.org/all/163116432405.2460985.5547867384570123403.stgit@dwillia2-desk3.amr.corp.intel.com/
[2]: https://git.kernel.org/pub/scm/linux/kernel/git/cxl/cxl.git/patch/?id=ab70c6227ee6165a562c215d9dcb4a1c55620d5d
[3]: https://github.com/neerajoss/ndctl/commits/linux-cxl/V1_CXL_LSA_2.1_Support/
[4]: https://elixir.bootlin.com/linux/v6.13.7/source/drivers/nvdimm/pmem.c#L520
[5]: https://lore.kernel.org/linux-cxl/20250917134116.1623730-1-s.neeraj@samsung.com/ 
[6]: https://lore.kernel.org/linux-cxl/20250730121209.303202-1-s.neeraj@samsung.com/ 
[7] v1 Cover Letter: https://lore.kernel.org/linux-cxl/1931444790.41750165203442.JavaMail.epsvc@epcpadp1new/
[8] v1 Rest Thread: https://lore.kernel.org/linux-cxl/158453976.61750165203630.JavaMail.epsvc@epcpadp1new/


Neeraj Kumar (17):
  nvdimm/label: Introduce NDD_REGION_LABELING flag to set region label
  nvdimm/label: CXL labels skip the need for 'interleave-set cookie'
  nvdimm/label: Add namespace/region label support as per LSA 2.1
  nvdimm/label: Include region label in slot validation
  nvdimm/label: Skip region label during ns label DPA reservation
  nvdimm/label: Preserve region label during namespace creation
  nvdimm/label: Add region label delete support
  nvdimm/label: Preserve cxl region information from region label
  nvdimm/label: Export routine to fetch region information
  cxl/mem: Refactor cxl pmem region auto-assembling
  cxl/region: Add devm_cxl_pmem_add_region() for pmem region creation
  cxl/pmem: Preserve region information into nd_set
  cxl/pmem_region: Prep patch to accommodate pmem_region attributes
  cxl/pmem_region: Introduce CONFIG_CXL_PMEM_REGION for core/pmem_region.c
  cxl/pmem_region: Add sysfs attribute cxl region label updation/deletion
  cxl/pmem_region: Create pmem region using information parsed from LSA
  cxl/pmem: Add CXL LSA 2.1 support in cxl pmem

 Documentation/ABI/testing/sysfs-bus-cxl |  22 +
 drivers/cxl/Kconfig                     |  15 +
 drivers/cxl/core/Makefile               |   1 +
 drivers/cxl/core/core.h                 |  35 +-
 drivers/cxl/core/pmem_region.c          | 390 ++++++++++++++++
 drivers/cxl/core/region.c               | 364 +++++++--------
 drivers/cxl/cxl.h                       |  41 +-
 drivers/cxl/mem.c                       |  18 +-
 drivers/cxl/pci.c                       |   4 +-
 drivers/cxl/pmem.c                      |  15 +-
 drivers/cxl/port.c                      |  39 +-
 drivers/nvdimm/dimm.c                   |   5 +
 drivers/nvdimm/dimm_devs.c              |  25 +
 drivers/nvdimm/label.c                  | 579 ++++++++++++++++++++----
 drivers/nvdimm/label.h                  |  18 +-
 drivers/nvdimm/namespace_devs.c         |  92 +++-
 drivers/nvdimm/nd-core.h                |   2 +
 drivers/nvdimm/nd.h                     |  79 ++++
 drivers/nvdimm/region_devs.c            |  10 +
 include/linux/libnvdimm.h               |  28 ++
 tools/testing/cxl/Kbuild                |   1 +
 21 files changed, 1413 insertions(+), 370 deletions(-)
 create mode 100644 drivers/cxl/core/pmem_region.c


base-commit: ea5514e300568cbe8f19431c3e424d4791db8291
prerequisite-patch-id: f6e07504b17ccf39d9486352b6f7305a03897863
prerequisite-patch-id: cd6bad0c8b993bb59369941905f418f3b799c89d
prerequisite-patch-id: 08ebdae0888c0a2631c3b26990679a0261f34f14
prerequisite-patch-id: 42c75ec8c08c7c8518024f46d31eb114f95a1bac
-- 
2.34.1

