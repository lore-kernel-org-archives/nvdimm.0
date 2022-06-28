Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CDE257A;
	Tue, 28 Jun 2022 11:47:24 +0000 (UTC)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LXN5N1f3kz682jJ;
	Tue, 28 Jun 2022 19:43:20 +0800 (CST)
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 28 Jun 2022 13:47:21 +0200
Received: from localhost (10.202.226.42) by lhreml710-chm.china.huawei.com
 (10.201.108.61) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Tue, 28 Jun
 2022 12:47:20 +0100
Date: Tue, 28 Jun 2022 12:47:18 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: <linux-cxl@vger.kernel.org>, <hch@infradead.org>,
	<alison.schofield@intel.com>, <nvdimm@lists.linux.dev>,
	<linux-pci@vger.kernel.org>, <patches@lists.linux.dev>
Subject: Re: [PATCH 02/46] cxl/port: Keep port->uport valid for the entire
 life of a port
Message-ID: <20220628124718.000023f8@Huawei.com>
In-Reply-To: <165603871491.551046.6682199179541194356.stgit@dwillia2-xfh>
References: <165603869943.551046.3498980330327696732.stgit@dwillia2-xfh>
	<165603871491.551046.6682199179541194356.stgit@dwillia2-xfh>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.29; i686-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [10.202.226.42]
X-ClientProxiedBy: lhreml712-chm.china.huawei.com (10.201.108.63) To
 lhreml710-chm.china.huawei.com (10.201.108.61)
X-CFilter-Loop: Reflected

On Thu, 23 Jun 2022 19:45:14 -0700
Dan Williams <dan.j.williams@intel.com> wrote:

> The upcoming region provisioning implementation has a need to
> dereference port->uport during the port unregister flow. Specifically,
> endpoint decoders need to be able to lookup their corresponding memdev
> via port->uport.
>=20
> The existing ->dead flag was added for cases where the core was
> committed to tearing down the port, but needed to drop locks before
> calling device_unregister(). Reuse that flag to indicate to
> delete_endpoint() that it has no "release action" work to do as
> unregister_port() will handle it.
>=20
> Fixes: 8dd2bc0f8e02 ("cxl/mem: Add the cxl_mem driver")

=46rom the explanation I'm not seeing why this has a fixes tag?

Otherwise seems fine...


> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/cxl/core/port.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
> index dbce99bdffab..7810d1a8369b 100644
> --- a/drivers/cxl/core/port.c
> +++ b/drivers/cxl/core/port.c
> @@ -370,7 +370,7 @@ static void unregister_port(void *_port)
>  		lock_dev =3D &parent->dev;
> =20
>  	device_lock_assert(lock_dev);
> -	port->uport =3D NULL;
> +	port->dead =3D true;
>  	device_unregister(&port->dev);
>  }
> =20
> @@ -857,7 +857,7 @@ static void delete_endpoint(void *data)
>  	parent =3D &parent_port->dev;
> =20
>  	device_lock(parent);
> -	if (parent->driver && endpoint->uport) {
> +	if (parent->driver && !endpoint->dead) {
>  		devm_release_action(parent, cxl_unlink_uport, endpoint);
>  		devm_release_action(parent, unregister_port, endpoint);
>  	}
>=20

