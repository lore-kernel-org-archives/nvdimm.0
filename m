Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 228B641C319
	for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 17:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779818073; cv=pass; b=A11oeM1m7aRNB4KjQvyF0z9ojNpfDZAxAXc/Im+wrR0KEvS3ksPK/o/ksrXfDeIPfjcMGfZSpeE80mOoLAGwkbPuYvc4hqbiKmd/4kTr3YJV1vl/tTvGOHS/6GDKQjwPx7UuwSyxp+EgAe8s1QCz5g0tSmE1L4Ys8v3Ys+vqPu0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779818073; c=relaxed/simple;
	bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ryJn3/r7xmaGgGDtxJF58UoSKbV5PQdCnX45IiCcE3Nxgg2Rza/pPqEF9JRZH5fgD+9eCtiTemZXJy6qxck6shSg/1bGUKkq8UFKWpGpPkmZD4+YwGeNN5Y6qya7SVPojjQNHzGwy4eKcwk56kTslqcXhcyLTB7z78e6dVuaGXc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EDpxAHzl; arc=pass smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EDpxAHzl"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2f13ae64db1so779832eec.3
        for <nvdimm@lists.linux.dev>; Tue, 26 May 2026 10:54:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779818071; cv=none;
        d=google.com; s=arc-20240605;
        b=aLm8glHmDY9DEG/NNMRzV3CRhS7+t5m98hoTlmy3cMZig4r4EKfQcCJX6yEycZ4kOk
         b5LI7fHJyx8VEBAlwFJBkCucD9T9hj3QjRtmLVqNcoQIvbugkoUXo/e3UuPJ4ZD4foeI
         oD4AFd75bQz7VqAVLicx3bM8rGtHzWT4XgXtTWBOkFTPHEqctXSswjsEpqFXUfIoi1Wj
         glJrKmJl8KbsSPtF0oEJFADwMPbrXkjNgFElDEldBcvwoXDODoY+zs27qT9A9Aw6is00
         6slFpxVt7ofrrZDM5tA6tonkphJB1xLAnOyxSVa3ojMawk6bvP4YDppvxu26PO6Uq4xK
         xO6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
        fh=BGybpp3MUlhkt3Ll8MWMvqAEs84ZZzQbnwC+pxLqcmk=;
        b=O8k2H8BQY7/pOouyux8pi9OOiNdHNxkHDtg7MNKE8WKc0Pyz+yxQL4BRKYPYpvsgP9
         C5mB5k184oB0mOMker2hgYZyNAJE9UQ1DJSS0XmnEXx5eET8T6jz+9utUS8KasIJDuyI
         vynjRIgw6EFz803MRobtLswkP+/5kYf0AYt2I6Bpe0vOaylP23uFb8PUGQAav2CPd6eU
         u5CngVp4L2JaSDvBQC9tjEx1JL/rxyIcT6SCKFLNHD+HdtTkBXoJuQ5ldPqGn1sXJayY
         U8KWBNx2e7K60Oy4OJqKdj6yqo+V2mmRekRyFleMKaxJrVIsCnItmigaJLykfVdAYyUz
         4WJg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779818071; x=1780422871; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
        b=EDpxAHzl+pr94YdISM0TlMZJV48p7jJ0Alf5Ov3Y0U46+BW7JAIXz5nXxm4Esabiqz
         ThfY/ewdAYJjxCQLm4Y1g1y8byFK1RR7j2nu9qOSsfoFCPtMKctsvD3ZmjwtQ3ePqOi5
         pKDNLg43g73I/If64ylSYvWl2y5rh90kLudFyJVFm1g7AIJxi2b6Aa/3/yfi3ALWTdyt
         HBZgF746viL79WfAdbiGP2aSbEVwR0xgcrnRMu2XXhJX/6mjAKeleQ8n8QdZ0Rntx5aL
         AyNx7amf99/48OZCmXkLSGf+sc7Yq72a0C2aKRO6w43eE9OfxFB9m9IVdmoDReUuynRF
         b7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779818071; x=1780422871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=puC9SJLHTM2cpEQVaMH58VO+otGA57OyLdV5XOHij4E=;
        b=LmAI0TzODXPM75TqHB0bsekJsZUvUjCnx7MFzT6D9k82o++0cuEhjJgxRct4YmgFYn
         rbjfXHKA8HFueY5EUa6sf6mLSfsvl46xAtwkk6pSCOYw/vLIBNCIKTGpt/EvZUQ6xYd1
         rCEXx2THGg7izfFBHuHZnQmEd5riiip3wT1amHIp8EsuCdZKi93GfRJueHBgnmyeHa48
         i5r+fjBIqClcY5CmMTw4kA7943zR0OCMxE47fXJBUOsjtSFgUSgrIB1TuUeI+BZqICXv
         T0OnvpFqgayPo5yZWyGr11OnFPx2SqW7DOf7daPOzqj7WIAOLxhf9421SKUn56n8gHSM
         t8aA==
