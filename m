Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC8822FA651
	for <nvdimm@lists.linux.dev>; Tue, 17 Jun 2025 17:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750180052; cv=none; b=Fu9n4YDHhedT+sRBvaGmdihTUh4I4/lA10kgPRydZzkZfeuHGhZmsAMAKecdO8OoO6mBw5LSTNVyECSf34hyPfEsasO75ihGO+8wJQPg/8GzxCREKJoNb5mFehHFeAvgBRzex4r6CzXrCOpgWfdEEy8pm1vfpMtG2EnGHpdDbXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750180052; c=relaxed/simple;
	bh=U7ooK9RLGClCl5MEVUVqDq4ZtRWl/d0PDqjvzoH+kxg=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MYyuNqijX92uBFEspXmycypmLfzJSmyHJVhUaYqUWGEepFi0L9RtLxJ9gq3NMfiJeYfEBFP2mXySjgBfZEQmV+jcNvstjrhXQZGH5fGEZZUztvYkTkd7tMoh8B5mktjm8WHck7SYVDuWjtiAxchkWR6Kw7yXD3CrgIB9feT1JRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4bMCt35LJTz6HJX9;
	Wed, 18 Jun 2025 01:05:15 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 562D1140119;
	Wed, 18 Jun 2025 01:07:26 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Tue, 17 Jun
 2025 19:07:25 +0200
Date: Tue, 17 Jun 2025 18:07:23 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Neeraj Kumar <s.neeraj@samsung.com>
CC: <dan.j.williams@intel.com>, <dave@stgolabs.net>, <dave.jiang@intel.com>,
	<alison.schofield@intel.com>, <vishal.l.verma@intel.com>,
	<ira.weiny@intel.com>, <a.manzanares@samsung.com>, <nifan.cxl@gmail.com>,
	<anisa.su@samsung.com>, <vishak.g@samsung.com>, <krish.reddy@samsung.com>,
	<arun.george@samsung.com>, <alok.rathore@samsung.com>,
	<neeraj.kernel@gmail.com>, <linux-kernel@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<gost.dev@samsung.com>, <cpgs@samsung.com>
Subject: Re: [RFC PATCH 00/20] Add CXL LSA 2.1 format support in nvdimm and
 cxl pmem
Message-ID: <20250617180723.00002d13@huawei.com>
In-Reply-To: <1931444790.41750165203442.JavaMail.epsvc@epcpadp1new>
References: <CGME20250617123958epcas5p3a9f00c6a63ddb140714e3d37463ff00e@epcas5p3.samsung.com>
	<1931444790.41750165203442.JavaMail.epsvc@epcpadp1new>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Tue, 17 Jun 2025 18:09:24 +0530
Neeraj Kumar <s.neeraj@samsung.com> wrote:

Hi Neeraj,

First a process thing. Looks like threading is broken in your patch set.
https://lore.kernel.org/linux-cxl/1931444790.41750165203442.JavaMail.epsvc@=
epcpadp1new/T/#u
Lore had a go and seems to have figured out there is a thread for the rest.
If you can't fix it locally for your email, look at using the b4 gateway
(see the docs for the b4 tool)

https://git.kernel.org/pub/scm/linux/kernel/git/palmer/b4.git/

Also, in an RFC the first thing I expect to see if a 'Why this is an RFC st=
atement'
vs ready for upstream merge.  What are the questions that need comments or
the blockers you know need to be resolved?

Anyhow, good to see this. Not an area I'm that familiar with but
I'll try to take a detailed look a bit later this week.

Thanks,

Jonathan


