Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D5063D3B3
	for <nvdimm@lists.linux.dev>; Tue,  2 Jun 2026 07:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780385550; cv=pass; b=aXKITmW7UT2y0D1C/96lhxSP30zSkrl8czrow42ASd7X+YmIrrOGEsY7lEHCvZQ1kEOrE5wpP5IRMqj0z2kV0MhYvPEToKJbRbakobLSuC5XOgleTFJ06lH4RKeYILmeHAZJEr2YG/W6rfi4mhMAGFgZCOn3gubFVYI/V9zNaGk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780385550; c=relaxed/simple;
	bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jKQYivyLxhOEgyD5g4UVODClFvqHqO2RZwQbg67O+IihhwCqRQDNaR9Fn6BnS+GgZWjcSo3P/EwIgimiw3XTK63m3Z7a8l/V5EPp0LszpZuTsve5F8N4ORxEHAOB/xJj1WZ80Q6qp0kiSc2x/qAPisLsG1Yv5bm734RXuBIm7zI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iz5yw+nF; arc=pass smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iz5yw+nF"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-137e836ccc8so113412c88.2
        for <nvdimm@lists.linux.dev>; Tue, 02 Jun 2026 00:32:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780385546; cv=none;
        d=google.com; s=arc-20240605;
        b=R5jnicG570/bFYPgCPkYtiKoEd+QqCOdYkTeqxmZCj3x71kWInQ5t6TelrWA3Unjgo
         7wtc0MUSJnnov0TLh0kzbR1PxD5mMmcQ6HZTJxZqjx+/DwhgnAJ+EzwRDuR1lI5HbfbY
         jnPNZi4bzKK7s4z2FwGxiOY8Fx9LSRNBWZuPpp9Rv2/rNWtPH9ly65xNtZWMvU64OOG5
         KOP82mTNrC4+JHjGmmhcIrNX1O8YCg+7XMasgYvOyEtf9fdXVK7rL6AiDk5tC0L2lANJ
         zmmMoAg/YUB9dJFyDyf1feWU0csng6YOKZDs8JCuR6pvNicEMd71E9FniXU9cPok7qrO
         H3cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
        fh=romSDGV5b7tu3Wn1/V5iL6XnS/y/BL181+ehCzwuFkU=;
        b=ai6psNe7vYw+jjAPgcVqwj3eUDN23j6w4NSOnpDv0B5Enj1Tgn/RYeZAhTyR297Uy+
         4OJj/fbDBDqYlUgBfYv75O4CXmGkCSqEMEcsL0c4UPz66hZ6yusEGKbEE3gGXTYNzIva
         Od+Q7lqpspZaRkrfLRhczpyJTEhP2USr60FoYP6mv7pn5wk2T87Pz+7XyloqDRLQ0BwM
         r0a+Bkohzy3gq4T/+AIhIVLIlkL7Kd1/1RE/+Q9Ue71f+sTGulllSqYKWz0WgNJ7kzQj
         ZF3n1fysczaLsNygvPn15C3Y6DzBph7coh/0Vh3cnmxOoiOJKfXWwdmSdlFVxKx6AKGw
         vttg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780385546; x=1780990346; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
        b=iz5yw+nFaZUsZzvrW4l0IpPBJzErmEssclh1OROAEZ9SKlLsGNQFxtwwYx10+4oe45
         zcOTTJPEJs2ubGsHOONZAXnPDqz3m4tlvS/bd+fLOB/lxIFFs+Z5vHmqGTHOKSJAIe0S
         j0iscMzgKRHJK5y+4Y7YF7JAv7/wkVO9Ob/Nb9bI3Xt0203xnMmweF45J9Y5nakK8q0W
         QD+kbbpXcyZfj84Hoe/5radxBEMiV7WyozhHnqSV3yos7fNQtlxUT/2WzYRF+zXAWStD
         zBkISGLLTeZOS932vOKoCIukzVzj9x2rIUCQGX5ohLLbLs+g+39dNwHfioNXiu8Z66j3
         7FvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780385546; x=1780990346;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1j0qfKP1KdBaZMY7Jn9DPIfIqNWUq3HwpWfkfU1xHmg=;
        b=UYB/pu8eUZgWKKIy3iS7HIpxtTqPHz2ugJsgnapCicvUlcob02ydzvD6xtMBIJWkYl
         XusQ5pwr2lNYO0oulBR872rHG3RNC20q8ZQY7i3VYDxWFle4BblzTSLw+7w3uQBNVOX4
         bzmVZuG3mlg7+PjPVx18zs4yon6nLJKtfhHyQEK3xhkocratEoIr9m/ByFZXlPMTXbVo
         11XYTD3xvulK+L2uTH+XUQnOPtUB9Pf4PJ2xIIxsoaI2/2aeAA+PCsVWIc3ZAx0CESBW
         XgDNJrt5BQPnZtISOVACuRLE9nNhT5B1yntPZ7Tx4xLPlLoCz6EHXQbr31iniSwhu/oQ
         Hghw==
