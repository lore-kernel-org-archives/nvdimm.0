Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A46355024
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 23:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768433657; cv=none; b=VRddY1TG/gbyIP56+qxXP7jYcsF7zD+ANuZcJmBK98XmGlWZd/s4uh21ZFB7C5/5VSg2QrwEEND/b0TcVdyqEx4Ox9N4Vf8rr0KvwaJvg/a1zv0zDb7kPpoVeEQZHvVDr3FY29lqZ74W6a73z7XOYkw8qUQa/gMmifMEEZTAa/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768433657; c=relaxed/simple;
	bh=r9IqegKKXF0hOodqnrc7EmAalu0NN7c//lGhFFS/Wr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vom4W6z57wY413ca66ZFU6SuOjifk+xqf1yCBfbSbvO/OOzJgFKmopvm11caBPDAxeqCKXXgdYPa+YAjH5RXbhS4sLqV8UB/0n7hQQM+A1R6wVDbJt2DEjyt79M+lo0UFvtqpTJUvFlQXAjPHxcIy2ULlNIcOPyFdrmpV8zZQWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XsCbtirF; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XsCbtirF"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8907fb0188fso2997606d6.1
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 15:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768433642; x=1769038442; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dJ1yqTOSIYfzgCIPomxp4mh5lXIFW6Vqr0XKillgvQc=;
        b=XsCbtirF4CbMIggGmlpt4dZnLco/TWAyfAwjcWqPYzThDVSQfE2oaepEdDy8ChQM0v
         w5yJ8EwmT1Bo+f8tA8MC0FjWxvL2KGUBsx/4j3lhPv8vfGdS9ErBJxQtn0q5cglAafXc
         kwy7z7E/RVcRKH/57k6+OSwYBfY02vDUTR6PBoO8haJcGs1HvF6wefGhQh6MNcaVaQGL
         Kc3w4Fj7M75gDIsZUJTiP0Dt2WtKVVav8sV53KvgAqizcAoOiSqAqxKt4ciETTsY0BLN
         fgsqh5IwhiWvfOO5KUWK987bUcoh1qbHF8+3yagwmgczoGR+yPxUPjBpLikodymXu4EK
         CJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768433642; x=1769038442;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dJ1yqTOSIYfzgCIPomxp4mh5lXIFW6Vqr0XKillgvQc=;
        b=puiTRC4DCj+0lol55R0mn68zvrZk89Hv620Qx1EV0LXjP+jY2M+dJx/RAUvi0rGXb5
         B4Pa7VDlec+odoj1JVpASlporEHKQDQWVC/5fBujMo/r1Rw400UxXYKwTUvZvJu+npJN
         ih85WTX7EX8XdO2p+etM5kwfqex++60Y5TxuwKeNQ5w0I5wR1GKIr4Z0d9NqjWMGi73h
         Y2jKYrhYQGJD7Dn+CaYTu+Xvw0kiQ3+COPANV/Oj8p6CHWKi4ikDT+3QUBamAQkPzPvm
         uvW8vw6IC7fiwq9nkBhSWnIzUSmI85GBw+qJw8CYpvlcmV57PzYMPpE3gOKGpNHBHYQD
         ZnWA==
X-Forwarded-Encrypted: i=1; AJvYcCV6IwhrW8s/GQPEg97Mk0ZfPi+l7BGaQgsF6FEwrgqnpRZ2S+flgdzj6f5j1oyToQHjQPVnWmo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxkr/qwfN3dOGl65xO6zsZHOEGeuHQULJfeYVofYXeE4eVil5tK
	nqZY+sY4Hn8VEK6QUPAEgQEfmBkNUrLJLnfk3q3AYiq7LcZNcUpz1X0gHTJ+BQ==
X-Gm-Gg: AY/fxX5H3tge1Z8xFdLSKvDEVmbStP20AYoMnmwpRkn54K1RioYpPK06sknK87s9SlN
	i0WkaBf0xG5cLKXBTqOOcCGCxKB0W46BTLBev+9Ri38d15JWU722hNic3asPWVp8TudmllYEoEL
	PQBrw8k5IZ2oWeq+iR29dhmHJRSBoo59D3Csd+Z7Bo1XCd1ad4XbX0H+7wV1q9LHXKB7PoRSHnp
	EitYUmKdMuQ1LUAOqA5ujVmxbk20a9YvV+vWA/poRlfx20Rqu+xKcKuSsUYruk7zFM2OyfSoPsR
	qSUjekXtft0LU63pV4oHAE/ucbkgEEVCV9EGu1F0BgX6w2iq0Kl9tHM6/XsvFgD5KbiFMrNwJiI
	EIfx91mS6rd6GFx+B16ODYxpG1hqRjFrAukjCMwRWK49MHROOzC9DRGhkD3Phl/vaCL2dO53Z89
	58OJLoKHt3c3yJvWgTIhhjtksCo4Ogsc/VJNPEONHzRYe4
