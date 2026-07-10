Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36161361DDE
	for <nvdimm@lists.linux.dev>; Fri, 10 Jul 2026 03:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783652938; cv=none; b=U59KC8DAbIbVXdLnF+7Thm1o0Z28EDA6ufnTa0icRQ1X85Vuc6sk0EHi2e/iKTGbFTTBy3Qvv+6uNmAifgafyXTKrvtlDOzMJm6YP9pizGnKS+7bWB+Oo0KadDX12C8oZ+f/UHtxEdXZIsGXQYm7ZJAtk4isjPPNulf9L2ozzq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783652938; c=relaxed/simple;
	bh=le65lxpxw4W65xyZzPtwOptaX/haFn4+aLgX+gVQMQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Jmbn7RoiKAOat8tkIa2mJ6usJoWoqEWYIZDAHnBPuj6hV6M6y1FfTxrbES7j+4MHq3HM/aOioiCAzxCG5nfDnjEHKfyKJ2vd8wSu3PsEzkliJXhy+71oUO+4OUgyxrwfQCJlTy7WAZmBuu/m1XO3Zf52uQXSBrzjuGqTmnmsOJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qTVsr3Sa; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qTVsr3Sa"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92e99ef0902so20325885a.2
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 20:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783652935; x=1784257735; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kr6wGBD9MJbLbiRkKQ9M+EqleUNYFT/q4nJmIpqWguM=;
        b=qTVsr3SaQrw/hByMDd2+8yxZD9T8T4K9rNRowfw+sEDC52FzqcL+cvD4x7+eYsgRtw
         fkucFz5qjVQSDEJ5OFvQVUxWHZEO5NEuROix8jBrTMPbD0yHRVdKmuTLS9+YgcmBrvAp
         fomjTqsqZsDVog4pI05N+LxDHI04UMrCbz7Tw1F7KzyH2x3kRod01qK7oaDehBzBlLfg
         8CX6dXF8TZkuILc52ILngtpgpv9bOGewmpRWpsfXHKCOjWmNoJg9zcZo9N5wi2wz0VIZ
         fB8ALv96X9qvALZfW1it1MBYHnedrYZD3Siuyv2lyDkoJPjrvgfo/ox56WcIW6TMblIb
         +LeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783652935; x=1784257735;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kr6wGBD9MJbLbiRkKQ9M+EqleUNYFT/q4nJmIpqWguM=;
        b=faLRMqfjBkyfOKLNCeJe1eUQaPdn7NxiqEcl8Dg3PsWnu644VV+C9t740SMwjGfMFC
         KLGKBFowy+9IVCiX7jbhjWj6cjUQj99aqaqetnWs8hameLFUhXb4DRpkD/2Vf4rgPDIY
         n+I+sYkhzwEkMrHxV6G/pyveunXftnKo8x6sCou4JuTN8BmSD+kJQz5Ae2GmVNPYjnZS
         qdCtvJ+lJC0FsgHFdQM1Vq3S4gJUu0UOBvD9hZiimmAlV7/hBVJGPFrTvO6PVwBOSWq5
         C8Qhff9qe8ibyE0HY2aJ/6ThOQ0pJhrJtq9tjiQ9msEG67iDlOzqCY+udj3ITZxZfbh1
         wYmA==
X-Forwarded-Encrypted: i=1; AHgh+RoFUWjBRrjL0ePYCXtHY4+DpJvQwjZNd6xNtAkAsd04ZGpejnjRnPyMba2P20qXg4d92armPJ8=@lists.linux.dev
X-Gm-Message-State: AOJu0YySJQWo300xg0F3zdmoUDJQR5i+0KW6sizdXc8t+fq6saufI/zW
	c1Wg47m0v/kJEKLFLHAUY8x2yhYP1XvO38fLP4UFq1GhXgf2kwfqUhSWG49YmDiHYkM=
X-Gm-Gg: AfdE7clVmepzVCcu5ybOWNNycwrwdLTlwN/YIG7c49ZEht1u+NRs57FZan/+t5em0IG
	DLiLaHog2g99rKeXmPLaPUPt8F68fFJGEQyy00a8hYEDLdJ55HoXQnJLSKSWAdgF/M6lvgjbpzA
	nemXkVY1TFamp/n4v+NQFryN7HXDo5ZeEvNKcpAksTh9RKKfe56AZtibiILejva0SiSbcWSe6CX
	xtKY4ubxkj9zGfZD/h8vFUXH6PR9JM3aY/X/NiPo+VPbw7q6oVpomXCeLsHH2tIl7pIBw0q1oXC
	MPpYeNaFRSw6QgsVysWuvgSHXU5JJBtCP1fKtP0HjGFBbjMGeh5g6EtMhxb0r4q8QuiBX6Sbb7T
	4DJ6UPcnH7nrDijeGo4xAYDqHlYq7zrozuSyMrw40bBcqBq98RYY8B7dvMdt6au7WF+VaLKXQ1m
	BbiQkZ+Ef/l1rLcTVLXrudq1qIxG97aTVGmacqOjWRJWMGTs7jBCCSLRwPK2lUhr8mUH5oXeRvP
	1mFXDM=
X-Received: by 2002:a05:620a:2701:b0:915:eec4:49ab with SMTP id af79cd13be357-92ecf5dd3bdmr1127366485a.51.1783652934221;
        Thu, 09 Jul 2026 20:08:54 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5cf78a5sm97038385a.31.2026.07.09.20.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 20:08:53 -0700 (PDT)
Date: Thu, 9 Jul 2026 23:08:48 -0400
From: Gregory Price <gourry@gourry.net>
To: "Dan Williams (nvidia)" <djbw@kernel.org>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <alBiQArmsWFg975w@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <6a502267b17cc_3b7ee51008f@djbw-dev.notmuch>
 <alApfp2z9Thyan16@gourry-fedora-PF4VCD3F>
 <6a50356aa7a4a_3cabcb1008a@djbw-dev.notmuch>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a50356aa7a4a_3cabcb1008a@djbw-dev.notmuch>

On Thu, Jul 09, 2026 at 04:57:30PM -0700, Dan Williams (nvidia) wrote:
> Gregory Price wrote:
> > > So the "unknown" case does not need to be here.
> > >
> > 
> > mhp_online_type_to_str can technically return NULL, seems better to not
> > just let a NULL dereference sit latent even if we can visually tell it
> > can't happen today?
> 
> Oh, makes sense I was thinking "unknown" was only a result of the
> drvdata missing case.
> 
> > > > +	if (dax_kmem_state_is_online(data->state)) {
> > > > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > > 
> > > I like that the BUG() is avoided, but I think these should stay
> > > dev_err() given the severity.
> > > 
> > 
> > I had to go back to calling remove_memory() by default given different
> > feedback, but I think if anything I will just modify the BUG() to a
> > WARN() and call it a day.
> 
> ack.

Ah, you know, on second look - DAX could never reach this BUG() in the
first place.  I think this was a hold-over from when i was originally
refactoring and trying to figure out the right path.

If there's a desire to soften these BUG() to WARN(), i can submit that
separately, but i will close this all out with some comment updates.
