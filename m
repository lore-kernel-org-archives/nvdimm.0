Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274402C80
	for <nvdimm@lists.linux.dev>; Tue,  1 Feb 2022 00:22:44 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id h12so15509792pjq.3
        for <nvdimm@lists.linux.dev>; Mon, 31 Jan 2022 16:22:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=jIHgdGIiKIa4L0IScjJCyDTcpqzj6Bi1VzL3ASe6azQ=;
        b=jgY4HyBd008qBo63rSgSWDTpijDW7gC3KFgr3h6OVdeFQ+xy+xoxY+ch/hqNKZPMnu
         CZUjup8oiCi2Tbc1MwrveJc0+HDEUlvRHxAO432hwwLwvJTQWsQUawBoX8nsfRHYIEaM
         HFUqnKWpQbBwW/3cdqf2PPR484VTXSjZJFj5AXYYJ212wStAii0GteXUTh9FBAW3YWhZ
         pIaN2KnGYevRiIC/zx3DWc+90dueGxWjKPtm1MOgExWADMT60tpJ3CN142+iqjIHZVVS
         GQQeZRXX/8Wy3fUl9JAkq4xK5CKyXIFL2vBHDS79xa+RowHpgdWWjXg9GUGmJKnfqh94
         zlfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=jIHgdGIiKIa4L0IScjJCyDTcpqzj6Bi1VzL3ASe6azQ=;
        b=y/d2DQ4lsFZDU3vcVRL03o2aaDzkpTMA5+C0l0BCyM4lNYKi9f39puAK22ev+9Ifnz
         +q8gOGVfxxlfwkisTasczkNMkarP3wnlX3dfzl0v+s5jKhp81bvsVlEsZnnvtmflvuhK
         EycxbsDsjgYV88wuojeFWTWeR+N+vm41cASR13+5e7/Bz0wJ/ewKrdOu9nVwy6o6HeX/
         x05+u+KrmfhEdbyG3PSzYXHSHa0C/1Rft/Rpu6pF096KWoshtLwLGW8g+93QCo7dsHtI
         xrysBEyZR2MCyJQSQvQCEh0HsBtynm1m4Meqha+BYyCeP6bz0kE6TlAZ8Vb8Fbje3QKD
         QFEQ==
X-Gm-Message-State: AOAM530rVud2dO/peJjoxV2Ogr+mj6FP4ENVC+i0ox3p+kkU4oYKUu4D
	aR7siTdG5gM2Cdt7u9di5BEgmLQUEnfnF0iriPFnxQ==
X-Google-Smtp-Source: ABdhPJwS7MQwNC4f8cq+f3Xr82/cV0/JabcKe4hKPclU2jlfgVz9aw8W6AoyRoZLOttBYD+a/Mtkg+ak5/IS0D4L1vQ=
X-Received: by 2002:a17:90a:640e:: with SMTP id g14mr37044050pjj.8.1643674963543;
 Mon, 31 Jan 2022 16:22:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <164322333437.3694981.17087130505938650994.stgit@dwillia2-desk3.amr.corp.intel.com>
 <164324151672.3935633.11277011056733051668.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20220131161856.00005cd0@Huawei.com>
In-Reply-To: <20220131161856.00005cd0@Huawei.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 31 Jan 2022 16:22:35 -0800
Message-ID: <CAPcyv4j2e-QxZp9-a7aL5JkC2WmLy9DAO9vgeYV7N1GdfayQQg@mail.gmail.com>
Subject: Re: [PATCH v5 18/40] cxl/pmem: Introduce a find_cxl_root() helper
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: linux-cxl@vger.kernel.org, Ben Widawsky <ben.widawsky@intel.com>, 
	Linux PCI <linux-pci@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 31, 2022 at 8:20 AM Jonathan Cameron
