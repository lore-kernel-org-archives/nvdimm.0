Return-Path: <SRS0=hiqq=AS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81F6EC433E0
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 16:56:11 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 5F6A12065D
	for <linux-nvdimm@archiver.kernel.org>; Tue,  7 Jul 2020 16:56:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5F6A12065D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=denx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 3764F1108E90C;
	Tue,  7 Jul 2020 09:56:11 -0700 (PDT)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=46.255.230.98; helo=jabberwock.ucw.cz; envelope-from=pavel@ucw.cz; receiver=<UNKNOWN> 
Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id EF5A51003FD6A
	for <linux-nvdimm@lists.01.org>; Tue,  7 Jul 2020 09:56:08 -0700 (PDT)
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 6075C1C0C0A; Tue,  7 Jul 2020 18:56:03 +0200 (CEST)
Date: Tue, 7 Jul 2020 18:56:02 +0200
From: Pavel Machek <pavel@denx.de>
To: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v2 11/12] PM, libnvdimm: Add 'mem-quiet' state and
 callback for firmware activation
Message-ID: <20200707165602.GB1947@amd>
References: <159408711335.2385045.2567600405906448375.stgit@dwillia2-desk3.amr.corp.intel.com>
 <159408717289.2385045.14094866475168644020.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
In-Reply-To: <159408717289.2385045.14094866475168644020.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Message-ID-Hash: DV23Z4TXIMMKSGVTZLLEQJEVKKVQPKHU
X-Message-ID-Hash: DV23Z4TXIMMKSGVTZLLEQJEVKKVQPKHU
X-MailFrom: pavel@ucw.cz
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-nvdimm@lists.01.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/DV23Z4TXIMMKSGVTZLLEQJEVKKVQPKHU/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============8645584421952982892=="


--===============8645584421952982892==
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Content-Disposition: inline


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> @@ -234,6 +234,7 @@ static const char * const pm_tests[__TEST_AFTER_LAST]=
 =3D {
>  	[TEST_PLATFORM] =3D "platform",
>  	[TEST_DEVICES] =3D "devices",
>  	[TEST_FREEZER] =3D "freezer",
> +	[TEST_MEM_QUIET] =3D "mem-quiet",
>  };
>

This adds field to sysfs interface, right? I guess we need
documentation for that....

Best regards,
									Pavel
								=09
--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAl8EqSIACgkQMOfwapXb+vLR9gCfa6KeYH8VY1zioulRsZBNW+Kg
s1wAnjRjjBnRWMzhG9K4RAp7LgAB86Hl
=mxU5
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--

--===============8645584421952982892==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============8645584421952982892==--
