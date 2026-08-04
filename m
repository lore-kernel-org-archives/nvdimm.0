Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEE543A807
	for <nvdimm@lists.linux.dev>; Tue,  4 Aug 2026 08:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785832796; cv=none; b=T3FjKe298rimmDZLxMEqZn/o85Ijf2tykux1NlWyh65V4HDIFIFXvHCxT7z2dIyYXClG0LS6UE49FulraORFEuyQ2G67HC0mce5m2Wt4stMFRv3ApIDgr+C7rc6AROtvUQbHqrnBOOZGa4kejgGklheKhS1dxdzd1zY4MsErY6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785832796; c=relaxed/simple;
	bh=St5xZjAvHbO5wVL5/bUSVAInpD9XhzCT+/yCzyLg26A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bEZS9xEc5y5ghu7KQW1F6mWqRfC5DIzJFEKq89Wc4Fq3g138LckttzBIYyywsBpASkw94t9MNCBThu8eF7so4Xuj8es8T0ORi5h2RViBPUgXq7IaFa4d4J1gKHE2Z8jFeZZv/vw9cl6Dp1NxYYwnMQfuitqE+7y7h7Zu5ib1Ync=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eH1KJfkb; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eH1KJfkb"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2caf228a910so31910385ad.2
        for <nvdimm@lists.linux.dev>; Tue, 04 Aug 2026 01:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785832793; x=1786437593; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=64eSuQSg7peuhPy9EAyTkvD08lRNBOCEScrOfZTKXsQ=;
        b=eH1KJfkbmsrdEdcqv7qxGdTnTN/RLkp7pmupbQJDRL1vThqRa6np2fUBi02vHQqNL0
         W1qiwmP05oDqfHon88AtOl23OP0nhYEdLcGb9ybcjEdEyaJ4EkTU8sZRFZZkULT85kiT
         HOrKlV9faK3QTlRaToHuPO5UlTozMSp83x37w2aMK1R1RTSEopvzf8NgDFFP6T0i+THu
         9ItCDoKJFh9pEf2/ZLAc3NeZ5lsmxKCajQQlEBhuD0J7MM3axQooLikeHc8EdYkk1efM
         ofIywu8fn/L988en40Z5NY3D/7+0nQQ8pu/yzcX83D9D31m/iCP5KHv46xg3GWT00N94
         CyjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785832793; x=1786437593;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=64eSuQSg7peuhPy9EAyTkvD08lRNBOCEScrOfZTKXsQ=;
        b=OxaYPeOBMiWjXQou+wKbD5dW+D1Y0QFtY1vlwdhcTFN72/snmXSqyvQEcIFlOCBEkq
         ZJBrVprNF6k/E5mtigGQWbWVtmc6zcA6kg4QYeEoSDqnVQ2xWU/QQCgSdUGmjbNl1nyc
         xMuTPWWPixvgbOtdvUK2d5u4YCdYudQqeZTwI05Y+poFhuCYuJbr30CKVkGtKpab6407
         zKQbPaIbBWHZrP9Xw0vl8/OlYUHi9+jzQl8b5dIKSYNnd+lTIS4rs411t6LD2UYV4hav
         qaKOV1yv490aoTT29zMvgH08pFIOHKQxi2OgUPYlrL45PxhwhQQ75lo0RhCzxd8IDOdD
         X15g==
X-Forwarded-Encrypted: i=1; AHgh+RoE6fOvv8bSzyFmJ9JZGCn50JPa5IM06rvK/tw2w0mQuMoKRQf1CpJ4nd3XFUuw3l1X6I3oWdg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyzwZ+iG8w8sX50rajJdmvGS+S9Q+YVnuHtlT92LpdJKI3oStVV
	NqgqbrHAS6sr8Z8xTUaqT82unBUZO3ZjOxVcFV4yRKHhUN7YXk0P6xQl
