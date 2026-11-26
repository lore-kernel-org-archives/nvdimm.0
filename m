Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795689901;
	b=NsWsfokzcLZN8EDN+zpHii+rmI9prnd8Fp4k2R1WxvM9SODF5J21m6C774GFw48BS7qa
	 CYJYKDVFv5qvygOZcOR4R6gLWX1Ta15P2fWKPoqCTJ65PGajbRxTINDscVwgvlZuB8pHS
	 sBPUIfmr9XFUv7FHthzBvzXLknZL6EDe9/vSvPMdgz7yQBuMU0RyXToPnRyKLfgOpIgSR
	 HgzvHsQNVRRY0dOEVsj1BvuvTbPF3JM0DmWJRiuqw7SSRS1uAs+GKuVyxElK5/o00aHGJ
	 apZTOVwvAf8NZtbUmRwyTadTIN7NPcp1DU3ftGZVTtMHxvGGvkRZMh1+E/Vku5WZ6xA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795689901;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=dTzX6/OrqoSYIYFMnL47MVuXS44X2MuyVzOdV4a6oao=;
	b=DLOYOs8oWpmueKl3ndblaYL4N8ul1ePCmfKLOsiJ/mRpIpSpq5ulx/BJIomfXoBjGv6+
	 yWXskfb1wj9gMMiKZ7FXtbAYCr28c2EiQ5OJbCQrIg08SkjiFznfOAOl7rFFuePttxbID
	 QQ33ut/z5/nmDeZMPsjmAbAzgU49B9rh6xpF912/82bhfX3+N8+p02gqEficuhFeJldEY
	 H4Wy3ynSk0GgSYhlnMEYbjmgTcdyDaaaQ4WeLGwsvUugnMA/EACUQ4H3kWirPsYkRrkrC
	 WIFCMpAdK62Gafu/uUlsmD9abBAn6lHS8Ba4HhjIm7OZvfCSPBXj1lsaseaATMIlarw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W5MzGLTO;
	arc=none smtp.remote-ip=209.85.221.50
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 377E5606A330
	for <nvdimm@lists.linux.dev>; Thu, 26 Nov 2026 10:45:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 377E5606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=W5MzGLTO
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-4a32576da88so3922211f8f.3
        for <nvdimm@lists.linux.dev>; Thu, 26 Nov 2026 02:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795689899; x=1796294699; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=dTzX6/OrqoSYIYFMnL47MVuXS44X2MuyVzOdV4a6oao=;
        b=W5MzGLTOIMPTJDLCD9jFQNR/bpq6D1sLNj7BllopqLkDq2Bs7MsfR5dV8HTeq/It//
         nZd/KsfWphObxVJutKJKH9aFIz7WAcRoQqlxz25OC0oGv1n7LynvNONYJokKhSoLycs8
         qbRfvUBxuE18ugfpv9k2K9JQBZrzlXv77iPpeXhKeSsaVrnM8S9D4Xgss6HW24RUE+AB
         5t7HWhvT1E87Nhcc5ZgL33FsFqFNasIA9mtDcd8QDJF3QtMP0RCIIFYbIO+PbH2rAMcA
         mkx+A1EGYyQu+vX4Zz69L6eU8taz387CFDQA6x3skWC5AWBGymjnicbXykUjZeBiDMaR
         fPpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795689899; x=1796294699;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dTzX6/OrqoSYIYFMnL47MVuXS44X2MuyVzOdV4a6oao=;
        b=wuPuu5vUjb0zzmnOQ7KZHjgIQ+jwwUl8yeVwYosOQO4F9lGSx/nlrn09NxWUNsye5w
         dN/khl0dxTRCR2kSWpykCxORB15RwJJHBmBMERoYuF1l3im1laKB9X7HPRlMyjNzqSQf
         mtRlfDLL4hcGREh93EYkBIG5aBaalqYRhL22Vc/WqOOX7S1o+EAS4tDDuOsIASYgsivF
         HkhJ1JL9dqijP7NRvzlCmThsRkF3cCImir92sW+4ethuOcNXK3XfKAt4CrpFBrq4wNVZ
         6XmDY/OWRrWftxKrivH+KNRyc+4dYEblwC8p1o6IkqtaHmUT89uYjsuFr5QEFuhqa7GF
         z6Xw==
X-Forwarded-Encrypted: i=1; AL+hErEAPyiugcPe318mjLsVIwXtlnXdM6XrOHo571gGd/pb+L934hxsCPF9mCkq9JVVMdMKi9LzvAI=@lists.linux.dev
X-Gm-Message-State: APuU4Z9B2stRhTuwN9DZ3i7oE+mca0WieM40oN+w6erYJntCVKIJIe6F
	yyhtzrHV6XF/BFiW0+7I4qE6UtkGKdjqENl6NwgG6zP5HV2rYSzEwNAy
