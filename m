Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3612B382F1F
	for <nvdimm@lists.linux.dev>; Thu, 16 Jul 2026 04:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784177623; cv=none; b=ue4oGYNuI0mA/kTewG8esRS0qmwtEQ5pb4WhfcdjmO/npsmpcXkLTMjKEiMaMqABC7DzanfFhkcXFyQepDA0GHrw1T35LQSD3YOqGt2rW1bVRRZzHgZcv32KFMIQhunsqfsT63VvdwkAQ0bo5V8QNYlp+RDyDgXv94b3nlnv7iU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784177623; c=relaxed/simple;
	bh=cyIUse6rdIINUmJMuDe20rWMLdtFCRJOhWxbsLdHauk=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hooEHYiyAKmzjEUiq1vZTcxT8sR7/LhoShcEolUPjTIjkRuRXXu+LYMIIkSvFJo6gt2DX9yLg1n7/YXQbOCwp7eFQd66akjK+s8U6OFT6E7iB2TcPa4K5+BGkU1DWzUJVuDBcwA5/EzZI8/5tYusMgnaZlcFtwcZFy2qYtGUChk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHA6v/jI; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHA6v/jI"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-38511175ad3so5174827a91.2
        for <nvdimm@lists.linux.dev>; Wed, 15 Jul 2026 21:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784177621; x=1784782421; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Sx8AIaAR3RInGCLFLAiX7ZQYpG491PmBlyZ/gwBf0XQ=;
        b=aHA6v/jIHe0520jr0DMF8qb3OYct9g9plp7Pm5oESwrhe8I4pg0ZQOLxN1CTOXkSCv
         q5NUP3lFFSVDEk+ZjDMJfaj4DBo2aNHTTUms6e7/WCuTvE0UJDM7OvRZgAiU0QFfNR9i
         UG9SJ8AFasTQWIWxfPYEccdPoMk3DrwUaLefeRX6pGNbwPShQk5XPr9meJJDyiuCuLGl
         d3AGmzzhTOp/J7d1ibOuz7lMSL5jnt08qGknH9+t+UI5saRcQhZjHDcLv6cp7bkowCd1
         KrBMRZznbhzc4jmijtBolXx5C3R9QlXWxBLiQuZ1NGOJyagkUUKJ4OhUfF7l2aDwyFEU
         frcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784177621; x=1784782421;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:date
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Sx8AIaAR3RInGCLFLAiX7ZQYpG491PmBlyZ/gwBf0XQ=;
        b=AW5+XgKy7D5yF6pRM53fI0Q2aYZNeJOK/6SqpIAzQAQdAm0P0+8Q+MiRsA3M1gbHKF
         MA9mpZw3JNtLrI4EZ2DDYiS2DmIup0snyk+dGt3qIciIzgeN6SG9sue/ZonRPpkArGZy
         FwcaVbCJTd+04MERN4C4lnIBgf0sE32x+5haQOPir3SnH51wZpu2RvwlOuKXTz4rda3g
         Lj0EhvQYlwrT8MfTc6UlkpAcUdQ4bM64PMZdbBS0fVGwGrLkMDoAQh8iQDbjvHk7fgV8
         KGb9AOmn5PJdOj37IPyoCOaWnzQmfCoXDzn67K0VATeJVBxoRX1KCk/Uz5sGZ5rElm5V
         bL7w==
X-Forwarded-Encrypted: i=1; AHgh+Rp0YuSFQpa4QJ02BawtF95gdi8LJ3i5IA0OAT1BcxO73UYd/mWIz/vpwRph8qqa1JG5YluJQlc=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQE9qYN34rErhhVlHHIEU6oqvtlieensKdDN1wJQft2SvDQL7A
	XYRxMZG3wwU49iqMN/HiSPv+gWw5FkmceZ5N55F6GAmB8MPn54zv7JJI
X-Gm-Gg: AfdE7cmU93I6Ppga7nFxEwWi3TsxpcwEAVid5AJMZeWO9QCLNML/F+AvE/lh2FSPD3B
	7AEfn0PSoI0To5ELnlxVw7Lfo3mRzQxtw3M6Y/+sLkN1pNl0tj1RhsTh+6VvYUxgnjbcpTdguQ6
	HVhFaCouLoJTdRStr5VkJR2BN9m2xLxhuS1xOzF96vth/p6DWxRR49bI8HqXdZ8gYmO/UYLUA61
	9LfPTAPqSLUWmu5RDVDAGOP/ikB5yrgO32CgB6Z0Q/ACT3Boe13+AiSPCvYkg9Cj41+Ff5d0ThI
	8L95oEqePMiaBFaBDclpLtEupfENNxlDlTPNy4LdTMeJ62pkKqFigOYYmgCBAO+bf3couQe6EzS
	9yZcr2ueUBVck0itfKyQKS6oiPi1+D+Mcbm7nLDhx1C1NALFm9w59JhQ2LLi1Uh05f+6A4lzh6r
	GiKjT89NNOnW6H0It7rw9WRzdk7JWtvbTkU/axobN/WIaVh4V0vDRlT06GvA==
X-Received: by 2002:a05:6300:4c:b0:3bf:6c08:fba7 with SMTP id adf61e73a8af0-3c357637b55mr11735006637.59.1784177621403;
        Wed, 15 Jul 2026 21:53:41 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e6f0dcdsm5961555eec.31.2026.07.15.21.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 21:53:40 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Wed, 15 Jul 2026 21:53:39 -0700
To: sashiko-reviews@lists.linux.dev
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [PATCH v11 13/31] cxl/mem: Add 20 second timeout for stalled
 DC_ADD_CAPACITY chains
