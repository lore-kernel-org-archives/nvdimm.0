Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E47A23EA976;
	Thu, 21 May 2026 14:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779372774; cv=none; b=PQIA1N84vYJe40pxh9hy1M8/bKgtEArvsEBzLJavqzoGlw/8z8cUMOmGnOlMJ1XPB3XLR6OXyAqROYM1IwUbxtp/T1lPNSIlXK5oCi+a6LeDVlygCefZJ7k/74Q7mIHt094Ga6PizfDz4lclaj7+G/8nsS8wTs9sVeXYISU3ZU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779372774; c=relaxed/simple;
	bh=7wJ/Oj9CcLN3cp1Lt3/QbZFmmeb4J+rxFd/fVdBr7QA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h2+fmYc/dVT+tBZxVa70aqoIMhoxN6pGghcVzBeKT/CPBYt8avxb4d0B2z67mkDuirA0+oYA03EQx50bWgnA0/WvK/PA7ODURn8NH0bNiUcpGnNnxIymFUr7vwAMJ1SO2ewee1Q5px9RrWeytkYljD6MOQVtUdW3VUvRwdLQTPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XBqiQP9c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XBqiQP9c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577DB1F000E9;
	Thu, 21 May 2026 14:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779372772;
	bh=WbDZ86X+l6IZWJWNcLY5koHwC+tgCiPfqrLA8vRC/bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XBqiQP9cmpB+zXdv//2yPu8yuAQpljdlj2602oqQA3cQtS0YxH8vvnyaKpThIjzzf
	 Dc6j7Rg8sf1fIJXcaGpjiZcah+Te5xCAZbp7ku9KTNWUcjczYi/8eMO/Dpu6Hng8UV
	 T8n5+O8d1rRRg1axxRU2v86O7OJsnwbejtP/AFa/ypcxXQQNKsU6gbLWKzqbZJ1DTN
	 aPjPInk18fNpztnwzrH4fT0k5Mv3SFNdwxZ1HNeIsGMKuCTjUePMwVhg1n+Dvay97F
	 Rz7f9uktm5DW70URjYlwoxMLzQ8kzCadhqzWMT4jeEqa8nZ9CWlDOU1Y2mTLZmtyqj
	 Bf34LMHCi57Uw==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Hans de Goede <hansg@kernel.org>, Armin Wolf <w_armin@gmx.de>,
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
 nvdimm@lists.linux.dev
Subject:
 [PATCH v1 01/17] ACPI: bus: Introduce devm_acpi_install_notify_handler()
Date: Thu, 21 May 2026 15:59:50 +0200
Message-ID: <2268031.irdbgypaU6@rafael.j.wysocki>
Organization: Linux Kernel Development
In-Reply-To: <4739447.LvFx2qVVIh@rafael.j.wysocki>
References: <4739447.LvFx2qVVIh@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

Introduce devm_acpi_install_notify_handler() for installing an ACPI
notify handler managed by devres that will be removed automatically on
driver detach.

It installs the notify handler on the device object in the ACPI
namespace that corresponds to the owner device's ACPI companion, if
present (an error is returned if the owner device doesn't have an ACPI
companion).

Currently, there is no way to manually remove the notify handler
installed by it because none of its users brought on subsequently
will need to do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c      | 67 +++++++++++++++++++++++++++++++++++++++++
 include/acpi/acpi_bus.h |  2 ++
 2 files changed, 69 insertions(+)

diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
index 2ec095e2009e..84f0ab47fd40 100644
--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -679,6 +679,73 @@ void acpi_dev_remove_notify_handler(struct acpi_device *adev,
 }
 EXPORT_SYMBOL_GPL(acpi_dev_remove_notify_handler);
 
+struct acpi_notify_handler_devres {
+	acpi_notify_handler handler;
+	u32 handler_type;
+};
+
+static void devm_acpi_notify_handler_release(struct device *dev, void *res)
+{
+	struct acpi_notify_handler_devres *dr = res;
+
+	acpi_dev_remove_notify_handler(ACPI_COMPANION(dev), dr->handler_type,
+				       dr->handler);
+}
+
+/**
+ * devm_acpi_install_notify_handler - Install an ACPI notify handler for a
+ * 				      managed device
+ * @dev: Device to install a notify handler for
+ * @handler_type: Type of the notify handler
+ * @handler: Handler function to install
+ * @context: Data passed back to the handler function
+ *
+ * This function performs the same function as acpi_dev_install_notify_handler()
+ * called for the ACPI companion of @dev with the same @handler_type, @handler,
+ * and @context arguments, but the ACPI notify handler installed by it will be
+ * automatically removed on driver detach.
+ *
+ * Callers should ensure that all resources used by @handler have been allocated
+ * prior to invoking this function, in which case those resources should be
+ * devres-managed so that they won't be released before the notify handler
+ * removal.  Otherwise, special synchronization between @handler and the
+ * management of those resources is required.
+ *
+ * When the request fails, an error message is printed with contextual
+ * information (device name, handler function and error code).  Don't add extra
+ * error messages at the call sites.
+ *
+ * Return: 0 on success or a negative error number.
+ */
+int devm_acpi_install_notify_handler(struct device *dev, u32 handler_type,
+				     acpi_notify_handler handler, void *context)
+{
+	struct acpi_notify_handler_devres *dr;
+	struct acpi_device *adev;
+	int ret;
+
+	adev = ACPI_COMPANION(dev);
+	if (!adev)
+		return dev_err_probe(dev, -ENODEV, "No ACPI companion in %s()\n", __func__);
+
+	dr = devres_alloc(devm_acpi_notify_handler_release, sizeof(*dr), GFP_KERNEL);
+	if (!dr)
+		return -ENOMEM;
+
+	ret = acpi_dev_install_notify_handler(adev, handler_type, handler, context);
+	if (ret) {
+		devres_free(dr);
+		return dev_err_probe(dev, ret, "Failed to install an ACPI notify handler\n");
+	}
+
+	dr->handler = handler;
+	dr->handler_type = handler_type;
+	devres_add(dev, dr);
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_acpi_install_notify_handler);
+
 /* Handle events targeting \_SB device (at present only graceful shutdown) */
 
 #define ACPI_SB_NOTIFY_SHUTDOWN_REQUEST 0x81
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index c41d9a7565cf..7e57f9698f7c 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -629,6 +629,8 @@ int acpi_dev_install_notify_handler(struct acpi_device *adev,
 void acpi_dev_remove_notify_handler(struct acpi_device *adev,
 				    u32 handler_type,
 				    acpi_notify_handler handler);
+int devm_acpi_install_notify_handler(struct device *dev, u32 handler_type,
+				     acpi_notify_handler handler, void *context);
 extern int acpi_notifier_call_chain(const char *device_class,
 				    const char *bus_id, u32 type, u32 data);
 extern int register_acpi_notifier(struct notifier_block *);
-- 
2.51.0




