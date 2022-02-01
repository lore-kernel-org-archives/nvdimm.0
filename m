Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A492CA1
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 10:58:36 +0000 (UTC)
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Jp1zF1qTpz67stb;
	Tue,  1 Feb 2022 18:54:49 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Tue, 1 Feb 2022 11:58:34 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Tue, 1 Feb
 2022 10:58:33 +0000
Date: Tue, 1 Feb 2022 10:58:32 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>, "Linux
 PCI" <linux-pci@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v5 18/40] cxl/pmem: Introduce a find_cxl_root() helper
Message-ID: <20220201105832.000058d6@Huawei.com>
In-Reply-To: <CAPcyv4j2e-QxZp9-a7aL5JkC2WmLy9DAO9vgeYV7N1GdfayQQg@mail.gmail.com>
References: <164322333437.3694981.17087130505938650994.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164324151672.3935633.11277011056733051668.stgit@dwillia2-desk3.amr.corp.intel.com>
	<20220131161856.00005cd0@Huawei.com>
	<CAPcyv4j2e-QxZp9-a7aL5JkC2WmLy9DAO9vgeYV7N1GdfayQQg@mail.gmail.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml733-chm.china.huawei.com (10.201.108.84) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Mon, 31 Jan 2022 16:22:35 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> On Mon, Jan 31, 2022 at 8:20 AM Jonathan Cameron
> <Jonathan.Cameron@huawei.com> wrote:
> >
> > On Wed, 26 Jan 2022 15:59:07 -0800
> > Dan Williams <dan.j.williams@intel.com> wrote:
> > =20
> > > In preparation for switch port enumeration while also preserving the
> > > potential for multi-domain / multi-root CXL topologies. Introduce a
> > > 'struct device' generic mechanism for retrieving a root CXL port, if =
one
> > > is registered. Note that the only know multi-domain CXL configurations
> > > are running the cxl_test unit test on a system that also publishes an
> > > ACPI0017 device.
> > >
> > > With this in hand the nvdimm-bridge lookup can be with
> > > device_find_child() instead of bus_find_device() + custom mocked look=
up
> > > infrastructure in cxl_test.
> > >
> > > The mechanism looks for a 2nd level port since the root level topology
> > > is platform-firmware specific and the 2nd level down follows standard
> > > PCIe topology expectations. The cxl_acpi 2nd level is associated with=
 a
> > > PCIe Root Port.
> > >
> > > Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> > > Signed-off-by: Dan Williams <dan.j.williams@intel.com> =20
> > A question inline.
> >
> > Thanks,
> >
> > Jonathan
> > =20
> > > ---
> > > Changes since v4:
> > > - reset @iter each loop otherwise only the first dport can be scanned.
> > >
> > >  drivers/cxl/core/pmem.c       |   14 ++++++++---
> > >  drivers/cxl/core/port.c       |   50 +++++++++++++++++++++++++++++++=
++++++++++
> > >  drivers/cxl/cxl.h             |    1 +
> > >  tools/testing/cxl/Kbuild      |    2 --
> > >  tools/testing/cxl/mock_pmem.c |   24 --------------------
> > >  5 files changed, 61 insertions(+), 30 deletions(-)
> > >  delete mode 100644 tools/testing/cxl/mock_pmem.c
> > >
> > > diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> > > index 40b3f5030496..8de240c4d96b 100644
> > > --- a/drivers/cxl/core/pmem.c
> > > +++ b/drivers/cxl/core/pmem.c
> > > @@ -57,24 +57,30 @@ bool is_cxl_nvdimm_bridge(struct device *dev)
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(is_cxl_nvdimm_bridge, CXL);
> > >
> > > -__mock int match_nvdimm_bridge(struct device *dev, const void *data)
> > > +static int match_nvdimm_bridge(struct device *dev, void *data)
> > >  {
> > >       return is_cxl_nvdimm_bridge(dev);
> > >  }
> > >
> > >  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *=
cxl_nvd)
> > >  {
> > > +     struct cxl_port *port =3D find_cxl_root(&cxl_nvd->dev);
> > >       struct device *dev;
> > >
> > > -     dev =3D bus_find_device(&cxl_bus_type, NULL, cxl_nvd, match_nvd=
imm_bridge);
> > > +     if (!port)
> > > +             return NULL;
> > > +
> > > +     dev =3D device_find_child(&port->dev, NULL, match_nvdimm_bridge=
);
> > > +     put_device(&port->dev);
> > > +
> > >       if (!dev)
> > >               return NULL;
> > > +
> > >       return to_cxl_nvdimm_bridge(dev);
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(cxl_find_nvdimm_bridge, CXL);
> > >
> > > -static struct cxl_nvdimm_bridge *
> > > -cxl_nvdimm_bridge_alloc(struct cxl_port *port)
> > > +static struct cxl_nvdimm_bridge *cxl_nvdimm_bridge_alloc(struct cxl_=
port *port)
> > >  {
> > >       struct cxl_nvdimm_bridge *cxl_nvb;
> > >       struct device *dev;
> > > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > > index 4c921c49f967..6447f12ef71d 100644
> > > --- a/drivers/cxl/core/port.c
> > > +++ b/drivers/cxl/core/port.c
> > > @@ -457,6 +457,56 @@ int devm_cxl_register_pci_bus(struct device *hos=
t, struct device *uport,
> > >  }
> > >  EXPORT_SYMBOL_NS_GPL(devm_cxl_register_pci_bus, CXL);
> > >
> > > +/* Find a 2nd level CXL port that has a dport that is an ancestor of=
 @match */
> > > +static int match_cxl_root_child(struct device *dev, const void *matc=
h)
> > > +{
> > > +     const struct device *iter =3D NULL;
> > > +     struct cxl_port *port, *parent;
> > > +     struct cxl_dport *dport;
> > > +
> > > +     if (!is_cxl_port(dev))
> > > +             return 0;
> > > +
> > > +     port =3D to_cxl_port(dev);
> > > +     if (is_cxl_root(port))
> > > +             return 0;
> > > +
> > > +     parent =3D to_cxl_port(port->dev.parent);
> > > +     if (!is_cxl_root(parent))
> > > +             return 0;
> > > +
> > > +     cxl_device_lock(&port->dev);
> > > +     list_for_each_entry(dport, &port->dports, list) {
> > > +             iter =3D match; =20
> >
> > This confuses me.  In the call below to bus_find_device()
> > data =3D=3D NULL, which ends up as match here. =20
>=20
> I think you misread, @start is NULL @data becomes @match as the
> starting point for the search.

oops. I read the wrong parameter order as you identified.


>=20
> >
> > So how does that ever find a match?
> > =20
> > > +             while (iter) {
> > > +                     if (iter =3D=3D dport->dport)
> > > +                             goto out;
> > > +                     iter =3D iter->parent;
> > > +             }
> > > +     }
> > > +out:
> > > +     cxl_device_unlock(&port->dev);
> > > +
> > > +     return !!iter; =20
> >
> > return iter; should be sufficient as docs just say non zero for a match
> > in bus_find_device() match functions. =20
>=20
> drivers/cxl/core/port.c:488:16: error: returning =E2=80=98const struct de=
vice
> *=E2=80=99 from a function with return type =E2=80=98int=E2=80=99 makes i=
nteger from pointer
> without a cast [-Werror=3Dint-conversion]
Ah. Good point.

Jonathan

