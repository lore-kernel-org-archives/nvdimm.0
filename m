Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A7441A4E7
	for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 21:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792186979; cv=none; b=Mq/Yw6R1MluWsFOE1Fh3M5ACPfoUhXP2qF1gD7cavuL3QH97BRUFlT9lsyP8NddmmEuw53F6pAtvn7DUpnNvnpw/Qb1M3ST897uogjHiRdsbzonuDHHLBQubryx0+1ZvqaqYHRcCBwtTrv6cdd/Y/LKxyvvb784khauPtKgB9og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792186979; c=relaxed/simple;
	bh=epZ+Tv4twj9omcUdqFjy3579cWwXC1i6LoOmmF+11f4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhCqG6QvpLo4BMu/hQg+EugvzIKzLL2Hx3mgTSc71r4+llUkGsee2Z+qoPj2qkC/7UR+jQ8nrOWLhzt1WNJVNpPyqFj+Fu86OEmOEoZCY26la7Is6lHY6XfeyMCtj+5Z636q4Pydo1L7X+vL6lf6/x7p41QYXsqReQPOv+BuFrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=rPa5qCLr; arc=none smtp.client-ip=209.85.219.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="rPa5qCLr"
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-917aca1aee5so3992366d6.2
        for <nvdimm@lists.linux.dev>; Fri, 16 Oct 2026 14:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792186977; x=1792791777; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uzNpaewaJctA3/hnc9N3XOje4ftRWEwGxLiESyBnTyo=;
        b=rPa5qCLrj13PlUErXQDBlGkxXURyYmedInGrxkqNFw8vtWW9WYswhif8mAnosVyQdW
         rEAai4zNUrLmG7wOZ3VHXrRhPSREeon9xapO9pMEY+LL5Gs6+OWf5mD/xkWU5+nCBDl9
         KEUwStPx7eogcGGXrLhFxYKmMQus3/TA6M73d53YaPGp1vYSzH8Ba4QQ3wmKFwEk5VMT
         hZY+/gPG2vYXvX2oDYgu2W0/yAc6Sphi+Dy+74nzIeEb4q3mY+KgFd5Ar3NNYsE7EbX9
         2QvXYgFzyVNc9CDLr6tikjdmbx81sCSXAZSedpecg1LtPRCqOp8FCLX9fo+7DrzlH7Ks
         0Gvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792186977; x=1792791777;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=uzNpaewaJctA3/hnc9N3XOje4ftRWEwGxLiESyBnTyo=;
        b=utBbRCUt28q83FVJhqkicgnaw/whCraXQweyGULje/5HTI2Wf/CkLZ2xr3Jrjx7wHf
         fybUaCRpNKJeRm4ttsVvLDIhzdkVvh0BpSCNL8Qh6JrHodJDxlI77zQ3OSnRh0hMEi9+
         wgdYZv65dWlBQEl3vdY6Py3JaVBIlI8wtsNLd04P2+C6w9YuA0FdDN4qavwkcn0Jd4Ou
         Qiwo/YWe77mTtrkVpviTWZQLMxKUWjBZGbYdjIs33+erruCUBfWJAOVSuT3ixk2MxpWz
         onzE/m8a730QhFvXn+TsmeAyyEdJ5OE06tYaw6P6sNopYLVQABBllp13rmr+HTB8xKqK
         lfug==
X-Gm-Message-State: AFq9FYJfGW8jXKoji/QvdTKtyusBqqKtJZ/YlJ5fkQ9Y0guauvSOofLN
	wiJ7EVO5D3rcxgjcFUrOkEFBVAgFwb7QLU4RHDVTPdz1LwZuZ2UK35pfmXzLyHSZIjlfIA0B/V1
	UKtjDWbc=
X-Gm-Gg: AYBFou2/B/6vklQtLdoIoik/26G1KlqKXMJ26CV/dbIKMqII8d52NGFenhKIz7KTKwD
	IqJoWtaAIb/+4ipMWtvI70gyFidrQ2jCMxQRDSusMrKYuUI7d3qSKDslcZ3oTg+4t6Y/x1lA1oG
	ZyFgXyIvQgqNjSaYQa1OuaWrjOp3/bymW6K/1wMMVTPhJUj7uF05jZLmBZVR7S7dvY2VCOsNSWI
	5t7ovKiyFeuBW2caXqoEKxV3vxweWERbtErV6m0ShpQ2OZmKipBb8DEFGkYFn5KL5Ms7gDjdb18
	UTZjS+6PNJITpKt2M2zuFYRR+d8CaXJKWWh4czSm5E7a3sTR6u7k2Ju0ixNhOc+kFJnTneRR0dd
	zywV1csYq8zh+Ll/Ko0ASNq7FVJTF865TpxUsqEBnHaAWHD4PBxyT5kIT7ao2U/3Tg+9FfRk2KX
	nWWeWk/8NNAg4pcR0j/9HJR2oVrW4lIsbhrURPwL+0L+yebHAFN8L6V0CGyPJnQv0w+yziwww4a
	3sCTicP1GM75LVQwgf0QwLZhsiuzyLQrBDOITvAKFjfGP3Q+nHqeWk+Rxkz
X-Received: by 2002:a05:620a:2715:b0:93e:62a4:be72 with SMTP id af79cd13be357-93f29cc952cmr209031185a.24.1792186977019;
        Fri, 16 Oct 2026 14:42:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f1a1a8ee1sm312622985a.34.2026.10.16.14.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 14:42:56 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: alison.schofield@intel.com,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH 2/6] daxctl: online whole-device memory atomically when available
Date: Fri, 16 Oct 2026 17:42:44 -0400
Message-ID: <20261016214248.443247-3-gourry@gourry.net>
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

