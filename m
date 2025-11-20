Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90CD73A1CF2
	for <nvdimm@lists.linux.dev>; Thu, 20 Nov 2025 17:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763658705; cv=none; b=icIz7Kx9wDPkPZY4IRLsIR5qHcyqnVBvcJnBma22Dq+xJqZ1HV2Va/AM2bQsojVg7SKc6MN7oLoGeIrwdQhDXt1+q61z/2J4q8S3P2rm3JqVwdkR6OhYEltlbFEyiXwCgq48nKcWD4iyP90U4TrzH/yD+3z2Iy3/3JmCa/vDfKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763658705; c=relaxed/simple;
	bh=2U5H0M+AmHJOzPsmhzLUd9oy7nlu/R+qhpQ/NyzGF28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OuS6JWgmsML4La3vgXMiesMtwabmIgq09ke6smuHX3BKSAZMkFJy6iRtbHkIF9Yl1I3Nf5P+fPWuVi4hTr088HFn1ayyHhGTCIzhmIzJVENWKROM56e/xriRPk602zZcOwb0jXNvOnKbL3N9BeLzqw0Wp6iOBdX37QygadnPahM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=K25EBDGH; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="K25EBDGH"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-644fbd758b3so13387a12.0
        for <nvdimm@lists.linux.dev>; Thu, 20 Nov 2025 09:11:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763658702; x=1764263502; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N/Z72n9Cl1RL7pgenMI30Fd9ER6zUw/sTuQNIj1Gn78=;
        b=K25EBDGHiYLor4fr/+6dYo+h4GFpeQyDbpxM++qhxa8teEdObs2OBCxfz/vz04E4aK
         jm1i38brpYWLHbnomdHEWMozhxvAkDGbYT9xe/u9c0EWdghl0XDDk6xdL87UdDQRDO5b
         Qu5B8D+tekEReDHWzOCML8iYrQoqgqhgOPDkrIwsAG8iYel82gN2r3H11CfcsK2kUi07
         15fbCHJjwRRlzY+9MokcjO7OTmMmleTj7cz9oeCfYUeGmX1VgG8LlHLrguCNYY/wn77J
         5UlzewgB28owgjFdI1WgZ9aKByIuy7PsQp3rai+Wiyn1Cj6jbyUaKEtx8fwpe2XEN7Kk
         YY6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763658702; x=1764263502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N/Z72n9Cl1RL7pgenMI30Fd9ER6zUw/sTuQNIj1Gn78=;
        b=VJZzh3Z1aN9gtfnSNM4XUrUvDhGs6zEQ9cdboL1KvQbqHzcgUtbf0/TiYDYYxruPAB
         fU0lfovOWUwhSBbyU172So9WPkDJInY2gYcXZXPshbuwoKwSYbxC/nAW4VX4pJx01Sc+
         65vN9ukyOFIe+CIm7eREjMS8cNG2wcIINyJZKoycOxRo3WwH8PNryZaPYrBRvoHZQowY
         HtM526NNzzNHKeZVUaQimq/1NA/LvUd6/uSwBhtM/Pdlv4NbRrUQsGaclPecYlGtMkA8
         fhKNuvqqq6Ho0MawhZ8U0GTxm5SYVJSpXwpj4SmVlJ0aYpTPGzqxzcgg41Uq5tWi4P4B
         O5kA==
X-Forwarded-Encrypted: i=1; AJvYcCU3BB6kO8ObtzAHgYEx/VIg2iM//ahhLzNziBNkXPKOj/RwXRLLYfSbYZefh9z+1wXeciUCAnQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywu2hgaJ3pZHgRruSqr206cXY+R3DGxAIJF4QUwWLldJ4R1FZI2
	Lq+N6V4CzMaMIDnBEQo+UVioA1rETDMaHaMR+nesJw4bPPaZXb8/1qWFaDop00Qd3HTM7+LKPtW
	IoK0MHRACGcMNbyXb0a7FZfB9xYZ+ZmfbOx0bk63e
X-Gm-Gg: ASbGncs/vyEAAmoK2zGerEXOsRrWCfDEKh7ZPqBCRg6CbEmLRiIxhWRAKE+E+BkWlyU
	tV6hjFryWuhq4Ymk/+MCGLeVo2GOIQrAG5w2C04wqINAoe81ruk/qVLSEpZyAGdABhOkSCX6zrI
	wkXvkg+17wYBp88dBGT/+jWq2WrGnsNhXu2L3ya4h/RxwOmu+8+u4mR9cQgQvUTj664PwczsJ61
	d87iNZpSCXma/DJT8kAkBIj0d6wMsRFpQHdmlyIPm2VLVy8FTr2SxhUyNTBgIgdfFMVmIPF2GuF
	iMs0MxiKb3Y7e7X87bZh47vvQw==
X-Google-Smtp-Source: AGHT+IGeUbm7Ie6pXSb+0wmq57u5fAGeqTIJ1BMG7y6hDCVTSEGpacFalC/5UQNwdn4sUHRkFYy+wUrbd07aK5lUCBY=
X-Received: by 2002:a05:6402:460b:20b0:62f:9f43:2117 with SMTP id
 4fb4d7f45d1cf-645369d2740mr52100a12.0.1763658701850; Thu, 20 Nov 2025
 09:11:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251024210518.2126504-1-mclapinski@google.com>
 <20251024210518.2126504-6-mclapinski@google.com> <691ce9acae44c_7a9a10020@iweiny-mobl.notmuch>
In-Reply-To: <691ce9acae44c_7a9a10020@iweiny-mobl.notmuch>
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
Date: Thu, 20 Nov 2025 18:11:29 +0100
X-Gm-Features: AWmQ_bkl38cRsErW02FYYsJNSvgkRtb1E7YCtig5YF_mXurH4QMwznjZdg5sa3s
Message-ID: <CAAi7L5foTbvvskLxKW50T49bdUBbedoxQHifZ-4NJYf+Fv7YvA@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] dax: add PROBE_PREFER_ASYNCHRONOUS to the dax
 device driver
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2025 at 10:46=E2=80=AFPM Ira Weiny <ira.weiny@intel.com> wr=
ote:
>
> Michal Clapinski wrote:
> > Signed-off-by: Michal Clapinski <mclapinski@google.com>
> > Reviewed-by: Dan Williams <dan.j.williams@intel.com>
>
> Sorry for the delay.  I picked up this series but I find that this breaks
> the device-dax and daxctl-create.sh.
>
> I was able to fix device-dax with a sleep, see below.
>
> I'm not 100% sure what to do about this.
>
> I don't want to sprinkle sleeps around the tests.  daxctl-create.sh also
> randomly fail due to the races introduced.  So not sure exactly where to
> sprinkle them without more work.

I see 2 possible solutions here:
1. Modify the tests to just poll for the devices to appear.
2. Modify ndctl to poll for the devices to appear before returning.

What do you think about those?

> Could dropping just this patch and landing the others achieve most of wha=
t
> you need?

No, device-dax is the only one I actually care about.
