Return-Path: <linux-fsdevel-owner@vger.kernel.org>
Date: Sun, 22 Apr 2018 10:05:15 +0200
From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC v2 01/83] Introduction and documentation of NOVA filesystem.
Message-ID: <20180422080515.GB17875@amd>
References: <1520705944-6723-1-git-send-email-jix024@eng.ucsd.edu>
 <1520705944-6723-2-git-send-email-jix024@eng.ucsd.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="98e8jtXdkpgskNou"
Content-Disposition: inline
In-Reply-To: <1520705944-6723-2-git-send-email-jix024@eng.ucsd.edu>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Andiry Xu <jix024@eng.ucsd.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, dan.j.williams@intel.com, andy.rudoff@intel.com, coughlan@redhat.com, swanson@cs.ucsd.edu, david@fromorbit.com, jack@suse.com, swhiteho@redhat.com, miklos@szeredi.hu, andiry.xu@gmail.com, Andiry Xu <jix024@cs.ucsd.edu>
List-ID: <linux-nvdimm@lists.01.org>


--98e8jtXdkpgskNou
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> +The above commands create a NOVA instance on `/dev/pmem0` and mounts it =
on
> +`/mnt/nova`.
> +
> +NOVA support several module command line options:
> +
> + * measure_timing: Measure the timing of file system operations for prof=
iling (default: 0)
> +
> + * inplace_data_updates:  Update data in place rather than with COW (def=
ault: 0)
> +
> +To recover an existing NOVA instance, mount NOVA without the init option=
, for example:
> +
> +# mount -t NOVA /dev/pmem0 /mnt/nova

You may want to limit documentation lines to 80 columns...

									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--98e8jtXdkpgskNou
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlrcQjsACgkQMOfwapXb+vIPyACghxTE8nBbLqj/n7JzTASwnwYt
2jcAoJgsxJ2NZWMqnWdeE0YMhTon8mwu
=73Af
-----END PGP SIGNATURE-----

--98e8jtXdkpgskNou--
