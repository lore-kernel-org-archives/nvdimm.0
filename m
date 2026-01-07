Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD0D318EFD
	for <nvdimm@lists.linux.dev>; Wed,  7 Jan 2026 15:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767800045; cv=none; b=VjcjyqypOb0MvpPGfERWQ/myna7L1rKI/xVIxHw5P7VB7Flq7vLmtzRx6DgfbLA+iyi/GmeyGuzyHHpNUJGAt9ITWnehOJNhSzPnZbdgz002idNFzjmyp13EQOOaVzFMC0XTi2XpyMORn/F2cKLmxu9cUSyJzGwJqmYe+1zxaVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767800045; c=relaxed/simple;
	bh=PyiR4akbn2AeaAQOQjDM80GGb6TmVA/W+ehpX5bfLv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t5bX1kUwsk1NCocQgLvDhDGctHkYRDdVOWmyi8tfc3asT3v++G6JHSxMXf3qSrlaMvM9tczzGHRydlwsGYJ+wuAeClx3ojEAcXj97VZ0bLGzowS3PhJqxeaIapo/kcV2ND2xOu4SFYvawpY4D7oLbRwVggI1RXrh2tEz0Y50R+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RUL50eSb; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=Groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RUL50eSb"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-455ddb90934so747720b6e.0
        for <nvdimm@lists.linux.dev>; Wed, 07 Jan 2026 07:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767800042; x=1768404842; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rU7mq0TXsreClp5X76nq6lsunavYv2TLFlf9O5dybH4=;
        b=RUL50eSbThpsnEBd9MN/kdOEwnyN2qtncjlD0p7dnNWXewtOgaTauFFw2lGj32v+eh
         gYfUKnxwi/a3Wp6a/rBHjOhQt4BnKy+krG7xwu6rIWpZmx/0CmKZYVmgCplHcpeN2AgR
         xm4L5Bzo4umhrOCDDJzNfILJYt6EJaIVfIIVi3be35ekCrD8OrwOLKPYDA53R6uAoAO6
         vhMyKsr3+tPoA2jWBC+7/Vdt0cklooNTtZc7WMaVLwYdg+i8AYcJMfUelL8Tkme/2CkA
         YQE4emh+WOxoC/jHezjTLF89oQqtGq/HJJeRLWUZZGtCfJq6D1726h0qHrXf3jC1VGNK
         Hd/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767800042; x=1768404842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rU7mq0TXsreClp5X76nq6lsunavYv2TLFlf9O5dybH4=;
        b=swEP0D1m7o5UNjB6v5F/L1nSCAVOi88tNk1zMLMD+OAGTHEe/sXpYy0+jQOlXP28TM
         nNbYtjepmwjmqbNKXmxx/L9VhnHEX9yY99g6mTGPLG69PziqsDioks8ZRpezygF3VNJx
         U0s7c9IrtVJ9RBbwTNjti2Kg5FxKku1YSJe7vZr9pE9d9Z+JVvhKkCr6l+bOesKcGhQG
         OLjawolpg0UQTZamuAmWAaYoAHK31m0H6pEF4PbRuGCauQJtoUpSA3iZKwa7H02ePA0N
         LLbQSgyXWOGSht6BAcMr8BD/jzWBGgMuBLCkk4UVB9TnHb6h1pdG5ucXm4G0KkcLS5Rn
         zi1g==
X-Forwarded-Encrypted: i=1; AJvYcCX0uxGvwPMQOmhx3rM7tGK0tTdwBbhb+i9gxoSJkafQycwrlShvMQydLqL4hkb0Zf8Cn51kTHg=@lists.linux.dev
X-Gm-Message-State: AOJu0YweHexqZ4xUyUXnrG22EgrWgrngNtdN4+bxEpu/v12DJEI43c+B
	igt0pLnp4LF+5KeKUdHuzzbCMTQo+TmsP79UZXGyDgYrbR4uXBlahB9P
X-Gm-Gg: AY/fxX6DCxcjRR8xgMxTUz87M/1bXRs1uNuHvever+gwIzZ9/eWLbcXmolyCaOi3oRK
	vqiP2EGHyoExre880CNfln7vuQ6+DtMf8RpPRIgUrjyffOy8YnoZW11TCtepWMEHlMvKdA6yzIb
	+yEjoZmmjLjMpoIqh8CPXwDyKelLdJDGYwMFbuFC2zbAt9gPbQAPeZhp7L14kcVAOY2+JxXXmol
	ugJ0jDj1qrdBIeIjmEqxWQV5WO7anArWzKNgpq+CDT+FyeBuZg+wj4Bj2iev95aFvVsGoHi5uSH
	gtHU/enEDPhfOTADi0HNXgRfp0svfFO+sG461lAKdmMwZxlgwXNOpql6HAMr3YijsCF0jgDCQOP
	Dx8hNHnJjhN7QPvpZoidUFhUQ0La+x4IED0duPXOlE17Vvk6+wOYFjt/uuu7xX/eijmNF6i5IbW
	2FKL4pHuTvC2gxIUevQrOwcxT3adcwcuSK1B0mmaETiuCAkP43Yd+wvTc=
