Received: from beige.elm.relay.mailchannels.net (beige.elm.relay.mailchannels.net [23.83.212.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155814A0A
	for <nvdimm@lists.linux.dev>; Wed, 13 Jul 2022 19:25:46 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 911826C16EB;
	Wed, 13 Jul 2022 19:06:51 +0000 (UTC)
Received: from pdx1-sub0-mail-a228.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id D19F56C17AA;
	Wed, 13 Jul 2022 19:06:50 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1657739210; a=rsa-sha256;
	cv=none;
	b=uNCTOYjFXqqn7Dwa82a8hvQpiUMX0Zzc/gUdTUUncS+p8uKzfZCkS1UQv4fS5PMoSBitBZ
	56ngf7q1CTnEqaxFrza0mYSqRbXQAz6IBlPxqrGoqisDvOYj9onM57rVIvs7Er2CAwbNE5
	8KQuR4C/hQ0pMRGYCFpQ66/RTWq9Es5XT+MZr00pH8e+vIxH5S+YO+Ji/HCHbGHG2vjdvl
	KjWReQIgzu8QsIJ7k3S5+lUK85ZC8RX4FZG5qCE2uZBaKknOLPmlHRQq3X1U7MDv+8TXFT
	bWrlbLxrY/LCFtcNh6nPt5wbT1EuEBmY1egcM1IAI04kf123ZoJjDCFQ3E8KCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1657739210;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=50EqSST0aiIhNeVDhbzWOF2H9pf8rm9Ld6sSRtsMHck=;
	b=SJ7A6RGcUHxXmaOnFKi15kZ6uSnNFVXUEfrvNqvJil0cWJoEyQl8+UTSNHi3bzoPjC9lGt
	dFPOYrR7LqXeliyY6z/LgnKGocO78mg9PYQ0VNkjpZjICEAvo6OqkV8CBYbkn4aD/WFrCP
	I8Aw5J0Py9grmdtvjKjFXLf4RjRohEMQU86skTIT5UI81/Y5qGvIugNHh6O3B7CqpSeJps
	YBEbkQ59GLW3Ah/Gel+X5J9zrlo8ZJgisNJGE3z4iZHoC++9wnHMEhlarDy/4Xgong8buO
	tLi2xtZpFUTq1dF59vWKdeLvyw7ie95Vb+UPm9LrAy19dExNoFmOFsDF5TZFAQ==
ARC-Authentication-Results: i=1;
	rspamd-689699966c-fmvc6;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-White-Cellar: 1e52006823a5a149_1657739211226_1137818684
X-MC-Loop-Signature: 1657739211226:1479349991
X-MC-Ingress-Time: 1657739211226
Received: from pdx1-sub0-mail-a228.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.98.67.142 (trex/6.7.1);
	Wed, 13 Jul 2022 19:06:51 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a228.dreamhost.com (Postfix) with ESMTPSA id 4LjnD96zFFz7v;
	Wed, 13 Jul 2022 12:06:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1657739210;
	bh=50EqSST0aiIhNeVDhbzWOF2H9pf8rm9Ld6sSRtsMHck=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=JR0xFYnjcljfPnXlkMzZSMATM10WMvJpqJaxFmVje4Gn+2dBGDGfs0woso0+Ubsw+
	 oyyTxZTFWk1By7lYJLXypFmw1U78XmRvJZFtjjQzNlUu10K9+9oFoCMYPVR6Tr1txd
	 zBPRnWl9jTA8sy5Ys9os4ZzDxKk+uEHGw8jsyU2ekZRzICnwUZnxU65LLWHUJ/D82w
	 n2D2hm90+PXYm/1v7CMRnSkPQrInfx/+I2g6x4RBV+y0cFaM5n7UCgJnG59I5rBW7C
	 eT2wUmpTWvevP6fK6qXCKS55OJE2zbQAwRKqC0PoR0fOnw52Cp5HDE71XFkTjp3XBj
	 ttaVerjxIus5Q==
Date: Wed, 13 Jul 2022 12:06:47 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: vishal.l.verma@intel.com, Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org,
	a.manzanares@samsung.com
Subject: Re: [PATCH 8/11] cxl/set-partition: Accept 'ram' as an alias for
 'volatile'
Message-ID: <20220713190647.u6xcip4wctudlunl@offworld>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
 <165765288979.435671.2636624998478988147.stgit@dwillia2-xfh>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165765288979.435671.2636624998478988147.stgit@dwillia2-xfh>
User-Agent: NeoMutt/20220429

On Tue, 12 Jul 2022, Dan Williams wrote:

>'ram' is a more convenient shorthand for volatile memory.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>
>Cc: Alison Schofield <alison.schofield@intel.com>
>Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>---
> Documentation/cxl/cxl-set-partition.txt |    2 +-
> cxl/memdev.c                            |    4 +++-
> 2 files changed, 4 insertions(+), 2 deletions(-)
>
>diff --git a/Documentation/cxl/cxl-set-partition.txt b/Documentation/cxl/cxl-set-partition.txt
>index 1e548af77da2..f0126daf808b 100644
>--- a/Documentation/cxl/cxl-set-partition.txt
>+++ b/Documentation/cxl/cxl-set-partition.txt
>@@ -37,7 +37,7 @@ include::memdev-option.txt[]
>
> -t::
> --type=::
>-	Type of partition, 'pmem' or 'volatile', to modify.
>+	Type of partition, 'pmem' or 'ram' (volatile), to modify.
>	Default: 'pmem'
>
> -s::
>diff --git a/cxl/memdev.c b/cxl/memdev.c
>index 9fcd8ae5724b..1cecad2dba4b 100644
>--- a/cxl/memdev.c
>+++ b/cxl/memdev.c
>@@ -65,7 +65,7 @@ OPT_BOOLEAN('f', "force", &param.force,                                \
>
> #define SET_PARTITION_OPTIONS() \
> OPT_STRING('t', "type",  &param.type, "type",			\
>-	"'pmem' or 'volatile' (Default: 'pmem')"),		\
>+	"'pmem' or 'ram' (volatile) (Default: 'pmem')"),		\
> OPT_STRING('s', "size",  &param.size, "size",			\
>	"size in bytes (Default: all available capacity)"),	\
> OPT_BOOLEAN('a', "align",  &param.align,			\
>@@ -355,6 +355,8 @@ static int action_setpartition(struct cxl_memdev *memdev,
>			/* default */;
>		else if (strcmp(param.type, "volatile") == 0)
>			type = CXL_SETPART_VOLATILE;
>+		else if (strcmp(param.type, "ram") == 0)
>+			type = CXL_SETPART_VOLATILE;
>		else {
>			log_err(&ml, "invalid type '%s'\n", param.type);
>			return -EINVAL;
>
