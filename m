Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D7F4318EF9
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769167887; cv=none; b=tohk179O812+qVxHe3/rbuM4CiTySBOkFIIaOcjv+n2/cBprxNF+uzhqNkqbiaNVbirDpOf8OXdOpTof7YeW/uby6r19ImJLfDQ4hruFfkBSTQNw8bm+kxG72RYe0jAphh9P9nlvqRUw4my3WpLPr6OWGodkI0yfE1UoxsFpVGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769167887; c=relaxed/simple;
	bh=miF+O5pzUpVq1Lbz+qlh3tZqBSRJDdpgr3P82pNkIes=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=bgYGiMMUnb5lcbs0zDrzbdWXrjcU8ywvkFCWKuquHgCSmAS0/4mcypSa9lsIYbTvDFMeJpstJIQb00mUnIXiSHk6BpIFfNUk1q7b23BV2r+NrVIE3OZTQU3UA9BAKP1AJnz9/DeUg7g7OuVy55C13lW6ezVZovc8xxcYlVQCRIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=aivo46IO; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="aivo46IO"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260123113123epoutp03ff312db28b157f18fb1cb2132454a3bf~NWNEI4x3M2124621246epoutp038
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 11:31:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260123113123epoutp03ff312db28b157f18fb1cb2132454a3bf~NWNEI4x3M2124621246epoutp038
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1769167883;
	bh=1JTnbibH6ENVxMBGctiDQg+4oF/rAJUT3UdyvvTcMp0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=aivo46IOqaotb9lkINVYOfE/xhyaEhPf+RFrzC8rsdNex+oIOH8nclW/socb6q+iP
	 4ivsg4gQyYUIGtuvwzRURjian7ebMOrZUB5edMtKT6p8QDTKEpOS7+JabkSgNBWw8f
	 A2xQ55RJAfg3n/pcypYwyZFHvT3HJasA6qQIhakM=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20260123113123epcas5p1e6f03c53c7e159cc3ff179ef534d7e63~NWND30Wtj2520225202epcas5p1o;
	Fri, 23 Jan 2026 11:31:23 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.86]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4dyG3G17Bpz6B9m9; Fri, 23 Jan
	2026 11:31:22 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91~NWNCjIDLy2764227642epcas5p1b;
	Fri, 23 Jan 2026 11:31:21 +0000 (GMT)
Received: from test-PowerEdge-R740xd.samsungds.net (unknown [107.99.41.79])
	by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260123113119epsmtip2eb8313851a341b20ed0d100a01f7ee85~NWNAsNCCo2681126811epsmtip2F;
	Fri, 23 Jan 2026 11:31:19 +0000 (GMT)
From: Neeraj Kumar <s.neeraj@samsung.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, gost.dev@samsung.com
Cc: a.manzanares@samsung.com, vishak.g@samsung.com, neeraj.kernel@gmail.com,
	Neeraj Kumar <s.neeraj@samsung.com>
Subject: [PATCH V6 00/18] Add CXL LSA 2.1 format support in nvdimm and cxl
 pmem
Date: Fri, 23 Jan 2026 17:00:54 +0530
Message-Id: <20260123113112.3488381-1-s.neeraj@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91
References: <CGME20260123113121epcas5p125bc64b4714525d7bbd489cd9be9ba91@epcas5p1.samsung.com>

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
Patch 10:    Refactor cxl pmem region auto assembly using Dan's Infra
Patch 11-13: Save cxl region info in LSA and region recreation during reboot
Patch 14:15: Segregate out cxl pmem region code from region.c to pmem_region.c
Patch 16:    Introduce cxl region addition/deletion attributes
Patch 17-18: Add support of cxl pmem region re-creation from CXL as per LSA 2.1

Testing:
========
In order to test this patchset, I also added the support of LSA v2.1 format
in ndctl. ndctl changes are available at [2]. After review, I’ll push in
ndctl repo for community review.

