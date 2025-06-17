Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190D72EA47A
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750165209; cv=none; b=KxfFVLWpvqCBm5jw9g2uf7wJVMrywaxaOSohV1I45DifLXiqERb/WzBDHm9XDJ1oCj1QBegkF54qGpUq0KFk0bda5nTCFaRsyTc+TgZ75gP5lz2BKADTQ9Ew9hk8wDdSeWh7LKrpReV3dwR6QGpoz78NdXjYZjcflGTt14+GCGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750165209; c=relaxed/simple;
	bh=TSdhe+Y1Ca/8kHahFJAMA3yAyK5Q6disNpV//9V+Yys=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=JQd3MTdoRuTruk4W4fyVA50MeNMibfRmHhNgBRm1NXKjjTExVuoyIsOv4MVokwvw0k2K7LjNRQJ5ehRDpa5dfz4RXUX12WAmPf0ZTeAI34hsUrjg9U29md/olY2h7xKcnVnnsoy1fTM0BEtAouD9xq+SDettjhTSqTgbDQipvk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=deWhzSxe; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="deWhzSxe"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20250617130004epoutp01d858a1ef4014231c48f074d6dd870e12~J1fr5DrY90676006760epoutp01Z
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 13:00:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20250617130004epoutp01d858a1ef4014231c48f074d6dd870e12~J1fr5DrY90676006760epoutp01Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1750165204;
	bh=QlX5QPL9C4BE5mcB4cnDucdNTbZRpHKmLbKkyEY/nds=;
	h=From:To:Cc:Subject:Date:References:From;
	b=deWhzSxeCCu6OgzvmeJ3YN5902krVmSuFlHeOxdDYxs5atyV5kkkQU3I7JzV9pNig
	 x85eUDKCIFq6o07A+C3ZtnasFeCwJJxHScg86UhsU6aZyj/RzjTcT0pWwCO34kws+q
	 AMvBETsBi5f/c9V/zZb4Y4Zh4Y/zgWB6wnJ94ft4=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250617130003epcas5p16edfb432185225e256f79c279beeaf17~J1frUAeqR2452824528epcas5p1e;
	Tue, 17 Jun 2025 13:00:03 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4bM6R73C2xz6B9mB; Tue, 17 Jun
	2025 13:00:03 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20250617123958epcas5p3a9f00c6a63ddb140714e3d37463ff00e~J1OJHkt0c1437414374epcas5p3n;
	Tue, 17 Jun 2025 12:39:58 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250617123955epsmtip23472460a05c7a0654f5f73ab59643ff6~J1OGmaj9D2488624886epsmtip2g;
	Tue, 17 Jun 2025 12:39:55 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: dan.j.williams@intel.com, dave@stgolabs.net,
	jonathan.cameron@huawei.com, dave.jiang@intel.com,
	alison.schofield@intel.com, vishal.l.verma@intel.com, ira.weiny@intel.com
Cc: a.manzanares@samsung.com, nifan.cxl@gmail.com, anisa.su@samsung.com,
	vishak.g@samsung.com, krish.reddy@samsung.com, arun.george@samsung.com,
	alok.rathore@samsung.com, s.neeraj@samsung.com, neeraj.kernel@gmail.com,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, gost.dev@samsung.com, cpgs@samsung.com
Subject: [RFC PATCH 00/20] Add CXL LSA 2.1 format support in nvdimm and cxl
 pmem
