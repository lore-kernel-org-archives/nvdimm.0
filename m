Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D2C74690
	for <nvdimm@lists.linux.dev>; Thu, 21 Jul 2022 17:22:57 +0000 (UTC)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LpfSX1xQnz6J66g;
	Fri, 22 Jul 2022 01:19:24 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Thu, 21 Jul 2022 19:22:54 +0200
Received: from localhost (10.122.247.231) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 21 Jul
 2022 18:22:53 +0100
Date: Thu, 21 Jul 2022 18:22:52 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, David Hildenbrand <david@redhat.com>, "Tony
 Luck" <tony.luck@intel.com>, Jason Gunthorpe <jgg@nvidia.com>, Ben Widawsky
	<bwidawsk@kernel.org>, Christoph Hellwig <hch@lst.de>, Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>, Matthew Wilcox <willy@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>
Subject: Re: [PATCH v2 00/28] CXL PMEM Region Provisioning
Message-ID: <20220721182252.0000227f@huawei.com>
In-Reply-To: <62d97efa7ec7a_17f3e8294b4@dwillia2-xfh.jf.intel.com.notmuch>
References: <165784324066.1758207.15025479284039479071.stgit@dwillia2-xfh.jf.intel.com>
	<20220721155907.0000708c@huawei.com>
	<62d97efa7ec7a_17f3e8294b4@dwillia2-xfh.jf.intel.com.notmuch>
Organization: Huawei Technologies R&D (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.122.247.231]
X-ClientProxiedBy: lhreml732-chm.china.huawei.com (10.201.108.83) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 21 Jul 2022 09:29:46 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> Jonathan Cameron wrote:
> > On Thu, 14 Jul 2022 17:00:41 -0700
> > Dan Williams <dan.j.williams@intel.com> wrote:
> >=20
> >=20
> > Hi Dan,
> >=20
> > I'm low on time unfortunately and will be OoO for next week,
> > But whilst fixing a bug in QEMU, I set up a test to exercise
> > the high port target register on the hb with
> >=20
> > CFMWS interleave ways =3D 1
> > hb with 8 rp with a type3 device connected to each.
> >=20
> > The resulting interleave granularity isn't what I'd expect to see.
> > Setting region interleave to 1k (which happens to match the CFMWS)
> > I'm getting 1k for the CFMWS, 2k for the hb and 256 bytes for the type3
> > devices.  Which is crazy...  Now there may be another bug lurking
> > in QEMU so this might not be a kernel issue at all. =20
>=20
> Potentially, I will note that there seems to be a QEMU issue, that I
> have not had time to dig into, that is preventing region creation
> compared to other environments, maybe this is it...
>=20

Fwiw, proposed QEMU fix is this.  One of those where I'm not sure how
it gave the impression of working previously.

=46rom 64c6566601c782e91eafe48eb28711e4bb85e8d0 Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Thu, 21 Jul 2022 13:29:59 +0100
Subject: [PATCH] hw/cxl: Fix wrong query of target ports.

Two issues in this code:
1) Check on which register to look in was inverted.
2) Both branches read the _LO register.

Whilst here moved to extract32() rather than hand rolling
the field extraction as simpler and hopefully less error prone.

Fixes Coverity CID: 1488873

Reported-by: Peter Maydell <peter.maydell@linaro.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 hw/cxl/cxl-host.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/hw/cxl/cxl-host.c b/hw/cxl/cxl-host.c
index faa68ef038..1adf61231a 100644
--- a/hw/cxl/cxl-host.c
+++ b/hw/cxl/cxl-host.c
@@ -104,7 +104,6 @@ static bool cxl_hdm_find_target(uint32_t *cache_mem, hw=
addr addr,
     uint32_t ctrl;
     uint32_t ig_enc;
     uint32_t iw_enc;
-    uint32_t target_reg;
     uint32_t target_idx;

     ctrl =3D cache_mem[R_CXL_HDM_DECODER0_CTRL];
@@ -116,14 +115,13 @@ static bool cxl_hdm_find_target(uint32_t *cache_mem, =
hwaddr addr,
     iw_enc =3D FIELD_EX32(ctrl, CXL_HDM_DECODER0_CTRL, IW);
     target_idx =3D (addr / cxl_decode_ig(ig_enc)) % (1 << iw_enc);

-    if (target_idx > 4) {
-        target_reg =3D cache_mem[R_CXL_HDM_DECODER0_TARGET_LIST_LO];
-        target_reg >>=3D target_idx * 8;
+    if (target_idx < 4) {
+        *target =3D extract32(cache_mem[R_CXL_HDM_DECODER0_TARGET_LIST_LO],
+                            target_idx * 8, 8);
     } else {
-        target_reg =3D cache_mem[R_CXL_HDM_DECODER0_TARGET_LIST_LO];
-        target_reg >>=3D (target_idx - 4) * 8;
+        *target =3D extract32(cache_mem[R_CXL_HDM_DECODER0_TARGET_LIST_HI],
+                            (target_idx - 4) * 8, 8);
     }
-    *target =3D target_reg & 0xff;

     return true;
 }
--
2.32.0



> > For this special case we should be ignoring the CFMWS IG
> > as it's irrelevant if we aren't interleaving at that level.
> > We also know we don't have any address bits used for interleave
> > decoding until the HB. =20
>=20
> ...but I am certain that the drvier implementation is not accounting for
> the freedom to specify any granularity when the CFMWS interleave is x1.
> Will craft an incremental fix.

