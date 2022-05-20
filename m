Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DEB17C3;
	Fri, 20 May 2022 16:40:42 +0000 (UTC)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L4X472XlWz67xxK;
	Sat, 21 May 2022 00:19:35 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 20 May 2022 18:23:27 +0200
Received: from localhost (10.122.247.231) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 20 May
 2022 17:23:26 +0100
Date: Fri, 20 May 2022 17:23:25 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Ben Widawsky <ben.widawsky@intel.com>, <linux-cxl@vger.kernel.org>
CC: <nvdimm@lists.linux.dev>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Dan Williams <dan.j.williams@intel.com>, "Ira
 Weiny" <ira.weiny@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 00/15] Region driver
Message-ID: <20220520172325.000043d8@huawei.com>
In-Reply-To: <20220413183720.2444089-1-ben.widawsky@intel.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
Organization: Huawei Technologies R&D (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.122.247.231]
X-ClientProxiedBy: lhreml737-chm.china.huawei.com (10.201.108.187) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 13 Apr 2022 11:37:05 -0700
Ben Widawsky <ben.widawsky@intel.com> wrote:

> Spring cleaning is here and we're starting fresh so I won't be referencing
> previous postings and I've removed revision history from commit messages.
>=20
> This patch series introduces the CXL region driver as well as associated =
APIs in
> CXL core to create and configure regions. Regions are defined by the CXL =
2.0
> specification [1], a summary follows.
>=20
> A region surfaces a swath of RAM (persistent or volatile) that appears as=
 normal
> memory to the operating system. The memory, unless programmed by BIOS, or=
 a
> previous Operating System, is inaccessible until the CXL driver creates a=
 region
> for it.A region may be strided (interleave granularity) across multiple d=
evices
> (interleave ways). The interleaving may traverse multiple levels of the C=
XL
> hierarchy.
>=20
> +-------------------------+      +-------------------------+
> |                         |      |                         |
> |   CXL 2.0 Host Bridge   |      |   CXL 2.0 Host Bridge   |
> |                         |      |                         |
> |  +------+     +------+  |      |  +------+     +------+  |
> |  |  RP  |     |  RP  |  |      |  |  RP  |     |  RP  |  |
> +--+------+-----+------+--+      +--+------+-----+------+--+
>       |            |                   |               \--
>       |            |                   |        +-------+-\--+------+
>    +------+    +-------+            +-------+   |       |USP |      |
>    |Type 3|    |Type 3 |            |Type 3 |   |       +----+      |
>    |Device|    |Device |            |Device |   |     CXL Switch    |
>    +------+    +-------+            +-------+   | +----+     +----+ |
>                                                 | |DSP |     |DSP | |
>                                                 +-+-|--+-----+-|--+-+
>                                                     |          |
>                                                 +------+    +-------+
>                                                 |Type 3|    |Type 3 |
>                                                 |Device|    |Device |
>                                                 +------+    +-------+
>=20
> Region verification and programming state are owned by the cxl_region dri=
ver
> (implemented in the cxl_region module). Much of the region driver is an
> implementation of algorithms described in the CXL Type 3 Memory Device So=
ftware
> Guide [2].
>=20
> The region driver is responsible for configuring regions found on persist=
ent
> capacities in the Label Storage Area (LSA), it will also enumerate regions
> configured by BIOS, usually volatile capacities, and will allow for dynam=
ic
> region creation (which can then be stored in the LSA). Only dynamically c=
reated
> regions are implemented thus far.
>=20
> Dan has previously stated that he doesn't want to merge ABI until the who=
le
> series is posted and reviewed, to make sure we have no gaps. As such, the=
 goal
> of posting this series is *not* to discuss the ABI specifically, feedback=
 is of
