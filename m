Received: from mail38.out.titan.email (mail38.out.titan.email [209.209.25.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B9CF20C000
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 12:35:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.209.25.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740141309; cv=none; b=Pl/ydv2aqS/r4zKXvbnFiK8/wZM//FHV7882pjrjjPd1zc1Nq4gmr0lypsHk5PFFnZySyrhSEZSoDGT6YA6Eo3m1J/WuwpZXeWodlZawp25tjyM20nU6hT/l5MOuvNgeAYp7VCeZStardyfBRven9uSRXbyL5Kd9mWYhgWKFQpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740141309; c=relaxed/simple;
	bh=OCNBLGjhq7P3rCWeCNzmUkTv7vySlkefy44pB4kpVfE=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=f7hsx4aQiyjG9rI15nkI3lRouBd18MDlQ++/AjghnjSFf/1eKJ871yYBL2OHoogza718JY8HKoF2J8bonnr7IIfvXhOqpM29hyeniB//CCI3Roro4XRl3xsIW7K5pwTOrm3NCusdI7G21vOqLMJN0DwC72Un9iwe3i/PSyh03WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=kO6MvcX0; arc=none smtp.client-ip=209.209.25.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="kO6MvcX0"
DKIM-Signature: a=rsa-sha256; bh=iV8YCNjejtbcc05TVav5ewkWbUeHHVZvkhZrrE0KVD8=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=subject:in-reply-to:cc:to:mime-version:message-id:references:date:from:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1740132387; v=1;
	b=kO6MvcX00hlwOk1XFictjJn6d+nmp42kR7UxdTamUW3Wqg15Up8dUUTaj1RpICWIWKzj96BL
	OJZYGeYNZugaLRaXHYv4tVCClHdrWrmULeBtKzqRz9mpWhvwFBVakOvWWehe8/V5Fk15pUQR3Cs
	Q2NTgH/oB1RRch7U/E3tGrKc=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id CA0376023D;
	Fri, 21 Feb 2025 10:06:19 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH 02/12] badblocks: factor out a helper try_adjacent_combine
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <i5vkxswklce2wtn3aolrd6qrtlib3obtlzgmdix22afcurp7lz@jkxbieqcitx4>
Date: Fri, 21 Feb 2025 18:06:07 +0800
Cc: axboe@kernel.dk,
 song@kernel.org,
 colyli@kernel.org,
 yukuai3@huawei.com,
 dan.j.williams@intel.com,
 vishal.l.verma@intel.com,
 dave.jiang@intel.com,
 ira.weiny@intel.com,
 dlemoal@kernel.org,
 yanjun.zhu@linux.dev,
 kch@nvidia.com,
 Hannes Reinecke <hare@suse.de>,
 zhengqixing@huawei.com,
 john.g.garry@oracle.com,
 geliang@kernel.org,
 xni@redhat.com,
 colyli@suse.de,
 linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org,
 nvdimm@lists.linux.dev,
 yi.zhang@huawei.com,
 yangerkun@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <0C74DE43-1DE1-4B35-8EDB-A6A088B522F8@coly.li>
References: <20250221081109.734170-1-zhengqixing@huaweicloud.com>
 <20250221081109.734170-3-zhengqixing@huaweicloud.com>
 <i5vkxswklce2wtn3aolrd6qrtlib3obtlzgmdix22afcurp7lz@jkxbieqcitx4>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1740132387684621551.7782.6706041692806606252@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=bq22BFai c=1 sm=1 tr=0 ts=67b85023
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=i0EeH86SAAAA:8
	a=sdqv7Ts4B3WvE9CFP6AA:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B42=E6=9C=8821=E6=97=A5 18:04=EF=BC=8CColy Li <i@coly.li> =
=E5=86=99=E9=81=93=EF=BC=9A
>=20
> On Fri, Feb 21, 2025 at 04:10:59PM +0800, Zheng Qixing wrote:
>> From: Li Nan <linan122@huawei.com>
>>=20
>> Factor out try_adjacent_combine(), and it will be used in the later =
patch.
>>=20
>=20
> Which patch is try_adjacent_combine() used in? I don't see that at a =
quick glance.


OK, I see it is in ack_all_badblocks().  Ignore the above question.

Coly Li