X-Gm-Gg: AR+sD128r1qxGUnZI0eJ/ollU8LtYvS7JGkRu8ONY9MTia3p24ube/v2J4iZThTtnMF
	m4N6ntF/iyMP2D05IMGAaqfVmYlZ/UiUwbqzUE5kQedGXYpigdsSGP4IJ7KRLb+mmEMevZQTSTU
	CvrlTrf3d6y1ifLQO8NwvDZXzMIPJY1n0yywctuYXn/5hAm07ukMjaHYC0/vlX9OtkNATbUEx/C
	tY2wiCAWIqRIpSwMK/yJDGv7n0VYxne2XmvviQb4snOz2AybPwgwBc7iQ6bdVI6AY99H7p3uda2
	kwKvVDBLKOgjAYpvIIcyhrdNDEuYUmFc04hmCEnZ8mDfSnYa2mAwj1Eyhj+hCnQ83MzGQyv8lwL
	k2XyTdbVbaX7kSq+QTXXmZmwK6+IrkcXWBZ9m2TwrkP3aRvU7qlb9gm6FprUNQrkVT+ivZqet/A
	bk6DawpEqqhOKGuz8Uc3BTUWzHqj0fkkN6PIpXM22gWWAij9RXxv9jwEUxfnYpeGaXYxKihobNQ
	RPjJBiMaNkk6KtdJtmHhkp0Fu0ClajMXBCVSFqZ3t8EJh7On2oHx05ur3XbgfiCQc7XxLiPR+oU
	m75MtNMJPXX5iuJNbBlX
X-Received: by 2002:a17:902:da81:b0:2c9:e69f:8b0f with SMTP id d9443c01a7336-2d0521dd6e5mr137791555ad.17.1785832792742;
        Tue, 04 Aug 2026 01:39:52 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:325:77fd:1068:74c8:af87? ([2620:10d:c092:600::1:541b])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0a9f93703sm3064405ad.7.2026.08.04.01.39.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 01:39:51 -0700 (PDT)
Message-ID: <214cf82d-742a-4753-bc86-c249366b54ed@gmail.com>
Date: Tue, 4 Aug 2026 09:39:31 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 02/16] iov_iter: add iterator type for dmabuf maps
To: Anuj gupta <anuj1072538@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>,
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
 Anuj Gupta <anuj20.g@samsung.com>, Tushar Gohad <tushar.gohad@intel.com>,
 William Power <william.power@intel.com>, Phil Cayton
 <phil.cayton@intel.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Vishal Verma <vishal.l.verma@intel.com>, David Sterba <dsterba@suse.com>,
 Ilya Dryomov <idryomov@gmail.com>, dm-devel@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-btrfs@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <cover.1785596451.git.asml.silence@gmail.com>
 <c1ab6c0db3853b339a89aee0b1a9c5ac0c48b79e.1785596451.git.asml.silence@gmail.com>
 <CACzX3AvwBF32_ODomei3XHSZ=KtRaWLN-_Tfkwv7sV3Ssc3wmw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CACzX3AvwBF32_ODomei3XHSZ=KtRaWLN-_Tfkwv7sV3Ssc3wmw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/3/26 14:20, Anuj gupta wrote:
> On Sat, Aug 1, 2026 at 9:19 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>> @@ -841,7 +857,7 @@ static unsigned long iov_iter_alignment_bvec(const struct iov_iter *i)
>>
>>   unsigned long iov_iter_alignment(const struct iov_iter *i)
>>   {
>> -       if (likely(iter_is_ubuf(i))) {
>> +       if (likely(iter_is_ubuf(i)) || iov_iter_is_dmabuf_map(i)) {
>>                  size_t size = i->count;
>>                  if (size)
>>                          return ((unsigned long)i->ubuf + i->iov_offset) | size;
> 
> dmabuf_map shares the same union slot as ubuf, so this reads the map
> pointer as a user address. gap_alignment() below already returns 0
> correctly for dmabuf - this should too. Checked the rest of this patch
> (advance/revert/restore) - none of them dereference the union pointer
> for dmabuf, so it's isolated to this one spot. Doesn't affect the
> current series, nothing reaches this with a dmabuf iter yet.

Ah yes, that's nonsense, it should've checked iov_offset instead. Thanks

-- 
Pavel Begunkov

