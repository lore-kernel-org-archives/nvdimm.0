Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D19DA2C
	for <nvdimm@lists.linux.dev>; Mon, 14 Feb 2022 17:45:26 +0000 (UTC)
Received: from fraeml712-chm.china.huawei.com (unknown [172.18.147.207])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JyBS03QhZz67P81;
	Tue, 15 Feb 2022 01:44:32 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml712-chm.china.huawei.com (10.206.15.61) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 14 Feb 2022 18:45:23 +0100
Received: from localhost (10.202.226.41) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Mon, 14 Feb
 2022 17:45:22 +0000
Date: Mon, 14 Feb 2022 17:45:21 +0000
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, Ben Widawsky <ben.widawsky@intel.com>,
	<linux-pci@vger.kernel.org>, <nvdimm@lists.linux.dev>
Subject: Re: [PATCH v4 35/40] cxl/core/port: Add endpoint decoders
Message-ID: <20220214174521.00003b84@Huawei.com>
In-Reply-To: <164386092069.765089.14895687988217608642.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298430609.3018233.3860765171749496117.stgit@dwillia2-desk3.amr.corp.intel.com>
	<164386092069.765089.14895687988217608642.stgit@dwillia2-desk3.amr.corp.intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.202.226.41]
X-ClientProxiedBy: lhreml718-chm.china.huawei.com (10.201.108.69) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Wed, 02 Feb 2022 20:02:06 -0800
Dan Williams <dan.j.williams@intel.com> wrote:

> From: Ben Widawsky <ben.widawsky@intel.com>
>=20
> Recall that a CXL Port is any object that publishes a CXL HDM Decoder
> Capability structure. That is Host Bridge and Switches that have been
> enabled so far. Now, add decoder support to the 'endpoint' CXL Ports
> registered by the cxl_mem driver. They mostly share the same enumeration
> as Bridges and Switches, but witout a target list. The target of
> endpoint decode is device-internal DPA space, not another downstream
> port.
>=20
> Signed-off-by: Ben Widawsky <ben.widawsky@intel.com>
> Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
> [djbw: clarify changelog, hookup enumeration in the port driver]
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

...

> index f5e5b4ac8228..990b6670222e 100644
> --- a/drivers/cxl/cxl.h
> +++ b/drivers/cxl/cxl.h
> @@ -346,6 +346,7 @@ struct cxl_decoder *cxl_root_decoder_alloc(struct cxl=
_port *port,
>  struct cxl_decoder *cxl_switch_decoder_alloc(struct cxl_port *port,
>  					     unsigned int nr_targets);
>  int cxl_decoder_add(struct cxl_decoder *cxld, int *target_map);
> +struct cxl_decoder *cxl_endpoint_decoder_alloc(struct cxl_port *port);
>  int cxl_decoder_add_locked(struct cxl_decoder *cxld, int *target_map);
>  int cxl_decoder_autoremove(struct device *host, struct cxl_decoder *cxld=
);
>  int cxl_endpoint_autoremove(struct cxl_memdev *cxlmd, struct cxl_port *e=
ndpoint);
> diff --git a/drivers/cxl/port.c b/drivers/cxl/port.c
> index 4d4e23b9adff..d420da5fc39c 100644
> --- a/drivers/cxl/port.c
> +++ b/drivers/cxl/port.c
> @@ -40,16 +40,17 @@ static int cxl_port_probe(struct device *dev)
>  		struct cxl_memdev *cxlmd =3D to_cxl_memdev(port->uport);
> =20
>  		get_device(&cxlmd->dev);
> -		return devm_add_action_or_reset(dev, schedule_detach, cxlmd);
> +		rc =3D devm_add_action_or_reset(dev, schedule_detach, cxlmd);
> +		if (rc)
> +			return rc;
> +	} else {
> +		rc =3D devm_cxl_port_enumerate_dports(port);
> +		if (rc < 0)
> +			return rc;
> +		if (rc =3D=3D 1)
> +			return devm_cxl_add_passthrough_decoder(port);

This is just a convenient place to ask a question rather that really being
connected to this patch.

8.2.5.12 in CXL r2.0

"A CXL Host Bridge is identified as an ACPI device with Host Interface ID (=
HID) of
=E2=80=9CACPI0016=E2=80=9D and is associated with one or more CXL Root port=
s. Any CXL 2.0 Host
Bridge that is associated with more than one CXL Root Port must contain one=
 instance
of this capability structure in the CHBCR. This capability structure resolv=
es the target
CXL Root Ports for a given memory address."

Suggests to me that there may be an HDM decoder in the one port case and it=
 may need
programming.

Hitting this in QEMU but I suspect it'll occur in real systems as well.

Jonathan



>  	}
> =20
> -	rc =3D devm_cxl_port_enumerate_dports(port);
> -	if (rc < 0)
> -		return rc;
> -
> -	if (rc =3D=3D 1)
> -		return devm_cxl_add_passthrough_decoder(port);
> -
>  	cxlhdm =3D devm_cxl_setup_hdm(port);
>  	if (IS_ERR(cxlhdm))
>  		return PTR_ERR(cxlhdm);
>=20

