Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2BE63659FB;
	Wed,  7 Oct 2026 20:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791405047; cv=none; b=TNeb51oQYCifR9j8xb6yc3L6kxXJ5gedZBPnSiWqBGjJE1pxBAA4BVOscYrDRuVWoTULJvWpvMNvNpzLyqlWghMuq7v2KRETArmtBhqw4JyIEMdbJqOkfxByodcjN40CBSsH8JlvWco36qKHS20JB7AtzBihDOUkVOhUM+/FbGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791405047; c=relaxed/simple;
	bh=hMt6w3MXxq87xfZheYcv/ZSYY3RwCi39yliBF2srruE=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=gcB7KgonMtNdd+OHXC9/e3/MWKc/VQLXzO5ftel/EzYlXcjskh8UXaTGDY0Osti7iR/NovP9P9iPHuP43QOUEFhi+yoaVGUCkAA5TwcKv+lyDoDj7QKEHz8P5zT9iOXn1tuZ8k0oW2zx+zRGRgmpmsqMDvbnIfDgkoE/rUuuIus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fhAUNCo6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fhAUNCo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ACD61F000FF;
	Wed,  7 Oct 2026 20:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791405046;
	bh=i6iZEu0NHaB946uUApQWm3E1l7hCHBVpS5Yummr2p6I=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fhAUNCo6QsJIbBwDjSPQu2t0MNIKZqN/+yy4XNhsySPnt8yDEclhrromuswImwDkq
	 p2dCfAU39yc26OvSi+TmbQ2/P4VBkT5aGcIfSikTwDqUVlwtVKIUoMxfP8f77S42gP
	 AwZvEBgh3pC5gcpYULUdTD3n/WEAIqg57lEOoBtYB/Nw44aCID7SdH549mw2dXqRFk
	 TMRii4ZpqRTIgY6l2ZeB3geiAowRrxRd+aL7WH2YXDbiix19AJgozWYbun/aiIQ26x
	 rmFV8/CG2iUJAds8Z1tufGv8n6xTAMCNy6hqRKyIrHu6Z1o+19CJ5rbhy4cxCE2dww
	 sBLhTL42JHIIQ==
Message-ID: <sashiko-outbox-163340@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v15 6/8] cxl/mem: Configure dynamic capacity interrupts
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
In-Reply-To: <20261007201828.952-7-anisa.su@samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
 <20261007201828.952-7-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 20:30:45 +0000
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] cxl: infinite loop in cxl_event_thread() on device surprise removal
--

commit 84b381be3cde0a84228cae787a5be8a35384cffd
Author: Ira Weiny <iweiny@kernel.org>

    cxl/mem: Configure dynamic capacity interrupts
   =20
    Dynamic Capacity Devices (DCD) support extent change notifications
    through the event log mechanism. The interrupt mailbox commands were
    extended in CXL 3.1 to support these notifications. Firmware can't
    configure DCD events to be FW controlled but can retain control of
    memory events.

> diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
> index 7b754af2168d0..d2bed92be30df 100644
> --- a/drivers/cxl/pci.c
> +++ b/drivers/cxl/pci.c
[ ... ]
> @@ -523,8 +534,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
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
>  		cond_resched();
>  	} while (status);

[Severity: High]
If the CXL device is surprise-removed or its PCIe link goes down, readl()
will return ~0U. Since this is masked with a non-zero bitmask, could
this result in an infinite loop?

If the loop does not break, the IRQ thread could consume 100% of a CPU core
and prevent the PCI removal path from completing. Should there be a check
for status =3D=3D ~0U to break out of the loop?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007201828.952-=
1-anisa.su@samsung.com?part=3D6
