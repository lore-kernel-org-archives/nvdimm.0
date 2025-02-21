Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E9020B7FD
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 12:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740140220; cv=none; b=XJ/iF2zqkwsLR5qtQi3jnoChjVrgx78eLk2+zcsa5QbGUAQKwbHh8+1gRKr5cWx8HoOzbLkTM4o/hqKVr2ftk/aHfMP+lk17kXoOCfbaHS0tP2oIW3J83t3xS6lEM6iuTQ4UHGw2oy9sE0e5yxoWvJ9JqhSoxCYst6acPXc/5AI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740140220; c=relaxed/simple;
	bh=AytNe/HlUvovzNVPebv72028JhoBKwW3ZkXVgYp23rE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:In-Reply-To:
	 Content-Type:References; b=EuziG35xtcuXGfe0locDn8Rjh/RjjPFTOOampHrtPNb68M1SzloeGPuQQf++E03NrkmDvx171QRjlbdBYAXliY6i7xrjOL5ntGKxU5gyhcTv2NSWXbIe95ERLalYNRtvlJQkGcYmUXTOZyEu0nPzGiB4/hGOhMSVkkxnp3Ju348=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=JQr9xBzj; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="JQr9xBzj"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250221121654epoutp039fe965697ef5245b812fe80cee85550f~mOE4vOcWV2991429914epoutp03X
	for <nvdimm@lists.linux.dev>; Fri, 21 Feb 2025 12:16:54 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250221121654epoutp039fe965697ef5245b812fe80cee85550f~mOE4vOcWV2991429914epoutp03X
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1740140214;
	bh=vHEeLZ2yQAJD7Zb6AS+MprdQT+oGOwFu1priVptQrqg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JQr9xBzjPiR4AoCTEwmDsP/nssLrYemKMooWpgxhoF1vnNGZg/8/LUU9G1fxO6MsS
	 TP+YC+3WpPyAoFDKq8O3VhZMr3WUKOOVOlvp+ODlQubVXmmfUVPQ792ZGU07a+TSI6
	 M6qYuM0ehvmM5amS4VAMgxUGPjBuviLVXwg/j3j4=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20250221121653epcas5p2c61096e52a754bbbd806a89cca6c083d~mOE4QPd1o0224102241epcas5p2J;
	Fri, 21 Feb 2025 12:16:53 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Yzpyq6sj9z4x9Ps; Fri, 21 Feb
	2025 12:16:51 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1F.C5.19710.3BE68B76; Fri, 21 Feb 2025 21:16:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20250221121541epcas5p163deb1f82a4775da19f3a57eb0bee55f~mOD1GC7XC1966519665epcas5p13;
	Fri, 21 Feb 2025 12:15:41 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20250221121541epsmtrp2b427fbb704630cc61b96c670b176b1d0~mOD1AIUkK1401914019epsmtrp26;
	Fri, 21 Feb 2025 12:15:41 +0000 (GMT)