X-Google-Smtp-Source: AGHT+IGGuPhuNMGxMH3hMywT/xZMd9I63HO5XzGofyUeNCfHY8A9ec2ffaSkWkYNbPyHpjuffbFtfA==
X-Received: by 2002:a05:6808:1188:b0:455:7da6:44d5 with SMTP id 5614622812f47-45a6bdaf691mr1055246b6e.27.1767800041948;
        Wed, 07 Jan 2026 07:34:01 -0800 (PST)
Received: from localhost.localdomain ([2603:8080:1500:3d89:a917:5124:7300:7cef])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45a5e2f1de5sm2398106b6e.22.2026.01.07.07.33.59
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 07 Jan 2026 07:34:01 -0800 (PST)
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
	Chen Linxuan <chenlinxuan@uniontech.com>,
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
	linux-fsdevel@vger.kernel.org,
	John Groves <john@groves.net>
Subject: [PATCH V3 07/21] dax: prevent driver unbind while filesystem holds device
Date: Wed,  7 Jan 2026 09:33:16 -0600
Message-ID: <20260107153332.64727-8-john@groves.net>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260107153332.64727-1-john@groves.net>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: John Groves <John@Groves.net>

Add custom bind/unbind sysfs attributes for the dax bus that check
whether a filesystem has registered as a holder (via fs_dax_get())
before allowing driver unbind.

When a filesystem like famfs mounts on a dax device, it registers
itself as the holder via dax_holder_ops. Previously, there was no
mechanism to prevent driver unbind while the filesystem was mounted,
which could cause some havoc.

The new unbind_store() checks dax_holder() and returns -EBUSY if
a holder is registered, giving userspace proper feedback that the
device is in use.

To use our custom bind/unbind handlers instead of the default ones,
set suppress_bind_attrs=true on all dax drivers during registration.

Signed-off-by: John Groves <john@groves.net>
---
 drivers/dax/bus.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 6e0e28116edc..ed453442739d 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -151,9 +151,61 @@ static ssize_t remove_id_store(struct device_driver *drv, const char *buf,
 }
 static DRIVER_ATTR_WO(remove_id);
 
+static const struct bus_type dax_bus_type;
+
+/*
+ * Custom bind/unbind handlers for dax bus.
+ * The unbind handler checks if a filesystem holds the dax device and
+ * returns -EBUSY if so, preventing driver unbind while in use.
+ */
+static ssize_t unbind_store(struct device_driver *drv, const char *buf,
+		size_t count)
+{
+	struct device *dev;
+	int rc = -ENODEV;
+
+	dev = bus_find_device_by_name(&dax_bus_type, NULL, buf);
+	if (dev && dev->driver == drv) {
+		struct dev_dax *dev_dax = to_dev_dax(dev);
+
+		if (dax_holder(dev_dax->dax_dev)) {
+			dev_dbg(dev,
+				"%s: blocking unbind due to active holder\n",
+				__func__);
+			rc = -EBUSY;
+			goto out;
+		}
+		device_release_driver(dev);
+		rc = count;
+	}
+out:
+	put_device(dev);
+	return rc;
+}
+static DRIVER_ATTR_WO(unbind);
+
+static ssize_t bind_store(struct device_driver *drv, const char *buf,
+		size_t count)
+{
+	struct device *dev;
+	int rc = -ENODEV;
+
+	dev = bus_find_device_by_name(&dax_bus_type, NULL, buf);
+	if (dev) {
+		rc = device_driver_attach(drv, dev);
+		if (!rc)
+			rc = count;
+	}
+	put_device(dev);
+	return rc;
+}
+static DRIVER_ATTR_WO(bind);
+
 static struct attribute *dax_drv_attrs[] = {
 	&driver_attr_new_id.attr,
 	&driver_attr_remove_id.attr,
+	&driver_attr_bind.attr,
+	&driver_attr_unbind.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(dax_drv);
@@ -1591,6 +1643,7 @@ int __dax_driver_register(struct dax_device_driver *dax_drv,
 	drv->name = mod_name;
 	drv->mod_name = mod_name;
 	drv->bus = &dax_bus_type;
+	drv->suppress_bind_attrs = true;
 
 	return driver_register(drv);
 }
-- 
2.49.0

