From: Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>
Subject: Re: [PATCH v2 34/37] docs: fix locations of several
 documents that got moved
Date: Wed, 19 Oct 2016 12:34:42 +0200
Message-ID: <20161019103442.GD1461@amd>
References: <cover.1476801354.git.mchehab@s-opensource.com>
 <28c1f5d3867174a7017e3f3d9e9e4ebb096ceed8.1476801354.git.mchehab@s-opensource.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Km1U/tdNT/EmXiR1"
Return-path: <rtc-linux+bncBDZKLXNI4ACBBRMYTXAAKGQEFPMOMMA-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <28c1f5d3867174a7017e3f3d9e9e4ebb096ceed8.1476801354.git.mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Mauro Carvalho Chehab <mchehab-JsYNTwtnfakRB7SZvlqPiA@public.gmane.org>
Cc: Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Jean Delvare <jdelvare-IBi9RG/b67k@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Karsten Keil <isdn-iHCpqvpFUx0uJkBD2foKsQ@public.gmane.org>, Mauro Carvalho Chehab <mchehab-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steffen Klassert <klassert-H0bhvm5RIPI+B2oLq8eQJv4efur1V5z/s0AfqQuZ5sE@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Johannes Berg <johannes-cdvu00un1VgdHxzADdlk8Q@public.gmane.org>, Jaroslav Kysela <perex-/Fr2/VpizcU@public.gmane.org>, Takashi Iwai <tiwai-IBi9RG/b67k@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Wim Van Sebroeck <wim@>
List-Id: linux-nvdimm@lists.01.org


--Km1U/tdNT/EmXiR1
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

Hi!


> --- a/Documentation/ABI/testing/sysfs-kernel-slab
> +++ b/Documentation/ABI/testing/sysfs-kernel-slab
> @@ -347,7 +347,7 @@ Description:
>  		because of fragmentation, SLUB will retry with the minimum order
>  		possible depending on its characteristics.
>  		When debug_guardpage_minorder=N (N > 0) parameter is specified
> -		(see Documentation/kernel-parameters.txt), the minimum possible
> +		(see Documentation/admin-guide/kernel-parameters.rst), the minimum possible
>  		order is used and this sysfs entry can not be used to change
>  		the order at run time.

Dunno, but kernel-parameters.txt was already quite long... for a file
that is referenced quite often. Adding admin-guide/ into the path does
not really help.

Maybe admin-guide should go directly into Documentation/ , as that's
what our users are interested in?

Plus, I'm not sure how many developers will figure out that process/
is what describes kernel patch submission process. We have processes
in the kernel, after all...

Could we leave symlinks in place? People say "please follow
CodingStyle" when reviewing patches. Saying "please follow
process/conding-style.rst" ... somehow I don't think that's going to
happen.

Best regards,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

-- 
You received this message because you are subscribed to "rtc-linux".
Membership options at http://groups.google.com/group/rtc-linux .
Please read http://groups.google.com/group/rtc-linux/web/checklist
before submitting a driver.
--- 
You received this message because you are subscribed to the Google Groups "rtc-linux" group.
To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

--Km1U/tdNT/EmXiR1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlgHTEIACgkQMOfwapXb+vIOHQCffkWad/67/hPT1um2PTOxE/VH
cGcAn2DSAakkiqxfcuv58QhQpk7mN3cQ
=PJG5
-----END PGP SIGNATURE-----

--Km1U/tdNT/EmXiR1--
