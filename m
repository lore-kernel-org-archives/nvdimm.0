Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA991A3178
	for <nvdimm@lists.linux.dev>; Sat, 29 Nov 2025 01:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764379208; cv=none; b=logHdam6Ug/x3K3dKgEEVltO4mzSIXktCyv5hTPRtwqpBl8rHYvXk+hC1tpwjARBdTW7yqpo2sffsN3pz25gbeypfn5AunaLJpsSBM5tvdY2jfHBhD8fOnI9x+QFPfJJwyAyVQOq7SfGbGW+bQzKle83UdPpRo15GKVtWKCep6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764379208; c=relaxed/simple;
	bh=CQ4gu5qwHISanFuymuvKH3qflMdaqJ/uuGBrjJ6tlTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QXhN+4deOpUMRFa3FP4PoCDIJ2DQTwpVRvwK6fD5Wu1chdFlH/0QbDNyRRzKITV4x4G8/HADzUA9YLZ/qRwjI3wbEGhansyhKUMXuhMIioJ3DmjdRZht2xgbCe+IDX3ndjXOgrtkhixtnSe/5iQaSeT52DXm/PLplDnoHNMhglg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YXBIA5iV; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YXBIA5iV"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4ed7a7ddc27so21162711cf.2
        for <nvdimm@lists.linux.dev>; Fri, 28 Nov 2025 17:20:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764379204; x=1764984004; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fs0ohHvC2dybiBLIXiSQxGJyUXrOOQGSRM7UOWCS5dA=;
        b=YXBIA5iVl1jJ5Lr3sJof78zHrpkQn1dv/8eluXaKvm32Rk8AuqcfQVRsVooNHK2otr
         aHoMIx7jrWK9uXoX/C93RHrOKC0iGW7fu5sisSxAeno2g4qXRBxArmLzjWFMvV3AX28g
         Rqx2GyRwTNAB1/dkvXERUptXB4ZdlaW1ySQuNITL6QKP7dxiJYIZsF/DaxQ8HNXkwehS
         E1Mdy66W+XkRZaosTdduZzG6lYC7a3GgdrEVXTeciPRUjPMuIEjUoQ/+qtA/VvRP6S0o
         CwLQJedoX3txhIqe3elS9Ja0QbOWGfC8HDWm5V4aqHZpaPYoS+9vD3/zvbabP2y3Md2k
         +u1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764379204; x=1764984004;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Fs0ohHvC2dybiBLIXiSQxGJyUXrOOQGSRM7UOWCS5dA=;
        b=grnaNRTh+niCfaRSlftCiGg8GDlUtOV8TCps+EmCbh3F/aGb0qMaPEk6LAq8tvJa7l
         AD4PWiycUC8zkXHVGpFBRTu2CrVHOi43oUg0hi8SQnIefiQ4LG9Jq0hFZE3zU1AtbEFC
         rBv0dS2nrpOG8FISga0eD6mTvAVb1XcvdfJCcylPt/HR12xLz1UU3HVX1wONCp4YUHhn
         Twab7Z4TCJzUabr4PoeffPSUEBI7B2pNgIk0GRBnwbvE51TL+L9YOZWvZDltdxdo9sak
         bNz3fzDvqoZxwl508bWCTtinFGh7iRpor0w+CVORjULqXulyrDXb5O9ZUDeJX12XGAHD
         zYMw==
X-Forwarded-Encrypted: i=1; AJvYcCVNYWMNjiTdFTZUbHtW1EjT/6gfPCNS/CtzMeTpFmuVqgL2cL0olO4HZLwbJwHe1M7MxprXHRM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxe1gtPwWEfGFA1fahU6tqsWns0EUXe8TXmXznUFGpljgzeEOW6
	Oz3YO9ZB8LhnDvSHK33FiqoggAUR02PWaFIlBjUegpAiyc+zHoxCvUOkSxBIucIVxHrgUeBtWbJ
	En5XqaFxJQtKD5V3K6hDRfx4l/9LMDh0=
X-Gm-Gg: ASbGnctmlzGugBUxIou9PfRb/mykezCPPSYolm8H3VuHlBJSbZTU1ygZyXeKOEu7Ygu
	m9SVRWXrDGHY4Cu4o4+atM3/fZlYz+GqhZsGSm0lRxutIoLSeYCvJW1m927DcO9eikFCoBEC/G6
	qMxKfjGv8JqIJJ0cVz7arw8f9rYBeaBNkRKXkUQ4ng46yU6LknteVUJsnfYN46/G+qBFYKX2bLC
	83pRe4xWI5uuS1IeWeegEchICE1cfQGa7huLif/z0vCIoJGHFmCssAnSg8YkKvLKGWyug==
X-Google-Smtp-Source: AGHT+IGvVajIc41VyAxCuPyxqWUXb2OrVTIXZXouCyBBkNWEtauVL8pGUlccoVwLRAWDPyhKgINw+5nh517v8WUU60c=
X-Received: by 2002:ac8:7c43:0:b0:4ed:b1fe:f87f with SMTP id
 d75a77b69052e-4efbda3957amr254551091cf.20.1764379203672; Fri, 28 Nov 2025
 17:20:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251128083219.2332407-1-zhangshida@kylinos.cn> <20251128083219.2332407-13-zhangshida@kylinos.cn>
In-Reply-To: <20251128083219.2332407-13-zhangshida@kylinos.cn>
From: Stephen Zhang <starzhangzsd@gmail.com>
Date: Sat, 29 Nov 2025 09:19:27 +0800
X-Gm-Features: AWmQ_bn06KtcfeC8pChk4HEBjz19bArSXx8IRJxxttyX3p2OYoBSLr0JgGawFZU
Message-ID: <CANubcdXJyE6Y5J3C5Zgc1jA7qSXk+_Hb0pm8Q-8cTb3Z_eM4sA@mail.gmail.com>
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio chaining
To: Johannes.Thumshirn@wdc.com, hch@infradead.org, gruenba@redhat.com, 
	ming.lei@redhat.com, Gao Xiang <hsiangkao@linux.alibaba.com>
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, 
	nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev, 
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	zhangshida@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

zhangshida <starzhangzsd@gmail.com> =E4=BA=8E2025=E5=B9=B411=E6=9C=8828=E6=
=97=A5=E5=91=A8=E4=BA=94 16:33=E5=86=99=E9=81=93=EF=BC=9A
>
> From: Shida Zhang <zhangshida@kylinos.cn>
>
> Replace repetitive bio chaining patterns with bio_chain_and_submit.
> Note that while the parameter order (prev vs new) differs from the
> original code, the chaining order does not affect bio chain
> functionality.
>
> Signed-off-by: Shida Zhang <zhangshida@kylinos.cn>
> ---
>  drivers/nvme/target/io-cmd-bdev.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/nvme/target/io-cmd-bdev.c b/drivers/nvme/target/io-c=
md-bdev.c
> index 8d246b8ca60..4af45659bd2 100644
> --- a/drivers/nvme/target/io-cmd-bdev.c
> +++ b/drivers/nvme/target/io-cmd-bdev.c
> @@ -312,8 +312,7 @@ static void nvmet_bdev_execute_rw(struct nvmet_req *r=
eq)
>                                         opf, GFP_KERNEL);
>                         bio->bi_iter.bi_sector =3D sector;
>
> -                       bio_chain(bio, prev);
> -                       submit_bio(prev);
> +                       bio_chain_and_submit(prev, bio);
>                 }
>

My apologies.  I think the order really matters here, will drop this patch.

Thanks,
shida

>                 sector +=3D sg->length >> 9;
> --
> 2.34.1
>
