Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEAA51DF75B;
	Fri, 31 Jul 2026 09:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785488685; cv=none; b=Ead6sfO+Ym62Fu/j0f72+W0ECzu7XLeGOx8LxPsQ3oIrijR/7NmSrL+4fTFvxMPYn8SFmaMSwa2Lx0fjL6eVtaLSzhEQY+4fyhBQrL0iWrZkp02eFiePYrwKZS2dksU/tCeJPHpd76sExFSmCBJC1j2NJm1JBtFaTBff7S/cxls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785488685; c=relaxed/simple;
	bh=XAhY2LjsD3z0kbZgY0n/Ne0pMMd5Ztv/IZiRid6ZKOc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=l3mSznkuQS2u0hj7diSU1YKIvcwxtb4Ag7hjbqFFkhuviAaAcNEP0zWlsaknEWf/ORNs7lMYne9Glq4Cjy3BKh9Jt/AD599Po3xCxKyqqDBYZMpw6vhzbcroU3MGPbyFoe1La2/SPFnGBLiSR4Bo6qS7w65L2RKZicdZz/MdS8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8U3oZ5y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8U3oZ5y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558491F000E9;
	Fri, 31 Jul 2026 09:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785488684;
	bh=CiChtvOanhbbN3LDErpUWZE9zsETG3HdtaCcK5OuVXs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=S8U3oZ5yqPYlDvNyaLq0MIXnsG5Cw6NaGXaZTJA5MOStU6p6/sJLQ88JRUw9XZGTB
	 MMyBHj1HCxXZkLVhYR6wpy08BEDGwo1qIPQFyJlVyGiog1kDNolE/YtjUFiFThlsa2
	 T5hV+G2DY6znqXZXTQVReyClxSWPk3sdSkH+CQNqNRoYDdtFLHFPI1I+JP3uxsoPNF
	 OZuvYOuLsY45wpe1PU3Jqucrzfb9bzwdAiSC5DZQZ6mno+YJabh3GknuSQt/R+/kT9
	 Yi6zjhWlHSYOPlZbORTGTS8YykdiYpZNWAXFSpUudIVOP+zDdsBaYbqd9/d89LfDCt
	 FovZ2Stz5P3qQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v12 6/8] cxl/mem: Configure dynamic capacity interrupts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260731084901.1512819-7-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
 <20260731084901.1512819-7-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 31 Jul 2026 09:04:43 +0000
Message-Id: <20260731090444.558491F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

New issues:
- [High] Infinite IRQ Thread Loop / CPU Spin when handling DCD events

Pre-existing issues:
- [High] Out-of-Bounds Read and Information Leak in Event logs
- [High] Out-of-Bounds Read and Information Leak in Poison logs
--

--- Patch [6]: [PATCH v12 6/8] cxl/mem: Configure dynamic capacity interrup=
ts ---
commit 5b173c122c3602992c4ceeafd1c2d87a80accacb
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Configure dynamic capacity interrupts

Dynamic Capacity Devices (DCD) support extent change notifications
through the event log mechanism. Configure DCD event log interrupts
on devices supporting dynamic capacity. Disable DCD if interrupts
are not supported.

> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index df13fb8802c38..6cb344ec4f3a7 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
> @@ -509,11 +509,30 @@ static bool cxl_alloc_irq_vectors(struct pci_dev *p=
dev)
>  	return true;
>  }
> =20
> +/*
> + * Event logs the driver drains: standard logs when native_cxl, DCD when
> + * supported.
> + */
> +static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge,
> +				struct cxl_memdev_state *mds)
> +{
> +	u32 mask =3D 0;
> +
> +	if (host_bridge->native_cxl_error)
> +		mask |=3D CXLDEV_EVENT_STATUS_ALL & ~CXLDEV_EVENT_STATUS_DCD;
> +	if (cxl_dcd_supported(mds))
> +		mask |=3D CXLDEV_EVENT_STATUS_DCD;
> +	return mask;
> +}
> +
>  static irqreturn_t cxl_event_thread(int irq, void *id)
>  {
>  	struct cxl_dev_id *dev_id =3D id;
>  	struct cxl_dev_state *cxlds =3D dev_id->cxlds;
>  	struct cxl_memdev_state *mds =3D to_cxl_memdev_state(cxlds);
> +	struct pci_host_bridge *host_bridge =3D
> +		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
> +	u32 mask =3D cxl_event_drain_mask(host_bridge, mds);
>  	u32 status;
> =20
>  	do {
> @@ -522,8 +541,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
>  		 * ignore the reserved upper 32 bits
>  		 */
>  		status =3D readl(cxlds->regs.status + CXLDEV_DEV_EVENT_STATUS_OFFSET);
> -		/* Ignore logs unknown to the driver */
> -		status &=3D CXLDEV_EVENT_STATUS_ALL;
> +		/* Ignore logs unknown to the driver or owned by BIOS */
> +		status &=3D mask;
>  		if (!status)
>  			break;
>  		cxl_mem_get_event_records(mds, status);

[Severity: High]
Since mask now includes CXLDEV_EVENT_STATUS_DCD, status can have this bit s=
et.
However, cxl_mem_get_event_records() does not appear to handle the DCD even=
t:

drivers/cxl/core/mbox.c:cxl_mem_get_event_records() {
    ...
    if (status & CXLDEV_EVENT_STATUS_FATAL)
        cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FATAL);
    if (status & CXLDEV_EVENT_STATUS_FAIL)
        cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_FAIL);
    if (status & CXLDEV_EVENT_STATUS_WARN)
        cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_WARN);
    if (status & CXLDEV_EVENT_STATUS_INFO)
        cxl_mem_get_records_log(mds, CXL_EVENT_TYPE_INFO);
    ...
}

Will this fail to clear the DCD event from the device? If the event is never
cleared, will the hardware register retain the bit and cause the while (sta=
tus)
loop to spin infinitely on the exact same status bit, potentially causing a=
 CPU
soft lockup?

>  		cond_resched();
>  	} while (status);

[ ... ]

[Severity: High]
This is a pre-existing issue, but I noticed a potential out-of-bounds read =
when
fetching event logs:

drivers/cxl/core/mbox.c:cxl_mem_get_records_log() {
    ...
    nr_rec =3D le16_to_cpu(payload->record_count);
    if (!nr_rec)
        break;

    for (i =3D 0; i < nr_rec; i++)
        __cxl_event_trace_record(cxlmd, type,
                                 &payload->records[i]);
    ...
}

Does this code validate the hardware-provided nr_rec against the allocated
payload size? If an untrusted or compromised device returns an artificially
large count, could this read out of bounds?

Similarly, when clearing those records:

drivers/cxl/core/mbox.c:cxl_clear_event_record() {
    ...
    for (cnt =3D 0; cnt < total; cnt++) {
        struct cxl_event_record_raw *raw =3D &get_pl->records[cnt];
        struct cxl_event_generic *gen =3D &raw->event.generic;

        payload->handles[i++] =3D gen->hdr.handle;
    ...
}

Could this write the out-of-bounds memory values into the clear event paylo=
ad
sent back to the device, leading to an information leak?

[Severity: High]
This is also a pre-existing issue, but a similar pattern exists in the pois=
on
log handling:

drivers/cxl/core/mbox.c:cxl_mem_get_poison() {
    ...
    for (int i =3D 0; i < le16_to_cpu(po->count); i++)
        trace_cxl_poison(cxlmd, cxlr, &po->record[i],
                         po->flags, po->overflow_ts,
                         CXL_POISON_TRACE_LIST);
    ...
}

Does this validate po->count against the buffer size, or could it result
in an out-of-bounds read if the device returns a large count?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260731084901.1512=
819-1-anisa.su@samsung.com?part=3D6
