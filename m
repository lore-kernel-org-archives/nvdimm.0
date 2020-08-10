Return-Path: <SRS0=2RnD=BU=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_40,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9107CC433E0
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Aug 2020 13:12:20 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 06E3A2073A
	for <linux-nvdimm@archiver.kernel.org>; Mon, 10 Aug 2020 13:12:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="L7vJvYft"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 06E3A2073A
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id BC65512E83977;
	Mon, 10 Aug 2020 06:12:19 -0700 (PDT)
Received-SPF: Pass (mailfrom) identity=mailfrom; client-ip=2401:3900:2:1::2; helo=ozlabs.org; envelope-from=mpe@ellerman.id.au; receiver=<UNKNOWN> 
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 3C90912E83973
	for <linux-nvdimm@lists.01.org>; Mon, 10 Aug 2020 06:12:16 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4BQGb00LF5z9sPB;
	Mon, 10 Aug 2020 23:12:12 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
	s=201909; t=1597065132;
	bh=SWGA3xns0cZf3gu/kE+GwGglOFuMwcwftttIL6V0KBw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=L7vJvYft6Vek2NkXCZJXraNyudPe4WZoLO/JLJwcGyebMMop3Zu6zM7JtIJiF5K83
	 Ad2DSc03dOE6DtFY9VNHeIGr1N0iwaUERIIyrZ9bd+yvml9mq4sYAYSxXtIiTyYUA2
	 NYl0GycWB+ecMFsfxXtC+lsmHOM/NzSKP+wHZzuC1QbyOpae4Zkjs8ee8Kdl2rWG4f
	 O7+s3eHVIFxt9VCab31rIS9LOCFs7TpfGvIGxRSVrFE1DxJ3wUlLAZ2jEiVlc8M5/T
	 bOiLWZ6B7WmrLf1tmkenQrFRYn4RE+K0Tc8RNhZCHmDI2RSa9OxYD+zTvGJXpz19Ty
	 wC9N+X8rKKbZg==
From: Michael Ellerman <mpe@ellerman.id.au>
To: Vaibhav Jain <vaibhav@linux.ibm.com>, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
Subject: Re: [PATCH] powerpc/papr_scm: Make access mode of 'perf_stats' attribute file to '0400'
In-Reply-To: <20200807123146.11037-1-vaibhav@linux.ibm.com>
References: <20200807123146.11037-1-vaibhav@linux.ibm.com>
Date: Mon, 10 Aug 2020 23:12:08 +1000
Message-ID: <87wo26abmf.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Message-ID-Hash: BAMYKUKZ5FNIS32437W2IZ3QNQ7G4ZXH
X-Message-ID-Hash: BAMYKUKZ5FNIS32437W2IZ3QNQ7G4ZXH
X-MailFrom: mpe@ellerman.id.au
X-Mailman-Rule-Hits: nonmember-moderation
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation
CC: Vaibhav Jain <vaibhav@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/BAMYKUKZ5FNIS32437W2IZ3QNQ7G4ZXH/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Vaibhav Jain <vaibhav@linux.ibm.com> writes:
> The newly introduced 'perf_stats' attribute uses the default access
> mode of 0444 letting non-root users access performance stats of an
> nvdimm and potentially force the kernel into issuing large number of
> expensive HCALLs. Since the information exposed by this attribute
> cannot be cached hence its better to ward of access to this attribute
> from non-root users.
>
> Hence this patch updates the access-mode of 'perf_stats' sysfs
> attribute file to 0400 to make it only readable to root-users.

Or should we ratelimit it?

Fixes: ??

> Reported-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
> Signed-off-by: Vaibhav Jain <vaibhav@linux.ibm.com>

cheers
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