<Jonathan.Cameron@huawei.com> wrote:
>
> On Wed, 26 Jan 2022 15:59:07 -0800
> Dan Williams <dan.j.williams@intel.com> wrote:
>
> > In preparation for switch port enumeration while also preserving the
> > potential for multi-domain / multi-root CXL topologies. Introduce a
> > 'struct device' generic mechanism for retrieving a root CXL port, if on=
e
> > is registered. Note that the only know multi-domain CXL configurations
> > are running the cxl_test unit test on a system that also publishes an
> > ACPI0017 device.
> >
> > With this in hand the nvdimm-bridge lookup can be with
> > device_find_child() instead of bus_find_device() + custom mocked lookup
> > infrastructure in cxl_test.
> >
> > The mechanism looks for a 2nd level port since the root level topology
> > is platform-firmware specific and the 2nd level down follows standard
> > PCIe topology expectations. The cxl_acpi 2nd level is associated with a
> > PCIe Root Port.
> >
> > Reported-by: Ben Widawsky <ben.widawsky@intel.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> A question inline.
>
> Thanks,
>
> Jonathan
>
> > ---
> > Changes since v4:
> > - reset @iter each loop otherwise only the first dport can be scanned.
> >
> >  drivers/cxl/core/pmem.c       |   14 ++++++++---
> >  drivers/cxl/core/port.c       |   50 +++++++++++++++++++++++++++++++++=
++++++++
> >  drivers/cxl/cxl.h             |    1 +
> >  tools/testing/cxl/Kbuild      |    2 --
> >  tools/testing/cxl/mock_pmem.c |   24 --------------------
> >  5 files changed, 61 insertions(+), 30 deletions(-)
> >  delete mode 100644 tools/testing/cxl/mock_pmem.c
> >
> > diff --git a/drivers/cxl/core/pmem.c b/drivers/cxl/core/pmem.c
> > index 40b3f5030496..8de240c4d96b 100644
> > --- a/drivers/cxl/core/pmem.c
> > +++ b/drivers/cxl/core/pmem.c
> > @@ -57,24 +57,30 @@ bool is_cxl_nvdimm_bridge(struct device *dev)
> >  }
> >  EXPORT_SYMBOL_NS_GPL(is_cxl_nvdimm_bridge, CXL);
> >
> > -__mock int match_nvdimm_bridge(struct device *dev, const void *data)
> > +static int match_nvdimm_bridge(struct device *dev, void *data)
> >  {
> >       return is_cxl_nvdimm_bridge(dev);
> >  }
> >
> >  struct cxl_nvdimm_bridge *cxl_find_nvdimm_bridge(struct cxl_nvdimm *cx=
l_nvd)
> >  {
> > +     struct cxl_port *port =3D find_cxl_root(&cxl_nvd->dev);
> >       struct device *dev;
> >
> > -     dev =3D bus_find_device(&cxl_bus_type, NULL, cxl_nvd, match_nvdim=
m_bridge);
> > +     if (!port)
> > +             return NULL;
> > +
> > +     dev =3D device_find_child(&port->dev, NULL, match_nvdimm_bridge);
> > +     put_device(&port->dev);
> > +
> >       if (!dev)
> >               return NULL;
> > +
> >       return to_cxl_nvdimm_bridge(dev);
> >  }
> >  EXPORT_SYMBOL_NS_GPL(cxl_find_nvdimm_bridge, CXL);
> >
> > -static struct cxl_nvdimm_bridge *
> > -cxl_nvdimm_bridge_alloc(struct cxl_port *port)
> > +static struct cxl_nvdimm_bridge *cxl_nvdimm_bridge_alloc(struct cxl_po=
rt *port)
> >  {
> >       struct cxl_nvdimm_bridge *cxl_nvb;
> >       struct device *dev;
> > diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> > index 4c921c49f967..6447f12ef71d 100644
> > --- a/drivers/cxl/core/port.c
> > +++ b/drivers/cxl/core/port.c
> > @@ -457,6 +457,56 @@ int devm_cxl_register_pci_bus(struct device *host,=
 struct device *uport,
> >  }
> >  EXPORT_SYMBOL_NS_GPL(devm_cxl_register_pci_bus, CXL);
> >
> > +/* Find a 2nd level CXL port that has a dport that is an ancestor of @=
match */
> > +static int match_cxl_root_child(struct device *dev, const void *match)
> > +{
> > +     const struct device *iter =3D NULL;
> > +     struct cxl_port *port, *parent;
> > +     struct cxl_dport *dport;
> > +
> > +     if (!is_cxl_port(dev))
> > +             return 0;
> > +
> > +     port =3D to_cxl_port(dev);
> > +     if (is_cxl_root(port))
> > +             return 0;
> > +
> > +     parent =3D to_cxl_port(port->dev.parent);
> > +     if (!is_cxl_root(parent))
> > +             return 0;
> > +
> > +     cxl_device_lock(&port->dev);
> > +     list_for_each_entry(dport, &port->dports, list) {
> > +             iter =3D match;
>
> This confuses me.  In the call below to bus_find_device()
> data =3D=3D NULL, which ends up as match here.

I think you misread, @start is NULL @data becomes @match as the
starting point for the search.

>
> So how does that ever find a match?
>
> > +             while (iter) {
> > +                     if (iter =3D=3D dport->dport)
> > +                             goto out;
> > +                     iter =3D iter->parent;
> > +             }
> > +     }
> > +out:
> > +     cxl_device_unlock(&port->dev);
> > +
> > +     return !!iter;
>
> return iter; should be sufficient as docs just say non zero for a match
> in bus_find_device() match functions.

drivers/cxl/core/port.c:488:16: error: returning =E2=80=98const struct devi=
ce
*=E2=80=99 from a function with return type =E2=80=98int=E2=80=99 makes int=
eger from pointer
without a cast [-Werror=3Dint-conversion]

>
> > +}
> > +
> > +struct cxl_port *find_cxl_root(struct device *dev)
> > +{
> > +     struct device *port_dev;
> > +     struct cxl_port *root;
> > +
> > +     port_dev =3D
> > +             bus_find_device(&cxl_bus_type, NULL, dev, match_cxl_root_=
child);
>
> Line breaking is rather ugly to my eye.  Perhaps break
> parameter list up instead?

This is what clang-format picked, but yes it's a tag ugly. I'll go
ahead and s/match_cxl_root_child/match_root_child/ since there are no
public symbol namespace issues with this static helper.
