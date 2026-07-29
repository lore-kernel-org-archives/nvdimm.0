Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0827A3955C9
	for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 17:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785347178; cv=none; b=UbBku6x/ApDXKpAOY9jaAZlHVUR2XapJf6cIn6bNGCxCHf3LYxz5wbdfgzHa27aZVP7X43YlBIuzZ2KvqG+ZlZWourJhlYijRX5Kg39k0BH6sWQJ9bsc9vmLpRa96TAslGnh5QzeCVzsWUXSbKPhomWh5iu8G6nNZhZGtg13BaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785347178; c=relaxed/simple;
	bh=UidFeDXv81Ur5iK25hdw53vt+RFWGx9NnnGs3apTKJM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k8arOslobTRcncdWhXhwSSyQOSXOU3W4dNjMpJ5gAB8p+Zti12qtpkJ8VCTeHSt9dWGfAFHQboySLB2WxT8tNkFdAPl5AzdGFTyAssaf+XJCxOSWlypYuvU15dxrquH/qw2miScd0rMnqkZTaZKE0XS84A5uHyN6ZIKQjLnlnlQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oFdzsUoD; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oFdzsUoD"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49554ebb87dso11070495e9.3
        for <nvdimm@lists.linux.dev>; Wed, 29 Jul 2026 10:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785347168; x=1785951968; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WKE9xNdjsRTW2zyuw6/ikQhgmzmnupdLH1iSl4caYw4=;
        b=oFdzsUoDomlsm4n7sfvF6dFpQvjoB3nmMKaDAUJgsQHkhW8BvzXlCvSFknROHMdt3G
         xZrqxIki6tNbtUI6UT6hwnobxRgBkNI+GzlaoX4qUVaFo6708PRqoVHjXQfXvJrec5yr
         dDT+/Ijor5aY2DVub+tnLO4UBGtInpREquUibYcyNYhc4PpmgLMGcxyRbT0wTLfYyp0n
         8cMszgpI9eRVXTO7Sq4U/htQhQSAtTs44ajX8FRQ30pa8+0Ygerwl4z4I9o5TOA55cwo
         OnMyX09xIKJBCkKkbrg30Vfm4OMufNn1+gCgBgIELyn0YnHdfDftLIe0FGW/MSF09y8P
         7Urg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785347168; x=1785951968;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WKE9xNdjsRTW2zyuw6/ikQhgmzmnupdLH1iSl4caYw4=;
        b=dmfGLXA8pHo0sb6GyfehZq1AApHg7ZGSF9TyQNWlL0uU+T5UrzMYgPd7M0bvgX/fFL
         swrhz93jC6+jdB+IpigaBVl8uO+1Q9on2jtkPy7dxIMb8Uq+GOGlhD4GKVK6VIv9h7Uj
         DtbA2wOWYCuikIhdTQa6SO2fxo9owcWfx8Mrvt+mEXwDrHRELBmVyAUjLLKq7xpeapbt
         pzlFnHyivyXnL6/T2mrfC6VjGID3dwklw/ZcNseZrDVCSUn2lx2T6nJIZu8+LO5pYE4q
         9vJbqnoa4MpMCDH7fK45NW4ZhqClcvANOkwGZHvgg2saPrsyEPrfqSdllW7eVn3F6IwN
         /9QA==
X-Forwarded-Encrypted: i=1; AHgh+RpEE+kOBGngYtp1inQe8H9ghPcui6uChTXcZ8FR369k2tlVlahzyaNEiheCP0sAI5vPfbQDleI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJQbz9OxcmLx84KmtFSKqZ7DSMlrZkqJjbVMrEm1xqe48U4O1G
	owr5ApUk9L+PnerN/+EQS0LLCRy33tluN3qjqm09aSa3d+rYRofKtqWt
