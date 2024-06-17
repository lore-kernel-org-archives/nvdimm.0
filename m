Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AC3190041
	for <nvdimm@lists.linux.dev>; Mon, 17 Jun 2024 07:55:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718610956; cv=none; b=ig6a5UhYWAuks7d9tAbMNnJ1pYsKqiusYvORIUv3ax2gigf3YB1i313Ffr4uXqHZWIDf1nnUixISXVSSwvdy1E2uvdskQKWPsHYAZXpeZhQ3IvP7Usm/D7tTt1wBr44cX2c1Gs0Ae4HmbnOMvOUoqHyn67ndCCgXM3D8fqHQqP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718610956; c=relaxed/simple;
	bh=JhFXSTpTbZnynjs4GWaWiZ25aqQJvGOYbY3MGHI2j0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cX+SVXK5TR3Ik1/FRGLJCyUvQCbjjku8voir+wAzO77QNarfPkGFFpjZdziL+1Cla4vMLeXtv0UsscdzuSDrAQEhppks/cAH7E/dBW8DoSzs+7HXRPxC+lpCI6oI6A4GjdnaFZ3BnXcu7+zhYCL6w4zEuHQ1wlBGnPtI9S5Dmdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com; spf=pass smtp.mailfrom=cloud.com; dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b=YcoZj8J2; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=citrix.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cloud.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=citrix.com header.i=@citrix.com header.b="YcoZj8J2"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4421c014b95so20836081cf.0
        for <nvdimm@lists.linux.dev>; Mon, 17 Jun 2024 00:55:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=citrix.com; s=google; t=1718610952; x=1719215752; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6I7HjTVD0FYGpGJyzdWr9lYyHGbtAeqv6wNa85E5Tlk=;
        b=YcoZj8J2Z2ubiO3ZJR2z79eldCfjV7v/LodIv4Zsg4KsmAiiN+0z9Sgw6PhkrzGQ/f
         rNJ0mosassppDU8ETQ2zgcE/uNe41LNQM9GKPBbeKAXPhvVAjcJHDLHX56GAU2EEatSs
         xzMxtVZrq4Bx4REFCRuL7cNR1YA6hDoq6f7TA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718610952; x=1719215752;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6I7HjTVD0FYGpGJyzdWr9lYyHGbtAeqv6wNa85E5Tlk=;
        b=r+WPPzCSnk6AEQPLDIG9isMeA0kwOTzCVFufmsyRmL8xWm2+7pVTQeSKsnLRVmwvq+
         pwBMIq+kjwGBqpTcoyCD+kwx8UpuiqFjkULrCaGMLonH14NvdCY/Zc9fDh9ruoUZBTuv
         APRa9RR92sbRUs2Ivw98W0bxzHhiRfZTJGd5EfbbMpSoQIFY2B/b5OaVDOEQ/r/jCCRN
         Ye6nN4+Xg6JvyNRQlr1yRmsq6oyvnWGQDAqccpm23czeXhKY5nAdSVu9r/gkOgF2z3Cx
         IHGFoO3ir+4zgr0aeG6UQZ5tYR0d3v5KVe1jrocEVvIWi6XWJ9r5BGRRZtuSpXzW2LGS
         IWQQ==
X-Forwarded-Encrypted: i=1; AJvYcCVcSjBHBvsHWA9SQJi++G8OHr+O7Zoff+b71tz6WNvbtOTUfsf59ISh8YMfjsHuz/PvFBInHRaN097XxdyLGIZ7e+iqU5sd
X-Gm-Message-State: AOJu0YwpJF/16aDUXn7nkd1qgaE6GvWP9JIrIfZRQGZgKy5du0Yu4R/m
	9CwcYm86k9et2iQXnl5vxskt6zOvwGhvVdVkwvW91MnkP86UXbghcIUqecvNy8Y=
X-Google-Smtp-Source: AGHT+IFxBb+fxu+zFP9/mPYH5nZSCdE6S/NGqQ55TdkfvSsNQ6okiuS1Itv2iysUUW0wZGmJIGDYbg==
X-Received: by 2002:ac8:5e11:0:b0:440:10be:3ecf with SMTP id d75a77b69052e-4417ac402c0mr199666251cf.22.1718610952095;
        Mon, 17 Jun 2024 00:55:52 -0700 (PDT)
Received: from localhost ([213.195.124.163])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-441ef4eefaesm44094171cf.21.2024.06.17.00.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jun 2024 00:55:51 -0700 (PDT)
Date: Mon, 17 Jun 2024 09:55:48 +0200
From: Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Geert Uytterhoeven <geert@linux-m68k.org>,
	Richard Weinberger <richard@nod.at>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	Christoph =?utf-8?Q?B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Josef Bacik <josef@toxicpanda.com>, Ming Lei <ming.lei@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>, Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Vineeth Vijayan <vneethv@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-m68k@lists.linux-m68k.org, linux-um@lists.infradead.org,
	drbd-dev@lists.linbit.com, nbd@other.debian.org,
	linuxppc-dev@lists.ozlabs.org, ceph-devel@vger.kernel.org,
	virtualization@lists.linux.dev, xen-devel@lists.xenproject.org,
	linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
	linux-mtd@lists.infradead.org, nvdimm@lists.linux.dev,
	linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH 01/26] xen-blkfront: don't disable cache flushes when
 they fail
Message-ID: <Zm_sBInagtSkOZtg@macbook>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240617060532.127975-2-hch@lst.de>

On Mon, Jun 17, 2024 at 08:04:28AM +0200, Christoph Hellwig wrote:
> blkfront always had a robust negotiation protocol for detecting a write
> cache.  Stop simply disabling cache flushes in the block layer as the
> flags handling is moving to the atomic queue limits API that needs
> user context to freeze the queue for that.  Instead handle the case
> of the feature flags cleared inside of blkfront.  This removes old
> debug code to check for such a mismatch which was previously impossible
> to hit, including the check for passthrough requests that blkfront
> never used to start with.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Roger Pau Monné <roger.pau@citrix.com>

Thanks, Roger.
