Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA523BE172
	for <nvdimm@lists.linux.dev>; Thu,  8 Oct 2026 13:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791465632; cv=none; b=Y7aj5rkOAnXJWJgW++ic7XmoVn/dsOIK4uxuREdDZ4HQuC5YP4KnXO/4eRc7BQ5UL1S96ip7ZZ22oR+O+OOxNulpLyiODxg26MEv9n8q4Ur+Ci348/lNiLqdySONUAURnd98tB7Pe+3/CctJTUV72YcItgF4Ekur7KsRUI8Odcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791465632; c=relaxed/simple;
	bh=3Wr9/2480/aki5bGWFAs7IixSJIK8jk6h7T+74lKaK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s4mVV8PSD3dXffbpB5F/UdNNhrGU06dwnul7oGiviB8rbPz8CJGQrear7af0QAFfTscFLX7MGB3FXdJFiQRchNsV/pJAV6fbTsqClwCCiTOClKI5w4Xj6QnWxpLXzBK8zZRr2vbmlcR/oQWcBUQOt0gmRQM9zwLnPPEJI7Uy/R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XcN9r6CX; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XcN9r6CX"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48c4649b35bso5138400f8f.3
        for <nvdimm@lists.linux.dev>; Thu, 08 Oct 2026 06:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1791465628; x=1792070428; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=DXt6zdr1dNJCoSR8LDi80DpeRm3wu09nw9+6kVlpfZs=;
        b=XcN9r6CXyjKwQe6R1sA6SgYrsjAteP6HtQvYHYmbsY55i2x2STPNJF7+dsB8xEvsj1
         r6/SrMbj70foC7rGGaOJegJUyQEU21lFhlmHMS/E7VCjKog1k1bh6fYqqhbY1ixg1STe
         YFW33rGT8AFwsfZllt15RTDzhC4XZPpYg4kiYZL13UG12pti3yTqqpWnJiNVBkRiZwnK
         MAC6eySFfTakvpZ+19Nyx30/B0qJr9yNQLwM1y35Ut8+W7HhnX1ptHfNoFUqRp+vKvEm
         G9NaBF+7oOd7JYjJhenn9SOi4NLIrHFjRfKC0iccznMcLcc2RqJhLJQMcFnHuibNak2l
         VzTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791465628; x=1792070428;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DXt6zdr1dNJCoSR8LDi80DpeRm3wu09nw9+6kVlpfZs=;
        b=DnO5EzZU7TeneJfwOP/HjYoSdzYA4QJrY7m3FphLTA5L6Gc23W2PKXs8rxdgEN2bSW
         B46dvCnH1B4o3+Cpa1STrOksEMVAyMwW3Q6jwe6/XGUzVlJ10FpwhxeR3jdqFV9zsoUZ
         AoOHotiiaeadtbZjj6uOV5xQF+QqL7iudLt06MEY8T00VpCyoxENmMr3/TQqerfABDJR
         ODNIWuYgZ9vtNE5FEvD8RDai+wduaQCn4rxr3Y/157YU0fVZdciFQMrRyoWd3/uhDPE8
         bMDv5/kRDQ/TrH00q29R71zanzNkkA0jejypXmOrbOkF9lrX4+EDGsCIdNwTUAtnHwJ5
         GyrA==
X-Forwarded-Encrypted: i=1; AKwUvBzrHnBb6ONdAiomduM3qBhUuoib4g9TzyM20+EIKmyRg0zW9yh+ahbQ6CzGYhYpdwYYYL7M0e8=@lists.linux.dev
X-Gm-Message-State: AFq9FYL+PHib9cK5lfnwxaPpwUc6TjwST8kSgK5/wq8Fk28xWHqHcc/L
	lvmzs26xgtQAig3heOyMThKr9ldgKQaISUMG4I7yvCElVkXYRb2bhoT4qSTcKeGxLSdMrST1y4D
	9cJuZ0F/Oww==
X-Gm-Gg: AYBFou0ZoXSr4tttVVpBAfXPEth1hCYdEZm4/E8lTlhJqaSipO4VPxagydsGXFox+L7
	8yC8iY3x+hH3BYzM8/NPUOs8DaPrl7NbJ6sQu/LnKR8PgOYkHrlq2Qf2STh/CpaA2Q8QUfSZEGu
	N+cITRX9tGuqa3I4tkClKLivkeWlB89j6QQGrdYL3tQTUFCwne67a4odJw3euHinlZByNHNPyhE
	lnnBMdBM+eUhzsdkPuNiGSEr/MZZnAFVYJR53GvXjTHTsn5iDaMMuXr727Fv4jW5vVNnlEQg4wU
	tPp/RZS2zES31yrIU+ctSoHpP29wmbQqGrw8v5qe5T7F0WeKpxJCiIsgWhqAR51JFs9eLrU4hvd
	cDXCYq5RioqazK+rd8pf2EHr4XgRqENNA9WaobuH/OvdF73bTnkz7dezghm0BRoJYiDfhM0SiZY
	NGnDQyEBjzUosuX8PXZvH0ceEcDK3fsvwxzM8FLzu+kCK9X1mANLzDK4XYiqZB7GmQZO5SpZ6O4
	42aRG/VPyQ=
X-Received: by 2002:a05:6000:470d:b0:487:c99:9020 with SMTP id ffacd0b85a97d-48c7272887fmr8760021f8f.2.1791465628326;
        Thu, 08 Oct 2026 06:20:28 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([185.194.184.20])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48c71d31767sm11753893f8f.51.2026.10.08.06.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 06:20:27 -0700 (PDT)
Date: Thu, 8 Oct 2026 09:20:23 -0400
From: Gregory Price <gourry@gourry.net>
To: Miklos Szeredi <mszeredi@redhat.com>
Cc: fuse-devel@lists.linux.dev, John Groves <john@groves.net>, 
	Amir Goldstein <amir73il@gmail.com>, "Darrick J . Wong" <djwong@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v4 2/9] dax: use READ_ONCE() in dax_holder()
Message-ID: <aseYiJO0cgEamazq@gourry-fedora-PF4VCD3F>
References: <20261008112004.1899560-1-mszeredi@redhat.com>
 <20261008112004.1899560-3-mszeredi@redhat.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261008112004.1899560-3-mszeredi@redhat.com>

On Thu, Oct 08, 2026 at 01:19:53PM +0200, Miklos Szeredi wrote:
> A future fuse patch will utilize dax_holder() in RCU context to make sure
> that the holder can't be freed by a racing fs_put_dax.
> 
> This patch just makes sure that dax_holder() works properly in such a
> context by adding READ_ONCE() (equivalent to rcu_dereference minus sanity
> checks).
> 
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>

Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>

> ---
>  drivers/dax/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/dax/super.c b/drivers/dax/super.c
> index 25836f389bde..76e8d3654629 100644
> --- a/drivers/dax/super.c
> +++ b/drivers/dax/super.c
> @@ -642,7 +642,7 @@ EXPORT_SYMBOL_GPL(put_dax);
>   */
>  void *dax_holder(struct dax_device *dax_dev)
>  {
> -	return dax_dev->holder_data;
> +	return READ_ONCE(dax_dev->holder_data);
>  }
>  EXPORT_SYMBOL_GPL(dax_holder);
>  
> -- 
> 2.54.0
> 
