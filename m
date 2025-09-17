Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB71B30AACA
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115828; cv=none; b=I2RmtJrrqO7nSiY6iaAz0H0hlD1wQc/852sxEJWJZJg5y/SQde2LcgREy2Sc9AXcK4zJf6o4BelAPRDpSAHqWsu+AbOuILcRkaz/G+sKnPLnv+jKa2DwsKcWum3dLLShQYLpBNoWNDOpg6ywxRJ5bd0HQyBxiNuQCbJfZ3lNMJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115828; c=relaxed/simple;
	bh=cri4ZLrQ8k/OyXCTv6AWfwEotmZRbjBD3L8BK3gOOz0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=m5b2ew9oOxtHy2g39e/O/qwIYRvDzwWjy7ASlAxJMJ9kSv+EPfNOoBEyvp8UJg+GzJuBzHkG9AsCrjz3K08jmAuGSaFitPhroddGzpH0n4+RqtcftcLEjItV6uj5fK78m8xp30ZThEryhUtK2HFBQ496RE2uP7VKRRYUtOYgCeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vcCKxUV2; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vcCKxUV2"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250917133021epoutp01e5e44a677f3060490159d4d8abd62b9c~mFQZiWRKn2083420834epoutp01g
	for <nvdimm@lists.linux.dev>; Wed, 17 Sep 2025 13:30:21 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250917133021epoutp01e5e44a677f3060490159d4d8abd62b9c~mFQZiWRKn2083420834epoutp01g
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1758115821;
	bh=83puCrk+Lpim3Ubd9lL/cK0apKQjtFv5CBv6PBUm5HU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=vcCKxUV2sOabDbpvpzFAHM21VhR2uwJoNzAgZzLFWlS6LWqVzkQ88a2Blt2xj7om5
	 K/LeyHM4o2A61W5mV2mbCub2AUB9Amuw3mgrgB2WLhH36mVl9ji6bV/P4/0WUPPkNk
	 pGTQc9lEnB4pr1WjgHvuLEnr/lrB3+5KTdYyXyo8=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250917133021epcas5p325001bfb5a0140e89bf1914d636ff477~mFQZPrm0f1910319103epcas5p3G;
	Wed, 17 Sep 2025 13:30:21 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.86]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4cRflc37PDz6B9m6; Wed, 17 Sep
	2025 13:30:20 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250917133019epcas5p2310450fd207693b909b23bf818cd12dc~mFQXtfc8A0428204282epcas5p2U;
	Wed, 17 Sep 2025 13:30:19 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250917133016epsmtip199ed203d7a5cf5f68e211d0540f2b632~mFQUoARov0528305283epsmtip1b;
	Wed, 17 Sep 2025 13:30:16 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V3 00/20] Add CXL LSA 2.1 format support in nvdimm and cxl
 pmem
Date: Wed, 17 Sep 2025 18:59:20 +0530
Message-Id: <20250917132940.1566437-1-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250917133019epcas5p2310450fd207693b909b23bf818cd12dc
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250917133019epcas5p2310450fd207693b909b23bf818cd12dc
References: <CGME20250917133019epcas5p2310450fd207693b909b23bf818cd12dc@epcas5p2.samsung.com>

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

Patch 1:     Introduce NDD_REGION_LABELING flag and Update cxl label index as per v2.1
Patch 2-4:   Update namespace label as per v2.1 along with code optimization
Patch 5-12:  Introduce cxl region labels and modify existing change accordingly
Patch 13:    Refactor cxl pmem region auto assembly
Patch 14-18: Save cxl region info in LSA and region recreation during reboot
Patch 19:    Segregate out cxl pmem region code from region.c to pmem_region.c
Patch 20:    Introduce cxl region addition/deletion attributes


Testing:
========
In order to test this patchset, I also added the support of LSA v2.1 format
in ndctl. ndctl changes are available at [2]. After review, I’ll push in
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
	

	- NOTE: We can see some lag in restart, Its WIP

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


Limitation (TODO):
==================
Current changes only support interleave way == 1


Observation:
============
First time namespace creation using ndctl takes around 10 to 20 second time
while executing "devm_memremap_pages" at [3]

As using this patchset, after auto region creation, namespace creation is
happening in boot sequence (if nvdimm and cxl drivers are static), It is
therefore boot sequence is increased by around 10 to 20 sec.