1. Used Qemu using following CXL topology
   M2="-object memory-backend-file,id=cxl-mem11,share=on,mem-path=$TMP_DIR/cxltest11.raw,size=4G \
       -object memory-backend-file,id=cxl-lsa11,share=on,mem-path=$TMP_DIR/lsa.raw11,size=1M \
       -object memory-backend-file,id=cxl-mem21,share=on,mem-path=$TMP_DIR/cxltest21.raw,size=4G \
       -object memory-backend-file,id=cxl-lsa21,share=on,mem-path=$TMP_DIR/lsa21.raw,size=1M \
       -device pxb-cxl,bus=pcie.0,bus_nr=10,id=cxl.1 \
       -device cxl-rp,port=110,bus=cxl.1,id=root_port11,chassis=0,slot=11 \
       -device cxl-type3,bus=root_port11,memdev=cxl-mem11,lsa=cxl-lsa11,id=cxl-pmem11,sn=11 \
       -device pxb-cxl,bus=pcie.0,bus_nr=20,id=cxl.2 \
       -device cxl-rp,port=210,bus=cxl.2,id=root_port21,chassis=0,slot=21 \
       -device cxl-type3,bus=root_port21,memdev=cxl-mem21,lsa=cxl-lsa21,id=cxl-pmem21,sn=21 \
       -M cxl-fmw.0.targets.0=cxl.1,cxl-fmw.0.size=8G,cxl-fmw.0.interleave-granularity=8k,cxl-fmw.1.targets.0=cxl.2,cxl-fmw.1.size=8G"

