From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 08/16] IB/ucm: utilize new cdev_device_add
 helper function
Date: Mon, 6 Mar 2017 09:24:54 +0200
Message-ID: <20170306072454.GO14379@mtr-leonro.local>
References: <1488783873-2614-1-git-send-email-logang@deltatee.com>
 <1488783873-2614-9-git-send-email-logang@deltatee.com>
Reply-To: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zl+NncWK+U5aSfTo"
Return-path: <rtc-linux+bncBAABBOE56TCQKGQEPPB42OY-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
Sender: rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Content-Disposition: inline
In-Reply-To: <1488783873-2614-9-git-send-email-logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
List-Post: <https://groups.google.com/group/rtc-linux/post>, <mailto:rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Help: <https://groups.google.com/support/>, <mailto:rtc-linux+help-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Archive: <https://groups.google.com/group/rtc-linux
List-Subscribe: <https://groups.google.com/group/rtc-linux/subscribe>, <mailto:rtc-linux+subscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>
List-Unsubscribe: <mailto:googlegroups-manage+712029733259+unsubscribe-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>,
 <https://groups.google.com/group/rtc-linux/subscribe>
To: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Johannes Thumshirn <jthumshirn-l3A5Bk7waGM@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Sajjan Vikas C <vikas.cha.sajjan-ZPxbGqLxI0U@public.gmane.org>, Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Olof Johansson <olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter
List-Id: linux-nvdimm@lists.01.org


--Zl+NncWK+U5aSfTo
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline

On Mon, Mar 06, 2017 at 12:04:24AM -0700, Logan Gunthorpe wrote:
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>
> The use after free is not triggerable here because the cdev holds
> the module lock and the only device_unregister is only triggered by
> module unload, however make the change for consistency.
>
> To make this work the cdev_del needs to move out of the struct device
> release function.
>
> This cleans up the error path significantly and thus also fixes a minor
> bug where the devnum would not be released if cdev_add failed.
>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> Reviewed-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> ---

Thanks,
Reviewed-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

-- 
You received this message because you are subscribed to "rtc-linux".
Membership options at http://groups.google.com/group/rtc-linux .
Please read http://groups.google.com/group/rtc-linux/web/checklist
before submitting a driver.
--- 
You received this message because you are subscribed to the Google Groups "rtc-linux" group.
To unsubscribe from this group and stop receiving emails from it, send an email to rtc-linux+unsubscribe-/JYPxA39Uh5TLH3MbocFF+G/Ez6ZCGd0@public.gmane.org
For more options, visit https://groups.google.com/d/optout.

--Zl+NncWK+U5aSfTo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAli9DsUACgkQ5GN7iDZy
WKfeDA/+LWy91DyEkMjdR+KX3aTKX/G4GD0Db7Md9hfiApMfYgs799aMb8HDklRv
63PSzGFLFG8xxUDl10DgzDj9xK2+6e7m4X9E6G6fISQlQuRhuKmKk4YO0Dtl0H+Z
Mh7jEAWxQkwwyl1DM2R9BA5ObKDC0LENpGYfFnWZRYCQaQt5GE+bulio8YLprVTM
qb30tmhpUVRTcAvLfJsvGo7V6qO7GZGi2WlaXiCjBuZFcv5yXUND1z2LeTSZAkrn
hmqZslp/akY0zbqoo98/W3tBa3qtKC2TrYQtqWZOyD7VlrcZ/5HL4kGg+hF1tKEJ
6i8UXtRGL7/IiXDN+C1GEq1IApRSG/2lxbrNWNlCJrYPGfH3jgMSSkGbqesLtazR
d3cjUTVRAHtyMcCn2jhlBx7d36Lz86X3+7U8j8k/pQ7txOPFb4U/f1PK2WStf/Kt
2MtsHSQwUddwPlngEAfiUMz1TyUUnYdunoN7kEMx78QOTh7lJs80GRpWkuyadS+p
U275++T5UELgev2l6GLEqNbaAsaS94ES2BRMS5zxZEV+XOTQraqkv/Xir1Cp+LB9
Q6nqcjVFyH2xyywBm5mOfQZzbWStqiOLWvT6SrDKkYtYAJD0yXgHsaNrLo2e67sL
5BFyBpa5YoCqAelTgeVLFx+xFLyH3wYC+qChrDNbrwOE+8Fm7vY=
=O0p7
-----END PGP SIGNATURE-----

--Zl+NncWK+U5aSfTo--
