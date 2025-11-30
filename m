Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 175E8248880
	for <nvdimm@lists.linux.dev>; Sun, 30 Nov 2025 23:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764543824; cv=none; b=PlvNpP+Uuly8XZbuafz01P/oypOdj+ykmaTXgepK/rzzfvSBRMaAJoWxcp7dnVEsN8RCx8+nZLe5DB16Ihg+n5C2F92dDdGeOuEz9qILo/RV84aDM+rfIQA3asdx5xMiB5nRF2Zd7fBlPksMjh2PbmTbEf3f/E/2bJRWfKRgW8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764543824; c=relaxed/simple;
	bh=+KhrMhcJSvItbb/04gtqwcqQ9SN2qd7j6u0HCMyKS6E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AdblxI538OAelp+q8Rfq+oaHG2XfXSZqHYvTNLW+h9LRRr4ak+6ufbLlNbKQbZ37UvTl8PlixBDN0+yH6e7silDq4L+5WtqtSmmUld0uJkwu6YCSNBg3GawBNEDntnfS19kJXzFiD7E+08oNAROucpZly+UQgkeKETsKd282c3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=grimberg.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-42e2cf93f7dso656999f8f.1
        for <nvdimm@lists.linux.dev>; Sun, 30 Nov 2025 15:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764543820; x=1765148620;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+KhrMhcJSvItbb/04gtqwcqQ9SN2qd7j6u0HCMyKS6E=;
        b=HmrXAm8C/SBysx5D8UP7Plb4f2SuwUEjIneaMMuxFepwcyU4E/jPqdLngQa68cYWBB
         WlofmK8Et+zcf4zdIbXBXrLcVFNd1AyaifaPpoavn4ufUjm3KWiu5CNbL65MazguxfmT
         dWScualiEzdy9/T+iOniAFkx+b4uBa7dGuBjBTweFKGj18kRap82KTxNOo9vfevbnS8G
         mdBKO5NmNZT/ONLbast4E/RiSFfHNGCbtMabaOMn7SHRDq1GtAxmFBhY1kQ9OLvFIYr7
         /uXn3EOzQIuuJYPnumabL3HUM1kwTz71xNuAZS0ZORloDtqGQL+XWNFJe1fLAOVZkpRx
         5wJg==
X-Forwarded-Encrypted: i=1; AJvYcCW1MFpdIYOYgycrXYf2RXNbBVa9+j951+YaGxm2JMGmZhX657aPj5w7GhSNEDkwK/bSKHjWKU8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyE8v5MB78T16Zty2H/CLAcL6HZG5/gYiZRdrMVN5ymm67ODe+L
	+upaGZX+JfDxpcg8exrWnK1+dEGUyhTI+tvUKdPwH0USDrP82F7bmmiJ
X-Gm-Gg: ASbGnctLf55hBUyfYhJQoLz9nBqQ7rh/pr7Z8WIlamcrcLEohbSELSvI4QrnODGHv3I
	dieEttFM6v21CwyXAoeoGevGDbYQB73WJ8OJhxMQn5n6B6FSyPnqGJ2pc5sqNH1rwoT4zI+5ygD
	ERzA4Eeqvn5uMf/wPu8fYq5bjkDLatzp5kmlL+hvy9wiTILSbhbwwsjqeebZwzakw/U0zZ6oz8P
	M3HadH6Oi5OQxSpwk+XVr+kDaXGT6/n5iJ0+zunMEdQXEL62kTP9OTrIezjULV4OgYt+asxmpqR
	IJovFcaf7j5qeTJJwk8LQYH/ZUArGhzD1pGOIVF0wh6dsVW44czrLUpDL8wYM3SxXK7czeykOwe
	fMHM3dWei0ltns70b7pxGcZfKY03VprbmYxiqQW/FMw/IssbsB4Vo9zc/WV9UBvES1nuHQsbpnJ
	C9YGKH0RIjsr/Iys34V2G3Vm+BKW8VbpFhbTETZRSp
X-Google-Smtp-Source: AGHT+IG0kUJO7SYN4V6YpXy8uJxkqAm9wDLe/yTWTady0nKXHIsEefrNGBZg2POKGw5qhetClLnvgw==
X-Received: by 2002:a05:6000:2484:b0:42c:a449:d68c with SMTP id ffacd0b85a97d-42cc1d0cf34mr37257663f8f.30.1764543820316;
        Sun, 30 Nov 2025 15:03:40 -0800 (PST)
Received: from [10.100.102.74] (89-138-71-2.bb.netvision.net.il. [89.138.71.2])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42e1caae37esm22401721f8f.40.2025.11.30.15.03.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 30 Nov 2025 15:03:39 -0800 (PST)
Message-ID: <b33b3587-edb0-4f30-a8ee-baaa2b631ed9@grimberg.me>
Date: Mon, 1 Dec 2025 01:03:37 +0200
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 12/12] nvmet: use bio_chain_and_submit to simplify bio
 chaining
To: zhangshida <starzhangzsd@gmail.com>, Johannes.Thumshirn@wdc.com,
 hch@infradead.org, gruenba@redhat.com, ming.lei@redhat.com,
 siangkao@linux.alibaba.com
Cc: linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
 nvdimm@lists.linux.dev, virtualization@lists.linux.dev,
 linux-nvme@lists.infradead.org, gfs2@lists.linux.dev, ntfs3@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
 zhangshida@kylinos.cn
References: <20251128083219.2332407-1-zhangshida@kylinos.cn>
 <20251128083219.2332407-13-zhangshida@kylinos.cn>
Content-Language: en-US
From: Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20251128083219.2332407-13-zhangshida@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Acked-by: Sagi Grimberg <sagi@grimberg.me>