X-Received: by 2002:a05:6820:2224:b0:65f:6582:6b23 with SMTP id 006d021491bc7-661006caf9dmr3084461eaf.38.1768427154787;
        Wed, 14 Jan 2026 13:45:54 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:4c85:2962:e438:72c4])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65f48cb03d4sm10935674eaf.12.2026.01.14.13.45.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 14 Jan 2026 13:45:54 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
From: John Groves <John@Groves.net>
X-Google-Original-From: John Groves <john@groves.net>
To: John Groves <John@Groves.net>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Dan Williams <dan.j.williams@intel.com>,
	Bernd Schubert <bschubert@ddn.com>,
	Alison Schofield <alison.schofield@intel.com>
Cc: John Groves <jgroves@micron.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	David Hildenbrand <david@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Jeff Layton <jlayton@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Stefan Hajnoczi <shajnocz@redhat.com>,
	Joanne Koong <joannelkoong@gmail.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	James Morse <james.morse@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Shivank Garg <shivankg@amd.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>,
	Aravind Ramesh <arramesh@micron.com>,
	Ajay Joshi <ajayjoshi@micron.com>,
	venkataravis@micron.com,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH V2 1/2] daxctl: Add support for famfs mode
Date: Wed, 14 Jan 2026 15:45:18 -0600
Message-ID: <20260114214519.29999-2-john@groves.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114214519.29999-1-john@groves.net>
References: <20260114153133.29420.compound@groves.net>
 <20260114214519.29999-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

Putting a daxdev in famfs mode means binding it to fsdev_dax.ko
(drivers/dax/fsdev.c). Finding a daxdev bound to fsdev_dax means
it is in famfs mode.

The test is added to the destructive test suite since it
modifies device modes.

With devdax, famfs, and system-ram modes, the previous logic that assumed
'not in mode X means in mode Y' needed to get slightly more complicated

Add explicit mode detection functions:
- daxctl_dev_is_famfs_mode(): check if bound to fsdev_dax driver
- daxctl_dev_is_devdax_mode(): check if bound to device_dax driver

Fix mode transition logic in device.c:
- disable_devdax_device(): verify device is actually in devdax mode
- disable_famfs_device(): verify device is actually in famfs mode
- All reconfig_mode_*() functions now explicitly check each mode
- Handle unknown mode with error instead of wrong assumption

Modify json.c to show 'unknown' if device is not in a recognized mode.

Signed-off-by: John Groves <john@groves.net>
---
 daxctl/device.c                | 126 ++++++++++++++++++++++++++++++---
 daxctl/json.c                  |   6 +-
 daxctl/lib/libdaxctl-private.h |   2 +
 daxctl/lib/libdaxctl.c         |  77 ++++++++++++++++++++
 daxctl/lib/libdaxctl.sym       |   7 ++
 daxctl/libdaxctl.h             |   3 +
 6 files changed, 210 insertions(+), 11 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index e3993b1..14e1796 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -42,6 +42,7 @@ enum dev_mode {
 	DAXCTL_DEV_MODE_UNKNOWN,
 	DAXCTL_DEV_MODE_DEVDAX,
 	DAXCTL_DEV_MODE_RAM,
+	DAXCTL_DEV_MODE_FAMFS,
 };
 
 struct mapping {
@@ -471,6 +472,13 @@ static const char *parse_device_options(int argc, const char **argv,
 					"--no-online is incompatible with --mode=devdax\n");
 				rc =  -EINVAL;
 			}
+		} else if (strcmp(param.mode, "famfs") == 0) {
+			reconfig_mode = DAXCTL_DEV_MODE_FAMFS;
+			if (param.no_online) {
+				fprintf(stderr,
+					"--no-online is incompatible with --mode=famfs\n");
+				rc =  -EINVAL;
+			}
 		}
 		break;
 	case ACTION_CREATE:
