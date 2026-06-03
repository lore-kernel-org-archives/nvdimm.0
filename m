Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 887AA373C00;
	Wed,  3 Jun 2026 17:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780509548; cv=none; b=OdnXXQQYJLY4C0gsfvyDPeY+dkQ5mzXdkOU9vmB5LwA/8X7/xzQoS8TkWLfocs7fHc9+b6cyFhdVqnqqvOC7cQvxsvcCSwug59GbAS1hf/P4/ZA8ADrv9ez0mi69KRiJgR+z8BBz+Qh9TUptc9Rm5+3OcecTXTYUfRbaEN0Y6A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780509548; c=relaxed/simple;
	bh=Aix4PRqT35BuIaJFVSN3M3dqEENcnfZ5m7fipK9KOQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d+Br9tN7YOWh5uKZqNLQF6sUhoZTpMdl9QaMhvJGuKuXoCf/PzzTbXrObw+wVHIeGLmB1bsCVQOERmJRUZVd6hK33xe9M9p3bgl/Px5oDBnvupf5KmMP2jem0ND/RxgzAkGzjKl0DKIEzHUFgE8RaDwwittqFGVFWlwGWz9zPXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XxLKZ0GE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XxLKZ0GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D26C1F00893;
	Wed,  3 Jun 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509547;
	bh=DhcyAy27X5uBxeVsTXvuaZhNTJhAg2KJ1SLIZ8KGoZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XxLKZ0GEg0P1l11vlPqsaQDU0vnGlgJuyyUHGln2ru9kUsYrvLPHsxpOL+AOAcnWk
	 GxDEzjLJiPWv5I38duzA9v2qXcMN19s+07JVm+PhKws5kOIE5cOzPapkCGeECv/SNJ
	 mzeqSiFohVdcB+MJGDW5ZyljnGnvIo3A1sbGsLzHk5WS/AJZu6gkHaXLL6nONdAk6k
	 TY3XjP8M8ywFr2FAoLK0Q5TzO5qlGqtSWAIFvPtK+oLVgnv3AmuCNBD9phNZ41w/pw
	 60K3QcaWCoC3L6lMOpLLsrh6tRgFrw5AuC2HimPYWwae9zcyMXNA4nZFtdImxpjqkC
	 rjPiBuljFC+1g==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
Subject:
 [PATCH v2 1/4] ACPI: NFIT: core: Fix possible NULL pointer dereference
Date: Wed, 03 Jun 2026 19:56:21 +0200
Message-ID: <2418508.ElGaqSPkdT@rafael.j.wysocki>
Organization: Linux Kernel Development
In-Reply-To: <5110904.31r3eYUQgx@rafael.j.wysocki>
References: <5110904.31r3eYUQgx@rafael.j.wysocki>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

After commit 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before
getting NFIT table"), acpi_nfit_probe() installs an ACPI notify handler
for the NFIT device before checking the presence of the NFIT table.  If
that table is not there, 0 is returned without allocating the acpi_desc
object and setting the driver data pointer of the NFIT device.  If the
platform firmware triggers an NFIT_NOTIFY_UC_MEMORY_ERROR notification
on the NFIT device at that point, acpi_nfit_uc_error_notify() will
dereference a NULL pointer.

Prevent that from occurring by adding an acpi_desc check against NULL
to acpi_nfit_uc_error_notify().

Fixes: 9b311b7313d6 ("ACPI: NFIT: Install Notify() handler before getting NFIT table")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: All applicable <stable@vger.kernel.org>
---
 drivers/acpi/nfit/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index 5cab62f618c8..8024cd3cad14 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3442,6 +3442,9 @@ static void acpi_nfit_uc_error_notify(struct device *dev, acpi_handle handle)
 {
 	struct acpi_nfit_desc *acpi_desc = dev_get_drvdata(dev);
 
+	if (!acpi_desc)
+		return;
+
 	if (acpi_desc->scrub_mode == HW_ERROR_SCRUB_ON)
 		acpi_nfit_ars_rescan(acpi_desc, ARS_REQ_LONG);
 	else
-- 
2.51.0




