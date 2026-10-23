Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=80.12.242.13
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792771881;
	b=athzUjSPxU7gELpbEneZJkBQvkzgWib8nd0b6cPnAnokkKjgriLW77KeDdhyic/Pyw17
	 EKjJ2R7TpYB0Y82Fb+PQwJUMH8yQ7TO2WmHKzBfmldPe11H6rBbNNgwIdb/l76yb/OVmH
	 Pv2kGRZwq0bPbjqHXE7Ht49/JIES/dnR1t+pjv6M1vqBQEqETUvsGDib9u95Y0pVJgdtO
	 tVaopWvr2q7PICFmhF7fYVGEib41QiYSelS++2AJ9IH4MJFgWwkXREA6atOl9KAgIbk6v
	 25DeJkpFzlPmkFoUgUIMnHdwVZTrAUwCvos4S6hmcoTUBcXHHFeuUVgSASOTMEStuqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792771881;
	h=DMARC-Filter:Received:DKIM-Signature:X-ME-Helo:X-ME-Auth:X-ME-Date:
	 X-ME-IP:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:From:Content-Language:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=WBe70HsD3zVS/yVaDYpbFIbwCditSt9sU+JUxVK4o8g=;
	b=hTZD6fEiDgGk/prk64aAk7YtCE4lHynUERJUwNHA6X5ExBXboP9V2+prSR7yckMqsQjr
	 UhRozUKTBYfYwTwmglmUr0fiyp8AEsIUAlpwssDAGoU0m9nOnVh+uIXRDlSgKqnogN9dn
	 tmf12603ehgumKVLkD9UZrQQKLkHDjepxqy7RZ8Zdpyscv3JUuE5CzWH6sJ9RqyaVC46K
	 t/paOHPxM34m2V3fAQIfRhmgwAox6KOU6aNDf/zKdGCvMgqALRtrVMmM7yVrO7KAgbZ6c
	 qpUSAMeLqjm4h/AGBJtku4x1syEovaIE3tFUvpXS9Nt3uVq8wTOZ3JinAg1ofqvkH3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wanadoo.fr;
	spf=pass smtp.mailfrom=wanadoo.fr;
	dkim=pass header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=K+G5DT5T;
	arc=none smtp.remote-ip=80.12.242.13
Received: from smtp.smtpout.orange.fr (smtp-13.smtpout.orange.fr [80.12.242.13])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF938606A31D
	for <nvdimm@lists.linux.dev>; Fri, 23 Oct 2026 16:11:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DF938606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wanadoo.fr
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wanadoo.fr header.i=@wanadoo.fr header.a=rsa-sha256 header.s=t20230301 header.b=K+G5DT5T
Received: from [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
 ([IPv6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e])
	by smtp.orange.fr with ESMTPSA
	id KHrKxpx1518sBKHrKxppOM; Fri, 23 Oct 2026 18:11:11 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wanadoo.fr;
	s=t20230301; t=1792771871;
	bh=WBe70HsD3zVS/yVaDYpbFIbwCditSt9sU+JUxVK4o8g=;
	h=Message-ID:Date:MIME-Version:Subject:To:From;
	b=K+G5DT5TqC5mq8NoM0TMmPC2VgDtayOjZlkxNqa4JNb9xM3SiayxHJTAX0xtiOy3i
	 uFuZj/88jrh+EXaewX3QKzrXYM9IQoqKYxv1KC7pP/3efkA/6PJ7HbvIQitefNzuGf
	 TW/83xRhwdykGjl4Ptxgq4Rd+U+OztKoFTpgtzyBzZdPhRCUKbFzLM8LVsHDvY/Xjg
	 Artip5DvxE5cjc8d+Hx2wCKd/cHw9+wmPAZNkegnSxkE8Jnjq5u/kKjzf/t+I9BDo2
	 w4m31Qkf4wHVPT0DxffR2SWR7cVNFZR0E9A36oiNXHWyGqId5Nm6B543R57xPFgoC9
	 DMPtvuVH148Jg==
X-ME-Helo: [IPV6:2a01:cb10:785:b00:26fb:aefb:6cd2:db0e]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Fri, 23 Oct 2026 18:11:11 +0200
X-ME-IP: 2a01:cb10:785:b00:26fb:aefb:6cd2:db0e
Message-ID: <1fea2b63-b1aa-4b2e-992e-9dc0c973a1ac@wanadoo.fr>
Date: Fri, 23 Oct 2026 18:11:09 +0200
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
Subject: Re: [PATCH v2] nvdimm/pmem: Release gendisk on probe failure
To: Alison Schofield <alison.schofield@intel.com>,
 Hemanth Selam <hemanth.selam@gmail.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
References: <20260911082543.473670-1-hemanth.selam@gmail.com>
 <ar8Lc1-griI_TwS4@aschofie-mobl2.lan>
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Content-Language: en-US, fr-FR
In-Reply-To: <ar8Lc1-griI_TwS4@aschofie-mobl2.lan>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Le 02/10/2026 à 03:40, Alison Schofield a écrit :
> On Fri, Sep 11, 2026 at 01:55:43PM +0530, Hemanth Selam wrote:
>> pmem_attach_disk() allocates the gendisk with blk_alloc_disk() and hands
>> it to devres only once device_add_disk() has succeeded.  Until that
>> point the probe path owns the disk itself, which is why every failure
>> after the allocation jumps to the out: label and puts it there.
>>
>> The devm_init_badblocks() failure returns directly instead, so the disk
>> allocated a few lines earlier is never released.  Nothing releases it
>> afterwards either: the devres action that would have done so has not
>> been registered yet, so unbinding the namespace or destroying it does
>> not reach the disk, and it stays allocated along with its queue and its
>> bdev inode until the machine is rebooted.
>>
>> devm_init_badblocks() only fails when a single page allocation fails, so
>> reaching this at all needs memory exhaustion during namespace probe, and
>> because device_add_disk() has not run there is nothing user visible left
>> behind: no device node, no sysfs entry, only the leaked memory.
>>
>> Release the gendisk through the existing cleanup path on this failure.
>>
>> Fixes: 3dd60fb9d95d ("nvdimm/pmem: stop using q_usage_count as external pgmap refcount")
>> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> 
> 
> Applied to libnvdimm-for-next:
> https://git.kernel.org/nvdimm/nvdimm/c/855a46681e0b

Hi,

For the records and if it sounds better patch, see [1] which propagates 
the error code from devm_init_badblocks() instead of hard-coding a -ENOMEM;

CJ

[1]: 
https://lore.kernel.org/lkml/f1933a01d9cefe24970ee93d741babb8fe9c1b32.1636219557.git.christophe.jaillet@wanadoo.fr/ 