2. Create cxl region on both devices
	cxl create-region -d decoder0.1 -m mem0
	cxl create-region -d decoder0.0 -m mem1

        root@QEMUCXL6060pmem:~# cxl list
        [
          {
            "memdevs":[
              {
                "memdev":"mem0",
                "pmem_size":4294967296,
                "serial":21,
                "host":"0000:15:00.0",
                "firmware_version":"BWFW VERSION 00"
              },
              {
                "memdev":"mem1",
                "pmem_size":4294967296,
                "serial":11,
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
                "size":4294967296,
                "type":"pmem",
                "interleave_ways":1,
                "interleave_granularity":256,
                "decode_state":"commit",
                "qos_class_mismatch":true
              },
              {
                "region":"region1",
                "resource":53955526656,
                "size":4294967296,
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
        root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region0 --size=256M
        {
          "dev":"namespace0.1",
          "mode":"fsdax",
          "map":"dev",
          "size":"250.00 MiB (262.14 MB)",
          "uuid":"5f9e28b4-f403-4e72-bb06-307ead53dec4",
          "sector_size":512,
          "align":2097152,
          "blockdev":"pmem0.1"
        }
        
        real    1m8.795s
        user    0m0.098s
        sys     0m48.699s
        
        
        root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region1 --size=128M
        {
          "dev":"namespace1.1",
          "mode":"fsdax",
          "map":"dev",
          "size":"124.00 MiB (130.02 MB)",
          "uuid":"33682096-7364-412d-bfbc-fa7568939abd",
          "sector_size":512,
          "align":2097152,
          "blockdev":"pmem1.1"
        }
        
        
        root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region0 --size=128M
        {
          "dev":"namespace0.0",
          "mode":"fsdax",
          "map":"dev",
          "size":"124.00 MiB (130.02 MB)",
          "uuid":"9681af0e-349a-401e-9833-1cf8903d58fa",
          "sector_size":512,
          "align":2097152,
          "blockdev":"pmem0"
        }
        
        real    0m39.805s
        user    0m0.138s
        sys     0m21.485s
        
        
        root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region1 --size=256M
        {
          "dev":"namespace1.0",
          "mode":"fsdax",
          "map":"dev",
          "size":"250.00 MiB (262.14 MB)",
          "uuid":"15f1c8d5-416f-4d2e-9e39-d17ce8f73a42",
          "sector_size":512,
          "align":2097152,
          "blockdev":"pmem1"
        }
        
        real    0m43.899s
        user    0m0.113s
        sys     0m31.167s

        
        root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=fsdax --region=region0 --size=128M
        {
          "dev":"namespace0.0",
          "mode":"fsdax",
          "map":"dev",
          "size":"124.00 MiB (130.02 MB)",
          "uuid":"9681af0e-349a-401e-9833-1cf8903d58fa",
          "sector_size":512,
          "align":2097152,
          "blockdev":"pmem0"
        }
        
        real    0m39.805s
        user    0m0.138s
        sys     0m21.485s


        root@QEMUCXL6060pmem:~# ndctl list
        [
          {
            "dev":"namespace1.0",
            "mode":"fsdax",
            "map":"dev",
            "size":262144000,
            "uuid":"15f1c8d5-416f-4d2e-9e39-d17ce8f73a42",
            "sector_size":512,
            "align":2097152,
            "blockdev":"pmem1"
          },
          {
            "dev":"namespace1.1",
            "mode":"fsdax",
            "map":"dev",
            "size":130023424,
            "uuid":"33682096-7364-412d-bfbc-fa7568939abd",
            "sector_size":512,
            "align":2097152,
            "blockdev":"pmem1.1"
          },
          {
            "dev":"namespace0.1",
            "mode":"fsdax",
            "map":"dev",
            "size":262144000,
            "uuid":"5f9e28b4-f403-4e72-bb06-307ead53dec4",
            "sector_size":512,
            "align":2097152,
            "blockdev":"pmem0.1"
          },
          {
            "dev":"namespace0.0",
            "mode":"fsdax",
            "map":"dev",
            "size":130023424,
            "uuid":"9681af0e-349a-401e-9833-1cf8903d58fa",
            "sector_size":512,
            "align":2097152,
            "blockdev":"pmem0"
          }
        ]

5. Re-Start Qemu and we could see
	- Region persistency using "cxl list"
	- Namespace persistency using "ndctl list" and cat /proc/iomem

	root@QEMUCXL6060pmem:~# cat /proc/iomem
        fed1c000-fed1ffff : Reserved
        feffc000-feffffff : Reserved
        fffc0000-ffffffff : Reserved
        100000000-27fffffff : System RAM
        a90000000-c8fffffff : CXL Window 0
          a90000000-b8fffffff : Persistent Memory
            a90000000-b8fffffff : region0
              a90000000-a97ffffff : namespace0.0
              a98000000-aa7ffffff : namespace0.1
        c90000000-e8fffffff : CXL Window 1
          c90000000-d8fffffff : Persistent Memory
            c90000000-d8fffffff : region1
              c90000000-c9fffffff : namespace1.0
              ca0000000-ca7ffffff : namespace1.1
        380000000000-38000000ffff : PCI Bus 0000:0a
          380000000000-38000000ffff : 0000:0a:00.0

	- NOTE: We can see some lag in restart. Look at Observesation below

6. Also verify LSA version using "ndctl read-labels -j nmem0"
        root@QEMUCXL6060pmem:~# time ndctl read-labels -j nmem0
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
              "uuid":"5b33b940-6767-4951-b923-952455482f52",
              "name":"",
              "flags":8,
              "nrange":1,
              "position":0,
              "dpa":134217728,
              "rawsize":268435456,
              "slot":0,
              "align":0,
              "region_uuid":"a1482e6b-968e-4297-b2f5-bf1733966e55",
              "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
              "lbasize":512
            },
            {
              "type":"529d7c61-da07-47c4-a93f-ecdf2c06f444",
              "uuid":"a1482e6b-968e-4297-b2f5-bf1733966e55",
              "flags":0,
              "nlabel":1,
              "position":0,
              "dpa":0,
              "rawsize":4294967296,
              "hpa":45365592064,
              "slot":1,
              "interleave granularity":256,
              "align":0
            },
            {
              "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
              "uuid":"2c1c33c0-909b-4c6a-8de4-dfc6c13ae82c",
              "name":"",
              "flags":0,
              "nrange":1,
              "position":0,
              "dpa":0,
              "rawsize":134217728,
              "slot":2,
              "align":0,
              "region_uuid":"a1482e6b-968e-4297-b2f5-bf1733966e55",
              "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
              "lbasize":512
            },
            {
              "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
              "uuid":"5b33b940-6767-4951-b923-952455482f52",
              "name":"",
              "flags":0,
              "nrange":1,
              "position":0,
              "dpa":134217728,
              "rawsize":268435456,
              "slot":3,
              "align":0,
              "region_uuid":"a1482e6b-968e-4297-b2f5-bf1733966e55",
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

Changes
=======
Changes in v5->v6
-----------------
- Find v5 link at [4]
- Find v4 link at [5]
- Find v3 link at [6]
- Find v2 link at [7]
- v1 patch-set was broken. Find the v1 links at [8] and [9]

[Misc]
- Rebase with for-7.0/cxl-init

[PATCH 01/18]
- Add Ira RB tag

[PATCH 03/18]
- Use export_uuid() instead of uuid_copy() [Jonathan]
- Add Jonathan RB tag
- Add Ira RB tag

[PATCH 04/18]
- Move the assignments at relevant place [Jonathan]
- Rename lslot to label_slot [Jonathan]
- Add Ira RB tag

[PATCH 05/18]
- Add Jonathan RB tag
- Add Ira RB tag

[PATCH 06/18]
- Add Jonathan RB tag
- Add Ira RB tag

[PATCH 07/18]
- Add Ira RB tag

[PATCH 08/18]
- use export_uuid() to avoid casts to uuid_t * [Jonathan]
- Add Jonathan RB tag
- Add Ira RB tag

[PATCH 09/18]
- Add Jonathan RB tag
- Add Ira RB tag

[PATCH 10/18]
- Initialize struct cxl_memdev_attach variable [Jonathan]
- Add Jonathan RB tag

[PATCH 10/18]
- Its a new patch addition in this series
- Seperate out renaming of __create_region() to cxl_create_region() [Jonathan]

[PATCH 11/18]
- Remove usage of cxl_dpa_free() from alloc_region_dpa() [Jonathan]

[PATCH 13/18]
- Add Jonathan RB tag

[PATCH 15/18]
- Add Jonathan RB tag

[PATCH 16/18]
- Fix wrong name state with region_label_state [Jonathan]
- Add Jonathan RB tag

[PATCH 17/18]
- Optimize loop matching [Jonathan]
- Use reverse xmas tree stype [Jonathan]

[PATCH 18/18]
- Add Jonathan RB tag


[1]: https://lore.kernel.org/all/163116432405.2460985.5547867384570123403.stgit@dwillia2-desk3.amr.corp.intel.com/
[2]: https://github.com/neerajoss/ndctl/commits/linux-cxl/V1_CXL_LSA_2.1_Support/
[3]: https://elixir.bootlin.com/linux/v6.13.7/source/drivers/nvdimm/pmem.c#L520
[4]: https://lore.kernel.org/linux-cxl/20260109124437.4025893-1-s.neeraj@samsung.com/
[5]: https://lore.kernel.org/linux-cxl/20250917134116.1623730-1-s.neeraj@samsung.com/
[6]: https://lore.kernel.org/linux-cxl/20251119075255.2637388-1-s.neeraj@samsung.com/
[7]: https://lore.kernel.org/linux-cxl/20250730121209.303202-1-s.neeraj@samsung.com/
[8] v1 Cover Letter: https://lore.kernel.org/linux-cxl/1931444790.41750165203442.JavaMail.epsvc@epcpadp1new/
[9] v1 Rest Thread: https://lore.kernel.org/linux-cxl/158453976.61750165203630.JavaMail.epsvc@epcpadp1new/


Neeraj Kumar (18):
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
  cxl/region: Rename __create_region() to cxl_create_region()
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
 drivers/cxl/core/pmem_region.c          | 422 +++++++++++++++++
 drivers/cxl/core/region.c               | 377 ++++++++-------
 drivers/cxl/cxl.h                       |  41 +-
 drivers/cxl/mem.c                       |  18 +-
 drivers/cxl/pci.c                       |   4 +-
 drivers/cxl/pmem.c                      |  15 +-
 drivers/cxl/port.c                      |  39 +-
 drivers/nvdimm/dimm.c                   |   5 +
 drivers/nvdimm/dimm_devs.c              |  19 +
 drivers/nvdimm/label.c                  | 580 ++++++++++++++++++++----
 drivers/nvdimm/label.h                  |  18 +-
 drivers/nvdimm/namespace_devs.c         |  82 +++-
 drivers/nvdimm/nd-core.h                |   2 +
 drivers/nvdimm/nd.h                     |  64 +++
 drivers/nvdimm/region_devs.c            |  10 +
 include/linux/libnvdimm.h               |  28 ++
 tools/testing/cxl/Kbuild                |   1 +
 21 files changed, 1424 insertions(+), 374 deletions(-)
 create mode 100644 drivers/cxl/core/pmem_region.c


base-commit: bc62f5b308cbdedf29132fe96e9d591e526527e1
-- 
2.34.1

