Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27BD354AF2
	for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769525709; cv=pass; b=jtAg20nIAhfVz/FnL+AMZC430IBJ96kz8CKqSjySnx0wMhN2nE7XzKvCx8As3+5Oq86rXBzvIIxhlxydmfH209BN5CvETbL3f1p1YgC+vBkwCj/FTBtpwRPS98Vdb1hhqZ39SUbiPEXW1oCP9K1yrJvI4e8p/FjxREldMgTfCc0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769525709; c=relaxed/simple;
	bh=t2ybBJsNWtFjQaIkqKJiX+bUT4FayuvonReDdoNdNG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Igp762FS/8FOZTJpUuQefj8HndcQPRfzzgVMRIgsqjEihbPqdXnGvZnw6sh3C7Fedp/BD7nf6H9xfFLxXn+AObSH0c46uyReIxz3fyq/mAgJQdumaufkYLIY66du0sI+7OUKsv0ZUuF9hYfz4mPeaxZAOoQgXrIqOENtLH7Wftw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iUU0mHe9; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iUU0mHe9"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b8838339fc6so1095576366b.0
        for <nvdimm@lists.linux.dev>; Tue, 27 Jan 2026 06:55:07 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769525706; cv=none;
        d=google.com; s=arc-20240605;
        b=RBaaR8k9BOVHqTTDV2H7jwch9rqCBUetDCWczrHd+G+z0yh9VE/wQkvvriHAxMqIbe
         /yrcP4VVfh5Scq7l/TWkkOKqmqQCZpPQNWijvJUFB11eVF+uQPdBiuhiC6p8bZShJ7Zv
         zsdNkgUTwWz2fz2+UXfWBWfVajPvvt4icUZcFJujR6AcLiBghPrgjGt7hC9qorW8Q4kD
         llgxH6YWPPSsU20+kmMiqjlFSUR5lrv6wVSVcW8jr6kOnsoa2bJhy+eRZLteMEHoG311
         iK5MEmXMYDrSrUt59qP4cnlB3yWqMDsNfcnxz05ThPxC3hO1bE3DNUqlBgkT9QmaCWQd
         AxDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=lCtQBBTytpHyzGbCjZPP22G47ZoJNaJiWCn03phHKmg=;
        fh=DP5q+r7zLfuNWY2SzlcL+b58Nk9Kxsrm0HM7GE3FJoY=;
        b=MjHOBB7OpO1A6CK6Cn38J7l/aIvcWi0SA5xfuIqGylPop3HlHLjcTmEdbHxq2nSR5c
         VgUoM5CKbpi3MqyMGfUexhERV5n6kq8TnuBvFzj+jL6nGN6Wxxm/1e1RtrnJszRc6NFG
         P33QohkoixBBAKDpXIaF3bndqr0MM2V9NYP736DwDk4HhlNtA+IgeJ0EdR3TCaSjEwrx
         Vsu6Wc5Ft9Gz2n9YSTimm3xqnp1024sSPlBdX1dlZ3kdk34EhzMcGaSCYtAlV5xptJSH
         hsgdXaHKMRMqk1SS2PiekTUMeAK7h3YM/6pEoIUmrf5//Qf5qswuGn1A/5kE/W3BpyFM
         zsOg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769525706; x=1770130506; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lCtQBBTytpHyzGbCjZPP22G47ZoJNaJiWCn03phHKmg=;
        b=iUU0mHe9M/lsiSF84NBpl90ZzTg0/uldAUWSluafSBjGJrhREB9CDFmOREurnBqgzg
         pTwTWmnOrsHxjh/wdKa/gf/oWfJ+TkMpDDw0sJR1huPFArXCS+ZOg8Jm2vCANw+eeUG2
         96/eCT+usNrPoQbNOoOu78hOBPNn33SDD3qg0o93LJy76GOBXBiY5W49HHuFM9hghzxQ
         v7MZ8JMWzgFtwqMfPsAlzubU4TDfrfbktwjiEiq0Lt+BMmenvPpNJGkKixRsVhL3Q1Zc
         etiZKZT3JSDEqkCMGUXTsDSuqY2purF2QposN8sh8Rg8/7SrvqVTW7/XKPN9rm5b5Atq
         OCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769525706; x=1770130506;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lCtQBBTytpHyzGbCjZPP22G47ZoJNaJiWCn03phHKmg=;
        b=WBpR6HL+/6GPnVPJQD7dYl1ecMy1+61AYjUdECWt08Vl8kUTN6858VW1FrfW3e31pN
         sGzrgPnCBIAIU9texDeb7T26extIgNiFtxglRycF1Mg5NmEK9gMwh4h5f0+Itlq4NoH9
         tXBBZ9d9wLAXrK6aB4ikABO+7qBew9tYc7y8qn40bAiiHjqdFbFpeGvgVEOsn8e00vD5
         oKoFWsQbOBCJ0hlF42c/ORcSEu/h3PH/2mpgVpk2wHEx5H7XYePgyAH7aW7r7BvCEm78
         7wicpF0Hxyw1d3YdRw+jDf7kgltKwgmVV3SoE5SwwQMUPcVUb+BNxg3Vw2QmOxhrcmUD
         4VCQ==
