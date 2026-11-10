Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794334049;
	b=jme0J8A88GSpQDg5qT0evxtTmiIDoj6O9FCQOIvmQgZC1WO4Legkq1nnC/uW1ToKWyj5
	 Frsw0eLcvpfJFsQxlfTIQ1pZb8yPWvOj0EDqaSmZQ0htP/Swq/z3mzO3dx2B8kOJd4Pe7
	 RYC3qG/69mja/0Qvw7oGbnGQb1I2EvHoTcFbHCjPA40Al30u9rWEimpyIqli/oZ6/ae8U
	 kVB9WwuSVFt6cx2il776Z6I5H+8dlhf4Yh/moruYIvzr5v+9aGyc4Pl8KI9aDMETXTeo/
	 AsnQPuzlL5OYjSKky9T+nbR5XYri5mDVv9dlU6b7xcEVbt/WU4akmg61p092c6yn3+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794334049;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:Subject:From:To:
	 Cc:In-Reply-To:References:Date:Message-Id:X-Mailer;
	bh=/93bouI9CcjSIYEarFZ2TsV/Z5miSOYaycaZE18W1uo=;
	b=rVhSx02GVcWFg1EbCQZx8fXRD20lJ3zxJG2R29nOs6RKRCnszFUPxyNMW3Z96wllPzsb
	 ZY8V23Mctk8UmfpDznNs+dYfC1qfUqFqgEp+tDmvnIr/wGDWHP36i0f4xr6gSAs+unEtk
	 yEt+F3iHyy9UR04X/TJNf50OUfGKM5D9If5UZVKshRfEjyVPUGapK3NYNSSMgbXsRPAOm
	 2RvsSCEmt/P295tmJWx44PjUe0M0tPovQl+yedKm/Mj8XC8oV9ehglyn9hm0DFl4t8sam
	 vMkA6RF2AKHQ0RMO+IazDDErxHZM592jzj23AcFZodLuu6BdcfDGGQOpe297hBcNRHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vRVBR98Y;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17F4D606A320
	for <nvdimm@lists.linux.dev>; Tue, 10 Nov 2026 18:07:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17F4D606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=vRVBR98Y
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-37000e7234bso4305400eec.1
        for <nvdimm@lists.linux.dev>; Tue, 10 Nov 2026 10:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794334047; x=1794938847; darn=lists.linux.dev;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=/93bouI9CcjSIYEarFZ2TsV/Z5miSOYaycaZE18W1uo=;
        b=vRVBR98YDUcnMRZ5f/xCMQbZohjGlYKckX+NOfeW/R4bNjk1Mo9POi2NFBztXtRA5Y
         YNJ49zm9sJgfugUyaFsh0pr1OP7DApzmzsyE1Frmdwj+HC9sbZw1XXxWTZp6ui++xn7M
         J5DtyxgQ1Mcqi278fWdHsRjn89dJg8DoyTHD0VX+4FjpUOuKeSrMVPd24+J7mzU8ECzM
         eppkts6PwdWr9kO51dUIPw2YErAku+8NxXpEb5hoanlKKls+QVzcXiqJBHEZVpoJ/CfG
         +EPYZrEN1qqtfIkf/NlJdyEMKwN2Q/0bBySMuQ5xM/hvJV8f4H8H4cJnkEZSXR6scvXb
         TTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794334047; x=1794938847;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/93bouI9CcjSIYEarFZ2TsV/Z5miSOYaycaZE18W1uo=;
        b=sK40JfsQejTl7saNfORKRgPe5CTYfADu5oZdhcGUePqMIdnKHKZX7/CSwp3xaEbab/
         34Qlu4jDtXxXa5q2/DvFW5bPB84SYqqMJReTkXeNlpKHg4L12J15T1l6YyUR0nnNjPxK
         XkN6IANnoMneqyvEjMsUE9wS6x26WBhyshl6uSvld34LDvLFntR3J7dza56yW75Ob4UP
         QfJrZwl6hcdIeOt87AKeHP1cVnCyhRzRUyXdgrLguBMQKdaT+dRds8gRs0SB20O4iNLl
         gucZYdAT/B1qwLrVVE2aiTZFj7HWqZrEtzMuPI9CO/vJg2de6T1oUMTZr+FVjGkTi9zq
         pkJg==
X-Forwarded-Encrypted: i=1; AL+hErHKUVrrwKW9Y1mdccqTcDn23C8WhNW9GJAgeQA2GDpwfOSCEQzlcxIAK2npb4pI+0opMwX0AUM=@lists.linux.dev
X-Gm-Message-State: APuU4Z8vZhOkwYtDP1O3oYuWCc9lduQIfOaJUhJIZ92oYOLiLTqPXigl
	FfbBgglaJneX59BQCHeMRHX5i42EkNixI4EfStQv7Uqx7x6kHq7aCqnq
