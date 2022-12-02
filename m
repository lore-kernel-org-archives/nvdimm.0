Received: from bumble.maple.relay.mailchannels.net (bumble.maple.relay.mailchannels.net [23.83.214.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10D6B7C
	for <nvdimm@lists.linux.dev>; Fri,  2 Dec 2022 03:45:17 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id 1CB4A6C13AC;
	Fri,  2 Dec 2022 03:45:17 +0000 (UTC)
Received: from pdx1-sub0-mail-a219.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id A00FE6C146D;
	Fri,  2 Dec 2022 03:45:16 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1669952716; a=rsa-sha256;
	cv=none;
	b=inqf9npvKLMHZOJtCx1JJFM1F7WMJChdSU+g2KywgM2ALsx5ilDNfbY9wJlJqfPJuBBgcL
	3IIVM8TZJom9ncwe97qUigrCpDLLAwfIvLPau+ShOodf3jotyp17uW/1Asrr5czUS35MYh
	0KZeo5EyAQ2Iw/h+mNxcPEOlLvpccrYgA6BBXrap/H9+f6p8Fo0LMFQFB9O1ob0XmDQvs0
	mNrPgCjr0tRTS2PM1k4uFRewaurW+Nv5MfP8SlW091XBZqEr44o6IvA/9nG7DhGHAacjeY
	nt/qm9K50GAr1p4b/UIGQzLhjrDKeQ2LeJxoZT/g25i7zavwZ+9RypAgTnrvCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1669952716;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6K6ihOYAD3agdJnFNENKJ8DqruC36ig0EqssysxJ5uY=;
	b=83U3sweEae5fFLAaPdV8rV3+UFw5eFcI8/rO2380x0PA1hsUW3bIDTdELbXIpU5uPogjpr
	VpA1q/OMBcfMMoLZ0p3WFp74xE7tptsojWpSUpYFK074e5ZcfGkIn7RnuWojDS+ShuF+Qf
	U4ErgF89Td5vDsA1xfPwBe6YVTI2lgc/R9OWEspnKa1ZO1HKSQL5XkRIqgowME93G/OwiE
	csoHND9kVL9QlsJnhy6TqElg6pKT07P4dAE8pNPhcdxH8aarGcSInv9j2Y4qWZieDbrqlL
	GYIZ2SW0UK0ucODOU5Kf/paTdzOmsthIWK9TlX/vBxXpVuoQZ1HZGYv22dTKUw==
ARC-Authentication-Results: i=1;
	rspamd-7bd68c5946-5928w;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Battle-Skirt: 74f7a46d58f5c4d4_1669952716921_1173322837
X-MC-Loop-Signature: 1669952716921:783466651
X-MC-Ingress-Time: 1669952716921
Received: from pdx1-sub0-mail-a219.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.120.227.191 (trex/6.7.1);
	Fri, 02 Dec 2022 03:45:16 +0000
Received: from offworld (unknown [104.36.25.245])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a219.dreamhost.com (Postfix) with ESMTPSA id 4NNf3H5hyGzK2;
	Thu,  1 Dec 2022 19:45:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1669952716;
	bh=6K6ihOYAD3agdJnFNENKJ8DqruC36ig0EqssysxJ5uY=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=gJPwvRziiPmBUlCg3CQ9+RyfH8ls5/LWqv0dIRnvY05Kamti0YqyDxaTXP2tgjTJW
	 j76m9epbT4AZlFkIr0a4GSZuvuQ8sBdx6yaDol0oYuF0hzIODi7OWq1zEzFGnwL62z
	 ZFS5LYYMbq+sIkQoseMpFhyepStipTxeReFJ9foEc2W4uEJ+44ASIuwkSvEbPMWGng
	 e6sZZGdgf5LKwaJqXXF2u9f7AKNQTlCLs2kjVpRXEYqWLjBJUC+4Bi+rZIu9d14TJt
	 5jAzgvFvlfGFKPOLX0wqlRwjNTlC6n5VdyDAy/cGBP2y6AzHNl+If6YlPv03B9fZ4E
	 4ochF5Wd81jdA==
Date: Thu, 1 Dec 2022 19:21:31 -0800
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-cxl@vger.kernel.org, Jonathan.Cameron@huawei.com,
	dave.jiang@intel.com, nvdimm@lists.linux.dev
Subject: Re: [PATCH 4/5] nvdimm/region: Move cache management to the region
 driver
Message-ID: <20221202032131.hmy7ydpddjrlpd4u@offworld>
References: <166993219354.1995348.12912519920112533797.stgit@dwillia2-xfh.jf.intel.com>
 <166993221550.1995348.16843505129579060258.stgit@dwillia2-xfh.jf.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <166993221550.1995348.16843505129579060258.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: NeoMutt/20220429

On Thu, 01 Dec 2022, Dan Williams wrote:

>Now that cpu_cache_invalidate_memregion() is generically available, use
>it to centralize CPU cache management in the nvdimm region driver.
>
>This trades off removing redundant per-dimm CPU cache flushing with an
>opportunistic flush on every region disable event to cover the case of
>sensitive dirty data in the cache being written back to media after a
>secure erase / overwrite event.

Very nifty.

>Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

with a few notes below.

>+static int nd_region_invalidate_memregion(struct nd_region *nd_region)
>+{
>+	int i, incoherent = 0;
>+
>+	for (i = 0; i < nd_region->ndr_mappings; i++) {
>+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
>+
>+		if (test_bit(NDD_INCOHERENT, &nvdimm->flags))
>+			incoherent++;

No need to compute the rest, just break out here?

>+	}
>+
>+	if (!incoherent)
>+		return 0;
>+
>+	if (!cpu_cache_has_invalidate_memregion()) {
>+		if (IS_ENABLED(CONFIG_NVDIMM_SECURITY_TEST)) {
>+			dev_warn(
>+				&nd_region->dev,
>+				"Bypassing cpu_cache_invalidate_memergion() for testing!\n");
>+			goto out;
>+		} else {
>+			dev_err(&nd_region->dev,
>+				"Failed to synchronize CPU cache state\n");
>+			return -ENXIO;
>+		}
>+	}
>+
>+	cpu_cache_invalidate_memregion(IORES_DESC_PERSISTENT_MEMORY);
>+out:
>+	for (i = 0; i < nd_region->ndr_mappings; i++) {
>+		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>+		struct nvdimm *nvdimm = nd_mapping->nvdimm;
>+
>+		clear_bit(NDD_INCOHERENT, &nvdimm->flags);
>+	}
>+
>+	return 0;
>+}
>+
> int nd_region_activate(struct nd_region *nd_region)
> {
>-	int i, j, num_flush = 0;
>+	int i, j, rc, num_flush = 0;
>	struct nd_region_data *ndrd;
>	struct device *dev = &nd_region->dev;
>	size_t flush_data_size = sizeof(void *);
>
>+	rc = nd_region_invalidate_memregion(nd_region);
>+	if (rc)
>+		return rc;
>+
>	nvdimm_bus_lock(&nd_region->dev);
>	for (i = 0; i < nd_region->ndr_mappings; i++) {
>		struct nd_mapping *nd_mapping = &nd_region->mapping[i];
>@@ -85,6 +129,7 @@ int nd_region_activate(struct nd_region *nd_region)
>	}
>	nvdimm_bus_unlock(&nd_region->dev);
>
>+
>	ndrd = devm_kzalloc(dev, sizeof(*ndrd) + flush_data_size, GFP_KERNEL);
>	if (!ndrd)
>		return -ENOMEM;
>@@ -1222,3 +1267,5 @@ int nd_region_conflict(struct nd_region *nd_region, resource_size_t start,
>
>	return device_for_each_child(&nvdimm_bus->dev, &ctx, region_conflict);
> }
>+
>+MODULE_IMPORT_NS(DEVMEM);
>diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
>index 6814339b3dab..a03e3c45f297 100644
>--- a/drivers/nvdimm/security.c
>+++ b/drivers/nvdimm/security.c
>@@ -208,6 +208,8 @@ static int __nvdimm_security_unlock(struct nvdimm *nvdimm)
>	rc = nvdimm->sec.ops->unlock(nvdimm, data);
>	dev_dbg(dev, "key: %d unlock: %s\n", key_serial(key),
>			rc == 0 ? "success" : "fail");
>+	if (rc == 0)
>+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
>
>	nvdimm_put_key(key);
>	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
>@@ -374,6 +376,8 @@ static int security_erase(struct nvdimm *nvdimm, unsigned int keyid,
>		return -ENOKEY;
>
>	rc = nvdimm->sec.ops->erase(nvdimm, data, pass_type);
>+	if (rc == 0)
>+		set_bit(NDD_INCOHERENT, &nvdimm->flags);
>	dev_dbg(dev, "key: %d erase%s: %s\n", key_serial(key),
>			pass_type == NVDIMM_MASTER ? "(master)" : "(user)",
>			rc == 0 ? "success" : "fail");
>@@ -408,6 +412,8 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
>		return -ENOKEY;
>
>	rc = nvdimm->sec.ops->overwrite(nvdimm, data);
>+	if (rc == 0)
>+		set_bit(NDD_INCOHERENT, &nvdimm->flags);

Are you relying on hw preventing an incoming region_activate() while the overwrite
operation is in progress to ensure that the flags are stable throughout the whole
op? Currently query-overwrite also provides the flushing guarantees for when the
command is actually complete (at least from a user pov).

Thanks,
Davidlohr
