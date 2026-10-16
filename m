Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6F8429803
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 21:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186979; cv=none; b=sFrn9QEDET0bmEbCSYD+s9Dttdj7/G2HxO/EGN2nptWkRFCpM6LFmNCLrZUe+TH45d6BWV+AFZwCCxiMvmX37ws4KMwzcdZjwuxEVvAmCJ7He/fP/GQTSj2dN/NQlbVPUAqNH5DVww+CKTKojtr/xAR/sKPO0DopIxEq1CMPSuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186979; c=relaxed/simple;
	bh=OrZefnPbM0hqSNG5LgeRH/CmfOYM38WyetYV8dzfLcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkJYJ3EoVebM3wORJC0GBpqdI6rqToX1PV3yb2pytxMfwruv/LEWUH1CWyNqYaOS6V/bDSMuH1tB2iZB+gMJQHI2ppTjSDghr+xKCE+4Kteam1Q75S7zs9rLnl9yUURAx7TsppL+XEopxto6fTEoSqNv/RP6lCiZlvKb7PqUfzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Vo9JemPS; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Vo9JemPS"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-917b78dfe30so5719996d6.0
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792186976; x=1792791776; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yqel/rUpZMGCjsyhhgtEf+VLt6cd2+9NH+Tz/z60eU8=;
        b=Vo9JemPS8my//BoEGNAn2fvLqAyTU9SbY/enQumJ3hgodfcPKEnoXTuO5VkbyYUxsb
         oOO5q2kHY/EzcWr60trRrNe5TBIOsqaD1ygswyuqShasK60ohtAxUgSEtVLkQ32SCio1
         qA095WJC6eU/+J9a6DXTwyVldpRWD+/xy/dd48CCfhBNE6iexsFEaKf4F7YWdMU/7OlW
         Ljg9tadjF1UNfUAJuyyXyhuc34BQ6P4n853JiyLgYfmc0hWMo20FTkVFa4wVWP30AnS1
         pO5I6RUI446s4EWK9QibSi3r2Gf+njSnRx0fL3QZXHwqtizTECdnL8R9znTWE3UCxhDy
         UPcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792186976; x=1792791776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yqel/rUpZMGCjsyhhgtEf+VLt6cd2+9NH+Tz/z60eU8=;
        b=1l4MuAfVQQ9Yrh2mSsKQJ533PaVaifxGeaDFzbvzXa5E4/eKYoHDsRxXzyzvIN0QUM
         Svk8TXx270M6ot6nEKTXxNY22OcVqg+dgG18S6iCZBUGMm0Kl620uojf01IZBUsd4l0I
         wgDu1Wk31idp0LdCRJ5HTOHu2Klm+Y6O8KwyBjNECfBIRkADaJzFfeqIeGfkhWTKp2gJ
         gVzzBMM+uOW2lZHBX8fFnHbCxIIpR+wzcKk/FWuXayyDJp+GttHbd9njfhPuVinTd0an
         I3WePHYW3MTpeKDiIbpkJ044Qw6d44GC3YfNcb5XPkPSQzRhgoNrEpgo1P5UZdbFZxEF
         QbfQ==
X-Gm-Message-State: AFq9FYKlCF3Vss6f4atz+32tcXjuh8fVWs1YkOZqi6mOFCEmxCry7YfW
	nRkMGbkWDUfK5SKRC72Z5yOC8czX1Y1Ngeb3LXuILbJhiS4iJRQK8iT4mxtRcdoa2RKc8qEWcsn
	dGtcdZCE=
X-Gm-Gg: AYBFou2PXoe+dcsUQ+WIJ3RtJjBJoawpJS8hg/PJt3v+QtNf2joTvji2lBMnb6uZIP7
	vYcqQNsO2KuJ3+EYUH0RbZpwNgkC2OD1JbZuQI3fJOTg81jWlUOM2wErp5C+fu4nFXJjPvV3pWJ
	O+jB3dbZC2rKU15OUUmzysO4101ZAMERCS+Vd/6ZJEcYbpJxIIU5r9t8VHlUbQY3JLk0pbibLtQ
	EVIvAP48sZm4kSXdZwEPpBom0Db+B74BQ7C7tbjnob7y6xTkjS9wRWVuEKjWw5uAHbxBPpUbe89
	JLflL01/mJh48qNNg6J7qTeCAIFlcv3ylLK08IXomz9Z7wI9KFaPdAa0O0+/O+/tkt2fP1RkOl9
	zS9FECPFU6q+eX6C91QUHb3xB7EH82LPR/Abd1ldOfI8vlR4jIjB2WykcBPSPraspBSz8GTEs92
	nB8Qcw+nj7spi0C6kvY07f3razutzz1KGf8FiD/uY0sEvCmUcULrnSVpjMFUsGsTO20TaaGiReV
	p6PuL9uXVPpvus0J08o5Pz4G6ITYBSFdCk5F18bZCEewHuwURfl5CYi0pnl
X-Received: by 2002:a05:620a:3728:b0:93e:94a4:a97d with SMTP id af79cd13be357-93f29a03e49mr222662085a.0.1792186975618;
        Fri, 16 Oct 2026 14:42:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a8ee1sm312622985a.34.2026.10.16.14.42.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:42:53 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH 1/6] libdaxctl: add dax kmem atomic hotplug state accessors
Date: Fri, 16 Oct 2026 17:42:43 -0400
Message-ID: <20261016214248.443247-2-gourry@gourry.net>
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