X-Forwarded-Encrypted: i=1; AFNElJ8p6yGCEjhAjVbsvYzbJKb77u6yAseTgI9PfzY3QpWK0GwMX9+aBre/rQdbusFGKWETH7y8UX8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzBxbjcILgnW/Zk2msvP/4V6DO460ODG2YooUiX9QqTP/wFYf8J
	IkRnWBHU7nxg/73+lBdKcspYiqZleh2HQIGFalDdljtd130evIRUb1Yk6QKw1C/RTfY2t4b+kvJ
	HRwN2hDMqRI79LleqH/4TrDtAQqO9FEo=
X-Gm-Gg: Acq92OEWL3nASOkcRwJMWDvzworF0Ofzow09KoVEh1fn/tZrfx2jUM9mXog6QZL4kMF
	MmDL0n0zOs3lVaiY5cTr/QBhQV5wUnog1gPdpBsyhwevowqagaW/2EO6Zv4DPHdzJtDzPQKHZNv
	4yUzFqBtxtz94bTWb3WACths8hz215X1EVkkSo7/2c/yJM1K8H2FVFuUq7KpwIXTkYIpr/9xwtp
	OiQsV5f+QVAA+4WrvrQDSyUPxKpvM6Jhm0hb9qLT7CPnydHkigame4smxMugXMorro4GhzT9vGj
	ZQc9OKMydpUSW4nKKNs2ondNRGNw3vl6WcA14YP7yHq5kSqAyBDRkrUDqwkc7HE8LTyn0A9JF/E
	apKZjtyjy6kULYZOEoMFZaCHCrcbYXDkZOQ==
X-Received: by 2002:a05:7301:2092:b0:304:4f23:4823 with SMTP id
 5a478bee46e88-3044f23c523mr2709812eec.7.1779818071249; Tue, 26 May 2026
 10:54:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1779286416.git.d@ilvokhin.com> <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
 <20260523084901.GF3102624@noisy.programming.kicks-ass.net> <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
In-Reply-To: <ahW4fyZ6j9YvJho9@shell.ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Tue, 26 May 2026 19:54:16 +0200
X-Gm-Features: AVHnY4K9vBisDpVZJMVTzCi8T3wy9swOj3IeT-5P4_v-UNE6ALKXLqpstbxL-rg
Message-ID: <CANiq72mZn7GZ6TbNoSuVUXsprJSrpPWA9oAcUQrYzzCj-dFnew@mail.gmail.com>
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with __nonnull()
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 26, 2026 at 5:13=E2=80=AFPM Dmitry Ilvokhin <d@ilvokhin.com> wr=
ote:
>
> They usually don't collide, except for User Mode Linux builds, which
> include both kernel and userspace headers.

:(

What about other similar names? i.e. a variation of your option 2,
e.g. just `nonnull` (we also have others like that, i.e. no
underscore, e.g. `noinline`), or `___nonnull` (triple underscore, but
may be confusing), or a suffix/prefix letter, e.g. `__knonnull` (for
kernel nonnull)...

i.e. it would be nice to have a "standard" spelling for ourselves, and
also replace the existing `__attribute__((nonnull))`s we have
elsewhere in the tree.

Cheers,
Miguel
