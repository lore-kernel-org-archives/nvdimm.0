Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39E012FF61
	for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711640362; cv=none; b=T7OYpZGsEUQfxg2DE/PcppSQBcGbsKKVfmoqFhvP0FkSWIRRlNGoItxgT48PPEVpuHjawImYuEDLH6xetztvfJQGx5nKQ0TK3Ec65kShrEWrbYFheVKGH/iouAANeZBC+AzaGWtPfwZ2fWOOG8e3yoq9JOpww9gGZdzX5eSCnJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711640362; c=relaxed/simple;
	bh=G1iRW2zHIY2/EiULrJ1nqfVUKDfTimjQj7b8q3dHoFc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rIDmEyNGI82Y+27KVdKTKAGTsHDr76NqBxPJggvlYBfMTX+F+VzS3H4RNmNaAfJOy/Zt3wtFfrUa7ZjoT9r3J8APpP7Y9jruUXR5OS63VFnjM7yxJio1o9AMmB/aM/XHPRbWtUW/XoI+uSNCN/a+sI4LSHYqxJgVeumNrq3j+6k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=mMd0u48U; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mMd0u48U"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6ea80de0e97so827740b3a.2
        for <nvdimm@lists.linux.dev>; Thu, 28 Mar 2024 08:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1711640358; x=1712245158; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mPjQD/vT8EW8FIsS5EhEUvjw7Yq2DPw74odbleQjQC0=;
        b=mMd0u48UQvF2VIv2uh7L1OQcL2FZtSreRdhgUtjv4P9FxDPk8tDx4uten3xzZH38CK
         ClOsaEoqxM5/80ppGz++FSnrntKLw8BirlSgik/veMTXkC0Ose6YHPmP7S0zU7IPAYX4
         HX/w3xJBg2lzRNnpc4t5NT2zasn/XpAxQ1K9kNwm535Zzislom+Uz4YYJREjQbxqeQlA
         1409dR+S/kZ+hzZczS1yYWjsJXjdau+pBvLtuaCJdBxid9yt84ogyKBQhirYbx1Dio2Z
         KVYEzXyB4C/+yCRYDcApfPf34ERZBcsoG8f5TLKBZPLmR++wLJAWSOBFKywqaaB9KI4k
         mGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711640358; x=1712245158;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPjQD/vT8EW8FIsS5EhEUvjw7Yq2DPw74odbleQjQC0=;
        b=Xm7GiulfV6Xz7DilqdS8kceY3T8suWSQsM7gdVOwjM3IgjkkkoUjTsSW2mHVTh6Vq+
         fr1d6v7RT/CdZ4nCtrtr82sTKzQmE2V1rA8T8yfS3+ENL3kh4DVvhmLv3CEA350aO5WH
         Y5KSlbYlaRlwcrZyBV3ZIyuwxH7hyDq9zYLoTcdHeScpHHAlAGlJYnAwSjIkX5TI8tDg
         903XzWL92xdItMfhfAU7AWcTXmZvShyVzZvamG+duYr/zO0Th4B+SxeCoQ+jIE6ZHZ67
         nk9cClXzevh5utL9G4JrvqZiPad149SgNUCGITQQkwf3q8upXf/7+bVDeZJ6cSgrwPq6
         2jKw==
X-Forwarded-Encrypted: i=1; AJvYcCVLebEHw5IZgjXqop7ivpl6IQ4Y4VrWxWrlK/1rk9TLP8k9o/LM2KQs6yKO0P0yarLm0HVIyooScl1JesFnttvu71Jgy31s
X-Gm-Message-State: AOJu0YzLrRVqpy0PrHrLKDkWnI1KQKeLqhDMnJH0p45vwCa82QtGgExu
	U0WCNSou66dMGKGV/zSBi5JYWHLpDKtY2HXxF60FaBKeWRUiFMAPN9WaMn6MtUw=
X-Google-Smtp-Source: AGHT+IGhUQYINGDQ7hWfiGCoXweY10vLCz/e/x+HjJ8dVvYs43ivIcKXZCgoqnZGIv+19J3DIwIpug==
X-Received: by 2002:a05:6a00:a12:b0:6ea:92a7:fb82 with SMTP id p18-20020a056a000a1200b006ea92a7fb82mr3800870pfh.27.1711640357806;
        Thu, 28 Mar 2024 08:39:17 -0700 (PDT)
Received: from p14s ([2604:3d09:148c:c800:ff63:c57b:4625:b68c])
        by smtp.gmail.com with ESMTPSA id e2-20020aa798c2000000b006ea923678a6sm1505830pfm.137.2024.03.28.08.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 08:39:17 -0700 (PDT)
Date: Thu, 28 Mar 2024 09:39:10 -0600
From: Mathieu Poirier <mathieu.poirier@linaro.org>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>,
	Marcel Holtmann <marcel@holtmann.org>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Olivia Mackall <olivia@selenic.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Gonglei <arei.gonglei@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Viresh Kumar <vireshk@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	David Airlie <airlied@redhat.com>,
	Gerd Hoffmann <kraxel@redhat.com>,
	Gurchetan Singh <gurchetansingh@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>, Alexander Graf <graf@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Eric Van Hensbergen <ericvh@kernel.org>,
	Latchesar Ionkov <lucho@ionkov.net>,
	Dominique Martinet <asmadeus@codewreck.org>,
	Christian Schoenebeck <linux_oss@crudebyte.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Kalle Valo <kvalo@kernel.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Vivek Goyal <vgoyal@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>,
	Anton Yakovlev <anton.yakovlev@opensynergy.com>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>,
	virtualization@lists.linux.dev, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-um@lists.infradead.org,
	linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-gpio@vger.kernel.org, dri-devel@lists.freedesktop.org,
	iommu@lists.linux.dev, netdev@vger.kernel.org, v9fs@lists.linux.dev,
	kvm@vger.kernel.org, linux-wireless@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-remoteproc@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	alsa-devel@alsa-project.org, linux-sound@vger.kernel.org
Subject: Re: [PATCH 19/22] rpmsg: virtio: drop owner assignment
Message-ID: <ZgWPHntosUk+5qac@p14s>
References: <20240327-module-owner-virtio-v1-0-0feffab77d99@linaro.org>
 <20240327-module-owner-virtio-v1-19-0feffab77d99@linaro.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240327-module-owner-virtio-v1-19-0feffab77d99@linaro.org>

On Wed, Mar 27, 2024 at 01:41:12PM +0100, Krzysztof Kozlowski wrote:
> virtio core already sets the .owner, so driver does not need to.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> 
> ---
> 
> Depends on the first patch.
> ---
>  drivers/rpmsg/virtio_rpmsg_bus.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/rpmsg/virtio_rpmsg_bus.c b/drivers/rpmsg/virtio_rpmsg_bus.c
> index 1062939c3264..e9e8c1f7829f 100644
> --- a/drivers/rpmsg/virtio_rpmsg_bus.c
> +++ b/drivers/rpmsg/virtio_rpmsg_bus.c
> @@ -1053,7 +1053,6 @@ static struct virtio_driver virtio_ipc_driver = {
>  	.feature_table	= features,
>  	.feature_table_size = ARRAY_SIZE(features),
>  	.driver.name	= KBUILD_MODNAME,
> -	.driver.owner	= THIS_MODULE,
>  	.id_table	= id_table,
>  	.probe		= rpmsg_probe,
>  	.remove		= rpmsg_remove,

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>

> 
> -- 
> 2.34.1
> 