Message-ID: <alhj0wV7a7x3fc68@AnisaLaptop.localdomain>
References: <20260625112638.550691-1-anisa.su@samsung.com>
 <20260625112638.550691-14-anisa.su@samsung.com>
 <20260625181544.67B691F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260625181544.67B691F000E9@smtp.kernel.org>

On Thu, Jun 25, 2026 at 06:15:43PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> - [High] Error paths in handle_add_event fail to abort the DCD event chain properly, leading to a stalled device, leaked watchdog timers, and partial chain acceptance.
Fixed.

> - [High] Watchdog timeout clears the pending list without transitioning to a discard state, leading to a double-response protocol violation if the chain completes.

Unlikely and also a spec issue.

> --
> 
> commit f4b4a95fd0c56d91f06baa4811e9a05ea46012ee
> Author: Anisa Su <anisa.su887@gmail.com>
> 
> cxl/mem: Add 20 second timeout for stalled DC_ADD_CAPACITY chains
> 
> A DC_ADD_CAPACITY event can span multiple event records. This patch adds a
> delayed-work watchdog to prevent indefinitely stalled chains and enforces a
> maximum limit on the number of pending extents.
> 
> > diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
> > index 7dd40fb8d613c..4e887b5cdc3ed 100644
> > --- a/drivers/cxl/core/mbox.c
> > +++ b/drivers/cxl/core/mbox.c
> 
> [ ... ]
> 
> > @@ -1208,15 +1208,78 @@ static void clear_pending_extents(void *_mds)
> >  
> >  	list_for_each_entry_safe(pos, tmp, &mds->add_ctx.pending_extents, list)
> >  		delete_extent_node(pos);
> > +	mds->add_ctx.nr_pending = 0;
> >  	mds->add_ctx.group = NULL;
> >  }
> 
> [ ... ]
> 
> > +static void cxl_dc_add_timeout(struct work_struct *work)
> > +{
> > +	struct pending_add_ctx *ctx = container_of(to_delayed_work(work),
> > +						   struct pending_add_ctx,
> > +						   timeout_work);
> 
> [ ... ]
> 
> > +	if (cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
> > +				 &ctx->pending_extents, 0))
> > +		dev_dbg(dev, "Failed to send empty ADD_DC_RESPONSE on timeout\n");
> > +
> > +	clear_pending_extents(mds);
> > +	ctx->armed = false;
> > +}
> 
> [Severity: High]
> If the device is just slow and later sends the remainder of the chain
> (including the closing More=0 event), will the driver treat the delayed
> events as a fresh chain?
> 
It will, but the kernel has no way of discerning the remainder of an
aborted chain from a new chain.

And this would only occur if the device exceeds the 20s timeout in the
first place, which is unlikely. If this needs to be fixed, a More chain
ID would have to be added to the spec.

> Because cxl_dc_add_timeout() resets ctx->armed = false and nr_pending = 0
> without marking the chain as discarded, it appears handle_add_event() would
> process a delayed tail of the chain as a new chain.
> 
> When the More=0 event is processed, wouldn't the driver issue a second
> ADD_DC_RESPONSE for this single event chain, violating the CXL protocol?
> 
> [ ... ]
> 
> > @@ -1239,10 +1303,20 @@ static int add_to_pending_list(struct list_head *pending_list,
> >  static int handle_add_event(struct cxl_memdev_state *mds,
> >  			    struct cxl_event_dcd *event)
> >  {
> > +	struct pending_add_ctx *ctx = &mds->add_ctx;
> >  	struct device *dev = mds->cxlds.dev;
> >  	int rc;
> >  
> > -	rc = add_to_pending_list(&mds->add_ctx.pending_extents, &event->extent);
> > +	guard(mutex)(&ctx->lock);
> > +
> > +	if (ctx->nr_pending >= CXL_DC_MAX_PENDING_EXTENTS) {
> > +		dev_warn(dev, "DC add chain exceeds %u extents; dropping (firmware bug)\n",
> > +			 CXL_DC_MAX_PENDING_EXTENTS);
> > +		clear_pending_extents(mds);
> > +		return -ENOSPC;
> > +	}
> > +
> > +	rc = add_to_pending_list(&ctx->pending_extents, &event->extent);
> >  	if (rc) {
> >  		clear_pending_extents(mds);
> >  		return rc;
> 
> [Severity: High]
> Do these early error returns fail to abort the event chain properly?
> 
> If the limit is exceeded or memory allocation fails, the code calls
> clear_pending_extents() and returns an error without sending an
> ADD_DC_RESPONSE.
> 
> If this happens on the first extent, wouldn't the device never receive a
> response and stall indefinitely?
> 
> If it occurs on a subsequent extent, does this leave the watchdog timer
> armed to fire spuriously later?
> 
> Additionally, because clear_pending_extents() resets nr_pending to 0, if
> the device continues sending More=1 events for the same chain, would the
> driver incorrectly process them as a new chain and potentially accept the
> tail of a chain after dropping the head?
> 
Fixed.

rc = add_to_pending_list(&ctx->pending_extents, &event->extent);
if (rc) {
	clear_pending_extents(mds);
	/*
	 * If More chain only has 1 record and errors before watchdog is
	 * armed, cxl_add_pending will never be reached, so no response
	 * is sent. Return an empty response. Also sends empty response
	 * for multi-record chain pre-emptively rather than waiting for
	 * watchdog to trigger.
	 */
	if (!(event->flags & CXL_DCD_EVENT_MORE)) {
		ctx->armed = false;
		cancel_delayed_work(&ctx->timeout_work);
		if (cxl_send_dc_response(mds, CXL_MBOX_OP_ADD_DC_RESPONSE,
					 &ctx->pending_extents, 0))
			dev_dbg(dev, "Failed to refuse chain after staging error\n");
	}
	return rc;
}

> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20260625112638.550691-1-anisa.su@samsung.com?part=13
