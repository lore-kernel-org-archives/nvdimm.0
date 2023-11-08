Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A24113ACC
	for <nvdimm@lists.linux.dev>; Wed,  8 Nov 2023 10:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TiBJTblq"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6bbfb8f7ac4so2049848b3a.0
        for <nvdimm@lists.linux.dev>; Wed, 08 Nov 2023 02:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699440659; x=1700045459; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bt2bvDjEv0HiaQYd0c4TjFAx6Nfzvf1eIcmbOTXqPwE=;
        b=TiBJTblqi8Qn5SmxLRgV04hIwGQBpprHFBB7hwYe0Cws54bK33un+uwaI8Pl7m6BP7
         1SRFXOU8S4XkPXE5hK5QU7/7vvViGPn1DjdBPKX+81X0A1dGAADiFmpJINmmXRv7KANs
         eA+Na4D53IpSSdLVG/ahpoK/8pINfK8LUDefY/4yBt9M1p13rp7VBPf6WGQAjGiwgeuu
         GpwJ0cAdq/U6sf7t0LXYFb59eKccvu0rrbJxmFNdPNWxUKGVPCM8KUBXKCF3TGrNhjjN
         miFM0b8mRId9xtAgfwGeeNoKCKE3qmc2ejooGPU2gG3WtzbloSt4F4pe/rJgQ5DJWYSJ
         3gEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699440659; x=1700045459;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bt2bvDjEv0HiaQYd0c4TjFAx6Nfzvf1eIcmbOTXqPwE=;
        b=P/288kqm8vTq/yQDyoDs7yQiAhwNW0glpBKrJ3Iq2pS89NtMTngfmTcnNSayJFdUWK
         xEZ3Sz86juQFoMiugrdAb4eld39OsGY+KiZQ3C9eQEFz6lJ6O2MZW9YY4TSWHtW7GqZ+
         lDMTabC+DXaIVWcfACdgtiaYB/fZ7bVxZEj6ML5HAy0Kpat7ti1S9dlwwpdmiMjyauAi
         C17d3KGsbx+syLJmgbqRZsKe4gACEwv/8Gs25YBTcsZ95CDr+oQ86QnPw6ZlHJ5nuMyt
         LKIHiL5dNU9uVVhE4cibEI1lDesRmIxCTo5xDLArwvHguLmYLC1GdEUZ8MLbLEH0zdKZ
         aQbQ==
X-Gm-Message-State: AOJu0Yzk3pbz1QBhiabZkTRwe/orPjEBiw917mKzDVxQcQ9ieEPYJJZe
	1WIZNUhd8XLtId9dckQr/mOK2Ma7zgNjhg==
X-Google-Smtp-Source: AGHT+IELClSbAQz1V/0drxjg1UD4ziQ+8CYyLr/3Fhum171i0Mlj3ge6042agi3t4nhAvWOeigTzjQ==
X-Received: by 2002:a05:6a20:4304:b0:16e:26fd:7c02 with SMTP id h4-20020a056a20430400b0016e26fd7c02mr1709920pzk.2.1699440659349;
        Wed, 08 Nov 2023 02:50:59 -0800 (PST)
Received: from [192.168.0.152] ([103.75.161.208])
        by smtp.gmail.com with ESMTPSA id fn3-20020a056a002fc300b0068fe9c7b199sm8728468pfb.105.2023.11.08.02.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Nov 2023 02:50:58 -0800 (PST)
Message-ID: <35c77f16-d01f-4dfd-96a7-2f6210e40e94@gmail.com>
Date: Wed, 8 Nov 2023 16:20:48 +0530
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] fs : Fix warning using plain integer as NULL
Content-Language: en-US
To: viro@zeniv.linux.org.uk, brauner@kernel.org, dan.j.williams@intel.com,
 willy@infradead.org, jack@suse.cz
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel-mentees@lists.linuxfoundation.org
References: <20231108101518.e4nriftavrhw45xk@quack3>
 <20231108104730.1007713-1-singhabhinav9051571833@gmail.com>
From: Abhinav Singh <singhabhinav9051571833@gmail.com>
In-Reply-To: <20231108104730.1007713-1-singhabhinav9051571833@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/23 16:17, Abhinav Singh wrote:
> Sparse static analysis tools generate a warning with this message
> "Using plain integer as NULL pointer". In this case this warning is
> being shown because we are trying to initialize  pointer to NULL using
> integer value 0.
> 
> Signed-off-by: Abhinav Singh <singhabhinav9051571833@gmail.com>
> Reviewed-by: Jan Kara <jack@suse.cz>
> ---
>   fs/dax.c       | 2 +-
>   fs/direct-io.c | 2 +-
>   2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/dax.c b/fs/dax.c
> index 3380b43cb6bb..423fc1607dfa 100644
> --- a/fs/dax.c
> +++ b/fs/dax.c
> @@ -1128,7 +1128,7 @@ static int dax_iomap_copy_around(loff_t pos, uint64_t length, size_t align_size,
>   	/* zero the edges if srcmap is a HOLE or IOMAP_UNWRITTEN */
>   	bool zero_edge = srcmap->flags & IOMAP_F_SHARED ||
>   			 srcmap->type == IOMAP_UNWRITTEN;
> -	void *saddr = 0;
> +	void *saddr = NULL;
>   	int ret = 0;
>   
>   	if (!zero_edge) {
> diff --git a/fs/direct-io.c b/fs/direct-io.c
> index 20533266ade6..60456263a338 100644
> --- a/fs/direct-io.c
> +++ b/fs/direct-io.c
> @@ -1114,7 +1114,7 @@ ssize_t __blockdev_direct_IO(struct kiocb *iocb, struct inode *inode,
>   	loff_t offset = iocb->ki_pos;
>   	const loff_t end = offset + count;
>   	struct dio *dio;
> -	struct dio_submit sdio = { 0, };
> +	struct dio_submit sdio = { NULL, };
>   	struct buffer_head map_bh = { 0, };
>   	struct blk_plug plug;
>   	unsigned long align = offset | iov_iter_alignment(iter);
Thanks a lot  maintainers for looking into this patch and accepting this 
patch.

BR
Abhinav
