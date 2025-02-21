Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD472204F83;
	Fri, 21 Feb 2025 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740134315; cv=none; b=BeluTWavOzKNQ3gPAX0d3Yz+gtMc4vM+RTsnIdZ7mBwCu1egWAZkUt5ujpvBJ8HpNAtvuyJ7Dlqdd1qDl6UZFusDf7sj8yn+0WvtN6v0MfsvqZrqqvi6xWnHTYZLnRqb+qOxt103CI4JBTbRfl4gwmFhtEs4CTAx7uaJHof/7Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740134315; c=relaxed/simple;
	bh=DQ7fsWXnr81TGCvxwT39yv85kiLQ5gpPRFYuWpRLa98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ke5/D8yN1qw4gIGbaA6ZDyl6HSDvgBhotT9HJFmULFJ8yoaI0vQOQg+YKfC+B9ndAWzpCglrrz3GaYKJFmeGevrm8oW62/5p9TK13ewCtMPGeQGrlXLod/QxSdc0oJ41HThIKvd8yG2YfF0F6yPCfP6MOf9dsctt0ZuY7p+Exnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KYVcjHps; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KYVcjHps"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5e04f87584dso2982624a12.3;
        Fri, 21 Feb 2025 02:38:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740134312; x=1740739112; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DQ7fsWXnr81TGCvxwT39yv85kiLQ5gpPRFYuWpRLa98=;
        b=KYVcjHpsJQ3FmOe8w78jDgY+uB099V9ysMpSeUIEhNE/UpVn1yy0OiDj3k2WtOnB+F
         jVi3p7k/HzKugvtnUftGWiDAj6mVusGKtcnUd422hOvCA7r9HmIob7pDfdmccBnULAzi
         038I3QI998jfzks4Oz8IHzHOPC8/EBFgUbaEEHp1ZnSxZNS3O/ddU1OAVPNkTVasfc3/
         DNGtwt6eqF62Dsc3EnYZNBuc8Jfkiw0uAaXbLUsQyrIcFetr98S5XwsnmUS+6RpcsP9q
         MPrMaKPkUoajyaVVA9qkdllQVm1IHNCFN4B1P6DVEX5qDRCNz9gXn3sZtyWhJ2NYRxPC
         gL9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740134312; x=1740739112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQ7fsWXnr81TGCvxwT39yv85kiLQ5gpPRFYuWpRLa98=;
        b=NgpLIQY92fTKuQ5pKphdKCcdwGxQmZPqDgL+wvDUpSX3gjzO4xI+Fbyyo0i43Y8Asx
         kfu7HsDDBG2EQ6A1Cta0QaAdCgjORp/6j8MGXgUodB3JT9q16evR5edDhQbQtnNVpfr9
         8QTQKx/K3UgGoHery2B7bY8xYxpyR6JWkmXAEsIexhnwcf9tpgURMu8PZPuD0mCgGO+t
         9GSA+R/XvTtrrXqTYq5hJou03DTHa6K2GEIQylQMzsFjj5oZEhjNCIkPX7QWVMBRcQ1D
         NIG7xPktTQHSxoXMY7ZhY55hMH15NAoSY3a15KvHb96IQsxxjiMZhWXgYEPV4qNX9dff
         18sg==
X-Forwarded-Encrypted: i=1; AJvYcCUj5ttBtNdWISWoUDBnObR09dktu/xvQ18E3Tv2PaoGyIRXWapEMIGpm7DnbkdV9rVmH7UcP/TE@lists.linux.dev, AJvYcCVFAG9Ol2xx6+ms8NAdThCp1ek0uNJ+qbn7On/DVfSMlT23aYbijosIJZYUJGXbkMVIAT3h+1mYsA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0N0OK2dSP0Qu0CXcnLQviqv9ZHRKU+Dmjo8juplU8hABRG2N3
	efK5rBYOBpNC9t/tvro7oBf5QMqH6Q0/knQGymsxYSSh0S3mPWNr9vi3/zFw72+Yy3CPJk8HS3j
	FPVmp6zi2Ho7RkuAeev2RIkekVA==
X-Gm-Gg: ASbGncsp7CP5olr7lHp6oibwF9iMWqb6JZp5RWQGqzjL7fY+VQp9Y2EPtg/qzMLlouV
	emDfxRSMFnReSYyGIiOBziTA1FFukvXRpsYU9gaYjp+wFuYghsDk3Gylk16/G8NgbNjZ4YkmdcG
	Cu5NUp4AFw0tKVqBprvWxgWUYD
X-Google-Smtp-Source: AGHT+IGD6YiP0dN6ELvQItWtcLSNC+C4YCLGwsEEcWIRRLLW5oS18HX8IlkEy6wochtZC/R6v/sJf4VACOoM2CreUjM=
X-Received: by 2002:a17:907:2d22:b0:ab7:9b86:598d with SMTP id
 a640c23a62f3a-abc09a4b7c6mr248969566b.17.1740134311947; Fri, 21 Feb 2025
 02:38:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f6130475-3ccd-45d2-abde-3ccceada0f0a@linux.ibm.com> <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq18qsjdz0r.fsf@ca-mkp.ca.oracle.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Fri, 21 Feb 2025 16:07:55 +0530
X-Gm-Features: AWEUYZmpH0Apw5ilSxEp1rdIgRl0iRXIb7970HtruWNGBkcA04c-5zyfLHhEwZI
Message-ID: <CACzX3AvbM4qG+ZOWJoCTNMMgSz8gMjoRcQ10_HJbMyi0Nv9qvQ@mail.gmail.com>
Subject: Re: Change in reported values of some block integrity sysfs attributes
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, 
	Anuj Gupta <anuj20.g@samsung.com>
Cc: M Nikhil <nikh1092@linux.ibm.com>, linux-block@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-scsi@vger.kernel.org, hare@suse.de, steffen Maier <maier@linux.ibm.com>, 
	Benjamin Block <bblock@linux.ibm.com>, Nihar Panda <niharp@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

> I don't see any change in what's reported with block/for-next in a
> regular SCSI HBA/disk setup. Will have to look at whether there is a
> stacking issue wrt. multipathing.

Hi Martin, Christoph,

It seems this change in behaviour is not limited to SCSI only. As Nikhil
mentioned an earlier commit
[9f4aa46f2a74 ("block: invert the BLK_INTEGRITY_{GENERATE,VERIFY} flags")]
causes this change in behaviour. On my setup with a NVMe drive not formatted
with PI, I see that:

Without this commit:
Value reported by read_verify and write_generate sysfs entries is 0.

With this commit:
Value reported by read_verify and write_generate sysfs entries is 1.

Diving a bit deeper, both these flags got inverted due to this commit.
But during init (in nvme_init_integrity) these values get initialized to 0,
inturn setting the sysfs entries to 1. In order to fix this, the driver has to
initialize both these flags to 1 in nvme_init_integrity if PI is not supported.
That way, the value in sysfs for these entries would become 0 again. Tried this
approach in my setup, and I am able to see the right values now. Then something
like this would also need to be done for SCSI too.