X-Gm-Gg: AYBFou3g5mslZoZQ0AlLfGd15fVvlPubE4Ij3hCv0cLtQgjDvM0bEBTcJUk+1ivO/E3
	pkFMNc9Kz0RRVT3qu8JDJO/HrF/mjELG51LTb0PzPYheOLTzZyItdSFzArhrE+caolaZQystYmE
	2yQBSgXFamJlgrFLr50HMB8bTDB85ivkcIo1c0Gs/Q39hB4p5AGBEW8w/GQ5OJ+jS3g1LuYNAbG
	DfeKA5TtOedxRXGwJcofhnVHACeva8ZTqna1B5t4gKkhEBXlFjjVFtyfcJP80tnx1kjxxhz2mn/
	x5jxl3nXE16XYtI/Vh8oYuHH8598TiaH6HgewSQBSS9BYwjAqf8DqezRD06nkg27UdNqTHeoJGJ
	a0jYFcxhrdAhvz66TJToH9gyvIysQVy/uTDKwdQBsoZw/n2621vBZfzaPyBx2G4yCHwneIHXuJa
	eBaz5q/gnVE0kzIM5yzR8fhMRmAf8BO9ksLhj9lNDdeP2jzmcJ9sAq4QYkjp+JQ1VSUR1YgXZOB
	lKGmaOjSbDoKlFg7w2D8ftqTbv4or6UXHYS1O/UdeaHYJZUJarJuHjUBi/5loQ2P0xL6AU9g65D
	isMl2lENtPylRwHB4m8N2GXr5WXhXkB9cfyfig==
X-Received: by 2002:a05:693c:2a17:b0:36d:a465:b38e with SMTP id 5a478bee46e88-3768395f032mr102273eec.5.1794334046759;
        Tue, 10 Nov 2026 10:07:26 -0800 (PST)
Received: from [192.168.29.85] ([2405:201:8026:213e:7392:6aad:f285:27fa])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3751d9f135asm8302893eec.2.2026.11.10.10.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2026 10:07:26 -0800 (PST)
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] nvdimm/pmem: Fix disk resource cleanup on
 initialization failure
From: mdshahid03@gmail.com
To: Alison Schofield <alison.schofield@intel.com>
Cc: mdshahid03@gmail.com, vishal.l.verma@intel.com, dave.jiang@intel.com, 
 iweiny@kernel.org, nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
In-Reply-To: <au0PabL2q2640uWI@aschofie-mobl2.lan>
References: <20261104161825.314835-1-mdshahid03@gmail.com>
 <au0PabL2q2640uWI@aschofie-mobl2.lan>
Date: Tue, 10 Nov 2026 23:37:07 +0530
Message-Id: <179433402708.154498.2389032583809626611.b4-reply@b4>
X-Mailer: b4 0.16.0

Thanks Alison .

Lesson learned !!!

On 2026-11-05 15:21 -0800, Alison Schofield wrote:
> On Wed, Nov 04, 2026 at 09:48:25PM +0530, mdshahid03@gmail.com wrote:
> > From: Mohammad Shahid <mdshahid03@gmail.com>
> > 
> > pmem_attach_disk() allocates a disk using blk_alloc_disk()
> > before initializing badblocks.
> > 
> > If devm_init_badblocks() fails, the function return directly
> > without releasing the previously allocated disk.
> > 
> > Use the existing cleanup path to release the disk and preserve
> > the original error code returned by devm_init_badblocks().
> 
> Hi Mohammad,
> 
> Your patch looks right but this leak is fixed in v7.4-rc1 by: 
> 855a46681e0b ("nvdimm/pmem: Release gendisk on probe failure")
> 
> Basing and building your patches on the latest tree, usually
> the most recent mainline -rc before sending helps avoid this.
> Sometimes a patch is also just on the mailing list, so check
> the list too.
> 
> -- Alison
> 
> > 
> > Signed-off-by: Mohammad Shahid <mdshahid03@gmail.com>
> > ---
> >  drivers/nvdimm/pmem.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> > index 5fb86595e8bd..76e80eccc8e7 100644
> > --- a/drivers/nvdimm/pmem.c
> > +++ b/drivers/nvdimm/pmem.c
> > @@ -563,8 +563,9 @@ static int pmem_attach_disk(struct device *dev,
> >  	nvdimm_namespace_disk_name(ndns, disk->disk_name);
> >  	set_capacity(disk, (pmem->size - pmem->pfn_pad - pmem->data_offset)
> >  			/ 512);
> > -	if (devm_init_badblocks(dev, &pmem->bb))
> > -		return -ENOMEM;
> > +	rc = devm_init_badblocks(dev, &pmem->bb);
> > +	if (rc)
> > +		goto out;
> >  	nvdimm_badblocks_populate(nd_region, &pmem->bb, &bb_range);
> >  	disk->bb = &pmem->bb;
> >  
> > -- 
> > 2.43.0
> > 
> 
> 


