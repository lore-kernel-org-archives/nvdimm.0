Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B34E72652A4
	for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 18:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769194709; cv=pass; b=hhdLySwhFiMQVWQAQ+wZ4seM2taG/ejAGk46splSQ/1a82iMuCSYZt3XGSLEFoz5SrZTYcC1OA+MNLNIS86ER70cZXZMyRCAs+ugquP/aJ11nf6czClxnoAEmOG3MKjP+qTLen98ZMD8hxCiZyejeWGt6sggWsOiF6zfZbq6+B4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769194709; c=relaxed/simple;
	bh=YSTfmMzpiQIpjfuPzmKDNhr84AYQSb8pZNVQ+vwG2GI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=pIN4/3jrpQhaaeGDF1dzOsBhJEBdmeWNmFCL8ijdCPAJWCsVU8tQG1FTEtKQN+mKkhafbcNvcflqe09A3ZcLeMTGFynXvdh3JzHm0+YDRhmZDh7x8rokVvB9KqvtUq5MfWMsOzVBfP5Qxmu5tvyYcQQRPMfeQtX/qf+DWslYhJM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QlRXbNFc; arc=pass smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QlRXbNFc"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b79f8f7ea43so386290966b.2
        for <nvdimm@lists.linux.dev>; Fri, 23 Jan 2026 10:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769194706; cv=none;
        d=google.com; s=arc-20240605;
        b=MYXtrvU041LdTm+w8Nq/Doxz2pr92UaJOo7hpXLTCiBIeLVfe2tnP7p37TqvR4qWOY
         IWG0Mn2grdsqxdOdzBKmJXWu6bo/5Ou4pXNiGlhWdD1Wm6cOE2dgQ/8LQ56/9x0fQT6Z
         dg6TTf1VLPBHzPFMSGHODKYov5T4V9l1JJ+BE0tDMdbtCfseaOpoBTDTjT0yEHCFbEp6
         9PeKaLMhSLd0g5grV+9aBk1MLJk+TAzy8B+UF12S9JIaBpeETuBr8arvlZhYs5eMB/j6
         TbUAZW+UnmrbnmMy0/dskF1jI36T0ic/W66k19I7xMUuLZX6zLfMLEkHMSdRppQPyNGg
         oZ+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=YSTfmMzpiQIpjfuPzmKDNhr84AYQSb8pZNVQ+vwG2GI=;
        fh=2W4H9QY+5XndYVAzD7it9eSlUmzMYcpPNGe9jCGNrTk=;
        b=UKdde8x/BJrroqHbcqLl9yh8pk6Bd/T2Bm7+L5foP084HWFtY8GnmzqjE9y6LKVzQl
         IJrLvkMe9vscNzrQTODlm382auAcY73UOUWtfbH7oQYxYLaxeqvHNVVGe+myo5zKcAtA
         3Wts3IJM52ReSqAke5PhI5K/nSjMEanYhBb7ocg3x3hq26wJt1IYDvmbfIog5fVJpo0d
         QbZuc+jkbg8siQCSfPJHAUcanKJEF4zHDAB8a8de7vdmTxa2vioW166v+ZWf6Pk6JWp5
         G8rTqRtFdEG4ZO2nWYphUmD48O4a4Y5UurXxmAojF3mDfQl0pBJ++yKM4EMciufsJmBO
         Q4KA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769194706; x=1769799506; darn=lists.linux.dev;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YSTfmMzpiQIpjfuPzmKDNhr84AYQSb8pZNVQ+vwG2GI=;
        b=QlRXbNFcZJGlCthYJc9wrjJBH0vYOug14B7h0YtFhEDTKYGJFdvEWG9r/GcQv70uHB
         pjqVf+KZ4YscHltuxSmRlkp+oQmt4Cmd2HmMV3bReMtk8d6YnAW54YhYMfPfCjVpkjCj
         2b8qvhXTEHPzTdmmozBQ4BG96hOPDxsLe4tMs6StQhpajG1yZzHhEMu7NsI1xilQ0uos
         HL7MbXEJ+G0y11DaNR+oVqKnpff0+vo9P8FO7E019dSIjwiYzdqqZW+T0qPm4ujYoMFq
         a+QP5UCp1CtmYt6hMpreNLsAd/o5nt4jC45KAgHFco4X+MiR6ce0w2hhJ2WRo48V97L/
         bmeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769194706; x=1769799506;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YSTfmMzpiQIpjfuPzmKDNhr84AYQSb8pZNVQ+vwG2GI=;
        b=mdNCUrXSmPvDZ/EUDHY1Ps0P42UJS5674LDNTgA4jxt1edFI37L2z9tJCz4Vnj4jJE
         OHhaOrm5axUSaqWN3bi079LjpSaeF4Z0U4uzT4zFMV+09N2lpl/jskiEy3fCrRTw1tHq
         dbTlYJv5KxwLGAa1oezqGYGBqH4Xt7u33emUJ+gJ/e4WxP5n2g28//+B/b/yOZi4Qscy
         uo46s49g680YqhpbOHA8UO1eUV35akoHYBaVKonYJWpv+Ke6S/+hW1Gp2wztR7X5ZLcQ
         qwurClweS5XkOkAYuhg79oeDFExF8fT1g56qzapnU2JXF+VuLzQsB1ZtfsLUJYJV7kKG
         UTtA==
X-Gm-Message-State: AOJu0Yyp6wHrRYwYhriquLQpmhxiEWRP0MAnzCzB5hOPERrXeDQbi/KE
	yHeNhVTWUeh5zQwHnT6QkR1oogUH7rBCLUZCH568a6LzTG5KFB83QYU30B9Pe2m50bAkmUW9D3I
	sauKs3ISK9BC4mJxYaCvwEPj6msIrmF63Qw==
X-Gm-Gg: AZuq6aKtuPgOhZR4gbAOChiP9y51dJzhBf638FNo4QRoRnWafIC1QOrALWi3wVjCSc1
	0LVanoBoXi6qvOmBORHPkCDHSwAx7yAvgK/x9YKXxT4jvo9ITyJRFAPGWSxXN0aXZBR+21tHygv
	BFvudlekRcRAvHeJwDb/zXuWN6Ho/ayfKoo7wx+qWfkn8OiHLMDWhbR+Yz8kQKD9OwTpfMQtTf8
	Kjjw0TnQLZTKW5BFOZ2n3XOSN4c/7p0/6hMdiy3fCbeY0GX1DKzDasRtwmLLi6pBZYC7gUPMT+F
	ZYrU3e5jRb2HTT5rZ6LFJCZr5fL6jkXmjeOk/A==
X-Received: by 2002:a17:907:3f03:b0:b88:4849:38be with SMTP id
 a640c23a62f3a-b885ae872c7mr272772766b.49.1769194705736; Fri, 23 Jan 2026
 10:58:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
From: Jane Chu <jchu314@gmail.com>
Date: Fri, 23 Jan 2026 10:58:12 -0800
X-Gm-Features: AZwV_Qje-hcvxPS6EaCwlSB19A5RI--H9e2ln8dRlPpWweRddso8mLiPzwHHlIU
Message-ID: <CAPH-rUX0mZRAVJFeKwTcNqB0qhiqmCkuPFQVO2r5Zzo_Joj2sg@mail.gmail.com>
Subject: unsubscribe
To: nvdimm@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Please unsubscribe me.
thanks!
-jane
