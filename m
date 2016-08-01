Return-Path: <linux-fsdevel-owner@vger.kernel.org>
From: Keith Packard <keithp@keithp.com>
Subject: Re: Subtle races between DAX mmap fault and write path
In-Reply-To: <20160801014645.GI16044@dastard>
References: <20160727120745.GI6860@quack2.suse.cz> <20160727211039.GA20278@linux.intel.com> <20160727221949.GU16044@dastard> <20160728081033.GC4094@quack2.suse.cz> <20160729022152.GZ16044@dastard> <CAPcyv4gOcDGzikJHYGxNXtYqQKkPUgkG+z4ASxogQUnp1zmD2g@mail.gmail.com> <20160730001249.GE16044@dastard> <CAPcyv4gLTkx4ne7pWuMSqfFpLoOBx=TowvcWXw9UGUxn=jd-Tg@mail.gmail.com> <20160801014645.GI16044@dastard>
Date: Sun, 31 Jul 2016 20:13:23 -0700
Message-ID: <86k2g15gh8.fsf@hiro.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-fsdevel-owner@vger.kernel.org
To: Dave Chinner <david@fromorbit.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Jan Kara <jack@suse.cz>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, XFS Developers <xfs@oss.sgi.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-ext4 <linux-ext4@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Dave Chinner <david@fromorbit.com> writes:

> So we'd see that from the point of view of a torn single sector
> write. Ok, so we better limit DAX to CRC enabled filesystems to
> ensure these sorts of events are always caught by the filesystem.

Which is the same lack of guarantee that we already get on rotating
media. Flash media seems to work harder to provide sector atomicity; I
guess that's a feature?

The alternative is to hide metadata behind a translation layer, and
while that can be done for lame file systems, I'd like to see the raw
hardware capabilities exposed and then make free software that
constructs a reliable system on top of that.

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUBV56+VNsiGmkAAAARAQhpyQ/9HRHbTruM/IlU4qAsCUYnMtOVj6TrHBFj
hSLmYzGF0grZqzxiVMpwlS9SlfC0kj4nK8VPt0Zw7zXUji89CrzMBCf3mD/i0hyh
lNOmKgaLOnV9Zm6MJH2PXsqEmJLHrcfyKF7OxucGmk4f0ofqlSh+TaGlXl82Yp0b
3SHg5G0/zewGUWjS46LmPdhhQhyot1IDi4i/KLMUynd6mkTubLCl7rx1NG98meiz
/+dcayUuZXZpTrnvZ081xPJhedCapcGbxPc5FtMJy0lsaQxTAUqhTO+5GM/CY+mI
NuD4UUBhCjo9kR1P9e25Z1BUMnNubIC6zToY6OqYpuWY/9j99nO/XKiJ6szaa/Kf
MvUkXEeCU4RapjBqxUHYOugmWjyrsW3NXdlh/NestCq/DROF3GnDn9rtL+9AGnKJ
oCaHxgeeqqyZ09jZ+NewkgpwRu+WMsxx5eITVQ/hD5CvXU2mfUb6C2K7G7dS/X3R
HzXZk6SXz0NwrmN8SPaExVIybg5su6FzxKyvgVaBKnjXYluhm39O4Z7aQIB4pVyA
cE1AGvYJiiEF1M5UJbf7qT19MXiAA3fYQ9U4ba5m9W5kyuCJGEY8DOVGkNtsV30q
7vqFCo5San6Xz8bzPmi8C/9Hucd2ZKRf+EpBm/mH3TBazryzi3fqCbUhTkTHdq1F
KXOEb/PQztQ=
=em4e
-----END PGP SIGNATURE-----
--=-=-=--