X-Forwarded-Encrypted: i=1; AFNElJ9z3IO0N0/+aeYlQdNMqvkTyi8JVxMKAXKWp2xi/jm3SJwNIxjPs1r0Y35QFkW6Lv1T+uGKMOo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyIxZAXhX0UXRT7tB0y3HOBlUVVNAerozWHVLv5cUgYaw/v1DSr
	HEZTV2OcLQsa38Z/oqoqTMBqU53N97alwRizmpkjVaE2pmrg26kYpMUie3LODUGyxxVYSmwbo5u
	+pU6RRAnWKO4tDPexNneXUHOTZP9kI88=
X-Gm-Gg: Acq92OEz5unS5yiUDAs8RFPdKgPcRpPCAblj6qK6R5/wTMvrKZgPEJg0WFbX1zq5zkk
	dDPn7uugEW1xk7gJJ7VGuBQjBGY0amL+WvGQ4+E4XVI1sc3f8kJgxI3mWgpaFujO85Qj5QpqSRE
	ooA78NX+8HVsaZqjekpyDjXZlIV2kdZ3NH6Hdv9rgqi0mzJj5+cmJCPlqV9RvNoGtSEY4x9dUF3
	1VgfSSu1hn3fChukQqKzijLyrlgp+8yBGsJQq4p/pi5lckeAQcDM4WEDKfD4wwEPcAz8mLVZSLL
	azS0dxo71jvPPANeCjsQlU2NCl7crh+BvCbo3iFScPB2vDoAoAYVqeO7VAsOF0G1gaYQSG5HzVp
	WTbEF73RabK6b/6Ec7O4n0gdALT0FfF3cCg==
X-Received: by 2002:a05:693c:2d83:b0:304:9b4b:3b9 with SMTP id
 5a478bee46e88-3073604172cmr664806eec.6.1780385546267; Tue, 02 Jun 2026
 00:32:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1780064327.git.d@ilvokhin.com> <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
In-Reply-To: <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 2 Jun 2026 09:32:12 +0200
X-Gm-Features: AVHnY4KFvdUeam43ra4W77gIMCiCUGgKOuyNNXapGiGfrnci6cK1Ym-kx5BR1ek
Message-ID: <CANiq72=vaiGXPwmdOuTHDp30Nm62UgjtL1STJx6aj=dDPWTQYA@mail.gmail.com>
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 2, 2026 at 9:13=E2=80=AFAM Dmitry Ilvokhin <d@ilvokhin.com> wro=
te:
>
> Miguel, I dropped your Acked-by due to the rename. Went with
> __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> spelling works for you.

I am fine with either, but thanks for the caution! :)

I assume `_args()` is meant as "the `nonnull` for the arguments, not
the return"?

Cheers,
Miguel