X-Forwarded-Encrypted: i=1; AJvYcCU4U6rEEvI6g2CizFyWSh6tVp6QOje0/f1ZBObxcRLTWHf60mPgvMuu9379jlv9dvKFpXCaQH8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxUhHZXMKfEj574Zh6G2fgOcGzDW/cRsxWyYafU74VUnVjKcchu
	Sw+8O8EJoX38jlIZvp/5jnQKaqVC/XBdkdP3Wq3vfHCf0vuelDjs5/d0Buswjx3jI4PkuNpirzY
	/Umbys8bTwRFqU7mIjv7qlUcdjoOTkg==
X-Gm-Gg: AZuq6aKQl4QIDeT/l6ji/ztLhRCHF/ZjVADlmLFoR2dIyM+D6DiQBPVhSyGPDuvlWAT
	t2oi8sw68cxsq9prZzUPmqpIuhvr7xKVINtaGl387V9F/8U8E3986oIHahoW8nDXLLP7Y8HvA5p
	VlStdKK+WdU1pg20iemuXFBDgZRMZ1RFAJFNYKcIjAEVj71euOkRIuaVY4ZyaLrDcYdliYXqxUn
	okki6V8xv8czYEDFaSWySwa+w9mbSNLAA5Z2+ym8sbsxcHW1EDP+M1HqMEG7AWPcjX3z4GWFmxp
	5J0HAjJ+b95P0KfxWqERYVSH065CcRQgp7qsz2xra56IU455RH/nAz9Tfw==
X-Received: by 2002:a17:907:2d08:b0:b76:d8cc:dfd9 with SMTP id
 a640c23a62f3a-b8daca2128fmr161653366b.18.1769525705537; Tue, 27 Jan 2026
 06:55:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260121064339.206019-1-hch@lst.de>
In-Reply-To: <20260121064339.206019-1-hch@lst.de>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 27 Jan 2026 20:24:28 +0530
X-Gm-Features: AZwV_QgrOpVy11EguRWdouecQbjVaZ_wK6fgRNHqWm4H5Y0Gztccb7HBO3aIMrA
Message-ID: <CACzX3AuDkwEw3v0bNmYLk8updk1ghVJa-T9o=EHXor9FA7badw@mail.gmail.com>
Subject: Re: support file system generated / verified integrity information
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, 
	Kanchan Joshi <joshi.k@samsung.com>, linux-block@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Christoph,

Here are the QD1 latency numbers (in usec)

Intel Optane:

Sequential read
  | size | xfs-bounce |  xfs-pi   |
  +------+------------+-----------+
  |   4k |    13.62   |    7.2    |
  |  64K |    99.66   |    34.16  |
  |   1M |    258.88  |    306.23 |
  +------+-------------------------+


Samsung PM1733

Sequential read
  | size | xfs-bounce |  xfs-pi   |
  +------+------------+-----------+
  |   4k |    118.92  |    91.6   |
  |  64K |    176.15  |    134.55 |
  |   1M |    612.67  |    584.84 |
  +------+-------------------------+


For sequential writes, I did not observe any noticeable difference,
which is expected.
The Optane numbers at bs=1M look a bit odd (xfs-pi slightly worse than
xfs-bounce), but they are reproducible across multiple runs.
Overall, the series shows a clear improvement in read performance,
which aligns well with the goal of making PI processing more efficient.

Feel free to add:
Tested-by: Anuj Gupta <anuj20.g@samsung.com>
