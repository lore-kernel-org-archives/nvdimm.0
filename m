Received: from sg-1-11.ptr.blmpb.com (sg-1-11.ptr.blmpb.com [118.26.132.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20FDC220F37
	for <nvdimm@lists.linux.dev>; Mon,  1 Dec 2025 05:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764567953; cv=none; b=PcEYXJoGwNaGa5i4odli2HHd6lIabHwVIyM/yeZozeKw+s1tGH9oNhSIjyDKVX6yVKvny9Q1HV/X8jhb8A5gsVPfpacqmigwgmrP2s0L8Yhd5zMCpxmU47kKwdDTUqW8KRRzj5Il7YH7tVnKWY477BAhRNlEihCj6KxJmt7bg7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764567953; c=relaxed/simple;
	bh=FrLZeS9iVrmZMi5DRhrhFzf5CcnM5AZI3fO/L2TjI1E=;
	h=Message-Id:References:In-Reply-To:Date:Mime-Version:Content-Type:
	 From:Cc:Subject:To; b=RWWEx2UXI5BQ6T0v5ZndCFo6Uo5by2venxguIJXigR39bepOwD7l0PmlP/icmVJPsA0E4aTCq4tiE+n+8GYu4hy+LZ62TZ3JHa+Jjs8pVRMjrc5EkWqWf/UyzehfxZkopRsCbVvaJEexwS3ljt/WHWaaog/X4Ukbv+xbiFWiTOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=mlVsioHM; arc=none smtp.client-ip=118.26.132.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="mlVsioHM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764567939;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=sCJL8NM5LN4ox9qDlAfQe91dK8F8fKCk/Hgg80m0H8Q=;
 b=mlVsioHMKYge9CWuleC4jliVQ3Weuv5CzkJGzTH4vCKC9ax/M+RcxXilpXCcI9Li7jFLI8
 6g6MaYOl7pBPRzOZaX5ES9+GjkqLm19EQDx4+VJLCQDJSBmAuRSZrQ/t3dS6dwYyHhDhmo
 J+CartXY1deG2DRV5hNzfveNCu0BwpW6NyNM6nbomfE7HaBeptBfLG/SNEAv6I9PWMInax
 9g3cOQBpt4AOcmz8zGyqty+FEXZ9MM/6e3kp4zjt15kQjIobhFnV3nPmstIjwVLQKQeyvY
 E99pLMpvh4HJ35t0TwbduzeYR/8fEX2pNPmUCbWLsLZCZbOzhjH0marQlOgVvQ==
Content-Transfer-Encoding: quoted-printable
Message-Id: <DFAC6F10-B224-4524-9D8F-506B5312A2E8@coly.li>
X-Original-From: Coly Li <i@coly.li>
References: <20251129090122.2457896-1-zhangshida@kylinos.cn> <20251129090122.2457896-2-zhangshida@kylinos.cn>
In-Reply-To: <20251129090122.2457896-2-zhangshida@kylinos.cn>
X-Mailer: Apple Mail (2.3864.200.81.1.6)
Date: Mon, 1 Dec 2025 13:45:24 +0800
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+2692d2b81+df44ac+lists.linux.dev+colyli@fnnas.com>
From: "Coly Li" <colyli@fnnas.com>
Cc: <Johannes.Thumshirn@wdc.com>, <hch@infradead.org>, <agruenba@redhat.com>, 
	<ming.lei@redhat.com>, <hsiangkao@linux.alibaba.com>, 
	<csander@purestorage.com>, <linux-block@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <nvdimm@lists.linux.dev>, 
	<virtualization@lists.linux.dev>, <ntfs3@lists.linux.dev>, 
	<linux-xfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<zhangshida@kylinos.cn>
Subject: Re: [PATCH v3 1/9] md: bcache: fix improper use of bi_end_io
Received: from smtpclient.apple ([120.245.66.121]) by smtp.feishu.cn with ESMTPS; Mon, 01 Dec 2025 13:45:36 +0800
To: "zhangshida" <starzhangzsd@gmail.com>

> 2025=E5=B9=B411=E6=9C=8829=E6=97=A5 17:01=EF=BC=8Czhangshida <starzhangzs=
d@gmail.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> From: Shida Zhang <zhangshida@kylinos.cn>
>=20
> Don't call bio->bi_end_io() directly. Use the bio_endio() helper
> function instead, which handles completion more safely and uniformly.
>=20
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
> drivers/md/bcache/request.c | 6 +++---
> 1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index af345dc6fde..82fdea7dea7 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c

[snipped]

The patch is good. Please modify the patch subject to:  bcache: fix imprope=
r use of bi_end_io

You may directly send the refined version to linux-bcache mailing list, I w=
ill take it.

Thanks.

Coly Li