X-Gm-Gg: AR+sD12jiteQt8PraYPqXcuRRJaqxEMuIra0EH+AIQ78v11argl1IMs0zVpuwiTaPap
	3A+fC0rxb2jTm8701axu8JI55fP4bOpPU7E7yzeJyMFwcY5b3/AG8FwFZw/JDCEaD0MnZeED0C4
	tVTCL2k2fygc70pD1JMur3+brbiwJZET9f17QPk6T7Q0NklpYx8j6mmQi+vVHBkuwnhQxUF/iWF
	iGZOgcHsMB6US7Mc7/4cRjFnZRNGJPeNTV++SfqTcESLraz7AE1q1H+hzHcyHY0MeWeDhrLWKFT
	qfFiiHG4tmunQg9VYctZPd8VAx8ZUDGl5GAe0d0/AiT4kuO/gpVth9h+zawyWAXkHr5WQAN2SDC
	4yF6MESLqBULee5gy6FJqRuxPNbPRQDrOZnzbLk507uRz5jwbs5Rfy2FLL+AvOvDww6K5FcdfMJ
	5+m9/zHp/8Ds8dqg3DKg3joxQMmAxrF1g5L/8w3tW/zJTUXZ7dqTXRcYy5o7nnSv4o6GWdNW+AM
	pGtcyAO53Z3tMYEvsavcPcLLh6IUozc9iL+QsFo+fuKES7HE11j/L3VL9wO9TBWV34MXGcq8rDP
	rLcgWcqPqZsMmiH8P7CMecQagx6PqAgfGArzCiU=
X-Received: by 2002:a05:600c:4fd2:b0:493:e79e:da6b with SMTP id 5b1f17b1804b1-496c6590660mr98300165e9.21.1785347168019;
        Wed, 29 Jul 2026 10:46:08 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45b1c2asm171605965e9.5.2026.07.29.10.46.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 10:46:07 -0700 (PDT)
Message-ID: <5afa3726-6c15-41c8-af19-766eb76b4b46@gmail.com>
Date: Wed, 29 Jul 2026 18:45:58 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 14/14] io_uring/rsrc: add dmabuf backed registered
 buffers
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>, Jens Axboe
 <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
 Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-nvme@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-media@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Nitesh Shetty <nj.shetty@samsung.com>, Kanchan Joshi <joshi.k@samsung.com>,
 Jason Gunthorpe <jgg@nvidia.com>, Damien Le Moal <dlemoal@kernel.org>,
 Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>,
 Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785274111.git.asml.silence@gmail.com>
 <CGME20260728213020epcas5p1721e72ba5544abf0b61482da005120d9@epcas5p1.samsung.com>
 <26dcd0ae5c87a3ada5710b14b6894ef343cec6fe.1785274111.git.asml.silence@gmail.com>
 <583fdfb2-5368-467f-a388-6d388859c995@samsung.com>
 <0df2f832-e8a8-4fdd-a5b6-e08657c2891f@gmail.com>
 <CACzX3Atj+hJmF+Au1Yw5KMk--EHy_J=7Yof1aQNkUV0hCrdVEA@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3Atj+hJmF+Au1Yw5KMk--EHy_J=7Yof1aQNkUV0hCrdVEA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 7/29/26 17:52, Anuj gupta wrote:
> On Wed, Jul 29, 2026 at 7:37 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>>>> +static int io_import_dmabuf(struct io_kiocb *req,
>>>> +                       int ddir, struct iov_iter *iter,
>>>> +                       struct io_mapped_ubuf *imu,
>>>> +                       size_t len, size_t offset,
>>>> +                       unsigned issue_flags)
>>>> +{
>>>> +    struct io_regbuf_dma *db = imu->priv;
>>>> +    struct dma_buf_io_map *map;
>>>> +
>>>> +    if (!IS_ENABLED(CONFIG_DMA_SHARED_BUFFER))
>>>> +            return -EOPNOTSUPP;
>>>> +    if (!len)
>>>> +            return -EFAULT;
>>>> +    if (req->file != db->target_file)
>>>> +            return -EBADF;
>>>> +
>>>> +    if (req->flags & REQ_F_DROP_DMABUF) {
>>>> +            map = req->dmabuf_map;
>>>> +            goto init_iter;
>>>> +    }
>>>
>>> O_DIRECT is checked only during registration; we should recheck
>>> (file->f_flags & O_DIRECT) per request.
>>
>> Nobody should be able to clear O_DIRECT, unless I missed something?
>> And fwiw, io_uring wouldn't be the right place to do it.
>>
> 
> fcntl(fd, F_SETFL, flags & ~O_DIRECT) on an already registered, already
> open fd succeeds. The consequence is that subsequent I/Os switch to

Very exciting.

> buffered I/O and cause silent data loss. Something on this path needs
> to reject this combination.

Yeah, I'll fix it, thanks

-- 
Pavel Begunkov