@@ -696,8 +704,42 @@ static int disable_devdax_device(struct daxctl_dev *dev)
 	int rc;
 
 	if (mem) {
-		fprintf(stderr, "%s was already in system-ram mode\n",
-			devname);
+		fprintf(stderr, "%s is in system-ram mode\n", devname);
+		return 1;
+	}
+	if (daxctl_dev_is_famfs_mode(dev)) {
+		fprintf(stderr, "%s is in famfs mode\n", devname);
+		return 1;
+	}
+	if (!daxctl_dev_is_devdax_mode(dev)) {
+		fprintf(stderr, "%s is not in devdax mode\n", devname);
+		return 1;
+	}
+	rc = daxctl_dev_disable(dev);
+	if (rc) {
+		fprintf(stderr, "%s: disable failed: %s\n",
+			daxctl_dev_get_devname(dev), strerror(-rc));
+		return rc;
+	}
+	return 0;
+}
+
+static int disable_famfs_device(struct daxctl_dev *dev)
+{
+	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
+	const char *devname = daxctl_dev_get_devname(dev);
+	int rc;
+
+	if (mem) {
+		fprintf(stderr, "%s is in system-ram mode\n", devname);
+		return 1;
+	}
+	if (daxctl_dev_is_devdax_mode(dev)) {
+		fprintf(stderr, "%s is in devdax mode\n", devname);
+		return 1;
+	}
+	if (!daxctl_dev_is_famfs_mode(dev)) {
+		fprintf(stderr, "%s is not in famfs mode\n", devname);
 		return 1;
 	}
 	rc = daxctl_dev_disable(dev);
@@ -711,6 +753,7 @@ static int disable_devdax_device(struct daxctl_dev *dev)
 
 static int reconfig_mode_system_ram(struct daxctl_dev *dev)
 {
+	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
 	const char *devname = daxctl_dev_get_devname(dev);
 	int rc, skip_enable = 0;
 
@@ -724,11 +767,21 @@ static int reconfig_mode_system_ram(struct daxctl_dev *dev)
 	}
 
 	if (daxctl_dev_is_enabled(dev)) {
-		rc = disable_devdax_device(dev);
-		if (rc < 0)
-			return rc;
-		if (rc > 0)
+		if (mem) {
+			/* already in system-ram mode */
 			skip_enable = 1;
+		} else if (daxctl_dev_is_famfs_mode(dev)) {
+			rc = disable_famfs_device(dev);
+			if (rc)
+				return rc;
+		} else if (daxctl_dev_is_devdax_mode(dev)) {
+			rc = disable_devdax_device(dev);
+			if (rc)
+				return rc;
+		} else {
+			fprintf(stderr, "%s: unknown mode\n", devname);
+			return -EINVAL;
+		}
 	}
 
 	if (!skip_enable) {
@@ -750,7 +803,7 @@ static int disable_system_ram_device(struct daxctl_dev *dev)
 	int rc;
 
 	if (!mem) {
-		fprintf(stderr, "%s was already in devdax mode\n", devname);
+		fprintf(stderr, "%s is not in system-ram mode\n", devname);
 		return 1;
 	}
 
@@ -786,12 +839,28 @@ static int disable_system_ram_device(struct daxctl_dev *dev)
 
 static int reconfig_mode_devdax(struct daxctl_dev *dev)
 {
+	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
+	const char *devname = daxctl_dev_get_devname(dev);
 	int rc;
 
 	if (daxctl_dev_is_enabled(dev)) {
-		rc = disable_system_ram_device(dev);
-		if (rc)
-			return rc;
+		if (mem) {
+			rc = disable_system_ram_device(dev);
+			if (rc)
+				return rc;
+		} else if (daxctl_dev_is_famfs_mode(dev)) {
+			rc = disable_famfs_device(dev);
+			if (rc)
+				return rc;
+		} else if (daxctl_dev_is_devdax_mode(dev)) {
+			/* already in devdax mode, just re-enable */
+			rc = daxctl_dev_disable(dev);
+			if (rc)
+				return rc;
+		} else {
+			fprintf(stderr, "%s: unknown mode\n", devname);
+			return -EINVAL;
+		}
 	}
 
 	rc = daxctl_dev_enable_devdax(dev);
@@ -801,6 +870,40 @@ static int reconfig_mode_devdax(struct daxctl_dev *dev)
 	return 0;
 }
 
+static int reconfig_mode_famfs(struct daxctl_dev *dev)
+{
+	struct daxctl_memory *mem = daxctl_dev_get_memory(dev);
+	const char *devname = daxctl_dev_get_devname(dev);
+	int rc;
+
+	if (daxctl_dev_is_enabled(dev)) {
+		if (mem) {
+			fprintf(stderr,
+				"%s is in system-ram mode, must be in devdax mode to convert to famfs\n",
+				devname);
+			return -EINVAL;
+		} else if (daxctl_dev_is_famfs_mode(dev)) {
+			/* already in famfs mode, just re-enable */
+			rc = daxctl_dev_disable(dev);
+			if (rc)
+				return rc;
+		} else if (daxctl_dev_is_devdax_mode(dev)) {
+			rc = disable_devdax_device(dev);
+			if (rc)
+				return rc;
+		} else {
+			fprintf(stderr, "%s: unknown mode\n", devname);
+			return -EINVAL;
+		}
+	}
+
+	rc = daxctl_dev_enable_famfs(dev);
+	if (rc)
+		return rc;
+
+	return 0;
+}
+
 static int do_create(struct daxctl_region *region, long long val,
 		     struct json_object **jdevs)
 {
@@ -887,6 +990,9 @@ static int do_reconfig(struct daxctl_dev *dev, enum dev_mode mode,
 	case DAXCTL_DEV_MODE_DEVDAX:
 		rc = reconfig_mode_devdax(dev);
 		break;
+	case DAXCTL_DEV_MODE_FAMFS:
+		rc = reconfig_mode_famfs(dev);
+		break;
 	default:
 		fprintf(stderr, "%s: unknown mode requested: %d\n",
 			devname, mode);
diff --git a/daxctl/json.c b/daxctl/json.c
index 3cbce9d..01f139b 100644
--- a/daxctl/json.c
+++ b/daxctl/json.c
@@ -48,8 +48,12 @@ struct json_object *util_daxctl_dev_to_json(struct daxctl_dev *dev,
 
 	if (mem)
 		jobj = json_object_new_string("system-ram");
-	else
+	else if (daxctl_dev_is_famfs_mode(dev))
+		jobj = json_object_new_string("famfs");
+	else if (daxctl_dev_is_devdax_mode(dev))
 		jobj = json_object_new_string("devdax");
+	else
+		jobj = json_object_new_string("unknown");
 	if (jobj)
 		json_object_object_add(jdev, "mode", jobj);
 
diff --git a/daxctl/lib/libdaxctl-private.h b/daxctl/lib/libdaxctl-private.h
index ae45311..0bb73e8 100644
--- a/daxctl/lib/libdaxctl-private.h
+++ b/daxctl/lib/libdaxctl-private.h
@@ -21,12 +21,14 @@ static const char *dax_subsystems[] = {
 enum daxctl_dev_mode {
 	DAXCTL_DEV_MODE_DEVDAX = 0,
 	DAXCTL_DEV_MODE_RAM,
+	DAXCTL_DEV_MODE_FAMFS,
 	DAXCTL_DEV_MODE_END,
 };
 
 static const char *dax_modules[] = {
 	[DAXCTL_DEV_MODE_DEVDAX] = "device_dax",
 	[DAXCTL_DEV_MODE_RAM] = "kmem",
+	[DAXCTL_DEV_MODE_FAMFS] = "fsdev_dax",
 };
 
 enum memory_op {
diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index b7fa0de..0a6cbfe 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -418,6 +418,78 @@ DAXCTL_EXPORT int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev)
 	return false;
 }
 
+/*
+ * Check if device is currently in famfs mode (bound to fsdev_dax driver)
+ */
+DAXCTL_EXPORT int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev)
+{
+	const char *devname = daxctl_dev_get_devname(dev);
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	char *mod_path, *mod_base;
+	char path[200];
+	const int len = sizeof(path);
+
+	if (!device_model_is_dax_bus(dev))
+		return false;
+
+	if (!daxctl_dev_is_enabled(dev))
+		return false;
+
+	if (snprintf(path, len, "%s/driver", dev->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return false;
+	}
+
+	mod_path = realpath(path, NULL);
+	if (!mod_path)
+		return false;
+
+	mod_base = basename(mod_path);
+	if (strcmp(mod_base, dax_modules[DAXCTL_DEV_MODE_FAMFS]) == 0) {
+		free(mod_path);
+		return true;
+	}
+
+	free(mod_path);
+	return false;
+}
+
+/*
+ * Check if device is currently in devdax mode (bound to device_dax driver)
+ */
+DAXCTL_EXPORT int daxctl_dev_is_devdax_mode(struct daxctl_dev *dev)
+{
+	const char *devname = daxctl_dev_get_devname(dev);
+	struct daxctl_ctx *ctx = daxctl_dev_get_ctx(dev);
+	char *mod_path, *mod_base;
+	char path[200];
+	const int len = sizeof(path);
+
+	if (!device_model_is_dax_bus(dev))
+		return false;
+
+	if (!daxctl_dev_is_enabled(dev))
+		return false;
+
+	if (snprintf(path, len, "%s/driver", dev->dev_path) >= len) {
+		err(ctx, "%s: buffer too small!\n", devname);
+		return false;
+	}
+
+	mod_path = realpath(path, NULL);
+	if (!mod_path)
+		return false;
+
+	mod_base = basename(mod_path);
+	if (strcmp(mod_base, dax_modules[DAXCTL_DEV_MODE_DEVDAX]) == 0) {
+		free(mod_path);
+		return true;
+	}
+
+	free(mod_path);
+	return false;
+}
+
 /*
  * This checks for the device to be in system-ram mode, so calling
  * daxctl_dev_get_memory() on a devdax mode device will always return NULL.
@@ -982,6 +1054,11 @@ DAXCTL_EXPORT int daxctl_dev_enable_ram(struct daxctl_dev *dev)
 	return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_RAM);
 }
 
+DAXCTL_EXPORT int daxctl_dev_enable_famfs(struct daxctl_dev *dev)
+{
+	return daxctl_dev_enable(dev, DAXCTL_DEV_MODE_FAMFS);
+}
+
 DAXCTL_EXPORT int daxctl_dev_disable(struct daxctl_dev *dev)
 {
 	const char *devname = daxctl_dev_get_devname(dev);
diff --git a/daxctl/lib/libdaxctl.sym b/daxctl/lib/libdaxctl.sym
index 3098811..2a812c6 100644
--- a/daxctl/lib/libdaxctl.sym
+++ b/daxctl/lib/libdaxctl.sym
@@ -104,3 +104,10 @@ LIBDAXCTL_10 {
 global:
 	daxctl_dev_is_system_ram_capable;
 } LIBDAXCTL_9;
+
+LIBDAXCTL_11 {
+global:
+	daxctl_dev_enable_famfs;
+	daxctl_dev_is_famfs_mode;
+	daxctl_dev_is_devdax_mode;
+} LIBDAXCTL_10;
diff --git a/daxctl/libdaxctl.h b/daxctl/libdaxctl.h
index 53c6bbd..84fcdb4 100644
--- a/daxctl/libdaxctl.h
+++ b/daxctl/libdaxctl.h
@@ -72,12 +72,15 @@ int daxctl_dev_is_enabled(struct daxctl_dev *dev);
 int daxctl_dev_disable(struct daxctl_dev *dev);
 int daxctl_dev_enable_devdax(struct daxctl_dev *dev);
 int daxctl_dev_enable_ram(struct daxctl_dev *dev);
+int daxctl_dev_enable_famfs(struct daxctl_dev *dev);
 int daxctl_dev_get_target_node(struct daxctl_dev *dev);
 int daxctl_dev_will_auto_online_memory(struct daxctl_dev *dev);
 int daxctl_dev_has_online_memory(struct daxctl_dev *dev);
 
 struct daxctl_memory;
 int daxctl_dev_is_system_ram_capable(struct daxctl_dev *dev);
+int daxctl_dev_is_famfs_mode(struct daxctl_dev *dev);
+int daxctl_dev_is_devdax_mode(struct daxctl_dev *dev);
 struct daxctl_memory *daxctl_dev_get_memory(struct daxctl_dev *dev);
 struct daxctl_dev *daxctl_memory_get_dev(struct daxctl_memory *mem);
 const char *daxctl_memory_get_node_path(struct daxctl_memory *mem);
-- 
2.49.0

