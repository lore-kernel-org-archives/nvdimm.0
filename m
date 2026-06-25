Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D16D430FC26;
	Thu, 25 Jun 2026 18:12:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782411141; cv=none; b=LFLuZY8PV0TJHLQHyB+x9zC5HbgIcW7llU4TsBO/84uGqbgVN7MZonLdF+snQu3dakac79aaxO+E4fTmXiKhADLaTibHhKkpJEj3aiMgu64WCdGKOld1FeOXaLcmY+W4e87eh+fY0CMVPSIf4fCCFg3uLOobJMc/4TvBx3AivU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782411141; c=relaxed/simple;
	bh=vx1ac3c/GnlZUy9y/e+huMiL3iz/T0lADzE6Ij7fR6U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DMSZUZ6BM5CAQ95UEzmXRZGQTQBkeEH3K+DDbttV9B4GBJGUKvQ1Wg51qeg5fOL8Bm75nI73SXgYc/5tDUTv6CfNBjSrvIYVDLfMgy9MjKg1RIzn8OHp9e/NkMg89zxOGTSAra+5uc2/ICge4VHErtySMvOI6Isqj4b8vhMRHXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QFlUhI+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QFlUhI+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8B51F000E9;
	Thu, 25 Jun 2026 18:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782411139;
	bh=61aa1MbJBQ8vPMA1+8V3QhkuAJ6Gke/Ge/GCc0NcJks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QFlUhI+iMBmi2YzIP04Gheirm+bQhuIXAXHHYeGV/e13ocDytfDeMmoo9Hq2z7Wwv
	 Utv77lhC42pGkgFXyvdKsoBJMAqo5+zdOx2PVv+rRnU3MVx9NfgYavAB1ByVu3hO15
	 Vcot7rKotKuFnY92Pw/+VhozabfWo0yxXYqL7VsVJ3wXdOvVnxlei720yfA9L2wii/
	 SwUIERJpm4BngPtjiaedL29ecCUx7Gk8ohkCmG3Vi7peJoDKJRAnnxEbo4vJIprQhB
	 FcYNUE12lG+j6wbgBYQKP32jmRFcqrMfES5YE4TW02oyh3cpeUSdfR5mgCQ7es+qqp
	 IiWC6zwYjViaQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 12/31] cxl/mem: Set up framework for handling DC
 Events
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
In-Reply-To: <20260625112638.550691-13-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-13-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 25 Jun 2026 18:12:18 +0000
Message-Id: <20260625181219.4E8B51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] Missing DCD response on memory allocation failure leaves the devic=
e state machine permanently blocked while unconditionally clearing the even=
t log.
- [Medium] Stack-allocation optimization in `memdev_release_extent()` is de=
feated by an internal dynamic allocation in `cxl_send_dc_response()`.
- [Medium] Invalid `__counted_by` attribute on a little-endian struct membe=
r breaks bounds checking on big-endian architectures.
--

commit f5333550094fcaacb4e98dbf0c270b32ec17b506
Author: Ira Weiny <iweiny@kernel.org>

cxl/mem: Set up framework for handling DC Events
   =20
Adds the support for receiving DC event records but defers
the real add/release logic to subsequent commits. Simply refuse all
extents for DC_ADD and ack all DC_RELEASE events for now. Forced
release is currently unsupported.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> +static void memdev_release_extent(struct cxl_memdev_state *mds, struct r=
ange *range)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	struct cxl_extent extent =3D {
> +		.start_dpa =3D cpu_to_le64(range->start),
> +		.length =3D cpu_to_le64(range_len(range)),
> +	};
> +	struct cxl_extent_list_node node =3D { .extent =3D &extent };
> +	LIST_HEAD(extent_list);
> +
> +	dev_dbg(dev, "Release response dpa %pra\n", range);
> +
> +	/*
> +	 * Stack-allocated instead of kzalloc'ed to avoid potential -ENOMEM,
> +	 * which would prevent sending the release DC rsp.
> +	 */
> +	list_add_tail(&node.list, &extent_list);
> +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_RELEASE_DC, &extent_list, 1))

[Severity: Medium]
The comment mentions stack-allocating to avoid -ENOMEM so we can ensure the
release DC response is sent.

However, cxl_send_dc_response() uses kzalloc() to allocate the
cxl_mbox_dc_response message:

    struct cxl_mbox_dc_response *response __free(kfree) =3D
                        kzalloc(pl_size, GFP_KERNEL);

Doesn't this dynamic allocation defeat the optimization, since memory
pressure could still cause kzalloc() to fail, preventing the release
response from being sent?

> +		dev_dbg(dev, "Failed to release %pra\n", range);
> +}

[ ... ]

> +static int handle_add_event(struct cxl_memdev_state *mds,
> +			    struct cxl_event_dcd *event)
> +{
> +	struct device *dev =3D mds->cxlds.dev;
> +	int rc;
> +
> +	rc =3D add_to_pending_list(&mds->add_ctx.pending_extents, &event->exten=
t);
> +	if (rc) {
> +		clear_pending_extents(mds);
> +		return rc;
> +	}

[Severity: High]
If add_to_pending_list() fails and returns -ENOMEM, we return early without
sending the required CXL_MBOX_OP_ADD_DC_RESPONSE command.

Since cxl_handle_dcd_event_records() drops the error and the event is clear=
ed
from the device log, will this leave the device state machine permanently
blocked waiting for a response that never arrives?

> +
> +	if (event->flags & CXL_DCD_EVENT_MORE) {

[ ... ]

> diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
> --- a/drivers/cxl/cxlmem.h
> +++ b/drivers/cxl/cxlmem.h

[ ... ]

> +/*
> + * Add Dynamic Capacity Response
> + * CXL rev 3.1 section 8.2.9.9.9.3; Table 8-168 & Table 8-169
> + */
> +struct cxl_mbox_dc_response {
> +	__le32 extent_list_size;
> +	u8 flags;
> +	u8 reserved[3];
> +	struct updated_extent_list {
> +		__le64 dpa_start;
> +		__le64 length;
> +		u8 reserved[8];
> +	} __packed extent_list[] __counted_by(extent_list_size);

[Severity: Medium]
Should this use __counted_by_le() instead of __counted_by()?

Since extent_list_size is explicitly little-endian (__le32), using
__counted_by() on big-endian architectures will result in the bounds checki=
ng
instrumentation reading an inflated integer value, leading to out-of-bounds
errors or kernel panics.

> +} __packed;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260625112638.5506=
91-1-anisa.su@samsung.com?part=3D12
