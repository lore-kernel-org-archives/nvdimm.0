Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4ADE30BBB9;
	Thu, 25 Jun 2026 18:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411283; cv=none; b=utfus7ufatxzoF+wAF9wFCpm+NRSV9Ljp7MR9JI0od+yiag0LxO5y5cyKN1S8EvnxfDMW9aftwMbP5pWOdfpiUEkIfzRL4H1Iqg7fvir8ye1b+rcGYhXY23q85V68Lk6Syu95XIWi6egeCEbRtjQ9YMf4UF98jQs18CwR1B7vLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411283; c=relaxed/simple;
	bh=TgFOmn/S6iGOC3SXnPV3hz4u1hPr+LED4ah7PUQvEw4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=porKB/P+xhlnlUc620f4n3QvkUaNbZxNAD7xVV6P+hCdY/sQtkJOlDduzZTFpyRgAflNY77EYCsvIPHvorwqXRgwz0lAwVH0Y4fcE1ypTchfCpSc7QAskmPa1Qpe7r0AEShoALi1PBO+TlpWrjuawJ2hZYw9Zq1dfX8zOzu4ufI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nWs129Bu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nWs129Bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33E561F000E9;
	Thu, 25 Jun 2026 18:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411282;
	bh=a+/NT9qQPyAZvJ8WJ03mQ9xhmNr5gFd8IqFW41T8WWQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nWs129BubL4C4Z10jBQUX5st0UdJH3MQXL6xhitZDTH89c7X4vvxKAxEEgl/QhlnU
	 PLrfAlNFpczIuxkBpVpDX6LSTMUOe6O7oHJkREEYYNngMVRqkhLCCtnJSt4sGltVds
	 mFGcf+p2divqX5ovMsgqcJQpPQGs/4pI2Ve0RaahvJAVqz6cKFRxId6gWATaQS9Mjd
	 NOPob37CEVcW7qR9nRNDmQKcaASOr6VBd9oKv72NHGz/VHSg7bqZXW3Enr8D2Urk7Y
	 a/76oSCtfCe8VdHVJYR00Yq7l3+0Vt3GWQ/Y5OlB2eID7rj07MGJGYZ9rSVKh8s5qq
	 ceSTesmB4Pqmw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 10/31] cxl/mem: Configure dynamic capacity
 interrupts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20260625112638.550691-11-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-11-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:14:41 +0000
Message-Id: <20260625181442.33E561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [High] An unhandled DCD event status bit will cause an infinite loop in t=
he `cxl_event_thread` IRQ handler if DCD processing is disabled dynamically.
- [High] The driver fails to perform an initial drain of the DCD event log =
when the BIOS has control of standard CXL errors (`!native_cxl`), stranding=
 pre-existing events.
--

commit 4e2d7455b6a9875d8ee530fc91ae3a8b65741caa
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Configure dynamic capacity interrupts

Dynamic Capacity Devices (DCD) support extent change notifications
through the event log mechanism.  The interrupt mailbox commands were
extended in CXL 3.1 to support these notifications.  Firmware can't
configure DCD events to be FW controlled but can retain control of
memory events.

> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 8d12c684d6700..95a4bf7c1e466 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
[ ... ]
> @@ -632,6 +657,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_stat=
e *mds,
>  	return 0;
>  }
> =20
> +static int cxl_irqsetup(struct cxl_memdev_state *mds,
> +			struct cxl_event_interrupt_policy *policy,
> +			bool native_cxl)
> +{
> +	struct cxl_dev_state *cxlds =3D &mds->cxlds;
> +	int rc;
> +
> +	if (native_cxl) {
> +		rc =3D cxl_event_irqsetup(mds, policy);
> +		if (rc)
> +			return rc;
> +	}
> +
> +	if (cxl_dcd_supported(mds)) {
> +		rc =3D cxl_event_req_irq(cxlds, policy->dcd_settings);
> +		if (rc) {
> +			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
> +			cxl_disable_dcd(mds);

[Severity: High]
If cxl_event_req_irq() fails here, cxl_disable_dcd() is called, but the
device is already programmed to generate DCD interrupts.

When a DCD event interrupt fires, cxl_event_thread() will read the status
and retain the CXLDEV_EVENT_STATUS_DCD bit because the mask includes it.
However, cxl_mem_get_event_records() skips draining the log when
cxl_dcd_supported() is false:

drivers/cxl/core/mbox.c:cxl_mem_get_event_records() {
    ...
    if (cxl_dcd_supported(mds) && (status & CXLDEV_EVENT_STATUS_DCD))
        cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_DCD);
    ...
}

Will this cause cxl_event_thread() to spin in an infinite loop since the
status bit is never cleared by draining the log?

> +		}
> +	}
> +
> +	return 0;
> +}
[ ... ]
> @@ -687,11 +744,16 @@ static int cxl_event_config(struct pci_host_bridge =
*host_bridge,
>  	if (rc)
>  		return rc;
> =20
> -	rc =3D cxl_event_irqsetup(mds, &policy);
> +	rc =3D cxl_irqsetup(mds, &policy, native_cxl);
>  	if (rc)
>  		return rc;
> =20
> -	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
> +	if (native_cxl)
> +		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);

[Severity: High]
If the BIOS has control of standard CXL errors (!native_cxl), does this skip
the initial drain of the DCD event log?

Since the driver owns the DCD log regardless of native_cxl, it appears that
pre-existing DCD events might be left in the log, potentially preventing
subsequent edge-triggered interrupts from firing.

> +
> +	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
> +		native_cxl ? "OS" : "BIOS",
> +		cxl_dcd_supported(mds) ? "supported" : "not supported");
> =20
>  	return 0;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D10
