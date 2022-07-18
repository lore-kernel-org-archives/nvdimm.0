Received: from dog.elm.relay.mailchannels.net (dog.elm.relay.mailchannels.net [23.83.212.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA530A46
	for <nvdimm@lists.linux.dev>; Mon, 18 Jul 2022 06:29:15 +0000 (UTC)
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
Received: from relay.mailchannels.net (localhost [127.0.0.1])
	by relay.mailchannels.net (Postfix) with ESMTP id A15FA81A99;
	Mon, 18 Jul 2022 06:29:07 +0000 (UTC)
Received: from pdx1-sub0-mail-a220.dreamhost.com (unknown [127.0.0.6])
	(Authenticated sender: dreamhost)
	by relay.mailchannels.net (Postfix) with ESMTPA id 13DE18193C;
	Mon, 18 Jul 2022 06:29:06 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1658125746; a=rsa-sha256;
	cv=none;
	b=9Xf8AyfaQEnWyhaP07RrJhZP28Uk0RMJXIcyJu76FnxcLpGgpIb1WYal2uTSSVfa83Y8Rb
	PbDZJBD+/is5UKYLsMrsWu4xPhtHm90NGp2VN3yxmje4rjsXIc6uXdHreV3YOKe30lKeJA
	Xr8pUH8JQHPlzOUKCZ+XH8KrCbcco8cwvyVij5kh24wjLn1w6+DW6EWsyNtJ5ysApQUJ7O
	8Xm+xUby7vGMnj3MbFSaiCReDQt2nLj1KdZxrtZSY4dRt5Q8feFfpAZ0uqH4NeudT0OtKE
	eK7cexq40O43ARb53y/klAf8DxQpRIb4yr4TPvwk55Maf6r6x64SwaouJPJ4aw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
	s=arc-2022; t=1658125746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xi6KAyVJ25K/T3eEYFHQUSX6q6bLKhuFf3IYvlWoVY8=;
	b=pP9ogDpKjuF3R1ul2CmkE7+7vkfeWJtNjKKd8kwQVNJ6xjIFal9jDd0+QEnbFOE8VxBfJp
	UDsYisX/MlDw5VAhvsq1kA185nhnsoSE6UBAKuK57vxvvI49mqixOMLZpR3O8UAuzvRGr+
	wenk5OgR1Za+teEs83P6G80PbIN7e2aIY/BL11Jwq1sWVFgud3E3uc8zezaoPBFL/IJyt/
	NiJdcIkb15EBwVO170AeQ45C28DCO3JoUFlOj19LfCz5OMaiIFyWB+q46zhMWJuGKBOODn
	1iU/BtvIXL3djd6nIiqIm39CTuDu+gDx55WZqDxClNS2R8huR3wyoCexrJSosg==
ARC-Authentication-Results: i=1;
	rspamd-689699966c-frzhf;
	auth=pass smtp.auth=dreamhost smtp.mailfrom=dave@stgolabs.net
X-Sender-Id: dreamhost|x-authsender|dave@stgolabs.net
X-MC-Relay: Neutral
X-MailChannels-SenderId: dreamhost|x-authsender|dave@stgolabs.net
X-MailChannels-Auth-Id: dreamhost
X-Left-Shade: 48165b596f844c0c_1658125746657_1363763677
X-MC-Loop-Signature: 1658125746657:3530652602
X-MC-Ingress-Time: 1658125746656
Received: from pdx1-sub0-mail-a220.dreamhost.com (pop.dreamhost.com
 [64.90.62.162])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
	by 100.98.242.215 (trex/6.7.1);
	Mon, 18 Jul 2022 06:29:06 +0000
Received: from offworld (unknown [104.36.25.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: dave@stgolabs.net)
	by pdx1-sub0-mail-a220.dreamhost.com (Postfix) with ESMTPSA id 4LmX9Y2nqkz75;
	Sun, 17 Jul 2022 23:29:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=stgolabs.net;
	s=dreamhost; t=1658125745;
	bh=xi6KAyVJ25K/T3eEYFHQUSX6q6bLKhuFf3IYvlWoVY8=;
	h=Date:From:To:Cc:Subject:Content-Type;
	b=MUhCiA/OiYOdgT05w5P6njjSHpvsgrUURYaqhsbq4sVksMKSHypCA1als7KwRWMMY
	 N4PGu1gN8XfuOUTRmD15/9QaIF0NTgsgS5rJoVx5yFVo6lA48ymO7TrsJHwiu4oyE9
	 Ew/bIp1z3Y82z/aUfD1DAive3Kw46FqE6bhH/zlB7+wgJnhfYRKwSlS4FwnwpKZ8XF
	 Rn9FdF/2r9dISWqqr/w6qujy6KytHCxk5oxLDAsgzHySHVKNf0kRYsqDBMSQz3on0w
	 0LqxtZ1pHh7Bhwt0BtH9olPVkSZWDnvOUW4JH25d1QSc4Z9649nkDVVaa9vGNJkFYw
	 jt6BmTNbHabfw==
Date: Sun, 17 Jul 2022 23:29:02 -0700
From: Davidlohr Bueso <dave@stgolabs.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
	vishal.l.verma@intel.com, alison.schofield@intel.com
Subject: Re: [PATCH RFC 2/15] tools/testing/cxl: Create context for cxl mock
 device
Message-ID: <20220718062902.i7pfbrej6hpwdvb4@offworld>
References: <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
 <165791932409.2491387.9065856569307593223.stgit@djiang5-desk3.ch.intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <165791932409.2491387.9065856569307593223.stgit@djiang5-desk3.ch.intel.com>
User-Agent: NeoMutt/20220429

On Fri, 15 Jul 2022, Dave Jiang wrote:

>Add context struct for mock device and move lsa under the context. This
>allows additional information such as security status and other persistent
>security data such as passphrase to be added for the emulated test device.
>

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>

>Signed-off-by: Dave Jiang <dave.jiang@intel.com>
>---
> tools/testing/cxl/test/mem.c |   29 +++++++++++++++++++++++------
> 1 file changed, 23 insertions(+), 6 deletions(-)
>
>diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
>index 6b9239b2afd4..723378248321 100644
>--- a/tools/testing/cxl/test/mem.c
>+++ b/tools/testing/cxl/test/mem.c
>@@ -9,6 +9,10 @@
> #include <linux/bits.h>
> #include <cxlmem.h>
>
>+struct mock_mdev_data {
>+	void *lsa;
>+};
>+
> #define LSA_SIZE SZ_128K
> #define EFFECT(x) (1U << x)
>
>@@ -140,7 +144,8 @@ static int mock_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> {
> 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
>-	void *lsa = dev_get_drvdata(cxlds->dev);
>+	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
>+	void *lsa = mdata->lsa;
> 	u32 offset, length;
>
> 	if (sizeof(*get_lsa) > cmd->size_in)
>@@ -159,7 +164,8 @@ static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> static int mock_set_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
> {
> 	struct cxl_mbox_set_lsa *set_lsa = cmd->payload_in;
>-	void *lsa = dev_get_drvdata(cxlds->dev);
>+	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
>+	void *lsa = mdata->lsa;
> 	u32 offset, length;
>
> 	if (sizeof(*set_lsa) > cmd->size_in)
>@@ -237,9 +243,12 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
> 	return rc;
> }
>
>-static void label_area_release(void *lsa)
>+static void cxl_mock_drvdata_release(void *data)
> {
>-	vfree(lsa);
>+	struct mock_mdev_data *mdata = data;
>+
>+	vfree(mdata->lsa);
>+	vfree(mdata);
> }
>
> static int cxl_mock_mem_probe(struct platform_device *pdev)
>@@ -247,13 +256,21 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
> 	struct device *dev = &pdev->dev;
> 	struct cxl_memdev *cxlmd;
> 	struct cxl_dev_state *cxlds;
>+	struct mock_mdev_data *mdata;
> 	void *lsa;
> 	int rc;
>
>+	mdata = vmalloc(sizeof(*mdata));
>+	if (!mdata)
>+		return -ENOMEM;
>+
> 	lsa = vmalloc(LSA_SIZE);
>-	if (!lsa)
>+	if (!lsa) {
>+		vfree(mdata);
> 		return -ENOMEM;
>-	rc = devm_add_action_or_reset(dev, label_area_release, lsa);
>+	}
>+
>+	rc = devm_add_action_or_reset(dev, cxl_mock_drvdata_release, mdata);
> 	if (rc)
> 		return rc;
> 	dev_set_drvdata(dev, lsa);
>
