Received: from mail-qk1-f195.google.com (mail-qk1-f195.google.com [209.85.222.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 416F835D5FE
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720712; cv=none; b=CqDFnpWKhwsisJMYzN2vnwgJhj/CQQ4MaZrnHqtsUQFen/S3fs+OcD3zgMUdbtgdnyuaujluLwivLY294fDGuooLAFyRMosBKSe/hRk3Z2pFTjeE+IHifKSvTg7kT1ZAiCJPJ1JJWCqMAWTFCXLs1nItnWFhJQUMUDtyauOCTbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720712; c=relaxed/simple;
	bh=Ysme87URA8h80dz3v+yZIs8qliOaAmjArpOmGNPSVUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q12wH/UX6o2UtSPZJDc16FQZ2irATjI6mvGcTZmmIWdvJEhWppyHu22wYM4mlICRQ8shpIJEU1ZNXg2t27DcdWogulObUYpj3//iSogdaTFebRUdnFmR6KvBu7fHYs6Utoe0vxF8vRyI+k3AooDzgjmKXSvi223B+fhLXnpQzaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=H0dKzmAh; arc=none smtp.client-ip=209.85.222.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="H0dKzmAh"
Received: by mail-qk1-f195.google.com with SMTP id af79cd13be357-8c655e0ee70so158167385a.3
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:05:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720708; x=1770325508; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2izjfMr9wFUktZXLnWxTLQ+Uf13Bf1lvXAJZzNDICcs=;
        b=H0dKzmAhL0TpoiNJsmX/F8jKbBDcQUjoLgAsukh58QJiq7Yd65cYtbGx54HIb6YUPp
         wID6i4/+G32EtkdW5U9/Kwd20qm4QAKzLJQhiCUaoBLoWYYEm4lgOWg3DvBySZ1+mlEv
         PhU9Z/43i0kKvSEPYHSniVeVuMop2NZtSdCL781iFtIBHgsdNA9G1++Ns8ER9Xrm52WY
         BpbHffg5+pJGIPr4bnqbVdUUM5bmXp9w3hFEqHAO8eX0hhZ5vKizX/GVuqjG0aHe1wyW
         cdNM34G4l+AWyDf2Vsu45WnGieozU0FwkBUy9CYOqXqvXh4LSd4NuPwOvB0/eRV48+NS
         SiOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720708; x=1770325508;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2izjfMr9wFUktZXLnWxTLQ+Uf13Bf1lvXAJZzNDICcs=;
        b=mw1JpimBQizODhGOXgD+/Sljzr18mBpf9wXOA66WWktnAdou+PCQ4Y07r6ofWILZaw
         NqXGel+7XQ/qEcskjv8ONuYHrTSGXUVG3QXwhrO7iR2FU+7a0PNQwCKMdeiwHgMz/bT9
         BW51/ACVf07M25uaLX++G8kkKL5N7P+6ota1lOxcvKhx/eIx6ir/xCS7BgF9BuzLR0yv
         l4fUOfotoq5lkMY6rJKQvRIHPTPbawSGGLPli7Kgd7AIDtke1L+eFyFBCEJOH/5b1/6w
         MqFIyBXV1JgTj+Fwr3vLvxRhVrq7RF5RV4ZYZVuI9I/x+HE7qqjKMeylm1/SOtGvnzGT
         JtMA==
X-Forwarded-Encrypted: i=1; AJvYcCVNZaq2eZdmGl0t9mx0itWmqnEwyL5RXBQ1fG67kTwQafUTAdHABxjDKC8RpvSQm6HPbAMf4WA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyMMQ5XfV/p1RZJEWEn0Dn6U4STXwKHuOJvpBc7sqFxcrWB+sr3
	8dR1OFg3Cn7r/dJbMz62ji7TdPTH+n4g/Ow+Iy9jYjebgNfR/VsYrm2EaW2cX8//M0M=
X-Gm-Gg: AZuq6aLCV7UDG54ZOXbfPVeQS9RMumTZFGTBh5OIzkQDaeSX1VF264WYkNLOPMmbIRz
	U1N/7OgBW7IA1e3P44FjrfZFPxGFRGC03AbfPDDyTeBw3Kr4xijqu6KyRS6oTDF4V1IVopHawu+
	4A1CuKgEmZoY6bMG8yAAFIG4IF9iSYCuJvY6BfcofumVnDaFZ6LiiJ0GQc9DYnu0bAz9I2CGBZb
	h2qe44Mmw/LYc/cUEWx1jnpYz6TvxQzh+LJQS4KZ05O+EanWVn9FqM4SbafD+xsLZNDCipYJ0JT
	yWne/QMOtHNoPg9DovzT/GNFFXCwHH/tQsf12cBfPNx0itqCopMU8kBBoXMvKbVnd3tKsc0Vkdy
	AJ6nijDpaEEKXnppBRQk0f/0guU9vTmHjqsuHLKp/kcwPlPxVRpGJ9Uz6eN4iZT4EnwOOV/6Z0U
	lIn9lgqHdmDO8G7SEUM8wOEONwH9FzAQz5VRk36ckJnH+O3mBlPC+hZkqibbTkA8GR7D/maRXNc
	BnCWGWVMfSV0w==
X-Received: by 2002:a05:620a:2845:b0:8a4:e7f6:bf57 with SMTP id af79cd13be357-8c9eb258c5dmr134323385a.5.1769720708025;
        Thu, 29 Jan 2026 13:05:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.05.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:05:07 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 9/9] Documentation/driver-api/cxl: add dax and sysram driver documentation
Date: Thu, 29 Jan 2026 16:04:42 -0500
Message-ID: <20260129210442.3951412-10-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Explain the binding process for sysram and daxdev regions which are
explicit about which dax driver to use during region creation.

Jonathan Corbet <corbet@lwn.net> 
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 .../driver-api/cxl/linux/cxl-driver.rst       | 43 +++++++++++++++++++
 .../driver-api/cxl/linux/dax-driver.rst       | 29 +++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/Documentation/driver-api/cxl/linux/cxl-driver.rst b/Documentation/driver-api/cxl/linux/cxl-driver.rst
index dd6dd17dc536..1f857345e896 100644
--- a/Documentation/driver-api/cxl/linux/cxl-driver.rst
+++ b/Documentation/driver-api/cxl/linux/cxl-driver.rst
@@ -445,6 +445,49 @@ for more details. ::
     dax0.0      devtype  modalias   uevent
     dax_region  driver   subsystem
 
+DAX regions are created when a CXL RAM region is bound to one of the
+following drivers:
+
+* :code:`cxl_devdax_region` - Creates a dax_region for device_dax mode.
+  The resulting DAX device provides direct userspace access via
+  :code:`/dev/daxN.Y`.
+
+* :code:`cxl_dax_kmem_region` - Creates a dax_region for kmem mode via a
+  sysram_region intermediate device.  See `Sysram Region`_ below.
+
+Sysram Region
+~~~~~~~~~~~~~
+A `Sysram Region` is an intermediate device between a CXL `Memory Region`
+and a `DAX Region` for kmem mode.  It is created when a CXL RAM region is
+bound to the :code:`cxl_sysram_region` driver.
+
+The sysram_region device provides an interposition point where users can
+configure memory hotplug policy before the underlying dax_region is created
+and memory is hotplugged to the system.
+
+The device hierarchy for kmem mode is::
+
+  regionX -> sysram_regionX -> dax_regionX -> daxX.Y
+
+The sysram_region exposes an :code:`online_type` attribute that controls
+how memory will be onlined when the dax_kmem driver binds:
+
+* :code:`invalid` - Not configured (default). Blocks driver binding.
+* :code:`offline` - Memory will not be onlined automatically.
+* :code:`online` - Memory will be onlined in ZONE_NORMAL.
+* :code:`online_movable` - Memory will be onlined in ZONE_MOVABLE.
+
+Example two-stage binding process::
+
+  # Bind region to sysram_region driver
+  echo region0 > /sys/bus/cxl/drivers/cxl_sysram_region/bind
+
+  # Configure memory online type
+  echo online_movable > /sys/bus/cxl/devices/sysram_region0/online_type
+
+  # Bind sysram_region to dax_kmem_region driver
+  echo sysram_region0 > /sys/bus/cxl/drivers/cxl_dax_kmem_region/bind
+
 Mailbox Interfaces
 ------------------
 A mailbox command interface for each device is exposed in ::
diff --git a/Documentation/driver-api/cxl/linux/dax-driver.rst b/Documentation/driver-api/cxl/linux/dax-driver.rst
index 10d953a2167b..2b8e21736292 100644
--- a/Documentation/driver-api/cxl/linux/dax-driver.rst
+++ b/Documentation/driver-api/cxl/linux/dax-driver.rst
@@ -17,6 +17,35 @@ The DAX subsystem exposes this ability through the `cxl_dax_region` driver.
 A `dax_region` provides the translation between a CXL `memory_region` and
 a `DAX Device`.
 
+CXL DAX Region Drivers
+======================
+CXL provides multiple drivers for creating DAX regions, each suited for
+different use cases:
+
+cxl_devdax_region
+-----------------
+The :code:`cxl_devdax_region` driver creates a dax_region configured for
+device_dax mode.  When a CXL RAM region is bound to this driver, the
+resulting DAX device provides direct userspace access via :code:`/dev/daxN.Y`.
+
+Device hierarchy::
+
+  regionX -> dax_regionX -> daxX.Y
+
+This is the simplest path for applications that want to manage CXL memory
+directly from userspace.
+
+cxl_dax_kmem_region
+-------------------
+For kmem mode, CXL provides a two-stage binding process that allows users
+to configure memory hotplug policy before memory is added to the system.
+
+The :code:`cxl_dax_kmem_region` driver then binds a sysram_region
+device and creates a dax_region configured for kmem mode.
+
+The :code:`online_type` policy will be passed from sysram_region to
+the dax kmem driver for use when hotplugging the memory.
+
 DAX Device
 ==========
 A `DAX Device` is a file-like interface exposed in :code:`/dev/daxN.Y`. A
-- 
2.52.0

