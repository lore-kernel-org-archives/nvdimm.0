Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4229F83A18
	for <nvdimm@lists.linux.dev>; Thu,  4 Apr 2024 11:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712230893; cv=none; b=RjCyC4slAZs7ap6Uje5rh22TiNWmljSoRWUjsOfA3UE9L9w55CwgPSbznQ6sNKQjAR6/oxj3FDMd7DS1uRGRoQdSuV6MKowPrCJAvAY6kuCfJAShhQrPN58jsTKZLRbbG8wcr9Un/GhRrjrMjQFvYLV9tdYo/B6sVn9o1huCugg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712230893; c=relaxed/simple;
	bh=xTu/IdCn/048THaVHddyM991QlKheudeHaOzDUEba/4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CbnfdACCpKM7Uc4gFzSIuRFwmKigKjPc5Isqa3rKxlnO63rflNgyWp4oa0Igwxjgy2oh4JUrhAaah0aW3A+CPVh9rXkfOvXd7DPrtRkicJR4IW2sgEQ52w1orcJR64JjxayzrJEsSVFNY9/+GTeLqwau8Gxc92lTxEoXyw1GGzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=j/l193E/; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j/l193E/"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-dc6d8bd612dso977856276.1
        for <nvdimm@lists.linux.dev>; Thu, 04 Apr 2024 04:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712230889; x=1712835689; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xTu/IdCn/048THaVHddyM991QlKheudeHaOzDUEba/4=;
        b=j/l193E/44huoJ04oBkRB2ZnTXE6+p/NUCx8c35Myr8DR1iqSOtfR2Fz16hDbeJ1OH
         tUExXpGQ28dkceUDdMpyO8EbZRjSCrex+1svJMWBUgMGjtORV2tIu1aUU7tRrlTqseAW
         3xBtk7B1sZWDxq6CBSHE23og4y4Uf0xWMmAPTgeKpXcaQUESIoqY/A0oYtntVtq9wzjm
         lJOxkU+B0t80gJwZe9OA2Oo42MF8k5j1NhzpyvqPDfPA7+hO00Q1BN72ZWALO04aNEn/
         BY01VUCN7ueDh8EfydFPuyA/LoG6wR5CeAWHszNIXog+FGeMZVY6ZzFMUx6QC5hmrLKo
         Veng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712230889; x=1712835689;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xTu/IdCn/048THaVHddyM991QlKheudeHaOzDUEba/4=;
        b=Qnqk7YiDVjSUqa223/OuDrgIi7GGpwU1sItaeZdFuTwXz2NbbTMS2xZjwjwfQUOwib
         yGrGwAbt6pXC4L0e6NNemdpNeRXyEuDmSxkSaK1lYz36zc7BWkuqR9ZixpOQRil12zUE
         fQnj7/lNV9ZGPD39ocxmd+j7eUnbjiSRjswBOJyKgGn7occHxNkWYAk9rXndlq3t6DMN
         +lzX+Whi90HH8BLdob2bLJ0Dvdu2qsu79E7gThsndzXKQQlkpIjdtRcAzji/iuGmt9la
         Tm2zcefYqfCYd4x5Qv2Fpcxnd/fAg/lmpHIRGxLCqujZq3KE5DCEkW7ej2lrD9hhp2OX
         +2AQ==
X-Forwarded-Encrypted: i=1; AJvYcCWPUTthJUCsafz3iq3leDqfwh/BrpwBI9hvkqc092ieA9Wo6RP/0WjrSnaysP5UPmtBkI14SEHJbQ72BSrYZ86Tf3oP1s0e
X-Gm-Message-State: AOJu0YzvzaVEe1GdWxA6p/q5sj8ulDUYIvbzL7jVIWJNDPd+lGinpDdu
	SiOf0v4Z++kJALDtXbj/Cvx7nnPrYdkImYu2oNsKG/vRcu2V32BoMwjplzwf3ji0RdfX20eAovj
	Y/LAGUag68z9CiB8B9nn2SSSBexGtmvEu4mckwg==
X-Google-Smtp-Source: AGHT+IEhL+O4bSIOCRsSy+Vdywn61xtrVBJ3li47sHwN1FOt8H7g9W+tj2/Or7rao9/9euGeRsXbtXq4vPMz7+GnZRc=
X-Received: by 2002:a25:ba86:0:b0:dd1:6fab:81e4 with SMTP id
 s6-20020a25ba86000000b00dd16fab81e4mr2034373ybg.37.1712230889318; Thu, 04 Apr
 2024 04:41:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240331-module-owner-virtio-v2-0-98f04bfaf46a@linaro.org> <20240331-module-owner-virtio-v2-12-98f04bfaf46a@linaro.org>
In-Reply-To: <20240331-module-owner-virtio-v2-12-98f04bfaf46a@linaro.org>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Thu, 4 Apr 2024 13:41:18 +0200
Message-ID: <CACRpkdYpVUq1SgxnPVfRdTiNg3o8dcBePxoxu9GRYy6LdzUE5A@mail.gmail.com>
Subject: Re: [PATCH v2 12/25] gpio: virtio: drop owner assignment
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Jonathan Corbet <corbet@lwn.net>, 
	David Hildenbrand <david@redhat.com>, Gerd Hoffmann <kraxel@redhat.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, Paolo Bonzini <pbonzini@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Marcel Holtmann <marcel@holtmann.org>, Luiz Augusto von Dentz <luiz.dentz@gmail.com>, 
	Olivia Mackall <olivia@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, 
	Amit Shah <amit@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Gonglei <arei.gonglei@huawei.com>, 
	"David S. Miller" <davem@davemloft.net>, Sudeep Holla <sudeep.holla@arm.com>, 
	Cristian Marussi <cristian.marussi@arm.com>, Viresh Kumar <vireshk@kernel.org>, 
	Bartosz Golaszewski <brgl@bgdev.pl>, David Airlie <airlied@redhat.com>, 
	Gurchetan Singh <gurchetansingh@chromium.org>, Chia-I Wu <olvaffe@gmail.com>, 
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, 
	Thomas Zimmermann <tzimmermann@suse.de>, Daniel Vetter <daniel@ffwll.ch>, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Joerg Roedel <joro@8bytes.org>, 
	Will Deacon <will@kernel.org>, Robin Murphy <robin.murphy@arm.com>, Alexander Graf <graf@amazon.com>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Eric Van Hensbergen <ericvh@kernel.org>, Latchesar Ionkov <lucho@ionkov.net>, 
	Dominique Martinet <asmadeus@codewreck.org>, Christian Schoenebeck <linux_oss@crudebyte.com>, 
	Stefano Garzarella <sgarzare@redhat.com>, Kalle Valo <kvalo@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Bjorn Andersson <andersson@kernel.org>, 
	Mathieu Poirier <mathieu.poirier@linaro.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, Anton Yakovlev <anton.yakovlev@opensynergy.com>, 
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, virtualization@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-um@lists.infradead.org, linux-block@vger.kernel.org, 
	linux-bluetooth@vger.kernel.org, linux-crypto@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev, 
	netdev@vger.kernel.org, v9fs@lists.linux.dev, kvm@vger.kernel.org, 
	linux-wireless@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-remoteproc@vger.kernel.org, linux-scsi@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, alsa-devel@alsa-project.org, 
	linux-sound@vger.kernel.org, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 31, 2024 at 10:45=E2=80=AFAM Krzysztof Kozlowski
<krzysztof.kozlowski@linaro.org> wrote:

> virtio core already sets the .owner, so driver does not need to.
>
> Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
