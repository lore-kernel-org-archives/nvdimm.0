Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 632DF490BF8;
	Mon,  5 Oct 2026 16:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791218626; cv=none; b=Nfz+paCrihJEb7GcIp+NYqQizXRav6FHWQfATeq4fb9NrJ8TnwQgZ4YvjmFZczgVuYF2tEqmOuTVKZzslj7YnevFd5n75KlZ6aInJpag/VVZzTF/5w+jHHPdmel3jOfjjmCkC4qoBm4EtU8HmcrWXTiJtETVhTeeFAUhqfbSzj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791218626; c=relaxed/simple;
	bh=QsLXyk1HZimlxMVEUGRz2zKlgMRWwGDVBqX28wTcnLA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q9N5JBzGwHUqP8Z/s78LxSoXBOuGOFN8R+nFu+SeFuNVNhl08mWU5+wZcIrEp/kd2EXeBLnfpKsGkB65/h3YDD3soUM5uYT8eBQgKkJEB1AbGwIvD5sP8423aLBVABX8qCgo2aBNzbUTAt7cqsRxsA+xDQcca+yDj3dJ1JVSaCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S8wsvnK1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S8wsvnK1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D49C1F000FF;
	Mon,  5 Oct 2026 16:43:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791218625;
	bh=X0AfyKVoCvIdgwkopveGc4Ekelt3ZdLYde10lxY31zU=;
	h=Date:From:To:List-Id:Cc:Subject:References:In-Reply-To;
	b=S8wsvnK1+a/xOmsDZn0LZvJlD3Bnq9DMJ3UsDAxcD9q3HXZkvhSb++WuKxwOAqzAu
	 hrbaDWQ2TKQeK5qAuU/GCEggF3bRaVsp4sqaGr+++rvPx/+wZ0Z2Q7GaXwDA/NY9v8
	 VKEEIXVnHH73b5warExc4DQfE3COvzbPuwvkwFys7kUtJwKL0pdKUAMEkKYt/ggiMA
	 h8T9M/F4zTywTKPBe9aTCkC/zOvbNC9Rmiv2B7nN0szPOFCqp8uBXlMMfr5Mzw8t4H
	 T3Dr+dtv+eAXxa9TkgXFVj7JR6K5twCoezU1EbX/6Y/45ZD9v8GfwTf7iOdVr9eYpV
	 ZRjdfRd3HaIYA==
Date: Mon, 5 Oct 2026 18:43:23 +0200
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Alejandro Colomar <alx+linux-hardening@kernel.org>, 
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
Message-ID: <asPSYn7sLqiH39Fu@debian>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
 <20261005112209.1e47fa-kees@kernel.org>
 <asOKvhT01aNb5-Dg@debian>
 <20261005155839.d5d200-kees@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mag73kyr3lvmhsn3"
Content-Disposition: inline
In-Reply-To: <20261005155839.d5d200-kees@kernel.org>


--mag73kyr3lvmhsn3
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
From: Alejandro Colomar <alx@kernel.org>
To: Kees Cook <kees@kernel.org>
List-Id: <linux-hardening.lore.kernel.org>
Cc: Alejandro Colomar <alx+linux-hardening@kernel.org>, 
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
Message-ID: <asPSYn7sLqiH39Fu@debian>
References: <20261003035906.too.263-kees@kernel.org>
 <20261003035921.1918874-5-kees@kernel.org>
 <asEhEe0Urb5Wx7yi@ashevche-desk.local>
 <202610040023.A3865A6@keescook>
 <asIPlnb0noMd33rr@ashevche-desk.local>
 <20261005112209.1e47fa-kees@kernel.org>
 <asOKvhT01aNb5-Dg@debian>
 <20261005155839.d5d200-kees@kernel.org>
MIME-Version: 1.0
In-Reply-To: <20261005155839.d5d200-kees@kernel.org>

Hi Kees,