Changes
=======
Changes from v2->v3
-------------------
- Find v2 link at [6]
[MISC Changes]
- Drop v2 prep patch 02/20 to avoid renaming noise [Jonathan/Dave/Ira]
- Introduce v3 patch 03/20 to fix nd_label_base() signature [Dave]
- Introduce v3 patch 04/20 to update mutex_lock() with guard(mutex)() [Ira]
- Re-arrange v2 patch 04/20 to v3 patch 02/20
- Re-arrange v2 patch 03/20 to v3 patch 05/20
- Re-arrange v2 patch 12/20 to v3 patch 10/20
[PATCH 01/20]
- Rename NDD_CXL_LABEL to NDD_REGION_LABELING [Jonathan/Dave]
[PATCH 02/20]
- Elaborate comment message [Dave]
- Add Jonathan RB tag
- Add Ira AB tag
[PATCH 06/20]
- Region label update/delete in LSA without v2 patch 01/20 [Jonathan/Dave/Ira]
- Use "union nd_lsa_label" inplace of "struct nd_lsa_label" [Jonathan/Dave]
- Rename rgl/rg* to region_label* [Dave]
- Use uuid_equal() without import_uuid() [Dave]
- Refactor __pmem_label_update() to accomodate region label [Fabio/Ira]
- Merge v2 patch 07/20 here [Ira]
- Fix hardcoded value while using init_labels() [Ira]
[PATCH 07/20]
- Fix comment message [Johathan]
- Replace mutex_lock() with guard(mutex)() [Jonathan]
[PATCH 08/20]
- Fix commit message [Johathan]
- Add Jonathan RB tag
[PATCH 09/20]
- Fix comment message [Johathan]
[PATCH 10/20]
- Re-arranged with v2 patch 12/20
- Fix commit message [Johathan]
[PATCH 11/20]
- Replace REVISIT with TODO [Johathan]
[PATCH 12/20]
- Fix commit message [Johathan]
[PATCH 14/20]
- Rename resize_or_free_dpa(() with alloc_region_dpa() [Dave]
- Rename resize_or_free_region_hpa() to alloc_region_hpa() [Dave]
- Elaborate comment message [Dave]
- Use  "__free(put_cxl_region)" for cxlr allocation [Dave]


Changes from v1 -> v2
---------------------
- v1 patch-set was broken. Find the v1 links at [4] and [5]
[PATCH 01/20]
- Simplify return in nvdimm_check_cxl_label_format() [Jonathan]
- Add spec reference while updating LSA major/minor [Jonathan, Dave]
[PATCH 02/20]
- Elaborate commit message with more information [Jonathan, Ira]
- Minimize extra re-naming to avoid churn & complexity [Jonathan]
[PATCH 05/20]
- Use guard(mutex)(&nd_mapping->lock) [Jonathan]
[PATCH 06/20]
- Use switch in place if condition check [Jonathan]
- Fix wrong style for multiline comments in this file [Jonathan]
- Fix wrong condition check in del_labels()
- Bail out extra condition check using extra variable [Jonathan]
[PATCH 07/20]
- Modify init_labels function to init_labels() [Jonathan]
[PATCH 08/20]
- Simplify return in is_region_label() and flip if condition [Jonathan]
[PATCH 12/20]
- Fix comment syntax [Jonathan]
[PATCH 13/20]
- Elaborate commit message and remove history statement from comment [Jonathan]
- Move cxl_region_discovery() from core/port.c to core/region.c [Dave]
[PATCH 14/20]
- Spell check fix in commit message [Jonathan]
- Use ACQUIRE() instead of down_write_killable() [Jonathan]
- Fix extra return check [Jonathan]
- Rename port to root_port to avoid long indirection [Jonathan]
- Remove cxl_wq_flush() as its not required [Jonathan, Dave]
- Add comment of attaching just one target [Jonathan]
- Rename update_region_size() to resize_or_free_region_hpa() [Dave]
- Rename val to size in resize_or_free_region_hpa() [Dave]
- Share common code using helper function in size_store() [Dave]
- Rename update_region_dpa_size() to resize_or_free_dpa() [Dave]
- Rename u64 in place of unsigned long long [Dave]
- Share common code using helper function in dpa_size_store() [Dave]
- Rename CXL_DECODER_PMEM with CXL_PARTMODE_PMEM [Dave]
- Share common code using helper function in commit_store() [Dave]
- Update verbose information about devm_cxl_pmem_add_region() [Dave]
- Renamed and refactored __create_region() to cxl_create_region() [Dave]
[PATCH 15/20]
- Avoid blank line [Jonathan]
- Rename root-cxl-port to CXL port [Dave]
- Add comment to release device ref taken via device_find_child() [Dave]
- Rename cxl_find_root_decoder() to cxl_find_root_decoder_by_port() [Dave]
[PATCH 18/20]
- Avoid extra nvdimm validity check [Jonathan]
- Flip logic to check for unhandled case first [Jonathan]
- Simplify return in match_ep_decoder() [Dave]
- Use lockdep_assert_held() in create_pmem_region() [Dave]
- To use lock moved create_pmem_region() from cxl/pmem.c to core/region.c
[PATCH 19/20]
- Spell check fix in commit message [Jonathan]
- Fix LIBNVDIMM selection condition check in cxl/Kconfig [Jonathan]
[PATCH 20/20]
- Add Documentation/ABI/testing/sysfs-bus-cxl [Jonathan]
- Use ACQUIRE() instead of down_write_killable() [Jonathan]
- Drop trailing comma on terminating entries [Jonathan]


[1]: https://lore.kernel.org/all/163116432405.2460985.5547867384570123403.stgit@dwillia2-desk3.amr.corp.intel.com/
[2]: https://github.com/neerajoss/ndctl/tree/linux-cxl/CXL_LSA_2.1_Support
[3]: https://elixir.bootlin.com/linux/v6.13.7/source/drivers/nvdimm/pmem.c#L520
[4] v1 Cover Letter: https://lore.kernel.org/linux-cxl/1931444790.41750165203442.JavaMail.epsvc@epcpadp1new/
[5] v1 Rest Thread: https://lore.kernel.org/linux-cxl/158453976.61750165203630.JavaMail.epsvc@epcpadp1new/
[6] v2: https://lore.kernel.org/linux-cxl/20250730121209.303202-1-s.neeraj@samsung.com/ 


Neeraj Kumar (20):
  nvdimm/label: Introduce NDD_REGION_LABELING flag to set region label
  nvdimm/label: CXL labels skip the need for 'interleave-set cookie'
  nvdimm/label: Modify nd_label_base() signature
  nvdimm/label: Update mutex_lock() with guard(mutex)()
  nvdimm/namespace_label: Add namespace label changes as per CXL LSA v2.1
  nvdimm/region_label: Add region label update support
  nvdimm/region_label: Add region label delete support
  nvdimm/label: Include region label in slot validation
  nvdimm/namespace_label: Skip region label during ns label DPA reservation
  nvdimm/namespace_label: Skip region label during namespace creation
  nvdimm/region_label: Preserve cxl region information from region label
  nvdimm/region_label: Export routine to fetch region information
  cxl/mem: Refactor cxl pmem region auto-assembling
  cxl/region: Add devm_cxl_pmem_add_region() for pmem region creation
  cxl: Add a routine to find cxl root decoder on cxl bus using cxl port
  cxl/mem: Preserve cxl root decoder during mem probe
  cxl/pmem: Preserve region information into nd_set
  cxl/pmem_region: Prep patch to accommodate pmem_region attributes
  cxl/pmem_region: Add sysfs attribute cxl region label updation/deletion
  cxl/pmem: Add CXL LSA 2.1 support in cxl pmem

 Documentation/ABI/testing/sysfs-bus-cxl |  22 +
 drivers/cxl/Kconfig                     |  14 +
 drivers/cxl/core/Makefile               |   1 +
 drivers/cxl/core/core.h                 |   8 +-
 drivers/cxl/core/pmem_region.c          | 346 ++++++++++++++++
 drivers/cxl/core/port.c                 |  29 +-
 drivers/cxl/core/region.c               | 351 ++++++++--------
 drivers/cxl/cxl.h                       |  50 ++-
 drivers/cxl/cxlmem.h                    |   1 +
 drivers/cxl/mem.c                       |  24 +-
 drivers/cxl/pmem.c                      |  15 +-
 drivers/cxl/port.c                      |  39 +-
 drivers/nvdimm/dimm.c                   |   5 +
 drivers/nvdimm/dimm_devs.c              |  25 ++
 drivers/nvdimm/label.c                  | 509 +++++++++++++++++++-----
 drivers/nvdimm/label.h                  |  16 +
 drivers/nvdimm/namespace_devs.c         |  84 +++-
 drivers/nvdimm/nd-core.h                |   2 +
 drivers/nvdimm/nd.h                     |  74 +++-
 drivers/nvdimm/region_devs.c            |  10 +
 include/linux/libnvdimm.h               |  28 ++
 tools/testing/cxl/Kbuild                |   1 +
 22 files changed, 1301 insertions(+), 353 deletions(-)
 create mode 100644 drivers/cxl/core/pmem_region.c


base-commit: c5dca38633daa1e240144bac453cf9065604a413
-- 
2.34.1

