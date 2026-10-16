Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F420144725C
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 21:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186987; cv=none; b=JoF+UydfqJfXVdJj2vcat5OV3K2i1GVdXHYFVxxQ42BT5+jU2FDhi9U8ApU8B0G7gJJqElADlDJr2fv+1mEQV7E0VRDWSgflux2ThCPoFe8iZFYavy/AwTc3MxaYXSd96yytfa0w3em9AnkvmDPkJ6hONkxPj8DC1SDbfIjWewc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186987; c=relaxed/simple;
	bh=t6W9N4Lt0S2yTO+Q/M+vHFn7ofP89M+UAmimJ2ozFqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PUqx+7pFXEIryxijKLaMHrC8ksnuQgFr30L6qa81nAy5TGPXeRAqdLympJDwaSvh9CICEnIstGgkDcVJ0MxcCUdENYrQaJGOiXk7RjuO9dPY3q/ePKTqSNmUrukbUCXiwA64IUDiq6CLK71LMBQnfCQ8SZXw8i67pEFXFmZscxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=H7de7Moi; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="H7de7Moi"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-91791ec1b83so3669356d6.1
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792186979; x=1792791779; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aPJTxCtLmLHFQa9V0XSMmI8R2UPplg407V8GNJE/Vao=;
        b=H7de7MoimEzL3SOVoKplGsObsZ9CXCqgYdybBtERVghuttW2sZ2gBPiVwQeseoUToN
         Ycfy7sz7AUPdiCN5CIKSy+EVPvky9aC/IbELQKUFBhn5B5oVsmOKqkki3tROlZ8PbDUX
         amF0dNElzkq+gpSZ+QxeK6ze9QO/g0o2Vxxa1K2keb/OJzzv5F0ipu8fnA0oIUDeUpVC
         m7g26wyMfOVx1+RWnjdbiIzubeiIg0oUFSSLHJQ0GU3TrHh3anFYmEVDFhf6MM7he1jS
         IRk06Mll3A4U9fGVy8WQ3SJDezK5IMxtHGWURuwz74TJjkEDrMVKWbM9FGPwZ7hzmh/v
         XNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792186979; x=1792791779;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aPJTxCtLmLHFQa9V0XSMmI8R2UPplg407V8GNJE/Vao=;
        b=nNHJzsWHauxmK6IdYHJfxbs7qxSRBNGr9uroDwJrISudehZV457e1cJg9YiFJGbaju
         HglRAczlhnDbbqbIgtlHfxrZ9GFPvsr/9X6ElS+NgBUM/HGkvSEK+O/Qg1Aow6otgoR4
         LbtreYnxI5fGw/6xRk58EWZ15QtcOPLqGB6E5+t58zRedP4FRMfDfQKbfO0B5ow0FE5+
         oEPppkyPLSobyVV0RiOwHIpaBSAxy79Qx+RJHtXtYTbn9qzrMEQM51JeiyTeL0Xx9yQj
         k+3oXw3doPi7JcbpYQuKWbGclpsXZYudcUXUYkwI+zAFLnpJB2ytI4XaxVonzXb/dnUE
         Dp+g==
X-Gm-Message-State: AFq9FYIp4/0J4P9yL4PH5BQRQZE1vk0MqOF3rxlFW75AAO2K4pTWyDQC
	JEMwIDRm+DPAHt8Bu2Tz/z/jQDUFoNFrUwszjfZCRjGtoI5SibH/qeiaZABHLR838m8H3nlccrL
	lql49E+o=
