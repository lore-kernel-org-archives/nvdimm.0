Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A341D2E5
	for <nvdimm@lists.linux.dev>; Wed, 15 Feb 2023 20:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44C3C4339C;
	Wed, 15 Feb 2023 20:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1676493970;
	bh=/zloXCJRxoVTnh5ZAKvTgJOmkQBS8OVbWKrLyxTz0RA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A4YXoKer2Glw2aBpp0zV1LXfG85Wf6WncoDhQiM0z0T+MXpMffuYhFqfpIJZNEiuz
	 Ev/hCCxZ2PAgPwC/+OVSEv6e1VGwVVBZfpJow70cWjsfeGD8dxe1hQKPnwmGYEH1Yb
	 XKCyqwSyL+6h+0lpUpBFPrRcxWfqiKIkkKOEFqbIgXaBek65c+eit9Y7VjAMZgXlal
	 Xz0KaljbTJfhNXZ0vnSGzx/qdDIRbab9DpanKly+MyvanwGX+cS6aaWJZXlzzOYoqT
	 az7RUaS4apA2Fcb38i6tFkOIpb9odiztbaBWbYBDiBjUoWCrfe7Lr7PiJu0OJUZjba
	 YW8fQ7/N3GRdw==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	dave.jiang@intel.com,
	ira.weiny@intel.com,
	rafael@kernel.org,
	nvdimm@lists.linux.dev,
	linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 09/24] ACPI: NFIT: fix a potential deadlock during NFIT teardown
Date: Wed, 15 Feb 2023 15:45:32 -0500
Message-Id: <20230215204547.2760761-9-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Vishal Verma <vishal.l.verma@intel.com>

[ Upstream commit fb6df4366f86dd252bfa3049edffa52d17e7b895 ]

Lockdep reports that acpi_nfit_shutdown() may deadlock against an
opportune acpi_nfit_scrub(). acpi_nfit_scrub () is run from inside a
'work' and therefore has already acquired workqueue-internal locks. It
also acquiires acpi_desc->init_mutex. acpi_nfit_shutdown() first
acquires init_mutex, and was subsequently attempting to cancel any
pending workqueue items. This reversed locking order causes a potential
deadlock:

    ======================================================
    WARNING: possible circular locking dependency detected
    6.2.0-rc3 #116 Tainted: G           O     N
    ------------------------------------------------------
    libndctl/1958 is trying to acquire lock:
    ffff888129b461c0 ((work_completion)(&(&acpi_desc->dwork)->work)){+.+.}-{0:0}, at: __flush_work+0x43/0x450

    but task is already holding lock:
    ffff888129b460e8 (&acpi_desc->init_mutex){+.+.}-{3:3}, at: acpi_nfit_shutdown+0x87/0xd0 [nfit]

    which lock already depends on the new lock.

    ...

    Possible unsafe locking scenario:

          CPU0                    CPU1
          ----                    ----
     lock(&acpi_desc->init_mutex);
                                  lock((work_completion)(&(&acpi_desc->dwork)->work));
                                  lock(&acpi_desc->init_mutex);
     lock((work_completion)(&(&acpi_desc->dwork)->work));

    *** DEADLOCK ***

Since the workqueue manipulation is protected by its own internal locking,
the cancellation of pending work doesn't need to be done under
acpi_desc->init_mutex. Move cancel_delayed_work_sync() outside the
init_mutex to fix the deadlock. Any work that starts after
acpi_nfit_shutdown() drops the lock will see ARS_CANCEL, and the
cancel_delayed_work_sync() will safely flush it out.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
Link: https://lore.kernel.org/r/20230112-acpi_nfit_lockdep-v1-1-660be4dd10be@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/nfit/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index ae5f4acf26753..6d4ac934cd499 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3297,8 +3297,8 @@ void acpi_nfit_shutdown(void *data)
 
 	mutex_lock(&acpi_desc->init_mutex);
 	set_bit(ARS_CANCEL, &acpi_desc->scrub_flags);
-	cancel_delayed_work_sync(&acpi_desc->dwork);
 	mutex_unlock(&acpi_desc->init_mutex);
+	cancel_delayed_work_sync(&acpi_desc->dwork);
 
 	/*
 	 * Bounce the nvdimm bus lock to make sure any in-flight
-- 
2.39.0

