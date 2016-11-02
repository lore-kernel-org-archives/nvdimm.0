From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH v2 34/37] docs: fix locations of several documents that
	got moved
Date: Wed, 2 Nov 2016 10:31:54 +0100
Message-ID: <20161102093154.GC23350@amd>
References: <cover.1476801354.git.mchehab@s-opensource.com>
	<28c1f5d3867174a7017e3f3d9e9e4ebb096ceed8.1476801354.git.mchehab@s-opensource.com>
	<20161019103442.GD1461@amd> <20161019115918.1162d16e@vento.lan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============7680369000982517778=="
Return-path: <virtualization-bounces@lists.linux-foundation.org>
In-Reply-To: <20161019115918.1162d16e@vento.lan>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/virtualization/>
List-Post: <mailto:virtualization@lists.linux-foundation.org>
List-Help: <mailto:virtualization-request@lists.linux-foundation.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/virtualization>,
	<mailto:virtualization-request@lists.linux-foundation.org?subject=subscribe>
Sender: virtualization-bounces@lists.linux-foundation.org
Errors-To: virtualization-bounces@lists.linux-foundation.org
To: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Jaroslav Kysela <perex@perex.cz>, Chris Metcalf <cmetcalf@ezchip.com>, Peter Loeffler <peter.loeffler@guruz.at>, Finn Thain <fthain@telegraphics.com.au>, Yaowei Bai <baiyaowei@cmss.chinamobile.com>, Jakub Wilk <jwilk@jwilk.net>, linux-acpi@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Guenter Roeck <linux@roeck-us.net>, Petr Mladek <pmladek@suse.com>, Jean Delvare <jdelvare@suse.com>, linux-pm@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Karsten Keil <isdn@linux-pingi.de>, Jiri Kosina <jkosina@suse.cz>, "seokhoon.yoon" <iamyooon@gmail.com>, Li Zefan <lizefan@huawei.com>, Ryan Swan <ryan@ryanswan.com>, Joe Perches <joe@perches.com>, Andrew Morton <akpm@linux-foundation.org>, Mark
List-Id: linux-nvdimm@lists.01.org


--===============7680369000982517778==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+nBD6E3TurpgldQp"
Content-Disposition: inline


--+nBD6E3TurpgldQp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> > Dunno, but kernel-parameters.txt was already quite long... for a file
> > that is referenced quite often. Adding admin-guide/ into the path does
> > not really help.
>=20
> The big string name starts with Documentation/ :) There are some discussi=
ons=20
> about changing it to doc/ (or docs/). Also, as you said, kernel-parameters
> is already a big name. Perhaps we could use, instead,
> > "kernel-parms".

cmdline?

> If we rename kernel-parameters.rst to kernel-parms.rst, plus the doc/ ren=
ame,
> then the string size will actually reduce:
>=20
> -		(see Documentation/kernel-parameters.txt), the minimum possible
> +		(see doc/admin-guide/kernel-parms.rst), the minimum possible
>=20
> > Maybe admin-guide should go directly into Documentation/ , as that's
> > what our users are interested in?
>=20
> There are several problems if we keep them at Documentation/ dir:
>=20
> - We'll end by mixing documents already converted to ReST with documents
>   not converted yet;
>=20
> - A rename is needed anyway, as Sphinx only accepts ReST files that end
>   with the extension(s) defined at Documentation/conf.py (currently,
>   .rst);
>=20
> - A partial documentation build is made by sub-directory. If we put
>   files under /Documentation, there's no way to build just one
>   book.

Well, documentation is primarily for users. I'm sure tools can adapt...

> > Plus, I'm not sure how many developers will figure out that process/
> > is what describes kernel patch submission process. We have processes
> > in the kernel, after all...
>=20
> Do you have a better idea?

development/ ?

Best regards,
									Pavel
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--+nBD6E3TurpgldQp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgZsooACgkQMOfwapXb+vKDEwCdEmlwjrrTY1HV6PoP/Pyie4I+
oBMAnjN0WHtyXtQBydl/7WLL5tES6tZi
=EDvv
-----END PGP SIGNATURE-----

--+nBD6E3TurpgldQp--

--===============7680369000982517778==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Virtualization mailing list
Virtualization@lists.linux-foundation.org
https://lists.linuxfoundation.org/mailman/listinfo/virtualization
--===============7680369000982517778==--
