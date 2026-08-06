Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322BC42901C
	for <nvdimm@lists.linux.dev>; Thu,  6 Aug 2026 12:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786018899; cv=none; b=kOcq08q3U3mtPF0QzsoiNMplTNhC1IxpHWsvwXTF363HpFsU0xDjdFmXJJ2nIMhfLe8EEqYq3OB/RKmovmlaghsp+RPyQ8ED20phKqbN5KPH6SHyayeKo4+f/6lxMN6CrqYiJyIQaO6g5xa8cyxX/z4Ezd7zi3aRgLo57KBhRcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786018899; c=relaxed/simple;
	bh=TTiHlStxZcKVKrwqcuDMLj38rBSP7TpoZoQlRZGLyrQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZCP+h5G751szhRTwHZzpvyRSKO35GpSs0TluZPViUN3A5Ps47ptFjLtnqYR+A0C+NJeK7LkkcYWe6U+d88S0ukrn/hxvyV4Pgf0v6Ig7Unxt0mxx30mQxluOYhBWGVlliLwNn8caic0vsQILIJvdARsZinCyZSdbQEKQ18wFrcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ex5p6Jcq; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ex5p6Jcq"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso1084707f8f.0
        for <nvdimm@lists.linux.dev>; Thu, 06 Aug 2026 05:21:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786018896; x=1786623696; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DfDlnjwEjqQiBft6//i9aWDA7+Wxp9IrqsB/3Fhaw40=;
        b=ex5p6JcqLI7580jOqQx82M5xec/IilPnvgUgo42AJ21+ifc33DsD+NslqKi/75GrfF
         BdxYFKbWg6ePWg6KZs6zNQEL5h1yOlXPFhXvlj7EAZtqkds3q+G1U/4Pce1Y+F2WbF+4
         U/W8JpUe43eT/78ZvbKpP1rLcAOVfUqUqjJIrahNSoIMkw2KtMhoPmzFiY86/wMyOCzD
         2JQnPFj2j+QFwqKhSsPIXR5GqhU2ofRSAo5H57QNpkCxTbeUdY4VXhrnv9fUZ0u7KWg/
         TN1HNlsatVxzaTLDfg2Pdavdw01f+r09cBIS9A2/bEVCQA0gnlhpipUgIUE4+vSFJ75r
         MzEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786018896; x=1786623696;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DfDlnjwEjqQiBft6//i9aWDA7+Wxp9IrqsB/3Fhaw40=;
        b=A8cOLFrs0cqypUcV6SIcYz6A/SEDRCZcZCBklnd3neVEbQTK+JrqXn2XEGYq18Ag6H
         vIW8E/h6y42M327r+7TkgjYo7rcY19PHf1vaGyHnKStL6nsurzAqH2bQAH8rnSPSSLkL
         Llx7JJrdv5iS8auuap0R4kBg2IcP4j0AdohrDAX5gn+aIlzk57EblNdCXT0VLq39HgmL
         UvMVjSnNUxMr2o4PH/UW76dhhbxNITGXxPS1lIyIaeuBvmBhjsWQKsFuV+VSXLJpVw+o
         ZLfF/tNvOUuO23H2qFzSiSbZMLkPyV4aL2TAWw7gKcwR0brJSrRR3L46Hwg1ZxVUsEAk
         Ikew==
X-Forwarded-Encrypted: i=1; AHgh+RrGiP1xd39BHWSvcMi3DwynwZGxmw5WkydVi4HAqL0I0NxSl3/wpMZKmfOgbkr6A2R5w2OEchU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzODa8HVttEkTXptVH0qeJUtrWD+hnNMy6XTJTgMHJsgG9YhgCs
	WXsZZtQvbGEI2s80WpYn79Q+Uo7vDyZWaCYI/EpUBDHDZnI8z3y9JzG3
X-Gm-Gg: AR+sD1175i6abQ5u24CAaG3AYuZsNbSZYMqQqgqkNBcsNsQF5PXAI5NAOZWr7JQlA0M
	Xm4XEKUeTwJZxWV6WXCUvH7NdrdmcWSSDX1b8dyKoJg+2/Dhb5zHdYLVbt7RBm+XPnd+sPBPRc9
	8VWve6Sjd1wTWVuktCB7K2UMGKkar/z7cFZa/A/5MnOAfjzMYFmiE3V8kAd5rfnyBspIeR5u51p
	Ssm+f7f+64ZFHJ2HGDhdFjwk+1eMMJNXo4SheF5teJQEmK5GOCCiL9w531a4KL10OuptLZt7KeM
	pdtOpiojneJWjPmTfgPhhn4ePEqhMZxi2Hwg47D+Q6UQJjaD5lbXgkZpnh5heOWME+eXiYsfuu7
	LX72gN8obh7UrZovV3aI3S2tynqs4osJAtaoeMSZG16Pt5UlxK27PUreElSqg/I2/ihuJACE0NH
	HnALCc3WE+7xKPVD19OjjnDmulhybRhWk2UdpYi5d8Gjx8v0CdMD7BjJ2OSwhUZGROdFdi3mCE3
	i/0Hkdt6Q8EnlXdnT6D5iRlXkBrXSzqqPt0Kos7tpsbR+RgwU8TDxCoouXkkOXmbrBeunksZmUf
	JawfDoD2b4JVbIEq72OPZgExySXF5an0y8F/xA==
X-Received: by 2002:a05:6000:290d:b0:47f:f42e:9715 with SMTP id ffacd0b85a97d-47ff42e974fmr10864047f8f.12.1786018896398;
        Thu, 06 Aug 2026 05:21:36 -0700 (PDT)
Received: from ?IPV6:2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c? ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b32492sm5927425f8f.35.2026.08.06.05.21.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 05:21:35 -0700 (PDT)
Message-ID: <f47ed617-5ee7-4259-9f5f-a6fd0f5aab24@gmail.com>
Date: Thu, 6 Aug 2026 13:21:38 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] block: rename bi_bvec_done
To: linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jonathan Corbet <corbet@lwn.net>,
 Damien Le Moal <dlemoal@kernel.org>, Alasdair Kergon <agk@redhat.com>,
 Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Dongsheng Yang <dongsheng.yang@linux.dev>, Zheng Gu <cengku@gmail.com>,
 Vishal Verma <vishal.l.verma@intel.com>, Dan Williams <djbw@kernel.org>,
 Dave Jiang <dave.jiang@intel.com>,
 Alison Schofield <alison.schofield@intel.com>,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>,
 Sagi Grimberg <sagi@grimberg.me>, Chris Mason <clm@fb.com>,
 David Sterba <dsterba@suse.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Andrew Morton <akpm@linux-foundation.org>, Ilya Dryomov
 <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
 Viacheslav Dubeyko <slava@dubeyko.com>, Hannes Reinecke <hare@kernel.org>,
 linux-doc@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev,
 linux-nvme@lists.infradead.org, linux-btrfs@vger.kernel.org,
 io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 ceph-devel@vger.kernel.org
References: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <4e4c21858705a200bd8848ffe4080522e3eb5c1c.1786018753.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/6/26 13:19, Pavel Begunkov wrote:
> struct bvec_iter::bi_bvec_done is used an offset in the current bvec,
> let's rename it accordingly for better clarity. I also plan to use it
> for non-bvec based iteration in the future like dma-buf, so drop the
> "bvec" part.

I have this patch for the dma-buf patch set, but it's a very noisy
one, and I've got an impression that it'd be a good thing to do
regardless. Hence sending separately hoping it'd get into 7.3

-- 
Pavel Begunkov