X-Gm-Gg: AZFdTZfvp6sF++GPzZgaC9EIvkcgtNRpOlCoBJx+Pvz83tftAWRmH86JMPXxyZnYjxK
	tQu6uHCGZhYngSH2JxZYfHBpsSYIfeFLWJKmo/Bd4/k20Yf39R6Qb/mg9k+1M6TLYyac2XDna7+
	VUrYLtkAu2d6qwJVXwTmJaGTUivta3kOmPYxuGNQ0h5mpds4M5wDpTC3fh084eOl5p42hfqtH1e
	5483+5orwUUQVGzA/3aPR2FAHOKZQE6Pr5f1QtIaUkdqAuVWkv6zI3h5dhCd9dpRY4eu/ls0r5P
	DQXYcV8q/F3a1j6FRy4/8GCkQdU3gRu1pk1HH2e/qBLcRJqfRF/b7VXSknD+xY1Q8l5hlreIGno
	wkuH7IF/rW4elVVPamJ8vPO1h+gktvvQsVrODNQxp+vw4bq0k8MOKH0nRW1WHgRxwCFJsjiZvwO
	DUPdSEjDIQoMjNKldZJI57slaXQqxd+H4IluKrVOnta5wBHpKh4yt+p7PcAoEBKZKaMr41TEdE5
	Sr7laOJ6f5Lyt2lumbDjrgoK9Mnpj1NA7trxDfxp44c0Nz3RcAOxOWVMasJ8Fo6Z1DUBeH6XFhe
	l35JgjbTz0WsKZtJWFbGuroYCxDElSpU4K9nsrVsALLRMDNKLBRhuzE0ulSrOjWdue7ITn8WYgg
	GCM8/28QUNEC0qU2O5zfEi0A2SEfEQ5Xt6l5Tu+FD03la7bb6MLT/jbZlpCF8izgvfj490yvNcD
	28MyE=
X-Received: by 2002:a5d:5888:0:b0:490:a481:7ac8 with SMTP id ffacd0b85a97d-4abb532ea79mr37997103f8f.29.1795689899355;
        Thu, 26 Nov 2026 02:44:59 -0800 (PST)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2c8csm40898578f8f.2.2026.11.26.02.44.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 02:44:58 -0800 (PST)
Message-ID: <0b76171b-7f2e-41d2-8a5c-102dbe4cb85b@gmail.com>
Date: Thu, 26 Nov 2026 10:44:53 +0000
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/8] ext4: Add dma-buf read/write support
To: Mengmeng Zhao <mengmeng.zhao@linux.dev>, Anuj Gupta
 <anuj20.g@samsung.com>, Christoph Hellwig <hch@lst.de>,
 Christian Brauner <brauner@kernel.org>
Cc: Anuj Gupta <anuj1072538@gmail.com>, Nitesh Shetty
 <nj.shetty@samsung.com>, Jens Axboe <axboe@kernel.dk>,
 Sumit Semwal <sumit.semwal@linaro.org>,
 Christian Koenig <christian.koenig@amd.com>,
 Philipp Stanner <phasta@kernel.org>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>, Theodore Ts'o <tytso@mit.edu>,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, Ritesh Harjani <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linaro-mm-sig@lists.linaro.org, Li Wang <liwang@kylinos.cn>,
 Mengmeng Zhao <zhaomengmeng@kylinos.cn>
References: <20261113070621.273953-1-mengmeng.zhao@linux.dev>
 <20261120154153.GC28611@lst.de>
 <361c4312-f77b-495f-9ee4-e0b9612b4463@linux.dev>
 <CGME20261124084131epcas5p3098eab1bc134da7aefcc83c646b54a9d@epcas5p3.samsung.com>
 <20261124084025.2101804-1-anuj20.g@samsung.com>
 <3bce3a69-e41c-4683-b1ca-9477dd41a7e0@linux.dev>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <3bce3a69-e41c-4683-b1ca-9477dd41a7e0@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/26/26 01:25, Mengmeng Zhao wrote:
> On 11/24/26 16:40, Anuj Gupta wrote:
>> On Mon, Nov 23, 2026 at 09:51:41AM +0800, Mengmeng Zhao wrote:
>>> Hi Anuj, I'd be happy to help pull our patches together into a single
>>> unified series and send it out for review, if you're okay with that—and
>>> would appreciate your review once it's posted as well. Please let me know how
>>> you'd like to coordinate, or if you have any updates in progress on your
>>> side before I put the series together.
>>
>> Hi Mengmeng,
>>
>> We already have updates in progress on the XFS side.
>>
>> We will consolidate the combined series along with your ext4 work and
>> related patches, keeping your authorship.
>>
>> One more thing that we are looking at combining is the ability to share
>> the registration across files. Pavel had mentioned this earlier in our
>> xfs series [1] and posted a series too [2] which needs some more work.
>>
>> FWIW, we also had ext4 changes, but intentionally started with one
>> filesystem (XFS) so that the common interface could settle first.
>>
>> [1] https://lore.kernel.org/linux-block/4649a20f-aba9-418e-987f-66f21ab24410@gmail.com/
>> [2] https://lore.kernel.org/linux-block/cover.1793751001.git.asml.silence@gmail.com/
> 
> Hi Anuj,
> 
> Sounds good, that makes sense given the ongoing XFS and shared registration
> updates. Thanks for including our ext4 patches and keeping the authorship.
> Feel free to loop me in once you post the combined series—I'd be happy to
> help review and test it.
> 
> I looked at Pavel's patchset as well, and noticed it adds a new f_dma_io_tag
> field to struct file, whereas Christoph and Christian want to avoid bloating
> struct file. Did I miss something, or do you have a different approach in mind
> to avoid adding fields to struct file?

I'll resend it later, how to store the tag is the least interesting
part, it can just move inside the block/ext4/etc code, which would
be uglier, but whatever.

-- 
Pavel Begunkov

