Return-Path: <SRS0=xhOP=43=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B99DEC10F27
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 10:53:29 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 8C63F222D9
	for <linux-nvdimm@archiver.kernel.org>; Tue, 10 Mar 2020 10:53:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZDGo9HJX"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C63F222D9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 884F810FC3604;
	Tue, 10 Mar 2020 03:54:20 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=207.211.31.81; helo=us-smtp-delivery-1.mimecast.com; envelope-from=stefanha@redhat.com; receiver=<UNKNOWN> 
Received: from us-smtp-delivery-1.mimecast.com (us-smtp-2.mimecast.com [207.211.31.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 1C3D310FC3602
	for <linux-nvdimm@lists.01.org>; Tue, 10 Mar 2020 03:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1583837605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QcfSUQMFok+AcNi7dQXtsoDmhCrnzMZSnlpXGMmh0d0=;
	b=ZDGo9HJXLrmQCoCK34ct3nDHyNe+KTHNZROju6byjBzOb80RIIsSYqSsF2eS3efwUbH8aZ
	/dhxSWGQGISn5mAkJR2QvAb8PjzaHSJOm+H0dVKIc3kkmlbEX7x9IG7Cgj9C03NEmZwzlq
	4bBOcaxbSy/BbNDDg8shMqJ3MDgoVbc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-8uj9hiuuPPGN9Y84CP11UA-1; Tue, 10 Mar 2020 06:53:23 -0400
X-MC-Unique: 8uj9hiuuPPGN9Y84CP11UA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 750F518FE860;
	Tue, 10 Mar 2020 10:53:21 +0000 (UTC)
Received: from localhost (unknown [10.36.118.73])
	by smtp.corp.redhat.com (Postfix) with ESMTP id DA367909E9;
	Tue, 10 Mar 2020 10:53:15 +0000 (UTC)
Date: Tue, 10 Mar 2020 10:53:14 +0000
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 03/20] virtio: Add get_shm_region method
Message-ID: <20200310105314.GH140737@stefanha-x1.localdomain>
References: <20200304165845.3081-1-vgoyal@redhat.com>
 <20200304165845.3081-4-vgoyal@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200304165845.3081-4-vgoyal@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Message-ID-Hash: NSGQJYVC4MPXOYLRRJ4ERSKD3DSKEYJP
X-Message-ID-Hash: NSGQJYVC4MPXOYLRRJ4ERSKD3DSKEYJP
X-MailFrom: stefanha@redhat.com
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org, virtio-fs@redhat.com, miklos@szeredi.hu, dgilbert@redhat.com, mst@redhat.com, Sebastien Boeuf <sebastien.boeuf@intel.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/NSGQJYVC4MPXOYLRRJ4ERSKD3DSKEYJP/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: multipart/mixed; boundary="===============8833101922474006869=="

--===============8833101922474006869==
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="poemUeGtc2GQvHuH"
Content-Disposition: inline

--poemUeGtc2GQvHuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 04, 2020 at 11:58:28AM -0500, Vivek Goyal wrote:
> From: Sebastien Boeuf <sebastien.boeuf@intel.com>
>=20
> Virtio defines 'shared memory regions' that provide a continuously
> shared region between the host and guest.
>=20
> Provide a method to find a particular region on a device.
>=20
> Signed-off-by: Sebastien Boeuf <sebastien.boeuf@intel.com>
> Signed-off-by: Dr. David Alan Gilbert <dgilbert@redhat.com>
> ---
>  include/linux/virtio_config.h | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--poemUeGtc2GQvHuH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl5ncZoACgkQnKSrs4Gr
c8jg6gf/SZPcTN7LLKRqnGxHpVb154voV9YMHZaHBKN3vnrXZ/Ea+UHdkyY5QADv
1HY5kbzIGy9+ACo9dYF7RX+TuinFOlr+r5jN3n7IucAg0tpW4TgOk6zpgA78e9lm
mO+nsBaEiHuhUuon5GUa93qEog7TEWFWJdvcPvVzMqZ2Lgn6GWHiREjWIjET8IUW
toe4/8fig7Co7AvRXossbQVGQy6JO0b77Fe1KkrhIGnFm1CCa40cgb9SQWqgZgx+
H8MqAl8thKLsKsusSCvvypkZnO4WI7I7bfQ8y91OFS6eH+TyOjWeCnE92hTIXNxs
ADjNRLTsQ8amVAZxTD9jyKsF+tsOFA==
=Eh/9
-----END PGP SIGNATURE-----

--poemUeGtc2GQvHuH--

--===============8833101922474006869==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org

--===============8833101922474006869==--
