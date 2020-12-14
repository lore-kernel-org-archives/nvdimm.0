Return-Path: <SRS0=BDGy=FS=lists.01.org=linux-nvdimm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E755C4361B
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Dec 2020 10:39:32 +0000 (UTC)
Received: from ml01.01.org (ml01.01.org [198.145.21.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mail.kernel.org (Postfix) with ESMTPS id 639D622B37
	for <linux-nvdimm@archiver.kernel.org>; Mon, 14 Dec 2020 10:39:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 639D622B37
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=fossix.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-nvdimm-bounces@lists.01.org
Received: from ml01.vlan13.01.org (localhost [IPv6:::1])
	by ml01.01.org (Postfix) with ESMTP id 2C3F1100EF271;
	Mon, 14 Dec 2020 02:39:31 -0800 (PST)
Received-SPF: None (mailfrom) identity=mailfrom; client-ip=2607:f8b0:4864:20::542; helo=mail-pg1-x542.google.com; envelope-from=santosh@fossix.org; receiver=<UNKNOWN> 
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
	(No client certificate requested)
	by ml01.01.org (Postfix) with ESMTPS id 8D4D2100EF26F
	for <linux-nvdimm@lists.01.org>; Mon, 14 Dec 2020 02:39:29 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id t37so12199184pga.7
        for <linux-nvdimm@lists.01.org>; Mon, 14 Dec 2020 02:39:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fossix-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+XQ98VQlJbx/wJmwWGGJ/XeFWJw65N1toCzuaN5sHhg=;
        b=wvc+9hENbi/rEqUgrjferRMyvvLbvVfKNBUFzneyWcHUz1uTXi8VTvQ14iPcAa79XL
         R1TwztPkKVIScMRUIIwEElH2ofN6AvYRimh7Poe4bpT+UPLBt7OZuRXfbq/OhkTT9SlE
         TEaNluX2LzuzRC80scywk6VUspLObux5BtUYcqVf4TdKLXOAIFJcTg4cvFWm7CBHCpC3
         +ueFYRVtH6riLkPxb9isk5xC9hMnSFQBmiIEOEkXLyAzv9Sbh3JkVV6Lj5admfrGnuIz
         b+Teklo0S83QbeMGGaA2v+JKt264xHyN6ejOrbhQE+WAXa9v2depTmTMgQT/s+heUziY
         +ruQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+XQ98VQlJbx/wJmwWGGJ/XeFWJw65N1toCzuaN5sHhg=;
        b=qe6lxOWwhxllGC98dRungfGYPCnM8NyuDyMA0fpGgFnL0aBJZ41iWzQvwU18/E64Ad
         F78ioqyXPun8aKeH2B6GPaWFYXiZCCon9JWNK8K3opCTO6tyzSRdapkQ6Y+m5a11FgX7
         WdfGyX8lTjVkUMT6jBIRYxt3nZRL44FI1INMgXtULJZWqk5aiGqOC6HkD/+rve7xq8Oq
         Gw8jbd3WCRYFUI/QpRHXXrzBqtKkw/dkPvat05N0L5zzMXkWEghk+2rQCGM4lNe69LvI
         Ff7/L6tAEDFzaSnox2RGP+aJDR38szBCqRZcmyMRSK9XfNksks+Cg768RJtMEDqjJlzJ
         ecqA==
X-Gm-Message-State: AOAM533TGbE0cQhu4x0516FBi/uRgqtgILoNhrERxp3KgOwZnlg8n/k8
	Z4b44UKkemS0JwuxXqD/RtkmEqi9V6GeBA==
X-Google-Smtp-Source: ABdhPJwA9T2pL/5Yz2Y0w1DMLYWHwNdUWyckT8KjLPL+rwVlTLMXhAwwuBrnJHyuUEaN/5nLr6CddA==
X-Received: by 2002:a63:df4a:: with SMTP id h10mr23638142pgj.25.1607942368992;
        Mon, 14 Dec 2020 02:39:28 -0800 (PST)
Received: from santosiv.in.ibm.com.com ([103.21.79.4])
        by smtp.gmail.com with ESMTPSA id p1sm20735926pfb.208.2020.12.14.02.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 02:39:28 -0800 (PST)
From: Santosh Sivaraj <santosh@fossix.org>
To: Linux NVDIMM <linux-nvdimm@lists.01.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Vaibhav Jain <vaibhav@linux.ibm.com>,
	Shivaprasad G Bhat <sbhat@linux.ibm.com>,
	Harish Sriram <harish@linux.ibm.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Santosh Sivaraj <santosh@fossix.org>
Subject: [RFC v5 2/7] ndtest: Add compatability string to treat it as PAPR family
Date: Mon, 14 Dec 2020 16:08:54 +0530
Message-Id: <20201214103859.2409175-3-santosh@fossix.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201214103859.2409175-1-santosh@fossix.org>
References: <20201214103859.2409175-1-santosh@fossix.org>
MIME-Version: 1.0
Message-ID-Hash: 2A2PWZRDIFIFBOB2AZ77MRAKCZD7O3CD
X-Message-ID-Hash: 2A2PWZRDIFIFBOB2AZ77MRAKCZD7O3CD
X-MailFrom: santosh@fossix.org
X-Mailman-Rule-Misses: dmarc-mitigation; no-senders; approved; emergency; loop; banned-address; member-moderation; nonmember-moderation; administrivia; implicit-dest; max-recipients; max-size; news-moderation; no-subject; suspicious-header
X-Mailman-Version: 3.1.1
Precedence: list
List-Id: "Linux-nvdimm developer list." <linux-nvdimm.lists.01.org>
Archived-At: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/message/2A2PWZRDIFIFBOB2AZ77MRAKCZD7O3CD/>
List-Archive: <https://lists.01.org/hyperkitty/list/linux-nvdimm@lists.01.org/>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Subscribe: <mailto:linux-nvdimm-join@lists.01.org>
List-Unsubscribe: <mailto:linux-nvdimm-leave@lists.01.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

Since this module is written to be platform agnostic, the module is made
part of the PAPR_FAMILY. ndctl identifies the family using the compatible
string inside of_node dir-entry.

Signed-off-by: Santosh Sivaraj <santosh@fossix.org>
---
 tools/testing/nvdimm/test/ndtest.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index f89d74fdcdee..001527b37a23 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -65,11 +65,34 @@ static int ndtest_ctl(struct nvdimm_bus_descriptor *nd_desc,
 	return 0;
 }
 
+static ssize_t compatible_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "nvdimm_test");
+}
+static DEVICE_ATTR_RO(compatible);
+
+static struct attribute *of_node_attributes[] = {
+	&dev_attr_compatible.attr,
+	NULL
+};
+
+static const struct attribute_group of_node_attribute_group = {
+	.name = "of_node",
+	.attrs = of_node_attributes,
+};
+
+static const struct attribute_group *ndtest_attribute_groups[] = {
+	&of_node_attribute_group,
+	NULL,
+};
+
 static int ndtest_bus_register(struct ndtest_priv *p)
 {
 	p->bus_desc.ndctl = ndtest_ctl;
 	p->bus_desc.module = THIS_MODULE;
 	p->bus_desc.provider_name = NULL;
+	p->bus_desc.attr_groups = ndtest_attribute_groups;
 
 	p->bus = nvdimm_bus_register(&p->pdev.dev, &p->bus_desc);
 	if (!p->bus) {
-- 
2.26.2
_______________________________________________
Linux-nvdimm mailing list -- linux-nvdimm@lists.01.org
To unsubscribe send an email to linux-nvdimm-leave@lists.01.org