X-Gm-Gg: AYBFou3SRPZmLAABO7kD01B6ljtvG8zv6UBM7tfZImD8IdF7irc9veno70aA1rr7uSP
	nfAG5+VfhhNgcbQvYkiHXpe+EwwjublBG0gezRsTE0kf+qFCAMeTBjXQ1SsP2QY/k5ww1HX1eIg
	22pn3jSMEG5wKI71fbbXMVPCsQrr8YqQuwIXEWECSIj/eX8CyEu30GIRJ59OJk9eR4WvcaKPpaR
	CpTQX41f7iqRN+CqHMNXZrpnQBdncR3nVfyJdXKEea0UNMEoQMAtqAkls1Rww/gKpDweP0buSi9
	7nHRGgL8ArdqH3uO2Q1tg5uvFd5DAliFrTwro6Kmgz8A4GmAfXAZ4nGHiiX5bGta0HS0X2aePwf
	i0rP+pDjB+6yRN0Si+e/LjsVI2OqCOif6vbiVFOQFiey6ean0ZC3n1qOcm4X69bm0xH6+1Wxmb5
	Db/64QwGBG9xlAjxxNAeP3aB8H/50laE6eCdPXesk7oOGi8y48++lBdKb4HnCnf1k1VSSpqLuDJ
	weM+ALKe8QvLAXtNMGtyrduAVhm3KasPURSms0wUkWhs+olYQz+2wnVMSkH
X-Received: by 2002:a05:620a:270b:b0:93f:6f8:9d72 with SMTP id af79cd13be357-93f29de6dd6mr191690285a.77.1792186979615;
        Fri, 16 Oct 2026 14:42:59 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a8ee1sm312622985a.34.2026.10.16.14.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:42:59 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH 4/6] daxctl: report whole-device hotplug state in 'daxctl list'
Date: Fri, 16 Oct 2026 17:42:46 -0400
Message-ID: <20261016214248.443247-5-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261016214248.443247-1-gourry@gourry.net>
References: <20261016214248.443247-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gregory Price <gourry@gourry.net>

Report daxX.Y/state as 'hotplug_state' in 'daxctl list'. The kernel
only updates it when written, so it goes stale if blocks are toggled
individually. Report 'inconsistent' when the blocks' online state or
zone disagrees with it; online_memblocks, total_memblocks and movable
show the actual state.

The attribute only appears when daxX.Y/state exists, so output on
older kernels is unchanged. ('state' already reports 'disabled'.)

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 daxctl/json.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/daxctl/json.c b/daxctl/json.c
index cf81fe6..986b695 100644
--- a/daxctl/json.c
+++ b/daxctl/json.c
@@ -12,6 +12,42 @@
 #include "filter.h"
 #include "json.h"
 
+/*
+ * daxX.Y/state only changes when written, so it goes stale if blocks are
+ * toggled individually. Report "inconsistent" if the blocks disagree.
+ */
+static const char *hotplug_state(enum daxctl_kmem_state state, int online,
+		int total, int movable)
+{
+	int all_online = total > 0 && online == total;
+
+	switch (state) {
+	case DAXCTL_KMEM_UNPLUGGED:
+		if (total == 0)
+			return "unplugged";
+		break;
+	case DAXCTL_KMEM_OFFLINE:
+		if (total > 0 && online == 0)
+			return "offline";
+		break;
+	case DAXCTL_KMEM_ONLINE:
+		if (all_online)
+			return "online";
+		break;
+	case DAXCTL_KMEM_ONLINE_KERNEL:
+		if (all_online && movable == 0)
+			return "online_kernel";
+		break;
+	case DAXCTL_KMEM_ONLINE_MOVABLE:
+		if (all_online && movable == 1)
+			return "online_movable";
+		break;
+	default:
+		break;
+	}
+	return "inconsistent";
+}
+
 struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 		unsigned long flags)
 {
@@ -19,6 +55,7 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 	const char *devname = daxctl_dev_get_devname(dev);
 	struct json_object *jdev, *jobj, *jmappings = NULL;
 	struct daxctl_mapping *mapping = NULL;
+	enum daxctl_kmem_state state;
 	int node, movable, align;
 
 	jdev = json_object_new_object();
@@ -92,6 +129,16 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 			jobj = NULL;
 		if (jobj)
 			json_object_object_add(jdev, "movable", jobj);
+
+		state = daxctl_dev_get_kmem_state(dev);
+		if (state != DAXCTL_KMEM_UNKNOWN && num_online >= 0 &&
+		    num_sections >= 0) {
+			jobj = json_object_new_string(hotplug_state(state,
+					num_online, num_sections, movable));
+			if (jobj)
+				json_object_object_add(jdev, "hotplug_state",
+						       jobj);
+		}
 	}
 
 	if (!daxctl_dev_is_enabled(dev)) {
-- 
2.53.0-Meta

