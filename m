Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F743380FD9
	for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 18:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779128393; cv=pass; b=ft0bnFB5ZQXufCwTVPo2FmTwqtadGnjAs63Wa5w9iaymD4DZXCeyOeYMJZ9IdRgALI+ovNzJLunmOKExjUR4Z3LOUMiXSQxFpLcaRAW5RRGgDyMfUCCs6LH1j/pk1OkhoVwbPcgnPjK0XtNPRyRFAg2Q7NDDOgBNE5bD6igyXNU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779128393; c=relaxed/simple;
	bh=F4zS/KBb4XpvEIOmXDt30BC5Zw1vEhYKH/qiVB5Kyfk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=C+ahdvPj+VyglwORXtNi25T4qR1dqrjIIpqpc2Q05sHwqCd5cDc+F2sz4QvaO8DCCzc+bNlZRl9RGtg85rD/6W3HTk7/ONpR7WI8LZhHCc8R06x2zF6tCp5UZNxEKRAz3aXXne5UDrzg0OvIF/orbBpmiJScUsX8vEs3xsNQpE8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eOLsN1bu; arc=pass smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eOLsN1bu"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2f24905306dso201664eec.2
        for <nvdimm@lists.linux.dev>; Mon, 18 May 2026 11:19:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779128391; cv=none;
        d=google.com; s=arc-20240605;
        b=CzVC0CjatFr8UwdBU6qclc31NRWoAvxFTxl7LH6AiJq9bG55d1ogpFz7kO4AXVPhkL
         /T82662oyx/gx+vV80m9hm7U4MHXKRNtm1pCErT1yvOsJquKbPbMaMfbi5hjQDs8k3uj
         JVzCctghV+cNByWT0txV4KrxKBABW5lReUuPHfharqz1tuv93l1PHXo4vEEjxk7KzGqS
         5paqsgwCDIW75BBjvgrQ+WwNasZVkZ4CRpcLsdb4lbl+rUDt30A2Vf7pYwknfZRYyGq/
         FR2Sfe9VIYk4X/fF9hgBQaLWop783qEMkaxj0Jr4n3GzwS/eu2sbrnQDpX+hjgUVVWUz
         8EGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2fmv/Ht8Pb5ForKew/DCgFtt1pcAkrp0oUM4GYdjaDo=;
        fh=97U4d+TVHvefxPAeH5QJNpAFZB3RTo4+in1ndPArS3A=;
        b=EOo5sEgNzpL9NU2BgUelP1X/NkULD9kYSUL5ZfWhtpqjhhcTAAQA9P+F9Bi1Hs+tWH
         d7gXl6z/iIsiKHLcGxdhjA1Fx41TJNWGuPBPWnDPJFKNE/NaC3IbWX+rT8qxw8/ms/cs
         fOohOyZt6Tr5htvaHMx6mI4hSy8VDlRXtgJaiUQLtSE3aq7kjq4ALvoAd9hY2VijwVdy
         K1y+fXuYVQbWT8H94tJ55HlAlx+s7PB1srS8AXuAgdHEBQGTKOfp8XhiJNffcELk/fvt
         U3MovKzBkHjkMXNdFA1X2b69UclDtDn5dBdwdPKvg3f0kWMxw73+uR51mHudMqQWZjRy
         waDA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779128391; x=1779733191; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2fmv/Ht8Pb5ForKew/DCgFtt1pcAkrp0oUM4GYdjaDo=;
        b=eOLsN1buSglwPk5KoUOIfTHtSx4AsJT8XDKWiFCBlz31yFe9rGi85BtApvn+QyzLu3
         gCWNc5tNxAzGd0WeFD8UmFKjpa8arjCgnQA7YY8vfyDSlaAvJ48VxUeTDEJPOJvgntm1
         XOt/EPTTCkhg2hNb0AaZpNStcg1p9TceQhLgX7iBLkQCZcoxLz+USgOXcxdHC2yC3rp9
         PBUiQDIOMxFJOqx8p1BCO+ckVlmFR6xKm+qtmWJYib07CNq8Xd+VCxj5wMJkjhuvy+R4
         wAss5I2hcb0FonvSvdeaMNNrR0VW0Iynspd+lJ04CBPBLEuzIqqQn6v3919IizsQX7oL
         XezA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779128391; x=1779733191;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2fmv/Ht8Pb5ForKew/DCgFtt1pcAkrp0oUM4GYdjaDo=;
        b=ePN4nrVFnvK0+u3HrqeqGDLAnZuVKSk5dOskqWZSmHLlWJ0VQTp8L7tn3NZP7vLxeU
         ILlXyOnqvpPx2btQXNVNQWzt0CbJALD8WdD4+JFU2B2zPv144wJVBm7gE00ZZ4DHmJ6A
         3ByZgUKmH/XHhNHLcdo51mrwviNNcIM8Zs1QCEO+3I5xqRd08WLDX0HFfL5+IvJYGcy3
         3hiRxhVe9N/S7/6Ji0Ww8HAbLLvoEL/L55lc0kNsfSKE0JMW06YjlYWpLzehQIrykl5G
         cBto9oo9KSo2Jl7OZhH76Mt0EgsHg6fpm6vqrKjyoSqEz6Lbt2SZ8oKS14OjU+M+NxJE
         Foxw==