Recent kernels add /sys/bus/dax/devices/daxX.Y/state to dax_kmem
devices for atomic whole-device hotplug. It reads 'unplugged',
'offline', 'online', 'online_kernel' or 'online_movable', and accepts
all but 'offline'.

Add an enum and get/set accessors for it. The getter returns
DAXCTL_KMEM_UNKNOWN when the attribute is absent, so callers can fall
back to per-block operations.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 daxctl/lib/libdaxctl-private.h |  9 ++++++
 daxctl/lib/libdaxctl.c         | 59 ++++++++++++++++++++++++++++++++++
 daxctl/lib/libdaxctl.sym       |  6 ++++
 daxctl/libdaxctl.h             | 18 +++++++++++
 4 files changed, 92 insertions(+)

diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
index b902e3d..00e906c 100644
--- a/daxctl/lib/libdaxctl-private.h
+++ b/daxctl/lib/libdaxctl-private.h
@@ -58,6 +58,15 @@ static const char *state_strings[] = {
 	[MEM_ZONE_MOVABLE] = "online_movable",
 };
 
+/* dax_kmem daxX.Y/state strings */
+static const char *kmem_state_strings[] = {
+	[DAXCTL_KMEM_UNPLUGGED] = "unplugged",
+	[DAXCTL_KMEM_OFFLINE] = "offline",
+	[DAXCTL_KMEM_ONLINE] = "online",
+	[DAXCTL_KMEM_ONLINE_KERNEL] = "online_kernel",
+	[DAXCTL_KMEM_ONLINE_MOVABLE] = "online_movable",
+};
+
 /**
  * struct daxctl_region - container for dax_devices
  */
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 01b1915..cbb42e3 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1794,3 +1794,62 @@ DAXCTL_EXPORT int daxctl_dev_has_online_memory(struct daxctl_dev *dev)
 	else
 		return 0;
 }
+
+DAXCTL_EXPORT enum daxctl_kmem_state daxctl_dev_get_kmem_state(
+		struct daxctl_dev *dev)
+{
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	char *path = dev->dev_buf;
+	int len = dev->buf_len;
+	char buf[SYSFS_ATTR_SIZE];
+	int i;
+
+	if (snprintf(path, len, "%s/state", dev->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_dev_get_devname(dev));
+		return DAXCTL_KMEM_UNKNOWN;
+	}
+
+	/* absent on older kernels */
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		return DAXCTL_KMEM_UNKNOWN;
+
+	for (i = DAXCTL_KMEM_UNPLUGGED; i <= DAXCTL_KMEM_ONLINE_MOVABLE; i++)
+		if (strcmp(buf, kmem_state_strings[i]) == 0)
+			return i;
+
+	dbg(ctx, "%s: unrecognized kmem state '%s'\n",
+			daxctl_dev_get_devname(dev), buf);
+	return DAXCTL_KMEM_UNKNOWN;
+}
+
+DAXCTL_EXPORT int daxctl_dev_set_kmem_state(struct daxctl_dev *dev,
+		enum daxctl_kmem_state state)
+{
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	char *path = dev->dev_buf;
+	int len = dev->buf_len;
+
+	switch (state) {
+	case DAXCTL_KMEM_UNPLUGGED:
+	case DAXCTL_KMEM_ONLINE:
+	case DAXCTL_KMEM_ONLINE_KERNEL:
+	case DAXCTL_KMEM_ONLINE_MOVABLE:
+		break;
+	/* 'offline' is read-only */
+	case DAXCTL_KMEM_OFFLINE:
+	case DAXCTL_KMEM_UNKNOWN:
+	default:
+		dbg(ctx, "%s: invalid kmem state %d\n",
+				daxctl_dev_get_devname(dev), state);
+		return -EINVAL;
+	}
+
+	if (snprintf(path, len, "%s/state", dev->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n",
+				daxctl_dev_get_devname(dev));
+		return -ENXIO;
+	}
+
+	return sysfs_write_attr(ctx, path, kmem_state_strings[state]);
+}
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index 43dd60b..d247542 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -113,3 +113,9 @@ global:
 	daxctl_dev_get_mode;
 	daxctl_dev_is_system_ram_mode;
 } LIBDAXCTL_10;
+
+LIBDAXCTL_12 {
+global:
+	daxctl_dev_get_kmem_state;
+	daxctl_dev_set_kmem_state;
+} LIBDAXCTL_11;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 7ec159e..e2812cc 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -77,6 +77,24 @@ int daxctl_dev_get_target_node(struct daxctl_dev *dev);
 int daxctl_dev_will_auto_online_memory(struct daxctl_dev *dev);
 int daxctl_dev_has_online_memory(struct daxctl_dev *dev);
 
+/*
+ * dax_kmem whole-device hotplug state (daxX.Y/state). UNKNOWN means the
+ * attribute is absent (older kernel, or device not bound to kmem) or
+ * reports a state this library does not recognize.
+ */
+enum daxctl_kmem_state {
+	DAXCTL_KMEM_UNKNOWN = -1,
+	DAXCTL_KMEM_UNPLUGGED = 0,
+	DAXCTL_KMEM_OFFLINE,
+	DAXCTL_KMEM_ONLINE,
+	DAXCTL_KMEM_ONLINE_KERNEL,
+	DAXCTL_KMEM_ONLINE_MOVABLE,
+};
+
+enum daxctl_kmem_state daxctl_dev_get_kmem_state(struct daxctl_dev *dev);
+int daxctl_dev_set_kmem_state(struct daxctl_dev *dev,
+		enum daxctl_kmem_state state);
+
 struct daxctl_memory;
 
 enum daxctl_dev_mode {
-- 
2.53.0-Meta

