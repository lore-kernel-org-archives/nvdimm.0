Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A1446EF7C;
	Mon, 12 Oct 2026 09:16:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791796561; cv=none; b=B4HGvU4pw5LEJ9FbEyOcCzmOxYN0grfRq8/ID31pwTReCSS8nZx12LL0vt4nsqTLcsFLgbWsi3tLUPwTBKJTA+CVLB8VL6ltzJ7IXY/aePyJtCST8MXqdRAvUCWIUKQNfgeVezH8dI0rDK0DlSxmc/VkomQdiraEFUBukagM90o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791796561; c=relaxed/simple;
	bh=KLBlgaeDuHabe1zhJimoUA0bpK31OVHOkP7Odbueqqw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oe60CEOSN7ATLgs5h+gNQ+a49kfdPJFrJomKhmKhH7CC8RpTdi7RPZHZ3HvXxOPOR1QbJOn3IASChyUJ/drwsdqbSU1VArosS0E6ZbOmVKUr7LYa9RTcmq0hYaRKXpOm0XRCdxm21OATjTihzv0Eyg0V4nhnVvIjuzbHYaYAUK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EMB9HcnR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EMB9HcnR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 075251F0089B;
	Mon, 12 Oct 2026 09:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791796560;
	bh=I0HNRCS/h711M+WA/GHMYCEaRzzHTm0vVBiP9fZikGI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=EMB9HcnR2Vy1CAnUk7OHOf5GsCaVPZ7a6Bro4eKk5SUaBIH94yOCIIzkHLk/dn29g
	 kV8aB+iGe4QM9ZmQqytyp1noivDVB6UtVQb5bb2D2X08dewTXGvGNOyFzYt7aWPou9
	 sUgXqAh09Pcup1sCOdYqDR+BacTYknTjLFf6XdQkB+ifvAqaXyOnlrtogEEhpZ8brj
	 r7mW4WAB9D1fJ+rHQJcJhySpnlLAb1oYZJOVxiPuABLWHmaPPa61rJvRfygQG9hGJe
	 iDkCjJKuTlNSHA3hlUKE9BPI/4vLJ63BW6D8A+VpIZfP9YwnHLUUu8rgBLrGz7Ioz5
	 COyMaej6bm63A==
Date: Mon, 12 Oct 2026 11:15:39 +0200
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Bill Wendling <morbo@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Gow <david@davidgow.net>, Petr Mladek <pmladek@suse.com>, 
	Shuvam Pandey <shuvampandey1@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Jonathan Corbet <corbet@lwn.net>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jiri Kosina <jikos@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>, 
	Thorsten Blum <blum@kernel.org>, Alison Schofield <alison.schofield@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Guangshuo Li <lgs201920130244@gmail.com>, Ira Weiny <iweiny@kernel.org>, 
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Vishal Verma <vishal.l.verma@intel.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 05/11] seq_buf: Add seq_buf_strlen()
Message-ID: <asyalCF06dhpVxPc@debian>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
 <20261005112209.1e47fa-kees@kernel.org>
 <asOKvhT01aNb5-Dg@debian>
 <20261005155839.d5d200-kees@kernel.org>
 <asPSYn7sLqiH39Fu@debian>
 <20261012005620.466497-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="j57xlliim47wxj7u"
Content-Disposition: inline
In-Reply-To: <20261012005620.466497-kees@kernel.org>


--j57xlliim47wxj7u
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx+linux-hardening@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Alejandro Colomar <alx@kernel.org>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Bill Wendling <morbo@google.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Gow <david@davidgow.net>, Petr Mladek <pmladek@suse.com>, 
	Shuvam Pandey <shuvampandey1@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Jonathan Corbet <corbet@lwn.net>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	=?utf-8?Q?G=C3=BCnther?= Noack <gnoack@google.com>, =?utf-8?Q?Micka=C3=ABl_Sala=C3=BCn?= <mic@digikod.net>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jiri Kosina <jikos@kernel.org>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Eduard Zingerman <eddyz87@gmail.com>, Kumar Kartikeya Dwivedi <memxor@gmail.com>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	Emil Tsalapatis <emil@etsalapatis.com>, Ihor Solodrai <ihor.solodrai@linux.dev>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>, 
	Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, Shivaprasad G Bhat <sbhat@linux.ibm.com>, 
	Thorsten Blum <blum@kernel.org>, Alison Schofield <alison.schofield@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Guangshuo Li <lgs201920130244@gmail.com>, Ira Weiny <iweiny@kernel.org>, 
	Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Vishal Verma <vishal.l.verma@intel.com>, 
	Randy Dunlap <rdunlap@infradead.org>, Shuah Khan <skhan@linuxfoundation.org>, 
	linux-kernel@vger.kernel.org, bpf@vger.kernel.org, linux-security-module@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, nvdimm@lists.linux.dev, 
	linux-doc@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH v4 05/11] seq_buf: Add seq_buf_strlen()
