Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793834001;
	b=GzMVNVV8DwKdAsapEM4+ZDS6yWYa1vB9klMuuxL1LK+LFaodFoycggofZRHqg4DGftbf
	 LxtyAhCOypMtjCydE7XlInAaj6rTu6jvXoHhcf+55hurr8MSFFbla6P+ETE1n18gBcyVh
	 kwtyo7mEpTcBKQtzmMR6HQXnEAa4cax3ZqI+zOgbCMWTBtJGXc7qy612+J7qNfGetYpGj
	 6bFCNUAU0APmtqyUJpLo1Z77lGGAOqKj4ohNEetCBv4VaRnYJzMRDhA9qxbfkDTDCrH3e
	 ojE7eg3ecKLW1JlG1Lw3+EEEbsCkq8WfjMx6+1P4DDN8+60rxZhVNqfeCBB3O82qlyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793834001;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=kIIE1LnpIx6uvbEhVNNKYoyukonBrIxkeebkYP47sKU=;
	b=YJin4VLHxdpPKW45m2FipnInKQUuqX3ZcoKLUWqWPsjf2mj5Pku7VksBy6lsFN6ubPcK
	 t8dotU5wQU2okeDh0PZTwKztXs+dRphTWaAFDnXVz8uBC3oGZgmqosS4eyFGycDoYfU7Z
	 SW4uc1k/WkkssTCPONRt01zgSmNZrb01WnTV/UjTX3XWcl8xGlQG38GfEzY3L84nXtOch
	 z3F9f8qBOvIMXaVbvd7iejBcnt40QWLAVztVCb+KO31Q3Jaf3mMgplGA/nd1ffC3AJriW
	 +3XqZfti/9LvTxdQIFU4AYCb+NkOrYVFBXVmo3r87v/BAnOiuXmkc++xPLNG/aZnw+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCHlvUvo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4F7606A326;
	Wed,  4 Nov 2026 23:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LCHlvUvo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B7091F000C1;
	Wed,  4 Nov 2026 23:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793834000;
	bh=kIIE1LnpIx6uvbEhVNNKYoyukonBrIxkeebkYP47sKU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LCHlvUvoWo8mDNjFPj3w4dY3MbsKI1WBurGI6ca8uTM3CuwaveOP0gOi7lZJNMmSF
	 TefjcGFD5FEtVa2XyNfn9xj1YAWeQZtuF+sFJc06/1pXNrILn3yFlI0Xcq5Bm0PZyw
	 zyenvskpW16GwzHtzBF4PEOlwXoBr9F3rBUWEig7zs1Y3LlByl6fCHobs0ovglhkKu
	 nULJCuOkDw6bKzNaLR1Nzca3hVgWC19ZhwrdRYBuCgHok00xayGkf61TrXwWQkyHoQ
	 ytFxYJHtPSSDLtuK1/Aaz1kKO0mxmpqVn6XyrA1RkVIydcgdSmHWGuRm+CwNhwIM3s
	 sLFohGqqaIc5A==
Message-ID: <sashiko-outbox-198277@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v1 05/14] cxl/mem: Add 20 second timeout for stalled DC
 event chains
Reply-To: sashiko-reviews@lists.linux.dev
To: "Anisa Su" <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev
In-Reply-To: <20261104230445.66625-6-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
 <20261104230445.66625-6-anisa.su@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 23:13:20 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] cxl/mem: handle_dcd_chain_event() queues work on deprecated system_=
wq
--

commit ffea09425b5b7122c1c8acbc05e99f66a63015a7
Author: Anisa Su <anisa.su887@gmail.com>

cxl/mem: Add 20 second timeout for stalled DC event chains

This commit adds a 20-second delayed-work watchdog to abort Dynamic Capacity
event chains when a device opens a chain with CXL_DCD_EVENT_MORE set but
never sends the closing record. On timeout, an add capacity chain is refused
with an empty response while a release capacity chain is cleared for retry.

> diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> index 3acf5ace48dbc..fea910e6c5108 100644
> --- a/drivers/cxl/core/mbox.c
> +++ b/drivers/cxl/core/mbox.c

[ ... ]

> @@ -1279,9 +1343,22 @@ static int handle_dcd_chain_event(struct cxl_memde=
v_state *mds,
> =20
>  	if (event->flags & CXL_DCD_EVENT_MORE) {
>  		dev_dbg(dev, "more bit set; delay processing of extent\n");
> +		/* The deadline is fixed when the chain opens, not per record */
> +		if (!chain->armed) {
> +			queue_delayed_work(system_wq, &chain->timeout_work,
> +					   CXL_DC_CHAIN_TIMEOUT);
> +			chain->armed =3D true;
> +		}

[Severity: Low]
When a Dynamic Capacity event record arrives with CXL_DCD_EVENT_MORE set,
handle_dcd_chain_event() queues chain->timeout_work onto system_wq.

In include/linux/workqueue.h, system_wq is marked deprecated in favor of
system_percpu_wq:

extern struct workqueue_struct *system_wq; /* use system_percpu_wq, this wi=
ll be removed */
extern struct workqueue_struct *system_percpu_wq;

Because system_wq is allocated with __WQ_DEPRECATED, when the 20-second tim=
er
expires and delayed_work_timer_fn() dispatches the work via __queue_work(),
it triggers a runtime deprecation warning:

	if (unlikely(wq->flags & __WQ_DEPRECATED))
		pr_warn_once("workqueue: work func %ps enqueued on deprecated workqueue. "
			"Use system_{percpu|dfl}_wq instead.\n",
			work->func);

Should handle_dcd_chain_event() use schedule_delayed_work() or
system_percpu_wq instead of system_wq?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104230445.6662=
5-1-anisa.su@samsung.com?part=3D5
