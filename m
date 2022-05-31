Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECC420E2;
	Tue, 31 May 2022 12:40:54 +0000 (UTC)
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LCBFx6sc6z67w73;
	Tue, 31 May 2022 20:21:09 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 31 May 2022 14:21:59 +0200
Received: from localhost (10.122.247.231) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 31 May
 2022 13:21:58 +0100
Date: Tue, 31 May 2022 13:21:57 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: Ben Widawsky <ben.widawsky@intel.com>, <linux-cxl@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <patches@lists.linux.dev>, Alison Schofield
	<alison.schofield@intel.com>, Ira Weiny <ira.weiny@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH 00/15] Region driver
Message-ID: <20220531132157.000022c7@huawei.com>
In-Reply-To: <CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
References: <20220413183720.2444089-1-ben.widawsky@intel.com>
	<20220520172325.000043d8@huawei.com>
	<CAPcyv4hkP1iuBxCPTK_FeQ=+afmVOLAAfE6t0z2u2OGH+Crmag@mail.gmail.com>
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
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

....

> > Hi Ben,
> >
> > I finally got around to actually trying this out on top of Dan's recent=
 fix set
> > (I rebased it from the cxl/preview branch on kernel.org).
> >
> > I'm not having much luck actually bring up a region.
> >
> > The patch set refers to configuring the end point decoders, but all the=
ir
> > sysfs attributes are read only.  Am I missing a dependency somewhere or
> > is the intent that this series is part of the solution only?
> >
> > I'm confused! =20
>=20
> There's a new series that's being reviewed internally before going to the=
 list:
>=20
> https://gitlab.com/bwidawsk/linux/-/tree/cxl_region-redux3
>=20
> Given the proximity to the merge window opening and the need to get
> the "mem_enabled" series staged, I asked Ben to hold it back from the
> list for now.
>=20
> There are some changes I am folding into it, but I hope to send it out
> in the next few days after "mem_enabled" is finalized.

Hi Dan,

I switched from an earlier version of the region code over to a rebase of t=
he tree.
Two issues below you may already have fixed.

The second is a carry over from an earlier set so I haven't tested
without it but looks like it's still valid.

Anyhow, thought it might save some cycles to preempt you sending
out the series if these issues are still present.

Minimal testing so far on these with 2 hb, 2 rp, 4 directly connected
devices, but once you post I'll test more extensively.  I've not
really thought about the below much, so might not be best way to fix.

Found a bug in QEMU code as well (missing write masks for the
target list registers) - will post fix for that shortly.

Thanks,

Jonathan


=46rom fa31f37214fcb121428be1ceb87ae335209fa4cc Mon Sep 17 00:00:00 2001
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Date: Tue, 31 May 2022 13:13:51 +0100
Subject: [PATCH] Fixes for region code

Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 drivers/cxl/region.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/cxl/region.c b/drivers/cxl/region.c
index e81c5b1339ec..fbbf084004d9 100644
--- a/drivers/cxl/region.c
+++ b/drivers/cxl/region.c
@@ -229,10 +229,10 @@ static struct cxl_decoder *stage_decoder(struct cxl_r=
egion *cxlr,

        return cxld;
 }
-
+// calculating whilst working down the tree - so divide granularity of pre=
vious level by local ways.
 static int calculate_ig(struct cxl_decoder *pcxld)
 {
-       return cxl_to_interleave_granularity(cxl_from_granularity(pcxld->ci=
p.g) + cxl_from_ways(pcxld->cip.w));
+       return cxl_to_interleave_granularity(cxl_from_granularity(pcxld->ci=
p.g) - cxl_from_ways(pcxld->cip.w));
 }

 static void unstage_decoder(struct cxl_decoder *cxld)
@@ -302,7 +302,8 @@ static struct cxl_decoder *stage_hb(struct cxl_region *=
cxlr,
                          t->nr_targets))
                return NULL;

-       t->target[port_grouping] =3D root_port;
+       //      t->target[port_grouping] =3D root_port;
+       t->target[hbd->cip.w] =3D root_port;
        hbd->cip.w++;

        /* If no switch, root port is connected to memdev */
--
2.32.0
