Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CCCD37FF70;
	Wed,  3 Jun 2026 17:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780509552; cv=none; b=RBtfy506rw5FxwPWXKOnVlyF+EBiVNjTAtKd8oyK9E7mvs5hFcdphuwC6scC698jltpmmJTwjdhm+rSZAIi/G2qknD5zdz+f46cDidg1aMZVkjHkCOu1c6xK5n3oQrgrTgPZatpfVmzVOWqnx3y2G8EUl2XjCT6KLvc6wB65tg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780509552; c=relaxed/simple;
	bh=zoFNHB1J8xmyYrha/t6eapnjffI2ALlN2EwppUHpzIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=YBReLtoxdE0qTCes7M6ZaMUnrwbaUQ1fMCPCRcA0ynGeP2s4XedPLyR9NwbMGIo0wPLF5KtRThsCNnO8ouF/5T8qtYBgnPgxHSE2PUPwQTtjjrlxZ6I/TsuZZWHLZ4GwKnyavRFAVrhVwXnWcDxlrJZqUxwfHuvbk39Cay4HxRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BLkDK1n5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BLkDK1n5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F3BF1F00893;
	Wed,  3 Jun 2026 17:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780509551;
	bh=NfXMCDskTI3m8h7njOgKHv3dJExtbkBLtlu9xyvDT1o=;
	h=From:To:Cc:Subject:Date;
	b=BLkDK1n53VryVlBtzBy7187nQ8tPsPr4O5ceea+ZZ5n6TDuFxZOOQxFE/Lyfl4xre
	 JsBfZelmUPQv35gYXEJ0tswofaTrmkUEqNVprC/+TrPRc60JW0DhzGMPxzW27vMFnm
	 YkazC8ACLHz2Gx6BA08oDHraPYlH19uG10OSvAknZAjKsk6RbsTo3ZXQgMEMo5mpxW
	 LfNIlqcA2Vv6Q+apm3GR8WWr9+F1FBM1HSWOw0vPWl4tnaadJB9NR+TastkviK4t9v
	 YOohDoP8OwAlxQu3BEHhORx6bqlysJhkSKy8/0PxnlEphn6dknD6KuEAGmvbFZgUgK
	 ylbf2DvEV2MDg==
From: "Rafael J. Wysocki" <rafael@kernel.org>
To: Linux ACPI <linux-acpi@vger.kernel.org>
Cc: Dan Williams <djbw@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>,
 Xiang Chen <chenxiang66@hisilicon.com>
Subject:
 [PATCH v2 0/4] ACPI: NFIT: core: Fix multiple issues related to concurrency
 and cleanup
Date: Wed, 03 Jun 2026 19:55:30 +0200
Message-ID: <5110904.31r3eYUQgx@rafael.j.wysocki>
Organization: Linux Kernel Development
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="UTF-8"

Hi All,

This series is a replacement for

https://lore.kernel.org/linux-acpi/6000262.DvuYhMxLoT@rafael.j.wysocki/

and it addresses some additional issues discovered during the review
of the patch above.  Some of it is based on the sashiko.dev feedback:

https://sashiko.dev/#/patchset/6000262.DvuYhMxLoT%40rafael.j.wysocki

Patch [1/4] adds a NULL pointer check to prevent a possible NULL pointer
dereference from occurring.

Patch [2/4] fixes issues related to acpi_nfit_init() failures.

Patch [3/4] is a preparatory cleanup before the next patch.

Patch [4/4] addresses a possible deadlock during driver removal or
failing probe and missing NVDIMM device notifications from platform
firmware.

Thanks!