X-Forwarded-Encrypted: i=1; AFNElJ8mCN9+KCj9K6hca+M1kQniF50sf6pOd4xc/0+9z+X3s7HCPLcNeg3Hd55BtNAwMR/9fRXKZ2s=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYdOBrEQg+pDIHNZ3S6y1/wB65Q9bPawjyGNJPXlbyVBHwNx5j
	vxyZBAG4pXpZv29bK19s4jbU6rT3eImbyhI7z8K1gtKUSPF/rXnRrwBmdp1apLGQsTq2+nBM2pr
	0zunwbC1SKGYg2ipWIaN7PEVd2bg7AVc=
X-Gm-Gg: Acq92OHEaZJCThDZzYdI3prusbvR+64DYiks5TkC914e/BDZPnfqOSKLKASKTzR7uQa
	z4LcrS+t5/2Eq/o91JTty/5gnlxdKFlqalY5rE+bRMFwrEWox0Zb7z7dWccdHb6LElEKVBFY9IN
	nX7RN2LNPRfQ5KvlMbLINbShfvUkRNHkNnO/3W13tZWgox/FsxfheCeHYtamtYkdll8Bvya/UTM
	SNFXGe/f5aJPy8VyxparglfKBNM5sl4zj8pvdqlKTmR6vlN8sHnYCPiW46ewD/ak/oegMBpC7Ax
	O5f8ZyEyGyn1TAP4KWDZXpxwb1UlZ5HED/bRWyWCLRTo23FoouT6WP9gOri9xDW9vpj1AFEkxp+
	8ftpeFg0qs34Nf7oApqqy2rM=
X-Received: by 2002:a05:7301:290d:b0:2bd:d8e6:90a0 with SMTP id
 5a478bee46e88-303986d60f2mr3837379eec.3.1779128391385; Mon, 18 May 2026
 11:19:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <cover.1779116497.git.d@ilvokhin.com> <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
In-Reply-To: <1854fc006c03647a3201a442743a1c22b13b404d.1779116497.git.d@ilvokhin.com>
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Date: Mon, 18 May 2026 20:19:35 +0200
X-Gm-Features: AVHnY4KjxRD-ATRdhbSHbi3LsNcRUTOOYVd1vfhW3urYgmIkyWa8d6ZcWVPY-W4
Message-ID: <CANiq72mG-EpBWbW_hZYPgtV_R1vyUBsn0ytaz2X2Zw9fr0keOA@mail.gmail.com>
Subject: Re: [PATCH v3 3/4] cleanup: Annotate guard constructors with __nonnull()
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Miguel Ojeda <ojeda@kernel.org>, 
	Thomas Gleixner <tglx@kernel.org>, Christian Brauner <brauner@kernel.org>, Marco Elver <elver@google.com>, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 18, 2026 at 5:22=E2=80=AFPM Dmitry Ilvokhin <d@ilvokhin.com> wr=
ote:
>
> Add __nonnull() to unconditional guard constructors so the compiler
> verifies at each call site that NULL is never passed:

> This provides automated, compiler-enforced verification that no
> unconditional guard constructor receives NULL.

I wouldn't say "verify", since the compiler does a best-effort here
with the information it has statically.

In other words, the attribute does not prevent NULL pointers to be passed.

> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.=
html#index-nonnull-function-attribute

Hmm... It appears GCC has changed the docs in commit 6e3c137f5dbb
("doc: Merge function, variable, type, and statement attribute
sections [PR88472]"), dropping the per-kind attribute pages.

So the right link would need to be now:

  https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull

I will need to send a patch to fix the other links.

> + * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull

I think this link goes to `_Nonnull` -- the GNU one is instead:

  https://clang.llvm.org/docs/AttributeReference.html#id10

(I don't love the numeric IDs, though, since they break, so I think it
is fine either way -- the `_Nonnull` is fairly close to the one we
want and I hope that one doesn't break)

> + */
> +#define __nonnull(x...)                        __attribute__((__nonnull_=
_(x)))

This is indeed available for a long time, and we already use it
elsewhere in the kernel tree (which would be nice to clean up
separately).

If you don't mind, please place it before `__nonstring__` (the file is
meant to be sorted by the actual attribute name -- there are a few
instances where this is not the case anymore, which I will eventually
clean up)

Thanks!

Cheers,
Miguel