Date: Tue, 17 Jun 2025 18:09:24 +0530
Message-Id: <1931444790.41750165203442.JavaMail.epsvc@epcpadp1new>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20250617123958epcas5p3a9f00c6a63ddb140714e3d37463ff00e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20250617123958epcas5p3a9f00c6a63ddb140714e3d37463ff00e
References: <CGME20250617123958epcas5p3a9f00c6a63ddb140714e3d37463ff00e@epcas5p3.samsung.com>

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
Patch 2-4:   Update namespace label as per v2.1
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
	root@QEMUCXL6060pmem:~# ndctl create-namespace --mode=fsdax --region=region0 --size=128M
	{
	  "dev":"namespace0.0",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"124.00 MiB (130.02 MB)",
	  "uuid":"3f6dcdc5-d289-4b0c-ad16-82636c82bec1",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem0"
	}
	
	root@QEMUCXL6060pmem:~# ndctl create-namespace --mode=fsdax --region=region1 --size=256M
	{
	  "dev":"namespace1.0",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"250.00 MiB (262.14 MB)",
	  "uuid":"6b9083c9-cb1a-447b-894d-fdfd2f3dbed2",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem1"
	}
	
	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region0 --size=256M
	{
	  "dev":"namespace0.1",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"250.00 MiB (262.14 MB)",
	  "uuid":"c2071802-8c24-4f9c-a6c1-f6bb6589e561",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem0.1"
	}
	
	real    0m47.517s
	user    0m0.209s
	sys     0m26.879s
	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region1 --size=128M
	{
	  "dev":"namespace1.1",
	  "mode":"fsdax",
	  "map":"dev",
	  "size":"124.00 MiB (130.02 MB)",
	  "uuid":"13bc8de3-53d3-4c3d-b252-be7efefe80ee",
	  "sector_size":512,
	  "align":2097152,
	  "blockdev":"pmem1.1"
	}
	
	real    0m33.459s
	user    0m0.243s
	sys     0m13.590s

	root@QEMUCXL6060pmem:~# ndctl list
	[
	  {
	    "dev":"namespace1.0",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":262144000,
	    "uuid":"6b9083c9-cb1a-447b-894d-fdfd2f3dbed2",
	    "sector_size":512,
	    "align":2097152,
	    "blockdev":"pmem1"
	  },
	  {
	    "dev":"namespace1.1",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":130023424,
	    "uuid":"13bc8de3-53d3-4c3d-b252-be7efefe80ee",
	    "sector_size":512,
	    "align":2097152,
	    "blockdev":"pmem1.1"
	  },
	  {
	    "dev":"namespace0.1",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":262144000,
	    "uuid":"c2071802-8c24-4f9c-a6c1-f6bb6589e561",
	    "sector_size":512,
	    "align":2097152,
	    "blockdev":"pmem0.1"
	  },
	  {
	    "dev":"namespace0.0",
	    "mode":"fsdax",
	    "map":"dev",
	    "size":130023424,
	    "uuid":"3f6dcdc5-d289-4b0c-ad16-82636c82bec1",
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

6. Also verify LSA version using "ndctl read-labels -j nmem0 -u"
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
	      "uuid":"9a26b9ce-a859-4a63-b1b7-fd176105770d",
	      "name":"",
	      "flags":8,
	      "nrange":1,
	      "position":0,
	      "dpa":134217728,
	      "rawsize":268435456,
	      "slot":0,
	      "align":0,
	      "region_uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
	      "lbasize":512
	    },
	    {
	      "type":"529d7c61-da07-47c4-a93f-ecdf2c06f444",
	      "uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
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
	      "uuid":"a90d211a-b28d-48c7-bfe7-99560d3825ef",
	      "name":"",
	      "flags":0,
	      "nrange":1,
	      "position":0,
	      "dpa":0,
	      "rawsize":134217728,
	      "slot":2,
	      "align":0,
	      "region_uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
	      "lbasize":512
	    },
	    {
	      "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
	      "uuid":"9a26b9ce-a859-4a63-b1b7-fd176105770d",
	      "name":"",
	      "flags":0,
	      "nrange":1,
	      "position":0,
	      "dpa":134217728,
	      "rawsize":268435456,
	      "slot":3,
	      "align":0,
	      "region_uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
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
while executing "devm_memremap_pages" at [3]

As using this patchset, after auto region creation, namespace creation is
happening in boot sequence (if nvdimm and cxl drivers are static), It is
therefore boot sequence is increased by around 10 to 20 sec.


[1]: https://lore.kernel.org/all/163116432405.2460985.5547867384570123403.stgit@dwillia2-desk3.amr.corp.intel.com/
[2]: https://github.com/neerajoss/ndctl/tree/linux-cxl/CXL_LSA_2.1_Support
[3]: https://elixir.bootlin.com/linux/v6.13.7/source/drivers/nvdimm/pmem.c#L520




Neeraj Kumar (20):
  nvdimm/label: Introduce NDD_CXL_LABEL flag to set cxl label format
  nvdimm/label: Prep patch to accommodate cxl lsa 2.1 support
  nvdimm/namespace_label: Add namespace label changes as per CXL LSAv2.1
  nvdimm/label: CXL labels skip the need for 'interleave-set cookie'
  nvdimm/region_label: Add region label updation routine
  nvdimm/region_label: Add region label deletion routine
  nvdimm/namespace_label: Update namespace init_labels and its region_uuid
  nvdimm/label: Include region label in slot validation
  nvdimm/namespace_label: Skip region label during ns label DPA reservation
  nvdimm/region_label: Preserve cxl region information from region label
  nvdimm/region_label: Export routine to fetch region information
  nvdimm/namespace_label: Skip region label during namespace creation
  cxl/mem: Refactor cxl pmem region auto-assembling
  cxl/region: Add cxl pmem region creation routine for region persistency
  cxl: Add a routine to find cxl root decoder on cxl bus
  cxl/mem: Preserve cxl root decoder during mem probe
  cxl/pmem: Preserve region information into nd_set
  cxl/pmem: Add support of cxl lsa 2.1 support in cxl pmem
  cxl/pmem_region: Prep patch to accommodate pmem_region attributes
  cxl/pmem_region: Add cxl region label updation and deletion device attributes

 drivers/cxl/Kconfig             |  12 +
 drivers/cxl/core/Makefile       |   1 +
 drivers/cxl/core/core.h         |   8 +-
 drivers/cxl/core/pmem_region.c  | 325 ++++++++++++++++++++++++++
 drivers/cxl/core/port.c         |  72 +++++-
 drivers/cxl/core/region.c       | 383 +++++++++++++++---------------
 drivers/cxl/cxl.h               |  46 +++-
 drivers/cxl/cxlmem.h            |   1 +
 drivers/cxl/mem.c               |  27 ++-
 drivers/cxl/pmem.c              |  72 +++++-
 drivers/cxl/port.c              |  38 ---
 drivers/nvdimm/dimm.c           |   5 +
 drivers/nvdimm/dimm_devs.c      |  28 +++
 drivers/nvdimm/label.c          | 403 ++++++++++++++++++++++++++++----
 drivers/nvdimm/label.h          |  20 +-
 drivers/nvdimm/namespace_devs.c | 149 ++++++++----
 drivers/nvdimm/nd-core.h        |   2 +
 drivers/nvdimm/nd.h             |  81 ++++++-
 drivers/nvdimm/region_devs.c    |   5 +
 include/linux/libnvdimm.h       |  28 +++
 tools/testing/cxl/Kbuild        |   1 +
 21 files changed, 1364 insertions(+), 343 deletions(-)
 create mode 100644 drivers/cxl/core/pmem_region.c


base-commit: 448a60e85ae2afe2cb760f5d2ed2c8a49d2bd1b4
-- 
2.34.1

