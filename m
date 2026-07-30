Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09CC444C657
	for <nvdimm@lists.linux.dev>; Thu, 30 Jul 2026 16:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428267; cv=pass; b=g5cp9h1MFwi7HBg01GA0mXWVpbwHj9tnmoRMV5w+cj8ByRz3IoBratmEuzgBMqpWfQHHoNEHzhV9oK8mcaayWlgz5KVsiU+MzHHYbeP78eNMLYPU7/aiXHotnizzjsADpS943Z7pyRTuMP+O76GouskWHpiMOQUuaYgIQ4AJxkc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428267; c=relaxed/simple;
	bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pjUKAFxKyQff/YqcllRibFAwd2WEYDxHDgauwOWWgH3eiY/tBIc2UICZ2BzEBAPIi/UhzyglUCVFcP2wG/pZHpreo3cCqXYiTOnwC2MMUmpNIRY10U7qc5sUB2eGw8qlz0rTDztEz9BUPZUvZ3UzSdaEQy0D9aOZZiznEXTNMxg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com; spf=pass smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=alxrqlQ8; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="alxrqlQ8"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-44c43edfcceso6617fac.3
        for <nvdimm@lists.linux.dev>; Thu, 30 Jul 2026 09:17:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785428264; cv=none;
        d=google.com; s=arc-20260327;
        b=MKVOxjtgkwsBeoJvb32+8T9WcMtkAXU4LeDfKvoKYCSWDB4+ZVwscdCoXg/qDGc5j0
         3DMkShMBDGurDJBBLO2qn5kGq8Xv24ZoxXriuUfKvtnYRkFxNmGa6u5Y2OmNd3bVoKPP
         cOFfFwXYtn2L+WbcO9pbkrK+YlElPiwIPPNSmRI/ggoArHEGKDSXC/Aiy6qUaXVNixvY
         0ybpT7yDIGXv3fCHu0pKLNoXEnX0tdhFrEd2unVWM6LVmRD9VXaOcq0NmpcHvdru5IYK
         O4QBarQ1m6R7mKGqcyuJh6U3MDqK4fgsflzhWqGSNFh+B78v3ZcnHwo20cj8wLiRF5PJ
         mb9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        fh=8DOkT+jsmd9jPDIvScaQY83yA4+PKr8LXSYNNGEtAjg=;
        b=mcMmojv/D6EiE/J13sMzjVN60v79RNVaE1JXo2OW6+eoHolO0WAB3mBMSklsEGWGEV
         pvP15VDly9Tp9WDPfRFg9GU1F2N0cZqQk91uu52KoRnDH2XAcfWk3dyOE96GFZEORqKv
         tMuP9P/1YieBr9W8cEw+aszUFG8D/cMdjv7+3y6LbkD0H44dOi/KgdQvLko5iPWF82rN
         xnhrkXbkG038fD97S41HRoV1ylhTbmd1pRV0EmneVmax753UPFhfhB5a9kWr3ECmgl3n
         pOxJCXIDHDC6qPfk9pT5DrnvgRxyE5PGNIrwHfjWrQQfJnvCovmhPrBviAypmW/gurod
         d8KA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1785428264; x=1786033064; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        b=alxrqlQ8B9ZF2dBww0GZBnaMs1s5AM5svOYqzmjrWLZXqBD4BP19iw/T7qgUI5XQ8v
         lSpw4FQuj0/YxaUlvPrEgst81DDBM9RJN0RIVj5i9CwH9ShO8sFPLSYyI/0Fq3U2D0bk
         F9fQRvDzpnyZrVINWwZfh8A6pc4HOZElN0IP7Q5TxS+XG0Hk8Jy2bEQK85vVNrXKmGha
         jb+baDfa18LK863lDy91NvTI8kHaEv8vtjcDDjAhzRyFvlkFQ2wAl0j3a9pm4ny1Oblf
         nr6IhlhXcpMxuDNmczClIoWlMdyuXj+1Oa5ICFa6X2k4EvLUj6Yj0fZq2CQVZnLLAvT9
         evMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428264; x=1786033064;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y9uL8axv/bSBp1hJEk9/5EREqK5uThhZ6LCPv7JfjT8=;
        b=SxIuB905Iicw34U6jMGfRdS8VwEVE/fPI8FrfWzNGOHcssqpLBn/+1qKnXWFMNWKTW
         /0zgxeZrpNGRuXf6SubEJjwG143T8vnAf9ve9Hze8oi1etSPIDnbnH/7fuES82d9x5IS
         VQm9TqMxVq/Dqxy13lYx3vDNqLWcgV6lmI8y5LTsH0trGDkmPB52sih6NLF1HSAME1/n
         3QiQcfDT7DkWqwW3MlVCVlbAfgPJW/l0Kh8CIli/rU2r1qwEt9nsCL5XuAtBCJciJZGc
         3bjb1wNKekf2LBlvBzwWB+tV4FoM4jI3JaLnOUw1XJbGeCXU5usBMOkjr+7uM2Of9nUM
         yfMg==