When the kernel provides daxX.Y/state, online a fully offline device
by writing the online policy to it rather than onlining each block.
This avoids racing other agents (udev, auto-online) that online blocks
as they appear. The kernel only onlines from 'unplugged', so a device
in 'offline' is unplugged first; if that fails (e.g. no memory
hotremove support), the device is unchanged and is onlined per-block.

Memory onlined by another agent is left alone: the 'offline' case
re-checks that no block is online before unplugging, and losing a
racing online falls back to the per-block path. A small window remains
between that check and the unplug.

The per-block path now fails when the device has no memory blocks,
rather than reporting zero sections already online.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 daxctl/device.c | 105 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 105 insertions(+)

diff --git a/daxctl/device.c b/daxctl/device.c
index 47942f1..fd84799 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -510,10 +510,99 @@ static const char *parse_device_options(int argc, const char **argv,
 	return device;
 }
 
+static int dev_online_memory_atomic(struct daxctl_dev *dev,
+		struct daxctl_memory *mem, enum daxctl_kmem_state state)
+{
+	const char *devname = daxctl_dev_get_devname(dev);
+	enum daxctl_kmem_state target;
+	int num_sections, num_on, rc;
+
+	if (param.no_movable)
+		target = DAXCTL_KMEM_ONLINE;
+	else
+		target = DAXCTL_KMEM_ONLINE_MOVABLE;
+
+	if (state == DAXCTL_KMEM_OFFLINE) {
+		/*
+		 * Onlining requires 'unplugged'. Don't unplug memory another
+		 * agent onlined meanwhile (a small window remains).
+		 */
+		num_on = daxctl_memory_is_online(mem);
+		if (num_on < 0) {
+			fprintf(stderr, "%s: failed to determine online state: %s\n",
+				devname, strerror(-num_on));
+			return num_on;
+		}
+		if (num_on > 0)
+			return -EAGAIN;
+		rc = daxctl_dev_set_kmem_state(dev, DAXCTL_KMEM_UNPLUGGED);
+		if (rc < 0) {
+			/* unchanged (e.g. no hotremove support); go per-block */
+			if (param.verbose)
+				fprintf(stderr, "%s: unplug failed: %s\n",
+					devname, strerror(-rc));
+			return -EAGAIN;
+		}
+	}
+
+	rc = daxctl_dev_set_kmem_state(dev, target);
+	if (rc == -EBUSY) {
+		/* back off only if another writer onlined it */
+		switch (daxctl_dev_get_kmem_state(dev)) {
+		case DAXCTL_KMEM_ONLINE:
+		case DAXCTL_KMEM_ONLINE_KERNEL:
+		case DAXCTL_KMEM_ONLINE_MOVABLE:
+			return -EAGAIN;
+		default:
+			break;
+		}
+	}
+	if (rc < 0) {
+		fprintf(stderr, "%s: failed to online memory: %s\n",
+			devname, strerror(-rc));
+		if (state == DAXCTL_KMEM_OFFLINE)
+			fprintf(stderr,
+				"%s: device left unplugged; retry to recover\n",
+				devname);
+		return rc;
+	}
+
+	/* all sections should now be online */
+	num_sections = daxctl_memory_num_sections(mem);
+	if (num_sections < 0) {
+		fprintf(stderr, "%s: failed to get number of memory sections\n",
+			devname);
+		return num_sections;
+	}
+	if (num_sections == 0) {
+		fprintf(stderr, "%s: no memory sections present after online\n",
+			devname);
+		return -ENXIO;
+	}
+
+	num_on = daxctl_memory_is_online(mem);
+	if (num_on < 0) {
+		fprintf(stderr, "%s: failed to determine online state: %s\n",
+			devname, strerror(-num_on));
+		return num_on;
+	}
+	if (num_on < num_sections) {
+		fprintf(stderr, "%s: failed to online %d memory sections\n",
+			devname, num_sections - num_on);
+		return -ENXIO;
+	}
+	if (param.verbose)
+		fprintf(stderr, "%s: %d memory section%s onlined\n", devname,
+			num_on, num_on == 1 ? "" : "s");
+
+	return 0;
+}
+
 static int dev_online_memory(struct daxctl_dev *dev)
 {
 	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
 	const char *devname = daxctl_dev_get_devname(dev);
+	enum daxctl_kmem_state state;
 	int num_sections, num_on, rc;
 
 	if (!mem) {
@@ -522,6 +611,18 @@ static int dev_online_memory(struct daxctl_dev *dev)
 		return -ENXIO;
 	}
 
+	/*
+	 * Online a fully offline device atomically where supported.
+	 * -EAGAIN means another agent onlined memory, or the device
+	 * could not be unplugged first; go per-block.
+	 */
+	state = daxctl_dev_get_kmem_state(dev);
+	if (state == DAXCTL_KMEM_UNPLUGGED || state == DAXCTL_KMEM_OFFLINE) {
+		rc = dev_online_memory_atomic(dev, mem, state);
+		if (rc != -EAGAIN)
+			return rc;
+	}
+
 	/* get total number of sections and sections already online */
 	num_sections = daxctl_memory_num_sections(mem);
 	if (num_sections < 0) {
@@ -529,6 +630,10 @@ static int dev_online_memory(struct daxctl_dev *dev)
 			devname);
 		return num_sections;
 	}
+	if (num_sections == 0) {
+		fprintf(stderr, "%s: no memory sections present\n", devname);
+		return -ENXIO;
+	}
 
 	num_on = daxctl_memory_is_online(mem);
 	if (num_on < 0) {
-- 
2.53.0-Meta

