Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A561A4F0F;
	Thu,  4 Jul 2024 11:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720091482; cv=none; b=PJoaP74wnx/ZFbM4AhkojUya+HjNzwkq25Rmup69faIQKdosv9NCa160IoPwz56hqopnXw7ftgJl+VrwOcK/Tasjk7twKWmkg7YwrqLuSR9yhA32ZYkIXHue7IUMA4Zqr4PN7jS9NUY2ABeICjB2p/Fuj67RSP70RMSx3pxEOIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720091482; c=relaxed/simple;
	bh=TwoVc/A5cvcKyYqBk85IeSoXm8WueZBsy4xxLnttTxM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=tmwlqUlopYjHTOcnxa3V9+3j8EqLLbnYgx82qagPMZLyfpFxuBeT4b/djFcZQayRN9XbAO3OIG9al09zvhY24BWYjfvlsbnk/BATtaNP8UBqgVk4wONiv1uu7h3Ylgvui80xSvJ7coyAtAs0Y1bIDclyRnYsnEG/h0YvJ6WcyxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VfoqL7kH; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VfoqL7kH"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-367a2c2e41aso57604f8f.2;
        Thu, 04 Jul 2024 04:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720091479; x=1720696279; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwBmB9TZGFjcG5R2+2N2tz93DvezoEGxh6PsIk8IO/w=;
        b=VfoqL7kHS+CFzGSTNU8taQiIQZVQ8UspcjVfz8TkXTItwEphkPcuK1QaUSfm23RVkz
         GoNu9vWReUdgwBqWnzrOwcU44jkJHYMQaoE8/+xeG8FJzDKWe4h4aN5b90FHlEZoTLzW
         r37dBPbkdlYj1VlQ/Csohve6JzYbpoaaXdRaRCUVCutEnXI7PXkvKwbqBdmXM9TQMMQK
         FeJ+QOpIjbIRkqqvZ9mXhwtlC8/lE0s1j/BUcAC8KENLKL6DBO/2HMrU4rhG+TetJ7Wu
         PYTisL3/wEIVZKBRvwgvlXlo9uG6tcH2Z0ea5ASOpa6LZ5mrWdQQX38cV+nWyHtw/fKu
         aYzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720091479; x=1720696279;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qwBmB9TZGFjcG5R2+2N2tz93DvezoEGxh6PsIk8IO/w=;
        b=JDG/ixm2X02No3hMCxpbXKgMwaElLaeNgPdkPhyW5h5Hbypm56RJ7dNCxcfuGCnS+2
         Fr6VY/P98dUoUGPJPDGIJ36Geu5BWNQv3FtBTpnO/VBHXCCoiQfjoIWJZk0RWQ5cDkCa
         OosMvmuSpOjjeFy0NIfDFo1aZLVjghTOL/+KN0GUdCT6Xl2haz5Gcbtjk5rKpttHo9GU
         vZ6uQkrFGF+zhXNJRjabLj5n8TfgXDRAbLxzWkjk/xkht5JxTjz1+FDK38MbZgppTPMg
         Lzp8T+zr5w09n71G23VzjrQMTXsZG5HIacZQ8Y/Vr8ab9UkPSu2OaqVsvtcDzMUVYfoh
         fAsA==
X-Forwarded-Encrypted: i=1; AJvYcCVA9FQfYAKWcjiGACD41UhAjmvA9ypcfFwY3S/mjoylzEwZ9iXu8mnwFuWOgN9+qZQKWvqPu1N9G9vpLdpWVJCDdAa4I1P3kuUPJllYZlbR4oWB0FDUzz6gP/MGaNdI21M0Ut6SiWsur+vRW+Po8FWdlpZBJc2vQSUXLorc0DzMZQ==
X-Gm-Message-State: AOJu0Ywa3dorlnprnBD3DZaqvoX0IYjEOf+rUrxxX/z2N+aCxzFX4aKi
	cMYA0T2mFoDGv3a2QXvDBMRpqTCPW/HvQ/cIFnSQeaFrDXNBb8l6
X-Google-Smtp-Source: AGHT+IFEzvL2jC2faLe/uaMvaq/UCJ26KrH1XFm9Ol6h8w0Rebt6hjx4X+gdY7pIVUfbtqQYexMuPw==
X-Received: by 2002:a5d:5712:0:b0:367:94e7:958a with SMTP id ffacd0b85a97d-3679dd17ec1mr1153338f8f.6.1720091479417;
        Thu, 04 Jul 2024 04:11:19 -0700 (PDT)
Received: from [10.14.0.2] ([139.28.176.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-36787db4d12sm6821051f8f.110.2024.07.04.04.11.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 04 Jul 2024 04:11:18 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.7\))
Subject: Re: [PATCH 14/26] block: move the nonrot flag to queue_limits
From: Simon Fernandez <fernandez.simon@gmail.com>
In-Reply-To: <ZnmoANp0TgpxWuF-@kbusch-mbp.dhcp.thefacebook.com>
Date: Thu, 4 Jul 2024 12:11:16 +0100
Cc: Christoph Hellwig <hch@lst.de>,
 Jens Axboe <axboe@kernel.dk>,
 Geert Uytterhoeven <geert@linux-m68k.org>,
 Richard Weinberger <richard@nod.at>,
 Philipp Reisner <philipp.reisner@linbit.com>,
 Lars Ellenberg <lars.ellenberg@linbit.com>,
 =?utf-8?Q?Christoph_B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
 Josef Bacik <josef@toxicpanda.com>,
 Ming Lei <ming.lei@redhat.com>,
 "Michael S. Tsirkin" <mst@redhat.com>,
 Jason Wang <jasowang@redhat.com>,
 =?utf-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
 Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Song Liu <song@kernel.org>,
 Yu Kuai <yukuai3@huawei.com>,
 Vineeth Vijayan <vneethv@linux.ibm.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-m68k@lists.linux-m68k.org,
 linux-um@lists.infradead.org,
 drbd-dev@lists.linbit.com,
 nbd@other.debian.org,
 linuxppc-dev@lists.ozlabs.org,
 ceph-devel@vger.kernel.org,
 virtualization@lists.linux.dev,
 xen-devel@lists.xenproject.org,
 linux-bcache@vger.kernel.org,
 dm-devel@lists.linux.dev,
 linux-raid@vger.kernel.org,
 linux-mmc@vger.kernel.org,
 linux-mtd@lists.infradead.org,
 nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org,
 linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org,
 linux-block@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <78BDDF6A-1FC7-4DD7-AABF-E0B055772CBF@gmail.com>
References: <20240617060532.127975-1-hch@lst.de>
 <20240617060532.127975-15-hch@lst.de>
 <ZnmoANp0TgpxWuF-@kbusch-mbp.dhcp.thefacebook.com>
To: Keith Busch <kbusch@kernel.org>
X-Mailer: Apple Mail (2.3608.120.23.2.7)

Hi folks, how can I unsubscribe from this group.?
Thanks in advance.
S

> On 24 Jun 2024, at 18:08, Keith Busch <kbusch@kernel.org> wrote:
>=20
> On Mon, Jun 17, 2024 at 08:04:41AM +0200, Christoph Hellwig wrote:
>> -#define blk_queue_nonrot(q)	test_bit(QUEUE_FLAG_NONROT, =
&(q)->queue_flags)
>> +#define blk_queue_nonrot(q)	((q)->limits.features & =
BLK_FEAT_ROTATIONAL)
>=20
> This is inverted. Should be:
>=20
> #define blk_queue_nonrot(q)	(!((q)->limits.features & =
BLK_FEAT_ROTATIONAL))
>=20