X-AuditID: b6c32a44-363dc70000004cfe-2b-67b86eb36ea3
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	A3.1C.33707.D6E68B76; Fri, 21 Feb 2025 21:15:41 +0900 (KST)
Received: from green245 (unknown [107.99.41.245]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20250221121539epsmtip22f2d2c43dd807a3d03f7ec968dab5328~mODzLy2gf0040200402epsmtip2U;
	Fri, 21 Feb 2025 12:15:39 +0000 (GMT)
Date: Fri, 21 Feb 2025 17:37:29 +0530
From: Anuj Gupta <anuj20.g@samsung.com>
To: Anuj gupta <anuj1072538@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig
	<hch@lst.de>, M Nikhil <nikh1092@linux.ibm.com>,
	linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-scsi@vger.kernel.org, hare@suse.de, steffen Maier
	<maier@linux.ibm.com>, Benjamin Block <bblock@linux.ibm.com>, Nihar Panda
	<niharp@linux.ibm.com>
Subject: Re: Change in reported values of some block integrity sysfs
 attributes
Message-ID: <20250221120729.GA5233@green245>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <CACzX3AvbM4qG+ZOWJoCTNMMgSz8gMjoRcQ10_HJbMyi0Nv9qvQ@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMJsWRmVeSWpSXmKPExsWy7bCmuu7mvB3pBp1zTC0+fv3NYnFp3QVm
	iwWL5rJY7Fk0icli5eqjTBZ7b2lbtM/fxWjRfX0Hm8XF3q/MFsuP/2Oy+Nbxkd3i7sWnzBYr
	f/xhdeD12DnrLrvHhEUHGD1ebJ7J6LH7ZgObx8ent1g8Np+u9vi8SS6APSrbJiM1MSW1SCE1
	Lzk/JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoWCWFssScUqBQQGJxsZK+
	nU1RfmlJqkJGfnGJrVJqQUpOgUmBXnFibnFpXrpeXmqJlaGBgZEpUGFCdsb9rTOYCppFK1Yf
	fsvSwDhHsIuRk0NCwERi7a9FLF2MXBxCArsZJWa1bWGFcD4xSrTOXofgnDi+lxmm5dLFBnaI
	xE5GiZOHXrJBOM8YJXbO+cIGUsUioCrxZfEedhCbTUBd4sjzVkYQW0RATeLptu1gDcwCncwS
	0zqngDUICwRKfN3wG6yIV0BHYmPzSnYIW1Di5MwnLCA2J1DNl+/NYGeICihLHNh2nAlkkITA
	Wg6J87+OMkHc5yKxc8ZVNghbWOLV8S3sELaUxOd3e6Hi6RI/Lj+Fqi+QaD62jxHCtpdoPdUP
	toBZIEPi98d9UD/LSkw9tY4JIs4n0fv7CVQvr8SOeTC2kkT7yjlQtoTE3nMNULaHxJfdF8Hm
	CAm0MEk0XWeawCg/C8lvs5Csg7B1JBbs/sQ2i5EDyJaWWP6PA8LUlFi/S38BI+sqRsnUguLc
	9NRk0wLDvNRyeJQn5+duYgSnZi2XHYw35v/TO8TIxMF4iFGCg1lJhLetfku6EG9KYmVValF+
	fFFpTmrxIUZTYGRNZJYSTc4HZoe8knhDE0sDEzMzMxNLYzNDJXHe5p0t6UIC6YklqdmpqQWp
	RTB9TBycUg1MevssYmZ9O7Jk3ZHED2WzZGZNjOq03xp6oJFbpVHebcNhrZ8Hr7Mt2vb6SG62
	lNQNhnTTWQULTn9R6fjEdTLNYa6/ybLjUy+lpgWtmptQVeUtZCmZw37DmS3gyHxXvlXeB3R0
	3V6esZ1rVj8t5a0syyIJ2x1nZ8p6rZ256vrSSDujCXveMHyaVyLwuGH/1suWD9LrBBpWPJTp
	vXJ+75Q4b+XbE9QW5XHtNstceGtmI+dmW67s2C8e8UWuRx4ebYq+fvzNoaCK0Ng/JvNnblyS
	mDdX6ea3B9FLunlDNsxbzXqlUGLVWeG5f/Js0np4f256dPzTFYUEfsbjZc2JslpqKp5b87U6
	51wUOGaXw/ZsvhJLcUaioRZzUXEiAM9HXrVWBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpkkeLIzCtJLcpLzFFi42LZdlhJXjc3b0e6QWOXqsXHr79ZLC6tu8Bs
	sWDRXBaLPYsmMVmsXH2UyWLvLW2L9vm7GC26r+9gs7jY+5XZYvnxf0wW3zo+slvcvfiU2WLl
	jz+sDrweO2fdZfeYsOgAo8eLzTMZPXbfbGDz+Pj0FovH5tPVHp83yQWwR3HZpKTmZJalFunb
	JXBlNF5+ylJwWKji7ZtpLA2MX/m6GDk5JARMJC5dbGDvYuTiEBLYzihx+cd8RoiEhMSpl8ug
	bGGJlf+eQxU9YZTYdbCBBSTBIqAq8WXxHnYQm01AXeLI81awBhEBNYmn27azgTQwC3QzSyzd
	vB+sQVggUOLrht9gRbwCOhIbm1dCTW1hkti+6QYrREJQ4uTMJ2ANzAJaEjf+vWTqYuQAsqUl
	lv/jAAlzAs358r2ZGcQWFVCWOLDtONMERsFZSLpnIemehdC9gJF5FaNoakFxbnpucoGhXnFi
	bnFpXrpecn7uJkZwLGkF7WBctv6v3iFGJg7GQ4wSHMxKIrxt9VvShXhTEiurUovy44tKc1KL
	DzFKc7AoifMq53SmCAmkJ5akZqemFqQWwWSZODilGpjMVyt0WmzlOlQoEOAx513p7Evvo5VV
	+Tdef8qz59AS/obVCgJXnTWVZebvmWz+MV3zv97sFJUA40vr9pxYPTvkuepCscB5HPUp3yTL
	9izXPnfOW7D354oTH0P3F5o/1fT5+OtB9Ex2sxz2hj7jSSf5NE8IHt1cdqB3o665gdeeF6o+
	RuzRk2WWaa9Qapz0Z8KBKdnblnCq3zt7tL+oT+7Vg5p5C5uOXJxy8MGbmqTS8DjPaqMO78hz
	kx1cZGMj15xctUvRPezPgk/cZ0UfS4kf3LZhStLu/qnTGJWbbivo7Pm0780l8dV7UmTF5fcE
	2qhNXt3P9mFqufJKhvd1fB82rFOMnsS1Kl1G6UaAmdUSJZbijERDLeai4kQAfQSPIBQDAAA=
X-CMS-MailID: 20250221121541epcas5p163deb1f82a4775da19f3a57eb0bee55f
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----BPpCInZN70AS5XN_6T9hoGDuzhCf8U2LGtknTi7-jKSoGEoM=_74df3_"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250221103836epcas5p2158071e3449f10b80b44b43595d18704
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com>
	<yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
	<CGME20250221103836epcas5p2158071e3449f10b80b44b43595d18704@epcas5p2.samsung.com>
	<CACzX3AvbM4qG+ZOWJoCTNMMgSz8gMjoRcQ10_HJbMyi0Nv9qvQ@mail.gmail.com>

------BPpCInZN70AS5XN_6T9hoGDuzhCf8U2LGtknTi7-jKSoGEoM=_74df3_
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline

On Fri, Feb 21, 2025 at 04:07:55PM +0530, Anuj gupta wrote:
> > I don't see any change in what's reported with block/for-next in a
> > regular SCSI HBA/disk setup. Will have to look at whether there is a
> > stacking issue wrt. multipathing.
> 
> Hi Martin, Christoph,
> 
> It seems this change in behaviour is not limited to SCSI only. As Nikhil
> mentioned an earlier commit
> [9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")]
> causes this change in behaviour. On my setup with a NVMe drive not formatted
> with PI, I see that:
> 
> Without this commit:
> Value reported by read_verify and write_generate sysfs entries is 0.
> 
> With this commit:
> Value reported by read_verify and write_generate sysfs entries is 1.
> 
> Diving a bit deeper, both these flags got inverted due to this commit.
> But during init (in nvme_init_integrity) these values get initialized to 0,
> inturn setting the sysfs entries to 1. In order to fix this, the driver has to
> initialize both these flags to 1 in nvme_init_integrity if PI is not supported.
> That way, the value in sysfs for these entries would become 0 again. Tried this
> approach in my setup, and I am able to see the right values now. Then something
> like this would also need to be done for SCSI too.
> 

I tried to make it work for SCSI too. However my testing is limited as I
don't have a SCSI device. With scsi_debug I see this currently:

# modprobe scsi_debug dev_size_mb=128 dix=0 dif=0
# cat /sys/block/sda/integrity/write_generate
1
# cat /sys/block/sda/integrity/read_verify
1
# cat /sys/class/scsi_host/host0/prot_capabilities
0

To fix this, I added this. Nikhil can you try below patch? Martin, can
you please take a look as well.

After this patch, with the same scsi_debug device, I see sysfs entries
populated as 0.

diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index ae6ce6f5d622..be2cd06f500b 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -40,8 +40,10 @@ void sd_dif_config_host(struct scsi_disk *sdkp, struct queue_limits *lim)
 		dif = 0; dix = 1;
 	}
 
-	if (!dix)
+	if (!dix) {
+		bi->flags |= BLK_INTEGRITY_NOGENERATE | BLK_INTEGRITY_NOVERIFY;
 		return;
+	}
 
 	/* Enable DMA of protection information */
 	if (scsi_host_get_guard(sdkp->device->host) & SHOST_DIX_GUARD_IP)

------BPpCInZN70AS5XN_6T9hoGDuzhCf8U2LGtknTi7-jKSoGEoM=_74df3_
Content-Type: text/plain; charset="utf-8"


------BPpCInZN70AS5XN_6T9hoGDuzhCf8U2LGtknTi7-jKSoGEoM=_74df3_--