> Date: 2026-10-05 08:58:45-0700
> From: Kees Cook <kees@kernel.org>
>
> On Mon, Oct 05, 2026 at 01:34:10PM +0200, Alejandro Colomar wrote:
> > > Yeah, reasonable. :) For v5 I've added this to seq_buf_str()'s kernel=
-doc:
> > >
> > >  * A zero-sized seq_buf has nowhere to put a NUL, so the empty string
> > >  * is returned instead of writing to @s->buffer. Any other seq_buf
> > >  * returns @s->buffer, even when it holds an empty string, so callers
> > >  * always get their own buffer back.
> >
> > Are such buffers actually used on purpose anywhere?  Why not keep the
> > WARN_ON?
>=20
> Yes, though not often: the sched_ext debug dump builds a nested per-CPU
> seq_buf from seq_buf_get_buf(), which returns a size of 0 once the dump
> buffer has overflowed, and it handles that case on purpose (see the
> "$s may already have overflowed" comment in kernel/sched/ext/ext.c).

Hmmmm, so IIUC, it is a sentinel value, and not really a buffer size?

Did you consider not holding the size of the buffer, but rather an end
pointer?  It also allows you to find how much you can write to the
buffer, but has slightly better semantics: the end doesn't change if you
advance the position.  'end' can only change through reallocations
(which I don't know if you do in the kernel).

It's fundamentally the same issue as was discussed with ARRAY_END() vs
ARRAY_SIZE(), where ARRAY_END() is more robust.  Also, using NULL as a
sentinel value is more readable; otherwise, you wonder why a buffer can
have 0 bytes.

I think it'd simplify the implementation of the buffer.

> Greg asked about the WARN_ON() in v2[1]: a size that comes from a device
> or from userspace would have to be checked before every seq_buf_init(),
> or it becomes a crash under panic_on_warn, and an empty buffer can just
> hold the empty string. So the accessors do that instead.

Makes sense.  Thanks for clarifying!


Have a lovely night!
Alex

>=20
> [1] https://lore.kernel.org/all/2026091953-cherub-empty-ef35@gregkh/
>=20
> -Kees
>=20
> --=20
> Kees Cook

--=20
<https://www.alejandro-colomar.es>

--mag73kyr3lvmhsn3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEES7Jt9u9GbmlWADAi64mZXMKQwqkFAmrD06QACgkQ64mZXMKQ
wqnpdQ//euFjtt+8eCfTbdx8D9yFA98qRQtBNJRMJkzbjRc1WHzJSyAenzDDHRW7
1nfO+8fVD+sABW5saDwArxt4Tve6VP/xyI4ifVoNW5aAqsHaw9ShgZYIIp8xpUUU
ACpzeCs1nelWY7X5eQegvND9U2tpW9XQ9BJ5bL/rMCPzqICH4Yk4cUkkqsUcPho4
DYITM73/V/Rh/KZNKJm0FJwegjDCLP0G3WkI9pp/FYX0yYFt9zutVQfQdoLLCJv+
bbA0W9u9U/bTr9yARxP6+KjjwpRXH7b4m/98g6tXng6OJ4exZXNo1XP4e2eQHqXz
1qqjE+X4g1mDXgmD78QMUGUM9vKVzbIjFevvAXtum+qr6Nj01OExY1gOUW27QbDX
Umt1EH/Dl5g8qwCMLuARH1jqVzUOORtqc1h408A2HIKjHqHBql4fGelGi/h5pJhO
CbSDEaxxr6F1s4KmSWiDAZkSFTn0lLrAW4+5g8scddimgKmo2H2gvyYqAW7nX9Fu
g6mO0PzwjtfvQf7mKhBvsjLdkkDH/V33KN23BoM89Sj/u6nONtESiARI7XMlcg8e
jnRRASeSXKkver8374YJ0LKv/YW0zKJUJF+W42h9PmmmYumgRWDjzPZmuwCJjn+t
0cN5QFNWVSt8LYxmBbHzPJ7q2J/bW11IibMUg7d9+0eo2N5tw8E=
=gQBr
-----END PGP SIGNATURE-----

--mag73kyr3lvmhsn3--