> course welcome. In other wordsIt has been discussed previously. The goal =
is to find
> architectural flaws in the implementation of the ABI that may pose proble=
matic
> for cases we haven't yet conceived.
>=20
> Since region creation is done via sysfs, it is left to userspace to preve=
nt
> racing for resource usage. Here is an overview for creating a x1 256M
> dynamically created region programming to be used by userspace clients. I=
n this
> example, the following topology is used (cropped for brevity):
> /sys/bus/cxl/devices/
> =E2=94=9C=E2=94=80=E2=94=80 decoder0.0 -> ../../../devices/platform/ACPI0=
017:00/root0/decoder0.0
> =E2=94=9C=E2=94=80=E2=94=80 decoder0.1 -> ../../../devices/platform/ACPI0=
017:00/root0/decoder0.1
> =E2=94=9C=E2=94=80=E2=94=80 decoder1.0 -> ../../../devices/platform/ACPI0=
017:00/root0/port1/decoder1.0
> =E2=94=9C=E2=94=80=E2=94=80 decoder2.0 -> ../../../devices/platform/ACPI0=
017:00/root0/port2/decoder2.0
> =E2=94=9C=E2=94=80=E2=94=80 decoder3.0 -> ../../../devices/platform/ACPI0=
017:00/root0/port1/endpoint3/decoder3.0
> =E2=94=9C=E2=94=80=E2=94=80 decoder4.0 -> ../../../devices/platform/ACPI0=
017:00/root0/port2/endpoint4/decoder4.0
> =E2=94=9C=E2=94=80=E2=94=80 decoder5.0 -> ../../../devices/platform/ACPI0=
017:00/root0/port1/endpoint5/decoder5.0
> =E2=94=9C=E2=94=80=E2=94=80 decoder6.0 -> ../../../devices/platform/ACPI0=
017:00/root0/port2/endpoint6/decoder6.0
> =E2=94=9C=E2=94=80=E2=94=80 endpoint3 -> ../../../devices/platform/ACPI00=
17:00/root0/port1/endpoint3
> =E2=94=9C=E2=94=80=E2=94=80 endpoint4 -> ../../../devices/platform/ACPI00=
17:00/root0/port2/endpoint4
> =E2=94=9C=E2=94=80=E2=94=80 endpoint5 -> ../../../devices/platform/ACPI00=
17:00/root0/port1/endpoint5
> =E2=94=9C=E2=94=80=E2=94=80 endpoint6 -> ../../../devices/platform/ACPI00=
17:00/root0/port2/endpoint6
> ...
>=20
> 1. Select a Root Decoder whose interleave spans the desired interleave co=
nfig
>    - devices, IG, IW, Large enough address space.
>    - ie. pick decoder0.0
> 2. Program the decoders for the endpoints comprising the interleave set.
>    - ie. echo $((256 << 20)) > /sys/bus/cxl/devices/decoder3.0
> 3. Create a region
>    - ie. echo $(cat create_pmem_region) >| create_pmem_region
> 4. Configure a region
>    - ie. echo 256 >| interleave_granularity
> 	 echo 1 >| interleave_ways
> 	 echo $((256 << 20)) >| size
> 	 echo decoder3.0 >| target0
> 5. Bind the region driver to the region
>    - ie. echo region0 > /sys/bus/cxl/drivers/cxl_region/bind
>=20
Hi Ben,

I finally got around to actually trying this out on top of Dan's recent fix=
 set
(I rebased it from the cxl/preview branch on kernel.org).

I'm not having much luck actually bring up a region.

The patch set refers to configuring the end point decoders, but all their
sysfs attributes are read only.  Am I missing a dependency somewhere or
is the intent that this series is part of the solution only?

I'm confused!

Jonathan

>=20
> [1]: https://www.computeexpresslink.org/download-the-specification
> [2]: https://cdrdv2.intel.com/v1/dl/getContent/643805?wapkw=3DCXL%20memor=
y%20device%20sw%20guide
>=20
> Ben Widawsky (15):
>   cxl/core: Use is_endpoint_decoder
>   cxl/core/hdm: Bail on endpoint init fail
>   Revert "cxl/core: Convert decoder range to resource"
>   cxl/core: Create distinct decoder structs
>   cxl/acpi: Reserve CXL resources from request_free_mem_region
>   cxl/acpi: Manage root decoder's address space
>   cxl/port: Surface ram and pmem resources
>   cxl/core/hdm: Allocate resources from the media
>   cxl/core/port: Add attrs for size and volatility
>   cxl/core: Extract IW/IG decoding
>   cxl/acpi: Use common IW/IG decoding
>   cxl/region: Add region creation ABI
>   cxl/core/port: Add attrs for root ways & granularity
>   cxl/region: Introduce configuration
>   cxl/region: Introduce a cxl_region driver
>=20
>  Documentation/ABI/testing/sysfs-bus-cxl       |  96 ++-
>  .../driver-api/cxl/memory-devices.rst         |  14 +
>  drivers/cxl/Kconfig                           |  10 +
>  drivers/cxl/Makefile                          |   2 +
>  drivers/cxl/acpi.c                            |  83 ++-
>  drivers/cxl/core/Makefile                     |   1 +
>  drivers/cxl/core/core.h                       |   4 +
>  drivers/cxl/core/hdm.c                        |  44 +-
>  drivers/cxl/core/port.c                       | 363 ++++++++--
>  drivers/cxl/core/region.c                     | 669 ++++++++++++++++++
>  drivers/cxl/cxl.h                             | 168 ++++-
>  drivers/cxl/mem.c                             |   7 +-
>  drivers/cxl/region.c                          | 333 +++++++++
>  drivers/cxl/region.h                          | 105 +++
>  include/linux/ioport.h                        |   1 +
>  kernel/resource.c                             |  11 +-
>  tools/testing/cxl/Kbuild                      |   1 +
>  tools/testing/cxl/test/cxl.c                  |   2 +-
>  18 files changed, 1810 insertions(+), 104 deletions(-)
>  create mode 100644 drivers/cxl/core/region.c
>  create mode 100644 drivers/cxl/region.c
>  create mode 100644 drivers/cxl/region.h
>=20
>=20
> base-commit: 7dc1d11d7abae52aada5340fb98885f0ddbb7c37