> Introduction:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> CXL Persistent Memory (Pmem) devices region, namespace and content must be
> persistent across system reboot. In order to achieve this persistency, it
> uses Label Storage Area (LSA) to store respective metadata. During system
> reboot, stored metadata in LSA is used to bring back the region, namespace
> and content of CXL device in its previous state.
> CXL specification provides Get_LSA (4102h) and Set_LSA (4103h) mailbox
> commands to access the LSA area. nvdimm driver is using same commands to
> get/set LSA data.
>=20
> There are three types of LSA format and these are part of following
> specifications:=20
>  - v1.1: https://pmem.io/documents/NVDIMM_Namespace_Spec.pdf
>  - v1.2: https://uefi.org/sites/default/files/resources/UEFI_Spec_2_7.pdf
>  - v2.1: https://computeexpresslink.org/wp-content/uploads/2024/02/CXL-2.=
0-Specification.pdf
>=20
> Basic differences between these LSA formats:
>  - v1.1: Support Namespace persistency. Size of Namespace Label is 128 by=
tes
>  - v1.2: Support Namespace persistency. Size of Namespace Label is 256 by=
tes
>  - v2.1: Support Namespace and Region persistency. Size of Namespace and
>    Region Label is 256 bytes.
>=20
> Linux nvdimm driver supports only v1.1 and v1.2 LSA format. CXL pmem devi=
ce
> require support of LSA v2.1 format for region and namespace persistency.
> Initial support of LSA 2.1 was add in [1].
>=20
> This patchset adds support of LSA 2.1 in nvdimm and cxl pmem driver.
>=20
> Patch 1:     Introduce NDD_CXL_LABEL flag and Update cxl label index as p=
er v2.1
> Patch 2-4:   Update namespace label as per v2.1
> Patch 5-12:  Introduce cxl region labels and modify existing change accor=
dingly
> Patch 13:    Refactor cxl pmem region auto assembly
> Patch 14-18: Save cxl region info in LSA and region recreation during reb=
oot
> Patch 19:    Segregate out cxl pmem region code from region.c to pmem_reg=
ion.c
> Patch 20:    Introduce cxl region addition/deletion attributes
>=20
>=20
> Testing:
> =3D=3D=3D=3D=3D=3D=3D=3D
> In order to test this patchset, I also added the support of LSA v2.1 form=
at
> in ndctl. ndctl changes are available at [2]. After review, I=E2=80=99ll =
push in
> ndctl repo for community review.
>=20
> 1. Used Qemu using following CXL topology
>    M2=3D"-object memory-backend-file,id=3Dcxl-mem1,share=3Don,mem-path=3D=
$TMP_DIR/cxltest.raw,size=3D512M \
>        -object memory-backend-file,id=3Dcxl-lsa1,share=3Don,mem-path=3D$T=
MP_DIR/lsa.raw,size=3D1M \
>        -object memory-backend-file,id=3Dcxl-mem2,share=3Don,mem-path=3D$T=
MP_DIR/cxltest2.raw,size=3D512M \
>        -object memory-backend-file,id=3Dcxl-lsa2,share=3Don,mem-path=3D$T=
MP_DIR/lsa2.raw,size=3D1M \
>        -device pxb-cxl,bus_nr=3D10,bus=3Dpcie.0,id=3Dcxl.1 \
>        -device cxl-rp,port=3D1,bus=3Dcxl.1,id=3Droot_port11,chassis=3D0,s=
lot=3D1 \
>        -device cxl-type3,bus=3Droot_port11,memdev=3Dcxl-mem1,lsa=3Dcxl-ls=
a1,id=3Dcxl-pmem1,sn=3D1 \
>        -device cxl-rp,port=3D2,bus=3Dcxl.1,id=3Droot_port12,chassis=3D0,s=
lot=3D2 \
>        -device cxl-type3,bus=3Droot_port12,memdev=3Dcxl-mem2,lsa=3Dcxl-ls=
a2,id=3Dcxl-pmem2,sn=3D2 \
>        -M cxl-fmw.0.targets.0=3Dcxl.1,cxl-fmw.0.size=3D4G,cxl-fmw.0.inter=
leave-granularity=3D8k"
>=20
> 2. Create cxl region on both devices
> 	cxl create-region -d decoder0.0 -m mem0
> 	cxl create-region -d decoder0.0 -m mem1
>=20
> 	root@QEMUCXL6060pmem:~# cxl list
> 	[
> 	  {
> 	    "memdevs":[
> 	      {
> 	        "memdev":"mem0",
> 	        "pmem_size":536870912,
> 	        "serial":2,
> 	        "host":"0000:0c:00.0",
> 	        "firmware_version":"BWFW VERSION 00"
> 	      },
> 	      {
> 	        "memdev":"mem1",
> 	        "pmem_size":536870912,
> 	        "serial":1,
> 	        "host":"0000:0b:00.0",
> 	        "firmware_version":"BWFW VERSION 00"
> 	      }
> 	    ]
> 	  },
> 	  {
> 	    "regions":[
> 	      {
> 	        "region":"region0",
> 	        "resource":45365592064,
> 	        "size":536870912,
> 	        "type":"pmem",
> 	        "interleave_ways":1,
> 	        "interleave_granularity":256,
> 	        "decode_state":"commit",
> 	        "qos_class_mismatch":true
> 	      },
> 	      {
> 	        "region":"region1",
> 	        "resource":45902462976,
> 	        "size":536870912,
> 	        "type":"pmem",
> 	        "interleave_ways":1,
> 	        "interleave_granularity":256,
> 	        "decode_state":"commit",
> 	        "qos_class_mismatch":true
> 	      }
> 	    ]
> 	  }
> 	]
>=20
> 3. Re-Start Qemu and we could see cxl region persistency using "cxl list"
>=20
> 4. Create namespace for both regions
> 	root@QEMUCXL6060pmem:~# ndctl create-namespace --mode=3Dfsdax --region=
=3Dregion0 --size=3D128M
> 	{
> 	  "dev":"namespace0.0",
> 	  "mode":"fsdax",
> 	  "map":"dev",
> 	  "size":"124.00 MiB (130.02 MB)",
> 	  "uuid":"3f6dcdc5-d289-4b0c-ad16-82636c82bec1",
> 	  "sector_size":512,
> 	  "align":2097152,
> 	  "blockdev":"pmem0"
> 	}
> =09
> 	root@QEMUCXL6060pmem:~# ndctl create-namespace --mode=3Dfsdax --region=
=3Dregion1 --size=3D256M
> 	{
> 	  "dev":"namespace1.0",
> 	  "mode":"fsdax",
> 	  "map":"dev",
> 	  "size":"250.00 MiB (262.14 MB)",
> 	  "uuid":"6b9083c9-cb1a-447b-894d-fdfd2f3dbed2",
> 	  "sector_size":512,
> 	  "align":2097152,
> 	  "blockdev":"pmem1"
> 	}
> =09
> 	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=3Dfsdax --reg=
ion=3Dregion0 --size=3D256M
> 	{
> 	  "dev":"namespace0.1",
> 	  "mode":"fsdax",
> 	  "map":"dev",
> 	  "size":"250.00 MiB (262.14 MB)",
> 	  "uuid":"c2071802-8c24-4f9c-a6c1-f6bb6589e561",
> 	  "sector_size":512,
> 	  "align":2097152,
> 	  "blockdev":"pmem0.1"
> 	}
> =09
> 	real    0m47.517s
> 	user    0m0.209s
> 	sys     0m26.879s
> 	root@QEMUCXL6060pmem:~# time ndctl create-namespace --mode=3Dfsdax --reg=
ion=3Dregion1 --size=3D128M
> 	{
> 	  "dev":"namespace1.1",
> 	  "mode":"fsdax",
> 	  "map":"dev",
> 	  "size":"124.00 MiB (130.02 MB)",
> 	  "uuid":"13bc8de3-53d3-4c3d-b252-be7efefe80ee",
> 	  "sector_size":512,
> 	  "align":2097152,
> 	  "blockdev":"pmem1.1"
> 	}
> =09
> 	real    0m33.459s
> 	user    0m0.243s
> 	sys     0m13.590s
>=20
> 	root@QEMUCXL6060pmem:~# ndctl list
> 	[
> 	  {
> 	    "dev":"namespace1.0",
> 	    "mode":"fsdax",
> 	    "map":"dev",
> 	    "size":262144000,
> 	    "uuid":"6b9083c9-cb1a-447b-894d-fdfd2f3dbed2",
> 	    "sector_size":512,
> 	    "align":2097152,
> 	    "blockdev":"pmem1"
> 	  },
> 	  {
> 	    "dev":"namespace1.1",
> 	    "mode":"fsdax",
> 	    "map":"dev",
> 	    "size":130023424,
> 	    "uuid":"13bc8de3-53d3-4c3d-b252-be7efefe80ee",
> 	    "sector_size":512,
> 	    "align":2097152,
> 	    "blockdev":"pmem1.1"
> 	  },
> 	  {
> 	    "dev":"namespace0.1",
> 	    "mode":"fsdax",
> 	    "map":"dev",
> 	    "size":262144000,
> 	    "uuid":"c2071802-8c24-4f9c-a6c1-f6bb6589e561",
> 	    "sector_size":512,
> 	    "align":2097152,
> 	    "blockdev":"pmem0.1"
> 	  },
> 	  {
> 	    "dev":"namespace0.0",
> 	    "mode":"fsdax",
> 	    "map":"dev",
> 	    "size":130023424,
> 	    "uuid":"3f6dcdc5-d289-4b0c-ad16-82636c82bec1",
> 	    "sector_size":512,
> 	    "align":2097152,
> 	    "blockdev":"pmem0"
> 	  }
> 	]
> =09
> 5. Re-Start Qemu and we could see
> 	- Region persistency using "cxl list"
> 	- Namespace persistency using "ndctl list" and cat /proc/iomem
>=20
> 	root@QEMUCXL6060pmem:~# cat /proc/iomem
> =09
> 	a90000000-b8fffffff : CXL Window 0
> 	  a90000000-aafffffff : Persistent Memory
> 	    a90000000-aafffffff : region0
> 	      a90000000-a97ffffff : namespace0.0
> 	      a98000000-aa7ffffff : namespace0.1
> 	  ab0000000-acfffffff : Persistent Memory
> 	    ab0000000-acfffffff : region1
> 	      ab0000000-abfffffff : namespace1.0
> 	      ac0000000-ac7ffffff : namespace1.1
> =09
>=20
> 	- NOTE: We can see some lag in restart, Its WIP
>=20
> 6. Also verify LSA version using "ndctl read-labels -j nmem0 -u"
> 	root@QEMUCXL6060pmem:~# ndctl read-labels -j nmem0
> 	{
> 	  "dev":"nmem0",
> 	  "index":[
> 	    {
> 	      "signature":"NAMESPACE_INDEX",
> 	      "major":2,
> 	      "minor":1,
> 	      "labelsize":256,
> 	      "seq":2,
> 	      "nslot":4090
> 	    },
> 	    {
> 	      "signature":"NAMESPACE_INDEX",
> 	      "major":2,
> 	      "minor":1,
> 	      "labelsize":256,
> 	      "seq":1,
> 	      "nslot":4090
> 	    }
> 	  ],
> 	  "label":[
> 	    {
> 	      "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
> 	      "uuid":"9a26b9ce-a859-4a63-b1b7-fd176105770d",
> 	      "name":"",
> 	      "flags":8,
> 	      "nrange":1,
> 	      "position":0,
> 	      "dpa":134217728,
> 	      "rawsize":268435456,
> 	      "slot":0,
> 	      "align":0,
> 	      "region_uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
> 	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
> 	      "lbasize":512
> 	    },
> 	    {
> 	      "type":"529d7c61-da07-47c4-a93f-ecdf2c06f444",
> 	      "uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
> 	      "flags":0,
> 	      "nlabel":1,
> 	      "position":0,
> 	      "dpa":0,
> 	      "rawsize":536870912,
> 	      "hpa":45365592064,
> 	      "slot":1,
> 	      "interleave granularity":256,
> 	      "align":0
> 	    },
> 	    {
> 	      "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
> 	      "uuid":"a90d211a-b28d-48c7-bfe7-99560d3825ef",
> 	      "name":"",
> 	      "flags":0,
> 	      "nrange":1,
> 	      "position":0,
> 	      "dpa":0,
> 	      "rawsize":134217728,
> 	      "slot":2,
> 	      "align":0,
> 	      "region_uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
> 	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
> 	      "lbasize":512
> 	    },
> 	    {
> 	      "type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c",
> 	      "uuid":"9a26b9ce-a859-4a63-b1b7-fd176105770d",
> 	      "name":"",
> 	      "flags":0,
> 	      "nrange":1,
> 	      "position":0,
> 	      "dpa":134217728,
> 	      "rawsize":268435456,
> 	      "slot":3,
> 	      "align":0,
> 	      "region_uuid":"de512bdc-9731-4e5f-838c-be2e9b94ea72",
> 	      "abstraction_uuid":"266400ba-fb9f-4677-bcb0-968f11d0d225",
> 	      "lbasize":512
> 	    }
> 	  ]
> 	}
> 	read 1 nmem
>=20
> 	- NOTE: We have following UUID types as per CXL Spec
> 		"type":"529d7c61-da07-47c4-a93f-ecdf2c06f444" is region label
> 		"type":"68bb2c0a-5a77-4937-9f85-3caf41a0f93c" is namespace label
>=20
>=20
> Limitation (WIP):
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Current changes only support interleave way =3D=3D 1
>=20
> Observation:
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> First time namespace creation using ndctl takes around 10 to 20 second ti=
me
> while executing "devm_memremap_pages" at [3]
>=20
> As using this patchset, after auto region creation, namespace creation is
> happening in boot sequence (if nvdimm and cxl drivers are static), It is
> therefore boot sequence is increased by around 10 to 20 sec.
>=20
>=20
> [1]: https://lore.kernel.org/all/163116432405.2460985.5547867384570123403=
.stgit@dwillia2-desk3.amr.corp.intel.com/
> [2]: https://github.com/neerajoss/ndctl/tree/linux-cxl/CXL_LSA_2.1_Support
> [3]: https://elixir.bootlin.com/linux/v6.13.7/source/drivers/nvdimm/pmem.=
c#L520
>=20
>=20
>=20
>=20
> Neeraj Kumar (20):
>   nvdimm/label: Introduce NDD_CXL_LABEL flag to set cxl label format
>   nvdimm/label: Prep patch to accommodate cxl lsa 2.1 support
>   nvdimm/namespace_label: Add namespace label changes as per CXL LSAv2.1
>   nvdimm/label: CXL labels skip the need for 'interleave-set cookie'
>   nvdimm/region_label: Add region label updation routine
>   nvdimm/region_label: Add region label deletion routine
>   nvdimm/namespace_label: Update namespace init_labels and its region_uuid
>   nvdimm/label: Include region label in slot validation
>   nvdimm/namespace_label: Skip region label during ns label DPA reservati=
on
>   nvdimm/region_label: Preserve cxl region information from region label
>   nvdimm/region_label: Export routine to fetch region information
>   nvdimm/namespace_label: Skip region label during namespace creation
>   cxl/mem: Refactor cxl pmem region auto-assembling
>   cxl/region: Add cxl pmem region creation routine for region persistency
>   cxl: Add a routine to find cxl root decoder on cxl bus
>   cxl/mem: Preserve cxl root decoder during mem probe
>   cxl/pmem: Preserve region information into nd_set
>   cxl/pmem: Add support of cxl lsa 2.1 support in cxl pmem
>   cxl/pmem_region: Prep patch to accommodate pmem_region attributes
>   cxl/pmem_region: Add cxl region label updation and deletion device attr=
ibutes
>=20
>  drivers/cxl/Kconfig             |  12 +
>  drivers/cxl/core/Makefile       |   1 +
>  drivers/cxl/core/core.h         |   8 +-
>  drivers/cxl/core/pmem_region.c  | 325 ++++++++++++++++++++++++++
>  drivers/cxl/core/port.c         |  72 +++++-
>  drivers/cxl/core/region.c       | 383 +++++++++++++++---------------
>  drivers/cxl/cxl.h               |  46 +++-
>  drivers/cxl/cxlmem.h            |   1 +
>  drivers/cxl/mem.c               |  27 ++-
>  drivers/cxl/pmem.c              |  72 +++++-
>  drivers/cxl/port.c              |  38 ---
>  drivers/nvdimm/dimm.c           |   5 +
>  drivers/nvdimm/dimm_devs.c      |  28 +++
>  drivers/nvdimm/label.c          | 403 ++++++++++++++++++++++++++++----
>  drivers/nvdimm/label.h          |  20 +-
>  drivers/nvdimm/namespace_devs.c | 149 ++++++++----
>  drivers/nvdimm/nd-core.h        |   2 +
>  drivers/nvdimm/nd.h             |  81 ++++++-
>  drivers/nvdimm/region_devs.c    |   5 +
>  include/linux/libnvdimm.h       |  28 +++
>  tools/testing/cxl/Kbuild        |   1 +
>  21 files changed, 1364 insertions(+), 343 deletions(-)
>  create mode 100644 drivers/cxl/core/pmem_region.c
>=20
>=20
> base-commit: 448a60e85ae2afe2cb760f5d2ed2c8a49d2bd1b4

