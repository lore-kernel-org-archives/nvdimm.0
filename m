Received: from poodle.tulip.relay.mailchannels.net (poodle.tulip.relay.mailchannels.net [23.83.218.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 870832C21EA
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 20:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=23.83.218.249
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770063836; cv=pass; b=HsDLTq9LjS2IUNrx7L5fz3Ho8DLErzZQiTJK1O+CqwRB5elb6dR8QY/BmEOQl+0A0a/SA612I6CZIfNA0/AroFY8r913oO/6AM+xIB59q6ey9jh1LXASuqqS7N0LmoYOFjEqrj8bbUYPgaLOjTyGZrVQFT5dOVK71pj1UPu8N2k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770063836; c=relaxed/simple;
	bh=YHKtglFHDamBYDDFQ0jDQUBbPnWpJcD/jGIdZvIcccU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OZVJO8p4+qVYyuzO3bWMGJP0fEIa1ddLjFkC7tjNMCE+AqJUexqLmY1lY6WEOsj9ZB/zNdKouL98mjULsxddOxmSSU7RzsEnHDjyMCRSylN0blsdIK1QxROlaqv+8L71r1kPUDYdmWD58+nHGD86IYBprGCD+BOdSGGapqmkNXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net; spf=fail smtp.mailfrom=stgolabs.net; dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b=YkQYVUvO; arc=pass smtp.client-ip=23.83.218.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=stgolabs.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stgolabs.net header.i=@stgolabs.net header.b="YkQYVUvO"
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 782A3721B84;
	Mon, 02 Feb 2026 19:29:04 +0000 (UTC)
Received: from pdx1-sub0-mail-a252.dreamhost.com (trex-green-9.trex.outbound.svc.cluster.local [100.97.7.16])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id B0D3A721997;
	Mon, 02 Feb 2026 19:29:02 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=mailchannels.net; s=arc-2022; cv=none;
	t=1770060542;
	b=xMIOFNBmsiQMHIvE21EM6aMVTrM6xVJl4cgPo7E1xmeMD10LQiJidLeoTl9KAUlM9PgIVk
	mfhi9jW4Guo987k5Mcy2qcIzsIkFj5VCkYYsNwCctPclib7oRjGe1zKjmQ2HHrtopdKPJX
	22qxTkn+SWP/AshPdkFgbfUZguVtuXbC9nL7rl4AP5soboBxud+PPuxyQctJpC/e8ArKkE
	Iw0aJ5EFjGV/oyNnvSAXapah2w06Lbk6jVXn+Fqem70KiCSPhIrS4VIdwqMqqq/JiyVT4q
	2kwmpXvUQIYYe+hJ5hqIEe2TdIQyPGWOYxjrABihcoRGgagAbkGGPIWsNKnAIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1770060542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ASnVhIsRwWOBQxGZ3Q5oBKC1xxHnmRG4tjDjPykve94=;
	b=WE390HXXKLmEj64dxKMR4kY8kh+o/L+ujM0o6smPZbGt+oYqEk7AAp5a5zkjbtia9+n2JX
	kjLg5dXo7jO/Awq45gtDh2Vdbhej0axU1SVIa8NV680jSElnAELu+2k4nDUNr5xX1x9Ud+
	pYnYPW39UnGi5Fh548vlQdwbTEnxuN3Mgc4l4l9pSTIr111df5gKit/jYtIZbS8N3wlcYr
	erSwMkM4bww2fSLOJIIk4ZRZbqXhwwBVkmOsrRmaICzvVD7bUkELmU7/nRB0ODX/Wveu+I
	stSeI2lJHOA0lI3ybdw9I3MAWzo/hWA46xqc85l2oHiQR70ee1S3SNQyWg4ofA==
ARC-Authentication-Results: i=1;
	rspamd-c758cdf4d-7vvhm;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Stretch-Gusty: 0d8465a10bf6f2ff_1770060543010_238767819
X-MC-Loop-Signature: 1770060543010:235294649
X-MC-Ingress-Time: 1770060543009
Received: from pdx1-sub0-mail-a252.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.97.7.16 (trex/7.1.3);
	Mon, 02 Feb 2026 19:29:03 +0000
Received: from offworld (unknown [76.167.199.67])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a252.dreamhost.com (Postfix) with ESMTPSA id 4f4c9p0SwXz105C;
	Mon,  2 Feb 2026 11:29:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1770060542;
	bh=ASnVhIsRwWOBQxGZ3Q5oBKC1xxHnmRG4tjDjPykve94=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=YkQYVUvO18tn8j6sr2zIPOpZtzIpBRw/OHjUFHT6n874wePAQZndjZJlSqJ4lZZ7i
	 jY+rujN1wDzzaGqyqI2F03IW/SpQVVgsuvOIXYft+IkGuJ8+MEEBXrgspknulDSUg3
	 fxxkyqhIiFm0WYma0a1PXODaPYGLY0pkgdhcdVbkn59NPgI1BgqtYXnJL7bR486Ncm
	 f/33E1RrIV2sLXpEInvNSw2fi4npM3qlr1SYHGV6V8usych3WJOmMDWqYMflkZj0Mh
	 uIW9SekA08sD7E1TIDPWpq0oKVLE0wUSgFa0wdFPFEmyG11oaGZ/ggO4T/CoYeOm4X
	 mA1TM7Hes6bTg==
Date: Mon, 2 Feb 2026 11:28:59 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Ira Weiny <ira.weiny@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>, linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 05/19] cxl/mem: Expose dynamic ram A partition in sysfs
Message-ID: <20260202192826.otyhqkhqskcgvzui@offworld>
References: <20250413-dcd-type2-upstream-v9-0-1d4911a0b365@intel.com>
 <20250413-dcd-type2-upstream-v9-5-1d4911a0b365@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20250413-dcd-type2-upstream-v9-5-1d4911a0b365@intel.com>
User-Agent: NeoMutt/20220429

On Sun, 13 Apr 2025, Ira Weiny wrote:

>To properly configure CXL regions user space will need to know the
>details of the dynamic ram partition.
>
>Expose the first dynamic ram partition through sysfs.
>
>Signed-off-by: Ira Weiny <ira.weiny@intel.com>
>
>---
>Changes:
>[iweiny: Complete rewrite of the old patch.]
>---
> Documentation/ABI/testing/sysfs-bus-cxl | 24 ++++++++++++++
> drivers/cxl/core/memdev.c               | 57 +++++++++++++++++++++++++++++++++
> 2 files changed, 81 insertions(+)
>
>diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
>index 99bb3faf7a0e..2b59041bb410 100644
>--- a/Documentation/ABI/testing/sysfs-bus-cxl
>+++ b/Documentation/ABI/testing/sysfs-bus-cxl
>@@ -89,6 +89,30 @@ Description:
>		and there are platform specific performance related
>		side-effects that may result. First class-id is displayed.
>
>+What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/size
>+Date:		May, 2025
>+KernelVersion:	v6.16
>+Contact:	linux-cxl@vger.kernel.org
>+Description:
>+		(RO) The first Dynamic RAM partition capacity as bytes.
>+
>+
>+What:		/sys/bus/cxl/devices/memX/dynamic_ram_a/qos_class
>+Date:		May, 2025
>+KernelVersion:	v6.16
>+Contact:	linux-cxl@vger.kernel.org
>+Description:
>+		(RO) For CXL host platforms that support "QoS Telemmetry"
>+		this attribute conveys a comma delimited list of platform
>+		specific cookies that identifies a QoS performance class
>+		for the persistent partition of the CXL mem device. These
			^^ 'persistent' should be dropped

>+		class-ids can be compared against a similar "qos_class"
>+		published for a root decoder. While it is not required
>+		that the endpoints map their local memory-class to a
>+		matching platform class, mismatches are not recommended
>+		and there are platform specific performance related
>+		side-effects that may result. First class-id is displayed.
>+