Message-ID: <asyalCF06dhpVxPc@debian>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
 <20261005112209.1e47fa-kees@kernel.org>
 <asOKvhT01aNb5-Dg@debian>
 <20261005155839.d5d200-kees@kernel.org>
 <asPSYn7sLqiH39Fu@debian>
 <20261012005620.466497-kees@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261012005620.466497-kees@kernel.org>

Hi Kees,

> Date: 2026-10-11 17:56:27-0700
> From: Kees Cook <kees@kernel.org>
>
> On Mon, Oct 05, 2026 at 06:43:23PM +0200, Alejandro Colomar wrote:
> > > Yes, though not often: the sched_ext debug dump builds a nested per-C=
PU
> > > seq_buf from seq_buf_get_buf(), which returns a size of 0 once the du=
mp
> > > buffer has overflowed, and it handles that case on purpose (see the
> > > "$s may already have overflowed" comment in kernel/sched/ext/ext.c).
> >
> > Hmmmm, so IIUC, it is a sentinel value, and not really a buffer size?
>=20
> It's the real size of what's left. seq_buf_get_buf() hands out the
> unused tail of the seq_buf. Once that has overflowed there is no tail,
> so it returns NULL for the buffer and 0 for the size, and sched_ext
> initializes the nested seq_buf with both. So that case does get the NULL;
> the 0 is how much room it has.
>=20
> > Did you consider not holding the size of the buffer, but rather an end
> > pointer?  It also allows you to find how much you can write to the
> > buffer, but has slightly better semantics: the end doesn't change if you
> > advance the position.  'end' can only change through reallocations
> > (which I don't know if you do in the kernel).
>=20
> The size doesn't change either: it is set by seq_buf_init(), and writers
> advance "len", an offset from the start of the buffer. seq_buf never
> reallocates.

The size changes here:

	$ grepc -h -B8 seq_buf_get_buf include/
	/**
	 * seq_buf_get_buf - get buffer to write arbitrary data to
	 * @s: the seq_buf handle
	 * @bufp: the beginning of the buffer is stored here
	 *
	 * Returns: the number of bytes available in the buffer, or zero if
	 * there's no space.
	 */
	static inline size_t seq_buf_get_buf(struct seq_buf *s, char **bufp)
	{
		WARN_ON(s->len > s->size + 1);

		if (s->len < s->size) {
			*bufp =3D s->buffer + s->len;
			return s->size - s->len;
		}

		*bufp =3D NULL;
		return 0;
	}

With an end pointer, that would be simplified to:

	static inline size_t my_seq_buf_get_buf(struct seq_buf *s, char **bufp)
	{
		WARN_ON(s->p >=3D s->end);

		*bufp =3D s->p;
		if (s->p !=3D NULL)
			return s->end - s->p;
		return 0;
	}

Moreover, if we change the API of that function, we could entirely get
rid of this function.  Here's an example where I see seq_buf_get_buf()
used, where I've modified it to use pointers:

diff --git i/kernel/sched/ext/ext.c w/kernel/sched/ext/ext.c
index 3219f0da0fe4..82904e4456e3 100644
--- i/kernel/sched/ext/ext.c
+++ w/kernel/sched/ext/ext.c
@@ -6893,8 +6893,7 @@ static void scx_dump_cpu(struct scx_sched *sch, struc=
t seq_buf *s,
         * Use a nested seq_buf to generate the standard dump so that we
         * can decide whether to commit later.
         */
-       avail =3D seq_buf_get_buf(s, &buf);
-       seq_buf_init(&ns, buf, avail);
+       seq_buf_init(&ns, s->p, s->end);
=20
        dump_newline(&ns);
        scx_dump_line(&ns, "CPU %-4d: nr_run=3D%u flags=3D0x%x cpu_rel=3D%d=
 ops_qseq=3D%lu ksync=3D%lu",

Considering the .p would replace the current .len, and would encode
overflow as a NULL pointer, and .end would replace the current .size,
and wouldn't ever change (not even on overflow, sice that info would be
stored in .p).  Now you wouldn't need to test whether the remaining
size can be 0, but would instead test whether ->p is NULL (you could do
that internally if you want to avoid accessing internals).

> An end pointer wouldn't remove the empty case: buffer =3D=3D end is the s=
ame

The thing is that you'd never reach buffer=3D=3Dend.  If that would have to
happen, you'd instead store a NULL in buffer.  This has the nice
property that if you try to read it as a string, it will crash (instead
of giving you a pointer that is not a string, which could result in a
buffer overrun).

> condition as size =3D=3D 0, so the accessors would still need the check. =
It
> also makes overflow harder to record. seq_buf marks it with len =3D=3D si=
ze +
> 1, and the matching position pointer, end + 1, would be weird.

Not really.  I'll show an example without the structure; just using
plain string-copying functions, which shows it more obviously.  The
structures are, after all, just an encapsulation of this logic.

With sizes and lengths:

	char    buf[42];
	size_t  len, size;

	len =3D 0;
	for (int i =3D 0; i < 10; i++) {
		x =3D strscpy(buf + len, "foo", size - len);
		if (x < 0)
			goto fail;
		len +=3D x;
	}
vs
	char  buf[42];
	char  *p, *end;

	p =3D buf;
	e =3D ARRAY_END(buf);
	for (int i =3D 0; i < 10; i++)
		p =3D stpecpy(p, end, "foo");
	if (p =3D=3D NULL)
		goto fail;

Let's say that each iteration of the loop is a step where we'd inherit
an old buffer into a new one with the functions showed above.  With a
length and a size, you need to update the size.  With a position pointer
and an end pointer, you only need to update the position pointer, and it
encodes the information about the overflow/truncation too.  Because
truncation is encoded as an invalid position (NULL), we can never
recover from that, and thus we don't need to have so many checks in each
iteration.

An important detail is that the functions that use such a position
pointer should check whether the position is NULL, and do nothing.
In this example, stpecpy() has such an early check:

	char *
	stpecpy(char *dst, const char *end, const char *restrict src)
	{
		ssize_t  dlen;

		if (dst =3D=3D NULL)
			return NULL;

		dlen =3D strscpy(dst, src, end - dst);
		if (dlen < 0)
			return NULL;

		return dst + dlen;
	}

As you can see, we can never reach a point where p=3D=3Dend, because once
truncation happens, p becomes NULL and never recovers from that.  This
simplifies greatly the handling of truncation.

> Changing the representation would also means changes outside
> lib/seq_buf.c, since tracing reads seq.len and seq.size directly
> (trace_seq treats a zero size as "not yet initialized", for one). I'm
> not saying that's a good thing to bypass the API, but rather that such
> a change should be its own series.

Agree.  I was just mentioning as an idea to keep for the long term.


Have a lovely day!
Alex

>=20
> -Kees
>=20
> --=20
> Kees Cook

--=20
<https://www.alejandro-colomar.es>

--j57xlliim47wxj7u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrMpTUACgkQ64mZXMKQ
wqmKKQ/+IUju4v7dG+hkUEBJrKJ5n4nq9IotpO+uHWDqtRhvFizqNIkQyTz4OEtR
YgKwo2cKL6kofiJKTMGBBldjXFFiCg7b+7kUg6wAV9E+86Ot801bmAh/OV4B2rEN
px81p+fJHLcVo3zqLs4M1PHaMP360L55Qv6YKJT7ZOpcheH/J0Z5AdDV0lxSamn+
NIXLfOTeDyo/Xs3BKslEKlSj3mzn9/mWAeKhr77fwDeRMD5w63mw3GZp/ai6QQMY
dwwo2ZOuFrfGZfnkqhbKxt0IyHPx2Vh5o6bxDWBFT9XYR0V/ENLJOxG9PvvtinZ5
EOt+S2erq7A9ShZchVCDsrHrx+CskREubVno6D3cLh3sGfQp6dP+f8j7VG1pInsK
D12+Fjibzz8JSNVNKlvkXTj9WufaoQX5Jqy5HU/ly1C64yFa0Cijq0jm2JlVyTB1
/jyYXfCDECCcyzTMygd9rEFwoAm9f2wO4cN4KZNWflAOfJudJ+Qbkt7Q77YYaxfo
d9+FUb5tqbWCzeuGTfTgL/ALDBbXJpremH0jWr3F18SEsYUWCbZYEgzl/KWG0NSD
gcJhuZHt4/9ZrXBmSqmI5ud/iPJ/JQ8l3vqeLNt+XZgG3E5H3AN9N1aE4ATAZ5kI
5bpoml/6Uim7ljbxOPFn7JLwYh+UPaCQ3zlZvA1wE/uBnkNr8Q0=
=dcL8
-----END PGP SIGNATURE-----

--j57xlliim47wxj7u--