X-Forwarded-Encrypted: i=1; AHgh+Rouy0Ky1rdlRnLLFWVFjJoKxiyzrDSia6J8Rb7VRaBCYqJiNeWP1YpwPAV+qs/10QkQw2+rNJs=@lists.linux.dev
X-Gm-Message-State: AOJu0YySx7OOzgTvepDcMfqPzi5MtQ2+6nF5ZdDW8SaqGyjxhxotUxwi
	Kei5mGxFxsCVQjsMWfVgP0WfXZqWBau9Bj8WdLkOs/lo3hRqQLOSAg5bNSmw/WtLJKz9wGwxcMs
	KunSkcxV+AHdNGjB2H8GiLZ1WkxAJHY2X0H7C+fX/jw==
X-Gm-Gg: AR+sD12zxt1u25u3zMpUflnKNENUGg0AK++5HkcOGXGIHlfwuPVD5464W8GJl1N1CRB
	AMNi16QuIl0+MrTo+kvaOqENBTmUsafysDsbtyCU+1jzRmGdwj6/RJtWIwW3O9TdDIKuuSg6tuQ
	1Ggw72Z/n5sXy+3BzkHsTXgM0SFtB7xPd6JJU2h0lhLaJqSYbK8xFMSxT1A+e5cKEGJg5xzD8em
	l8LY97YVbRwMQaR1VlHv0GrtncpwurSFnR3Lc+8vcye8IeBjuvO6uUPdGdx3M3/Q5MIu9XDM+3M
	gIttkfB3d1K0mLpqgt+G/NLcAfq7UyYnPy8WRE/HGftO
X-Received: by 2002:a05:6870:610c:b0:448:8595:1e8b with SMTP id
 586e51a60fabf-458dd203cc6mr828125fac.4.1785428263717; Thu, 30 Jul 2026
 09:17:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1785274111.git.asml.silence@gmail.com> <19e5c945ea8114320c10f7951d19197d48b59249.1785274111.git.asml.silence@gmail.com>
 <CADUfDZpwF0jp2e=+c3w_NjWPbnQ858bkSD731M6+x27jzgcJiw@mail.gmail.com>
 <CGME20260730104131epcas5p4b52720519486f7ac774c317923a79c81@epcas5p4.samsung.com>
 <de4ec386-42ba-41c3-bcbe-1fe8b2f71ba9@gmail.com> <09134617-6d9e-4963-9319-1855e88a4df9@samsung.com>
In-Reply-To: <09134617-6d9e-4963-9319-1855e88a4df9@samsung.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 30 Jul 2026 09:17:31 -0700
X-Gm-Features: AUfX_mzVuCLkHKoQjKU1BgpL-X0Ty4OF1wEt1trnCKGouEKw-m3DZTMxHTHiuQw
Message-ID: <CADUfDZoVUHMWK0KBnznB73o6Vg+iQBBzJE2NmF1Tf22Zvh4=Yw@mail.gmail.com>
Subject: Re: [PATCH v4 08/14] nvme-pci: implement dma_token backed requests
To: "Anuj Gupta/Anuj Gupta" <anuj20.g@samsung.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>, 
	Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-btrfs@vger.kernel.org, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 30, 2026 at 4:36=E2=80=AFAM Anuj Gupta/Anuj Gupta
<anuj20.g@samsung.com> wrote:
>
> On 7/30/2026 4:11 PM, Pavel Begunkov wrote:
> >>
> >> I wonder if it's possible to perform the PRP list page allocations and
> >> initialization in nvme_dma_buf_io_map() instead of the I/O path. The
> >> NVMe dma_pools are per-NUMA-node linked lists protected by spinlocks,
> >> making them significant CPU hotspots. If the dmabuf registration set
> >> up a contiguous DMA-coherent list of PRP entries for the pages of the
> >> registered buffer, any command using the dmabuf and requiring at most
> >> 1 PRP list page (i.e. length <=3D 2 MB) could just set its PRP list
> >> pointer to an offset into the dmabuf's PRP list.
> >
> > Possible to an extent, predecessor patches tried that, I left it for
> > later to keep the series simpler. I guess chaining won't work in
> > general case.
> > I mentioned this to Kanchan, Anuj and Nitesh before, they were up to
> > playing with nvme optimisations in general, and since sgl from Anuj
> > is ready, maybe they already have a prototype somewhere for that.
> >
>
> Right, I have prototyped the PRP list optimisation before. I will send
> it once the initial version of this series lands, to avoid adding new
> review churn while the rest of the series is pretty settled.

Sure, landing it subsequently makes sense. Glad to hear it's already
in the works.

Thanks,
Caleb
